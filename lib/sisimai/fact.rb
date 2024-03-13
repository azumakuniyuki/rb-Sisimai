module Sisimai
  # Sisimai::Fact generate parsed data
  class Fact
    require 'sisimai/message'
    require 'sisimai/rfc1894'
    require 'sisimai/rfc5322'
    require 'sisimai/reason'
    require 'sisimai/address'
    require 'sisimai/datetime'
    require 'sisimai/time'
    require 'sisimai/smtp/error'
    require 'sisimai/smtp/command'
    require 'sisimai/string'
    require 'sisimai/rhost'

    @@rwaccessors = [
      :action,          # [String] The value of Action: header
      :addresser,       # [Sisimai::Address] From address
      :alias,           # [String] Alias of the recipient address
      :catch,           # [?] Results generated by hook method
      :deliverystatus,  # [String] Delivery Status(DSN)
      :destination,     # [String] The domain part of the "recipinet"
      :diagnosticcode,  # [String] Diagnostic-Code: Header
      :diagnostictype,  # [String] The 1st part of Diagnostic-Code: Header
      :feedbacktype,    # [String] Feedback Type
      :hardbounce,      # [Boolean] true = Hard bounce, false = is not a hard bounce
      :lhost,           # [String] local host name/Local MTA
      :listid,          # [String] List-Id header of each ML
      :messageid,       # [String] Message-Id: header
      :origin,          # [String] Email path as a data source
      :reason,          # [String] Bounce reason
      :recipient,       # [Sisimai::Address] Recipient address which bounced
      :replycode,       # [String] SMTP Reply Code
      :rhost,           # [String] Remote host name/Remote MTA
      :senderdomain,    # [String] The domain part of the "addresser"
      :smtpagent,       # [String] Module(Engine) name
      :smtpcommand,     # [String] The last SMTP command
      :subject,         # [String] UTF-8 Subject text
      :timestamp,       # [Sisimai::Time] Date: header in the original message
      :timezoneoffset,  # [Integer] Time zone offset(seconds)
      :token,           # [String] Message token/MD5 Hex digest value
    ]
    attr_accessor(*@@rwaccessors)

    RetryIndex = Sisimai::Reason.retry
    RFC822Head = Sisimai::RFC5322.HEADERFIELDS(:all)
    ActionList = { delayed: 1, delivered: 1, expanded: 1, failed: 1, relayed: 1 };

    if RUBY_PLATFORM.start_with?('java')
      # [WORKAROUND] #159 #267 JRuby seems to fail and throws exception at strptime(), but this
      # issue might be fixed in a future version of JRuby.
      #   https://gist.github.com/hiroyuki-sato/6ef40245874d4c847a95ef99886e4fa7
      #   https://github.com/sisimai/rb-sisimai/issues/267#issuecomment-1976642884
      #   https://github.com/jruby/jruby/issues/8139
      #   https://github.com/sisimai/rb-sisimai/issues/267
      TimeModule = ::DateTime
    else
      TimeModule = Sisimai::Time
    end

    # Constructor of Sisimai::Fact
    # @param    [Hash] argvs    Including each parameter
    # @return   [Sisimai::Fact] Structured email data
    def initialize(argvs)
      # Create email address object
      @alias          = argvs['alias'] || ''
      @addresser      = argvs['addresser']
      @action         = argvs['action']
      @catch          = argvs['catch']
      @diagnosticcode = argvs['diagnosticcode']
      @diagnostictype = argvs['diagnostictype']
      @deliverystatus = argvs['deliverystatus']
      @destination    = argvs['recipient'].host
      @feedbacktype   = argvs['feedbacktype']
      @hardbounce     = argvs['hardbounce']
      @lhost          = argvs['lhost']
      @listid         = argvs['listid']
      @messageid      = argvs['messageid']
      @origin         = argvs['origin']
      @reason         = argvs['reason']
      @recipient      = argvs['recipient']
      @replycode      = argvs['replycode']
      @rhost          = argvs['rhost']
      @senderdomain   = argvs['addresser'].host
      @smtpagent      = argvs['smtpagent']
      @smtpcommand    = argvs['smtpcommand']
      @subject        = argvs['subject']
      @token          = argvs['token']
      @timestamp      = argvs['timestamp']
      @timezoneoffset = argvs['timezoneoffset']
    end

    # Constructor of Sisimai::Fact
    # @param         [Hash]   argvs
    # @options argvs [String]  data       Entire email message
    # @options argvs [Boolean] delivered  Include the result which has "delivered" reason
    # @options argvs [Boolean] vacation   Include the result which has "vacation" reason
    # @options argvs [Proc]    hook       Proc object of callback method
    # @options argvs [Array]   load       User defined MTA module list
    # @options argvs [Array]   order      The order of MTA modules
    # @options argvs [String]  origin     Path to the original email file
    # @return        [Array]              Array of Sisimai::Fact objects
    def self.rise(**argvs)
      return nil unless argvs
      return nil unless argvs.is_a? Hash

      email = argvs[:data]; return nil unless email
      loads = argvs[:load]  || nil
      order = argvs[:order] || nil
      args1 = { data: email, hook: argvs[:hook], load: loads, order: order }
      mesg1 = Sisimai::Message.rise(**args1)

      return nil unless mesg1
      return nil unless mesg1['ds']
      return nil unless mesg1['rfc822']

      deliveries = mesg1['ds'].dup
      rfc822data = mesg1['rfc822']
      listoffact = [];

      while e = deliveries.shift do
        # Create parameters for each Sisimai::Fact object
        o = {}  # To be passed to each accessor of Sisimai::Fact
        p = {
          'action'         => e['action']       || '',
          'alias'          => e['alias']        || '',
          'catch'          => mesg1['catch']    || nil,
          'deliverystatus' => e['status']       || '',
          'diagnosticcode' => e['diagnosis']    || '',
          'diagnostictype' => e['spec']         || '',
          'feedbacktype'   => e['feedbacktype'] || '',
          'hardbounce'     => false,
          'lhost'          => e['lhost']        || '',
          'origin'         => argvs[:origin],
          'reason'         => e['reason']       || '',
          'recipient'      => e['recipient']    || '',
          'replycode'      => e['replycode']    || '',
          'rhost'          => e['rhost']        || '',
          'smtpagent'      => e['agent']        || '',
          'smtpcommand'    => e['command']      || '',
        }
        unless argvs[:delivered]
          # Skip if the value of "deliverystatus" begins with "2." such as 2.1.5
          next if p['deliverystatus'].start_with?('2.')
        end

        unless argvs[:vacation]
          # Skip if the value of "reason" is "vacation"
          next if p['reason'] == 'vacation'
        end

        # EMAILADDRESS: Detect email address from message/rfc822 part
        RFC822Head[:addresser].each do |f|
          # Check each header in message/rfc822 part
          g = f.downcase
          next unless rfc822data[g]
          next if rfc822data[g].empty?

          j = Sisimai::Address.find(rfc822data[g]) || next
          p['addresser'] = j.shift
          break
        end

        unless p['addresser']
          # Fallback: Get the sender address from the header of the bounced email if the address is
          # not set at loop above.
          j = Sisimai::Address.find(mesg1['header']['to']) || []
          p['addresser'] = j.shift
        end
        next unless p['addresser']
        next unless p['recipient']

        # TIMESTAMP: Convert from a time stamp or a date string to a machine time.
        datestring = nil
        zoneoffset = 0
        datevalues = []; datevalues << e['date'] unless e['date'].to_s.empty?

        # Date information did not exist in message/delivery-status part,...
        RFC822Head[:date].each do |f|
          # Get the value of Date header or other date related header.
          next unless rfc822data[f]
          datevalues << rfc822data[f]
        end

        # Set "date" getting from the value of "Date" in the bounce message
        datevalues << mesg1['header']['date'] if datevalues.size < 2

        while v = datevalues.shift do
          # Parse each date value in the array
          datestring = Sisimai::DateTime.parse(v)
          break if datestring
        end

        if datestring && cv = datestring.match(/\A(.+)[ ]+([-+]\d{4})\z/)
          # Get the value of timezone offset from datestring: Wed, 26 Feb 2014 06:05:48 -0500
          datestring = cv[1]
          zoneoffset = Sisimai::DateTime.tz2second(cv[2])
          p['timezoneoffset'] = cv[2]
        end

        begin
          # Convert from the date string to an object then calculate time zone offset.
          t = TimeModule.strptime(datestring, '%a, %d %b %Y %T')
          p['timestamp'] = (t.to_time.to_i - zoneoffset) || nil
        rescue
          warn ' ***warning: Failed to strptime ' << datestring.to_s
        end
        next unless p['timestamp']

        # OTHER_TEXT_HEADERS:
        rr = mesg1['header']['received'] || []
        unless rr.empty?
          # Get a localhost and a remote host name from Received header.
          p['rhost'] = Sisimai::RFC5322.received(rr[-1])[1] if p['rhost'].empty?
          p['lhost'] = '' if p['rhost'] == p['lhost']
          p['lhost'] = Sisimai::RFC5322.received(rr[ 0])[0] if p['lhost'].empty?
        end

        # Remove square brackets and curly brackets from the host variable
        %w[rhost lhost].each do |v|
          p[v] = p[v].split('@')[-1] if p[v].include?('@')
          p[v].delete!('[]()')    # Remove square brackets and curly brackets from the host variable
          p[v].sub!(/\A.+=/, '')  # Remove string before "="
          p[v].chomp!("\r") if p[v].end_with?("\r") # Remove CR at the end of the value

          # Check space character in each value and get the first element
          p[v] = p[v].split(' ', 2).shift if p[v].include?(' ')
          p[v].chomp!('.') if p[v].end_with?('.')   # Remove "." at the end of the value
        end

        # Subject: header of the original message
        p['subject'] = rfc822data['subject'] || ''
        p['subject'].scrub!('?')
        p['subject'].chomp!("\r") if p['subject'].end_with?("\r")

        # The value of "List-Id" header
        if Sisimai::String.aligned(rfc822data['list-id'], ['<', '.', '>'])
          # https://www.rfc-editor.org/rfc/rfc2919
          # Get the value of List-Id header: "List name <list-id@example.org>"
          p0 = rfc822data['list-id'].index('<') + 1
          p1 = rfc822data['list-id'].index('>')
          p['listid'] = rfc822data['list-id'][p0, p1 - p0]
        else
          # Invalid value of the List-Id: field
          p['listid'] = ''
        end

        # The value of "Message-Id" header
        if Sisimai::String.aligned(rfc822data['message-id'], ['<', '@', '>'])
          # https://www.rfc-editor.org/rfc/rfc5322#section-3.6.4
          # Leave only string inside of angle brackets(<>)
          p0 = rfc822data['message-id'].index('<') + 1
          p1 = rfc822data['message-id'].index('>')
          p['messageid'] = rfc822data['message-id'][p0, p1 - p0]
        else
          # Invalid value of the Message-Id: field
          p['messageid'] = ''
        end

        # CHECK_DELIVERY_STATUS_VALUE: Cleanup the value of "Diagnostic-Code:" header
        if p['diagnosticcode'].to_s.size > 0
          # Get an SMTP Reply Code and an SMTP Enhanced Status Code
          p['diagnosticcode'].chop if p['diagnosticcode'][-1, 1] == "\r"

          cs = Sisimai::SMTP::Status.find(p['diagnosticcode'])    || ''
          cr = Sisimai::SMTP::Reply.find(p['diagnosticcode'], cs) || ''
          p['deliverystatus'] = Sisimai::SMTP::Status.prefer(p['deliverystatus'], cs, cr)

          if cr.size == 3
            # There is an SMTP reply code in the error message
            p['replycode'] = cr if p['replycode'].to_s.empty?

            if p['diagnosticcode'].include?(cr + '-')
              # 550-5.7.1 [192.0.2.222] Our system has detected that this message is
              # 550-5.7.1 likely unsolicited mail. To reduce the amount of spam sent to Gmail,
              # 550-5.7.1 this message has been blocked. Please visit
              # 550 5.7.1 https://support.google.com/mail/answer/188131 for more information.
              #
              # kijitora@example.co.uk
              #   host c.eu.example.com [192.0.2.3]
              #   SMTP error from remote mail server after end of data:
              #   553-SPF (Sender Policy Framework) domain authentication
              #   553-fail. Refer to the Troubleshooting page at
              #   553-http://www.symanteccloud.com/troubleshooting for more
              #   553 information. (#5.7.1)
              ['-', " "].each do |q|
                # Remove strings: "550-5.7.1", and "550 5.7.1" from the error message
                cx = sprintf("%s%s%s", cr, q, cs)
                p0 = p['diagnosticcode'].index(cx)
                while p0
                  # Remove strings like "550-5.7.1"
                  p['diagnosticcode'][p0, cx.size] = ''
                  p0 = p['diagnosticcode'].index(cx)
                end

                # Remove "553-" and "553 " (SMTP reply code only) from the error message
                cx = sprintf("%s%s", cr, q)
                p0 = p['diagnosticcode'].index(cx)
                while p0
                  # Remove strings like "553-"
                  p['diagnosticcode'][p0, cx.size] = ''
                  p0 = p['diagnosticcode'].index(cx)
                end
              end

              if p['diagnosticcode'].index(cr).to_i > 1
                # Add "550 5.1.1" into the head of the error message when the error message does not
                # begin with "550"
                p['diagnosticcode'] = sprintf("%s %s %s", cr, cs, p['diagnosticcode'])
              end
            end
          end

          p1 = p['diagnosticcode'].downcase.index('<html>')
          p2 = p['diagnosticcode'].downcase.index('</html>')
          p['diagnosticcode'][p1, p2 + 7 - p1] = '' if p1 && p2
          p['diagnosticcode'] = Sisimai::String.sweep(p['diagnosticcode'])
        end

        if Sisimai::String.is_8bit(p['diagnosticcode'])
          # To avoid incompatible character encodings: ASCII-8BIT and UTF-8 (Encoding::CompatibilityError
          p['diagnosticcode'] = p['diagnosticcode'].force_encoding('UTF-8').scrub('?')
        end

        p['diagnostictype']   = nil        if p['diagnostictype'].empty?
        p['diagnostictype'] ||= 'X-UNIX'   if p['reason'] == 'mailererror'
        p['diagnostictype'] ||= 'SMTP' unless %w[feedback vacation].include?(p['reason'])

        # Check the value of SMTP command
        p['smtpcommand'] = '' unless Sisimai::SMTP::Command.test(p['smtpcommand'])

        # Create parameters for the constructor
        as = Sisimai::Address.new(p['addresser'])          || next; next if as.void
        ar = Sisimai::Address.new(address: p['recipient']) || next; next if ar.void
        ea = %w[
          action deliverystatus diagnosticcode diagnostictype feedbacktype lhost listid messageid
          origin reason replycode rhost smtpagent smtpcommand subject 
        ]

        o = {
          'addresser'    => as,
          'recipient'    => ar,
          'senderdomain' => as.host,
          'destination'  => ar.host,
          'alias'        => p['alias'] || ar.alias,
          'token'        => Sisimai::String.token(as.address, ar.address, p['timestamp']),
        }

        # Other accessors
        ea.each { |q| o[q] ||= p[q] || '' }
        o['catch']          = p['catch'] || nil
        o['hardbounce']     = p['hardbounce']
        o['replycode']      = Sisimai::SMTP::Reply.find(p['diagnosticcode']).to_s if o['replycode'].empty?
        o['timestamp']      = TimeModule.parse(::Time.at(p['timestamp']).to_s)
        o['timezoneoffset'] = p['timezoneoffset'] || '+0000'

        # ALIAS
        while true do
          # Look up the Envelope-To address from the Received: header in the original message
          # when the recipient address is same with the value of o['alias'].
          break if o['alias'].empty?
          break if o['recipient'].address != o['alias']
          break unless rfc822data.has_key?('received')
          break if rfc822data['received'].empty?

          rfc822data['received'].reverse.each do |er|
            # Search for the string " for " from the Received: header
            next unless er.include?(' for ')

            af = Sisimai::RFC5322.received(er)
            next if af.empty?
            next if af[5].empty?
            next unless Sisimai::Address.is_emailaddress(af[5])
            next if o['recipient'].address == af[5]

            o['alias'] = af[5]
            break
          end
          break
        end
        o['alias'] = '' if o['alias'] == o['recipient'].address

        # REASON: Decide the reason of email bounce
        if o['reason'].empty? || RetryIndex[o['reason']]
          # The value of "reason" is empty or is needed to check with other values again
          re = ''; de = o['destination']
          re = Sisimai::Rhost.get(o) if Sisimai::Rhost.match(o['rhost'])
          if re.empty?
            # Failed to detect a bounce reason by the value of "rhost"
            re = Sisimai::Rhost.get(o, de) if Sisimai::Rhost.match(de)
            re = Sisimai::Reason.get(o)    if re.empty?
            re = 'undefined'               if re.empty?
          end
          o['reason'] = re
        end

        # HARDBOUNCE: Set the value of "hardbounce", default value of "bouncebounce" is false
        if o['reason'] == 'delivered' || o['reason'] == 'feedback' || o['reason'] == 'vacation'
          # The value of "reason" is "delivered", "vacation" or "feedback".
          o['replycode'] = '' unless o['reason'] == 'delivered'
        else
          smtperrors = p['deliverystatus'] + ' ' << p['diagnosticcode']
          smtperrors = '' if smtperrors.size < 4
          softorhard = Sisimai::SMTP::Error.soft_or_hard(o['reason'], smtperrors)
          o['hardbounce'] = true if softorhard == 'hard'
        end

        # DELIVERYSTATUS: Set a pseudo status code if the value of "deliverystatus" is empty
        if o['deliverystatus'].empty?
          smtperrors = p['replycode'] + ' ' << p['diagnosticcode']
          smtperrors = '' if smtperrors.size < 4
          permanent1 = Sisimai::SMTP::Error.is_permanent(smtperrors)
          permanent1 = true if permanent1 == nil
          o['deliverystatus'] = Sisimai::SMTP::Status.code(o['reason'], permanent1 ? false : true) || ''
        end

        # REPLYCODE: Check both of the first digit of "deliverystatus" and "replycode"
        cx = [o['deliverystatus'][0, 1], o['replycode'][0, 1]]
        if cx[0] != cx[1]
          # The class of the "Status:" is defer with the first digit of the reply code
          cx[1] = Sisimai::SMTP::Reply.find(p['diagnosticcode'], cx[0]) || ''
          o['replycode'] = cx[1].start_with?(cx[0]) ? cx[1] : ''
        end

        unless ActionList.has_key?(o['action'])
          # There is an action value which is not described at RFC1894
          if ox = Sisimai::RFC1894.field('Action: ' << o['action'])
            # Rewrite the value of "Action:" field to the valid value
            #
            #    The syntax for the action-field is:
            #       action-field = "Action" ":" action-value
            #       action-value = "failed" / "delayed" / "delivered" / "relayed" / "expanded"
            o['action'] = ox[2]
          end
        end
        o['action'] = 'delayed' if o['reason'] == 'expired'
        if o['action'].empty?
          o['action'] = 'failed' if cx[0] == '4' || cx[0] == '5'
        end

        listoffact << Sisimai::Fact.new(o)
      end
      return listoffact
    end

    # Emulate "softbounce" accessor for the backward compatible
    # @return   [Integer]
    def softbounce
      warn ' ***warning: Sisimai::Fact.softbounce will be removed at v5.1.0. Use Sisimai::Fact.hardbounce instead'
      return  0 if self.hardbounce
      return -1 if self.reason == 'delivered' || self.reason == 'feedback' || self.reason == 'vacation'
      return  1
    end

    # Convert from Sisimai::Fact object to a Hash
    # @return   [Hash] Hashed data
    def damn
      data = {}
      stringdata = %w[
        action alias catch deliverystatus destination diagnosticcode diagnostictype feedbacktype
        lhost listid messageid origin reason replycode rhost senderdomain smtpagent smtpcommand
        subject timezoneoffset token
      ]

      begin
        v = {}
        stringdata.each { |e| v[e] = self.send(e.to_sym) || '' }
        v['hardbounce'] = self.hardbounce
        v['addresser']  = self.addresser.address
        v['recipient']  = self.recipient.address
        v['timestamp']  = self.timestamp.to_time.to_i
        data = v
      rescue
        warn ' ***warning: Failed to execute Sisimai::Fact.damn'
      end
      return data
    end
    alias :to_hash :damn

    # Data dumper
    # @param    [String] type   Data format: json, yaml
    # @return   [String]        data
    #           [Nil]           The value of the first argument is neither "json" nor "yaml"
    def dump(type = 'json')
      return nil unless %w[json yaml].include?(type)
      referclass = 'Sisimai::Fact::' << type.upcase

      begin
        require referclass.downcase.gsub('::', '/')
      rescue
        warn '***warning: Failed to load' << referclass
      end

      dumpeddata = Module.const_get(referclass).dump(self)
      return dumpeddata
    end

    # JSON handler
    # @return   [String]        JSON string converted from Sisimai::Fact
    def to_json(*)
      return self.dump('json')
    end

  end
end

