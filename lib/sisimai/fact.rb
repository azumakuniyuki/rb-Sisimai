module Sisimai
  # Sisimai::Fact generate the list of decoded bounce data
  class Fact
    require 'sisimai/message'
    require 'sisimai/rfc1123'
    require 'sisimai/rfc1894'
    require 'sisimai/rfc5322'
    require 'sisimai/reason'
    require 'sisimai/address'
    require 'sisimai/datetime'
    require 'sisimai/time'
    require 'sisimai/smtp/failure'
    require 'sisimai/smtp/command'
    require 'sisimai/string'
    require 'sisimai/rhost'
    require 'sisimai/lda'

    @@rwaccessors = [
      :action,          # [String] The value of Action: header
      :addresser,       # [Sisimai::Address] From address
      :alias,           # [String] Alias of the recipient address
      :catch,           # [?] Results generated by hook method
      :deliverystatus,  # [String] Delivery Status(DSN)
      :destination,     # [String] The domain part of the "recipient"
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
    RFC822Head = Sisimai::RFC5322.HEADERTABLE
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
    # @options argvs [Boolean] delivered  true if the result which has "delivered" reason is included
    # @options argvs [Boolean] vacation   true if the result which has "vacation" reason is included
    # @options argvs [Proc]    hook       Proc object of the callback method
    # @options argvs [String]  origin     Path to the original email file
    # @return        [Array]              Array of Sisimai::Fact objects
    def self.rise(**argvs)
      return nil unless argvs
      return nil unless argvs.is_a? Hash

      email = argvs[:data]; return nil unless email
      args1 = { data: email, hook: argvs[:hook] }
      mesg1 = Sisimai::Message.rise(**args1)
      return nil unless mesg1
      return nil unless mesg1['ds']
      return nil unless mesg1['rfc822']

      deliveries = mesg1['ds'].dup
      rfc822data = mesg1['rfc822']
      listoffact = [];

      while e = deliveries.shift do
        # Create parameters for each Sisimai::Fact object
        next if e['recipient'].size < 5
        next if ! argvs[:vacation]  && e['reason'] == 'vacation'
        next if ! argvs[:delivered] && e['status'].start_with?('2.')

        thing = {}  # To be passed to each accessor of Sisimai::Fact
        piece = {
          "action"         => e["action"],
          "alias"          => e["alias"],
          "catch"          => mesg1["catch"] || nil,
          "deliverystatus" => e["status"],
          "diagnosticcode" => e["diagnosis"],
          "diagnostictype" => e["spec"],
          "feedbacktype"   => e["feedbacktype"],
          "hardbounce"     => false,
          "lhost"          => e["lhost"],
          "origin"         => argvs[:origin],
          "reason"         => e["reason"],
          "recipient"      => e["recipient"],
          "replycode"      => e["replycode"],
          "rhost"          => e["rhost"],
          "smtpagent"      => e["agent"],
          "smtpcommand"    => e["command"],
        }

        # EMAILADDRESS: Detect an email address from message/rfc822 part
        RFC822Head[:addresser].each do |f|
          # Check each header in message/rfc822 part
          next unless rfc822data[f]
          next if rfc822data[f].empty?

          j = Sisimai::Address.find(rfc822data[f]) || next
          piece['addresser'] = j.shift
          break
        end

        unless piece['addresser']
          # Fallback: Get the sender address from the header of the bounced email if the address is
          # not set at loop above.
          j = Sisimai::Address.find(mesg1['header']['to']) || []
          piece['addresser'] = j.shift
        end
        next unless piece['addresser']

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
          datestring = Sisimai::DateTime.parse(v) || next

          if cv = datestring.match(/\A(.+)[ ]+([-+]\d{4})\z/)
            # Get the value of timezone offset from datestring: Wed, 26 Feb 2014 06:05:48 -0500
            datestring = cv[1]
            zoneoffset = Sisimai::DateTime.tz2second(cv[2])
            piece['timezoneoffset'] = cv[2]
          end
          break if datestring
        end

        begin
          # Convert from the date string to an object then calculate time zone offset.
          t = TimeModule.strptime(datestring, '%a, %d %b %Y %T')
          piece['timestamp'] = (t.to_time.to_i - zoneoffset) || nil
        rescue
          warn ' ***warning: Failed to strptime ' << datestring.to_s
        end
        next unless piece['timestamp']

        # OTHER_TEXT_HEADERS:
        recv = mesg1["header"]["received"] || []
        if piece["rhost"].empty?
          # Try to pick a remote hostname from Received: headers of the bounce message
          ir = Sisimai::RFC1123.find(e["diagnosis"])
          piece["rhost"] = ir if Sisimai::RFC1123.is_internethost(ir)

          if piece["rhost"].empty?
            # The remote hostname in the error message did not exist or is not a valid
            # internet hostname
            recv.reverse.each do |re|
              # Check the Received: headers backwards and get a remote hostname
              break if piece["rhost"].size > 0
              cv = Sisimai::RFC5322.received(re)[0]
              next unless Sisimai::RFC1123.is_internethost(cv)
              piece['rhost'] = cv
            end
          end
        end
        piece["lhost"] = "" if piece["rhost"] == piece["lhost"]

        if piece["lhost"].empty?
          # Try to pick a local hostname from Received: headers of the bounce message
          recv.each do |le|
            # Check the Received: headers backwards and get a local hostname
            cv = Sisimai::RFC5322.received(le)[0]
            next unless Sisimai::RFC1123.is_internethost(cv)
            piece['lhost'] = cv
            break
          end
        end

        # Remove square brackets and curly brackets from the host variable
        %w[rhost lhost].each do |v|
          next if piece[v].empty?

          if piece[v].include?('@')
            # Use the domain part as a remote/local host when the value is an email address
            piece[v] = piece[v].split('@')[-1]
          end
          piece[v].delete!('[]()')    # Remove square brackets and curly brackets from the host variable
          piece[v].sub!(/\A.+=/, '')  # Remove string before "="
          piece[v].sub!("\r", '')     # Remove CR at the end of the value

          if piece[v].include?(' ')
            # Check space character in each value and get the first hostname
            ee = piece[v].split(' ')
            ee.each do |w|
              # get a hostname from the string like "127.0.0.1 x109-20.example.com 192.0.2.20"
              # or "mx.sp.example.jp 192.0.2.135"
              next if w =~ /\A\d{1,3}[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}\z/; # Skip if it is an IPv4 address
              piece[v] = w
              break
            end
          end
          piece[v] = ee[0] if piece[v].include?(' ')
          piece[v].chomp!('.') if piece[v].end_with?('.')   # Remove "." at the end of the value
        end

        # Subject: header of the original message
        piece['subject'] = rfc822data['subject'] || ''
        piece['subject'].scrub!('?')
        piece['subject'].chomp!("\r") if piece['subject'].end_with?("\r")

        # The value of "List-Id" header
        if Sisimai::String.aligned(rfc822data['list-id'], ['<', '.', '>'])
          # https://www.rfc-editor.org/rfc/rfc2919
          # Get the value of List-Id header: "List name <list-id@example.org>"
          p0 = rfc822data['list-id'].index('<') + 1
          p1 = rfc822data['list-id'].index('>')
          piece['listid'] = rfc822data['list-id'][p0, p1 - p0]
        else
          # Invalid value of the List-Id: field
          piece['listid'] = ''
        end

        # The value of "Message-Id" header
        if Sisimai::String.aligned(rfc822data['message-id'], ['<', '@', '>'])
          # https://www.rfc-editor.org/rfc/rfc5322#section-3.6.4
          # Leave only string inside of angle brackets(<>)
          p0 = rfc822data['message-id'].index('<') + 1
          p1 = rfc822data['message-id'].index('>')
          piece['messageid'] = rfc822data['message-id'][p0, p1 - p0]
        else
          # Invalid value of the Message-Id: field
          piece['messageid'] = ''
        end

        # CHECK_DELIVERY_STATUS_VALUE: Cleanup the value of "Diagnostic-Code:" header
        if piece['diagnosticcode'].to_s.size > 0
          # Get an SMTP Reply Code and an SMTP Enhanced Status Code
          piece['diagnosticcode'].chop if piece['diagnosticcode'][-1, 1] == "\r"

          cs = Sisimai::SMTP::Status.find(piece['diagnosticcode'])    || ''
          cr = Sisimai::SMTP::Reply.find(piece['diagnosticcode'], cs) || ''
          piece['deliverystatus'] = Sisimai::SMTP::Status.prefer(piece['deliverystatus'], cs, cr)

          if cr.size == 3
            # There is an SMTP reply code in the error message
            piece['replycode'] = cr if piece['replycode'].empty?

            if piece['diagnosticcode'].include?(cr + '-')
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
                p0 = piece['diagnosticcode'].index(cx)
                while p0
                  # Remove strings like "550-5.7.1"
                  piece['diagnosticcode'][p0, cx.size] = ''
                  p0 = piece['diagnosticcode'].index(cx)
                end

                # Remove "553-" and "553 " (SMTP reply code only) from the error message
                cx = sprintf("%s%s", cr, q)
                p0 = piece['diagnosticcode'].index(cx)
                while p0
                  # Remove strings like "553-"
                  piece['diagnosticcode'][p0, cx.size] = ''
                  p0 = piece['diagnosticcode'].index(cx)
                end
              end

              if piece['diagnosticcode'].index(cr).to_i > 1
                # Add "550 5.1.1" into the head of the error message when the error message does not
                # begin with "550"
                piece['diagnosticcode'] = sprintf("%s %s %s", cr, cs, piece['diagnosticcode'])
              end
            end
          end

          dc = piece['diagnosticcode'].downcase
          p1 = dc.index('<html>')
          p2 = dc.index('</html>')
          piece['diagnosticcode'][p1, p2 + 7 - p1] = '' if p1 && p2
          piece['diagnosticcode'] = Sisimai::String.sweep(piece['diagnosticcode'])
        end

        if Sisimai::String.is_8bit(piece['diagnosticcode'])
          # To avoid incompatible character encodings: ASCII-8BIT and UTF-8 (Encoding::CompatibilityError
          piece['diagnosticcode'] = piece['diagnosticcode'].force_encoding('UTF-8').scrub('?')
        end

        if piece["reason"] == "mailererror"
          piece["diagnostictype"] = "X-UNIX"
        else
          piece["diagnostictype"] = "SMTP" unless %w[feedback vacation].include?(piece["reason"])
        end

        # Check the value of SMTP command
        piece['smtpcommand'] = '' unless Sisimai::SMTP::Command.test(piece['smtpcommand'])

        # Create parameters for the constructor
        as = Sisimai::Address.new(piece['addresser'])          || next; next if as.void
        ar = Sisimai::Address.new(address: piece['recipient']) || next; next if ar.void
        ea = %w[
          action deliverystatus diagnosticcode diagnostictype feedbacktype lhost listid messageid
          origin reason replycode rhost smtpagent smtpcommand subject
        ]

        thing = {
          'addresser'    => as,
          'recipient'    => ar,
          'senderdomain' => as.host,
          'destination'  => ar.host,
          'alias'        => piece['alias'] || ar.alias,
          'token'        => Sisimai::String.token(as.address, ar.address, piece['timestamp']),
        }
        ea.each { |q| thing[q] = piece[q] if thing[q].nil? || thing[q].empty? }

        # Other accessors
        thing['catch']          = piece['catch'] || nil
        thing['hardbounce']     = piece['hardbounce']
        thing['replycode']      = Sisimai::SMTP::Reply.find(piece['diagnosticcode']).to_s if thing['replycode'].empty?
        thing['timestamp']      = TimeModule.parse(::Time.at(piece['timestamp']).to_s)
        thing['timezoneoffset'] = piece['timezoneoffset'] || '+0000'
        ea.each { |q| thing[q] = piece[q] if thing[q].empty? }

        # ALIAS
        while true do
          # Look up the Envelope-To address from the Received: header in the original message
          # when the recipient address is same with the value of thing['alias'].
          break if thing['alias'].empty?
          break if thing['recipient'].address != thing['alias']
          break unless rfc822data.has_key?('received')
          break if rfc822data['received'].empty?

          rfc822data['received'].reverse.each do |er|
            # Search for the string " for " from the Received: header
            next unless er.include?(' for ')

            af = Sisimai::RFC5322.received(er)
            next if af.empty?
            next if af[5].empty?
            next unless Sisimai::Address.is_emailaddress(af[5])
            next if thing['recipient'].address == af[5]

            thing['alias'] = af[5]
            break
          end
          break
        end
        thing['alias'] = '' if thing['alias'] == thing['recipient'].address

        # REASON: Decide the reason of email bounce
        while true
          if thing["reason"].empty? || RetryIndex[thing["reason"]]
            # The value of "reason" is empty or is needed to check with other values again
            re = thing["reason"].empty? ? "undefined" : thing["reason"]
            cr = Sisimai::LDA.find(thing);    if Sisimai::Reason.is_explicit(cr) then thing["reason"] = cr; break; end
            cr = Sisimai::Rhost.find(thing);  if Sisimai::Reason.is_explicit(cr) then thing["reason"] = cr; break; end
            cr = Sisimai::Reason.find(thing); if Sisimai::Reason.is_explicit(cr) then thing["reason"] = cr; break; end
            thing["reason"] = thing["diagnosticcode"].size > 0 ? "onhold" : re
            break
          end
          break
        end

        # HARDBOUNCE: Set the value of "hardbounce", default value of "bouncebounce" is false
        if thing['reason'] == 'delivered' || thing['reason'] == 'feedback' || thing['reason'] == 'vacation'
          # Delete the value of ReplyCode when the Reason is "feedback" or "vacation"
          thing['replycode'] = '' unless thing['reason'] == 'delivered'
        else
          # The reason is not "delivered", or "feedback", or "vacation"
          smtperrors = piece['deliverystatus'] + ' ' << piece['diagnosticcode']
          smtperrors = '' if smtperrors.size < 4
          thing['hardbounce'] = Sisimai::SMTP::Failure.is_hardbounce(thing['reason'], smtperrors)
        end

        # DELIVERYSTATUS: Set a pseudo status code if the value of "deliverystatus" is empty
        if thing['deliverystatus'].empty?
          smtperrors = piece['replycode'] + ' ' << piece['diagnosticcode']
          smtperrors = '' if smtperrors.size < 4
          permanent0 = Sisimai::SMTP::Failure.is_permanent(smtperrors)
          temporary0 = Sisimai::SMTP::Failure.is_temporary(smtperrors)
          temporary1 = temporary0; temporary1 = false if !permanent0 && !temporary1 
          thing['deliverystatus'] = Sisimai::SMTP::Status.code(thing['reason'], temporary1) || ''
        end

        # REPLYCODE: Check both of the first digit of "deliverystatus" and "replycode"
        cx = [thing['deliverystatus'][0, 1], thing['replycode'][0, 1]]
        if cx[0] != cx[1]
          # The class of the "Status:" is defer with the first digit of the reply code
          cx[1] = Sisimai::SMTP::Reply.find(piece['diagnosticcode'], cx[0]) || ''
          thing['replycode'] = cx[1].start_with?(cx[0]) ? cx[1] : ''
        end

        unless ActionList.has_key?(thing['action'])
          # There is an action value which is not described at RFC1894
          if ox = Sisimai::RFC1894.field('Action: ' << thing['action'])
            # Rewrite the value of "Action:" field to the valid value
            #
            #    The syntax for the action-field is:
            #       action-field = "Action" ":" action-value
            #       action-value = "failed" / "delayed" / "delivered" / "relayed" / "expanded"
            thing['action'] = ox[2]
          end
        end
        thing["action"] = ""          if thing["action"].nil?
        thing["action"] = "delivered" if thing["action"].empty? && thing["reason"] == "delivered"
        thing["action"] = "delayed"   if thing["action"].empty? && thing["reason"] == "expired"
        thing["action"] = "failed"    if thing["action"].empty? && cx[0] == "4" || cx[0] == "5"

        listoffact << Sisimai::Fact.new(thing)
      end
      return listoffact
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

