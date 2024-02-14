module Sisimai
  # Sisimai::Message convert bounce email text to data structure. It resolve
  # email text into an UNIX From line, the header part of the mail, delivery
  # status, and RFC822 header part. When the email given as a argument of "new"
  # method is not a bounce email, the method returns nil.
  class Message
    # Imported from p5-Sisimail/lib/Sisimai/Message.pm
    # :from   [String] UNIX From line
    # :header [Hash]   Header part of an email
    # :ds     [Array]  Parsed data by Sisimai::Lhost::* module
    # :rfc822 [Hash]   Header part of the original message
    # :catch  [Any]    The results returned by hook method
    attr_accessor :from, :header, :ds, :rfc822, :catch

    require 'sisimai/mime'
    require 'sisimai/order'
    require 'sisimai/lhost'
    require 'sisimai/string'
    require 'sisimai/address'
    require 'sisimai/rfc5322'
    DefaultSet = Sisimai::Order.another
    LhostTable = Sisimai::Lhost.path

    # Constructor of Sisimai::Message
    # @param         [String] data      Email text data
    # @param         [Hash] argvs       Module to be loaded
    # @options argvs [String] :data     Entire email message
    # @options argvs [Array]  :load     User defined MTA module list
    # @options argvs [Array]  :order    The order of MTA modules
    # @options argvs [Code]   :hook     Reference to callback method
    # @return        [Sisimai::Message] Structured email data or nil if each
    #                                   value of the arguments are missing
    def initialize(data: '', **argvs)
      return nil if data.empty?
      param = {}
      email = data.scrub('?').gsub("\r\n", "\n").gsub("\r", "\n")
      thing = { 'from' => '','header' => {}, 'rfc822' => '', ds => [], 'catch' => nil }

      # 1. Load specified MTA modules
      [:load, :order].each do |e|
        # Order of MTA modules
        next unless argvs[e]
        next unless argvs[e].is_a? Array
        next if argvs[e].empty?
        param[e.to_s] = argvs[e]
      end
      tobeloaded = Sisimai::Message.load(param)

      # 2. Split email data to headers and a body part.
      return nil unless aftersplit = Sisimai::Message.divideup(email)

      # 3. Convert email headers from text to hash reference
      thing['from']   = aftersplit[0]
      thing['header'] = Sisimai::Message.makemap(aftersplit[1])

      # 4. Decode and rewrite the "Subject:" header
      unless thing['header']['subject'].empty?
        # Decode MIME-Encoded "Subject:" header
        s = thing['header']['subject']
        q = Sisimai::MIME.is_mimeencoded(s) ? Sisimai::MIME.mimedecode(s.split(/[ ]/)) : s

        # Remove "Fwd:" string from the Subject: header
        if cv = q.downcase.match(/\A[ \t]*fwd?:[ ]*(.*)\z/)
          # Delete quoted strings, quote symbols(>)
          q = cv[1]
          aftersplit[2] = aftersplit[2].gsub(/^[>]+[ ]/, '').gsub(/^[>]$/, '')
        end
        thing['header']['subject'] = q
      end

      # 5. Rewrite message body for detecting the bounce reason
      param = {
        'hook' => argvs[:hook] || nil,
        'mail' => thing,
        'body' => aftersplit[2],
        'tobeloaded' => tobeloaded,
        'tryonfirst' => Sisimai::Order.make(thing['header']['subject'])
      }
      return nil unless bouncedata = Sisimai::Message.parse(param)
      return nil if bouncedata.empty?

      # 6. Rewrite headers of the original message in the body part
      %w|ds catch rfc822|.each { |e| thing[e] = bouncedata[e] }
      p = bouncedata['rfc822']
      p = aftersplit[2] if p.empty?
      thing['rfc822'] = p.is_a?(::String) ? Sisimai::Message.makemap(p, true) : p

      @from   = thing['from']
      @header = thing['header']
      @ds     = thing['ds']
      @rfc822 = thing['rfc822']
      @catch  = thing['catch'] || nil
    end

    # Check whether the object has valid content or not
    # @return        [True,False]   returns true if the object is void
    def void; return @ds ? false : true; end

    # Load MTA modules which specified at 'order' and 'load' in the argument
    # @param         [Hash] argvs       Module information to be loaded
    # @options argvs [Array]  load      User defined MTA module list
    # @options argvs [Array]  order     The order of MTA modules
    # @return        [Array]            Module list
    # @since v4.20.0
    def self.load(argvs)
      modulelist = []
      tobeloaded = []

      %w[load order].each do |e|
        # The order of MTA modules specified by user
        next unless argvs[e]
        next unless argvs[e].is_a? Array
        next if argvs[e].empty?

        modulelist += argvs['order'] if e == 'order'
        next unless e == 'load'

        # Load user defined MTA module
        argvs['load'].each do |v|
          # Load user defined MTA module
          begin
            require v.to_s.gsub('::', '/').downcase
          rescue LoadError
            warn ' ***warning: Failed to load ' << v
            next
          end
          tobeloaded << v
        end
      end

      while e = modulelist.shift do
        # Append the custom order of MTA modules
        next if tobeloaded.index(e)
        tobeloaded << e
      end

      return tobeloaded
    end

    # Divide email data up headers and a body part.
    # @param         [String] email  Email data
    # @return        [Array]         Email data after split
    def self.divideup(email)
      return nil if email.empty?

      block = ['', '', '']  # 0:From, 1:Header, 2:Body
      email.gsub!(/\r\n/, "\n")  if email.include?("\r\n")
      email.gsub!(/[ \t]+$/, '') if email =~ /[ \t]+$/

      (block[1], block[2]) = email.split(/\n\n/, 2)
      return nil unless block[1]
      return nil unless block[2]

      if block[1].start_with?('From ')
        # From MAILER-DAEMON Tue Feb 11 00:00:00 2014
        block[0] = block[1].split(/\n/, 2)[0].delete("\r")
      else
        # Set pseudo UNIX From line
        block[0] = 'MAILER-DAEMON Tue Feb 11 00:00:00 2014'
      end
      block[1] << "\n" unless block[1].end_with?("\n")

      %w[image/ application/ text/html].each do |e|
        # https://github.com/sisimai/p5-sisimai/issues/492, Reduce email size
        p0 = 0
        p1 = 0
        ep = e == 'text/html' ? '</html>' : "--\n"
        while true
          # Remove each part from "Content-Type: image/..." to "--\n" (the end of each boundary)
          p0 = block[2].index('Content-Type: ' + e, p0); break unless p0
          p1 = block[2].index(ep, p0 + 32);              break unless p1
          block[2][p0, p1 - p0] = ''
        end
      end
      block[2] << "\n"

      return block
    end

    # Convert a text including email headers to a hash reference
    # @param    [String] argv0  Email header data
    # @param    [Bool]   argv1  Decode "Subject:" header
    # @return   [Hash]          Structured email header data
    # @since    v4.25.6
    def self.makemap(argv0 = '', argv1 = nil)
      return {} if argv0.empty?
      argv0.gsub!(/^[>]+[ ]/m, '') # Remove '>' indent symbol of forwarded message

      # Select and convert all the headers in $argv0. The following regular expression
      # is based on https://gist.github.com/xtetsuji/b080e1f5551d17242f6415aba8a00239
      headermaps = { 'subject' => '' }
      recvheader = []
      argv0.scan(/^([\w-]+):[ ]*(.*?)\n(?![\s\t])/m) { |e| headermaps[e[0].downcase] = e[1] }
      headermaps.delete('received')
      headermaps.each_key { |e| headermaps[e].gsub!(/\n[\s\t]+/, ' ') }

      if argv0.include?('Received:')
        # Capture values of each Received: header
        recvheader = argv0.scan(/^Received:[ ]*(.*?)\n(?![\s\t])/m).flatten
        recvheader.each { |e| e.gsub!(/\n[\s\t]+/, ' ') }
      end
      headermaps['received'] = recvheader

      return headermaps unless argv1
      return headermaps if headermaps['subject'].empty?

      # Convert MIME-Encoded subject
      if Sisimai::String.is_8bit(headermaps['subject'])
        # The value of ``Subject'' header is including multibyte character,
        # is not MIME-Encoded text.
        headermaps['subject'].scrub!('?')
      else
        # MIME-Encoded subject field or ASCII characters only
        r = []
        if Sisimai::MIME.is_mimeencoded(headermaps['subject'])
          # split the value of Subject by borderline
          headermaps['subject'].split(/ /).each do |v|
            # Insert value to the array if the string is MIME encoded text
            r << v if Sisimai::MIME.is_mimeencoded(v)
          end
        else
          # Subject line is not MIME encoded
          r << headermaps['subject']
        end
        headermaps['subject'] = Sisimai::MIME.mimedecode(r)
      end
      return headermaps
    end

    # @abstract Parse bounce mail with each MTA module
    # @param               [Hash] argvs    Processing message entity.
    # @param options argvs [Hash] mail     Email message entity
    # @param options mail  [String] from   From line of mbox
    # @param options mail  [Hash]   header Email header data
    # @param options mail  [String] rfc822 Original message part
    # @param options mail  [Array]  ds     Delivery status list(parsed data)
    # @param options argvs [String] body   Email message body
    # @param options argvs [Array] tryonfirst  MTA module list to load on first
    # @param options argvs [Array] tobeloaded  User defined MTA module list
    # @return              [Hash]          Parsed and structured bounce mails
    def self.parse(argvs)
      return nil unless argvs['mail']
      return nil unless argvs['body']

      mailheader = argvs['mail']['header']
      bodystring = argvs['body']
      hookmethod = argvs['hook'] || nil
      havecaught = nil
      return nil unless mailheader

      # PRECHECK_EACH_HEADER:
      # Set empty string if the value is nil
      mailheader['from']         ||= ''
      mailheader['subject']      ||= ''
      mailheader['content-type'] ||= ''

      # Decode BASE64 Encoded message body, rewrite.
      mesgformat = (mailheader['content-type'] || '').downcase
      ctencoding = (mailheader['content-transfer-encoding'] || '').downcase
      if mesgformat.start_with?('text/')
        # Content-Type: text/plain; charset=UTF-8
        if ctencoding == 'base64'
          # Content-Transfer-Encoding: base64
          bodystring = Sisimai::MIME.base64d(bodystring)

        elsif ctencoding == 'quoted-printable'
          # Content-Transfer-Encoding: quoted-printable
          bodystring = Sisimai::MIME.qprintd(bodystring)
        end

        if mesgformat.start_with?('text/html;')
          # Content-Type: text/html;...
          bodystring = Sisimai::String.to_plain(bodystring, true)
        end
      else
        # NOT text/plain
        if mesgformat.start_with?('multipart/')
          # In case of Content-Type: multipart/*
          p = Sisimai::MIME.makeflat(mailheader['content-type'], bodystring)
          bodystring = p unless p.empty?
        end
      end
      bodystring = bodystring.scrub('?').delete("\r")

      haveloaded = {}
      parseddata = nil
      modulename = ''
      if hookmethod.is_a? Proc
        # Call the hook method
        begin
          p = { 'headers' => mailheader, 'message' => bodystring }
          havecaught = hookmethod.call(p)
        rescue StandardError => ce
          warn ' ***warning: Something is wrong in hook method :' << ce.to_s
        end
      end

      catch :PARSER do
        while true
          # 1. User-Defined Module
          # 2. MTA Module Candidates to be tried on first
          # 3. Sisimai::Lhost::*
          # 4. Sisimai::RFC3464
          # 5. Sisimai::ARF
          # 6. Sisimai::RFC3834
          while r = argvs['tobeloaded'].shift do
            # Call user defined MTA modules
            next if haveloaded[r]
            parseddata = Module.const_get(r).make(mailheader, bodystring)
            haveloaded[r] = true
            modulename = r
            throw :PARSER if parseddata
          end

          [argvs['tryonfirst'], DefaultSet].flatten.each do |r|
            # Try MTA module candidates
            next if haveloaded[r]
            require LhostTable[r]
            parseddata = Module.const_get(r).make(mailheader, bodystring)
            haveloaded[r] = true
            modulename = r
            throw :PARSER if parseddata
          end

          unless haveloaded['Sisimai::RFC3464']
            # When the all of Sisimai::Lhost::* modules did not return bounce
            # data, call Sisimai::RFC3464;
            require 'sisimai/rfc3464'
            parseddata = Sisimai::RFC3464.make(mailheader, bodystring)
            modulename = 'RFC3464'
            throw :PARSER if parseddata
          end

          unless haveloaded['Sisimai::ARF']
            # Feedback Loop message
            require 'sisimai/arf'
            parseddata = Sisimai::ARF.make(mailheader, bodystring) if Sisimai::ARF.is_arf(mailheader)
            throw :PARSER if parseddata
          end

          unless haveloaded['Sisimai::RFC3834']
            # Try to parse the message as auto reply message defined in RFC3834
            require 'sisimai/rfc3834'
            parseddata = Sisimai::RFC3834.make(mailheader, bodystring)
            modulename = 'RFC3834'
            throw :PARSER if parseddata
          end

          break # as of now, we have no sample email for coding this block
        end
      end
      return nil unless parseddata

      parseddata['catch'] = havecaught
      modulename = modulename.sub(/\A.+::/, '')
      parseddata['ds'].each do |e|
        e['agent'] = modulename unless e['agent']
        e.each_key { |a| e[a] ||= '' }  # Replace nil with ""
      end
      return parseddata
    end

  end
end

