module Sisimai
  # Sisimai::ARF is a decoder for the email returned as a FeedBack Loop report message.
  module ARF
    class << self
      require 'sisimai/lhost'
      require 'sisimai/rfc5322'

      # http://tools.ietf.org/html/rfc5965
      # http://en.wikipedia.org/wiki/Feedback_loop_(email)
      # http://en.wikipedia.org/wiki/Abuse_Reporting_Format
      #
      # Netease DMARC uses:    This is a spf/dkim authentication-failure report for an email message received from IP
      # OpenDMARC 1.3.0 uses:  This is an authentication failure report for an email message received from IP
      # Abusix ARF uses        this is an autogenerated email abuse complaint regarding your network.
      Indicators = Sisimai::Lhost.INDICATORS
      StartingOf = {
        rfc822:  ['Content-Type: message/rfc822', 'Content-Type: text/rfc822-headers'],
        report:  ['Content-Type: message/feedback-report'],
        message: [
          ['this is a', 'abuse report'],
          ['this is a', 'authentication', 'failure report'],
          ['this is a', ' report for'],
          ['this is an authentication', 'failure report'],
          ['this is an autogenerated email abuse complaint'],
          ['this is an email abuse report'],
        ],
      }.freeze
      ReportFrom = ['staff@hotmail.com', 'complaints@email-abuse.amazonses.com'];
      LongFields = Sisimai::RFC5322.LONGFIELDS

      def description; return 'Abuse Feedback Reporting Format'; end

      # Email is a Feedback-Loop message or not
      # @param    [Hash] heads    Email header including "Content-Type", "From", and "Subject" field
      # @return   [True,False]    true: Feedback Loop
      #                           false: is not Feedback loop
      def is_arf(heads)
        return false unless heads

        # Content-Type: multipart/report; report-type=feedback-report; ...
        return true if Sisimai::String.aligned(heads['content-type'], ['report-type=', 'feedback-report'])

        match = false
        if heads['content-type'].include?('multipart/mixed')
          # Microsoft (Hotmail, MSN, Live, Outlook) uses its own report format.
          # Amazon SES Complaints bounces
          cv = Sisimai::Address.s3s4(heads['from'])
          if heads['subject'].include?('complaint about message from ')
            # From: staff@hotmail.com
            # From: complaints@email-abuse.amazonses.com
            # Subject: complaint about message from 192.0.2.1
            match = true if ReportFrom.any? { |a| cv.include?(a) }
          end
        end
        match = true if heads['x-apple-unsubscribe'] == 'true'

        return match
      end

      # @abstract Detect an error for Feedback Loop
      # @param  [Hash] mhead    Message headers of a bounce email
      # @param  [String] mbody  Message body of a bounce email
      # @return [Hash]          Bounce data list and message/rfc822 part
      # @return [Nil]           it failed to decode or the arguments are missing
      def inquire(mhead, mbody)
        return nil unless self.is_arf(mhead)

        dscontents = [Sisimai::Lhost.DELIVERYSTATUS]
        bodyslices = mbody.split("\n")
        rfc822part = ''   # (String) message/rfc822-headers part
        previousfn = ''   # (String) Previous field name
        readcursor = 0    # (Integer) Points the current cursor position
        recipients = 0    # (Integer) The number of 'Final-Recipient' header
        rcptintext = ''   # (String) Recipient address in the message body
        commondata = {
          'diagnosis' => '',  # Error message
          'from'      => '',  # Original-Mail-From:
          'rhost'     => '',  # Reporting-MTA:
        }
        arfheaders = {
          'feedbacktype' => nil,   # FeedBack-Type:
          'rhost'        => nil,   # Source-IP:
          'agent'        => nil,   # User-Agent:
          'date'         => nil,   # Arrival-Date:
          'authres'      => nil,   # Authentication-Results:
        }
        v = nil

        # 3.1.  Required Fields
        #
        #   The following report header fields MUST appear exactly once:
        #
        #   o  "Feedback-Type" contains the type of feedback report (as defined
        #      in the corresponding IANA registry and later in this memo).  This
        #      is intended to let report parsers distinguish among different
        #      types of reports.
        #
        #   o  "User-Agent" indicates the name and version of the software
        #      program that generated the report.  The format of this field MUST
        #      follow section 14.43 of [HTTP].  This field is for documentation
        #      only; there is no registry of user agent names or versions, and
        #      report receivers SHOULD NOT expect user agent names to belong to a
        #      known set.
        #
        #   o  "Version" indicates the version of specification that the report
        #      generator is using to generate the report.  The version number in
        #      this specification is set to "1".
        #
        while e = bodyslices.shift do
          # This is an email abuse report for an email message with the
          #   message-id of 0000-000000000000000000000000000000000@mx
          #   received from IP address 192.0.2.1 on
          #   Thu, 29 Apr 2010 00:00:00 +0900 (JST)
          p = e.downcase
          if commondata['diagnosis'].empty?
            commondata['diagnosis'] = e if StartingOf[:message].any? { |a| Sisimai::String.aligned(p, a) }
          end

          if readcursor == 0
            # Beginning of the bounce message or message/delivery-status part
            readcursor |= Indicators[:deliverystatus] if e.start_with?(StartingOf[:report][0])
          end

          if (readcursor & Indicators[:'message-rfc822']) == 0
            # Beginning of the original message part
            if e.start_with?(StartingOf[:rfc822][0], StartingOf[:rfc822][1])
              readcursor |= Indicators[:'message-rfc822']
              next
            end
          end

          if readcursor & Indicators[:'message-rfc822'] > 0
            # message/rfc822 OR text/rfc822-headers part
            if e.start_with?('X-HmXmrOriginalRecipient:')
              # Microsoft ARF: original recipient.
              dscontents[-1]['recipient'] = Sisimai::Address.s3s4(e[e.index(':') + 1, e.size])
              recipients += 1

              # The "X-HmXmrOriginalRecipient" header appears only once so we take this opportunity
              # to hard-code ARF headers missing in Microsoft's implementation.
              arfheaders['feedbacktype'] = 'abuse'
              arfheaders['agent'] = 'Microsoft Junk Mail Reporting Program'

            elsif e.start_with?('From: ')
              # Microsoft ARF: original sender.
              commondata['from'] = Sisimai::Address.s3s4(e[6, e.size]) if commondata['from'].empty?
              previousfn = 'from'

            elsif e.start_with?(' ')
              # Continued line from the previous line
              if previousfn == 'from'
                # Multiple lines at "From:" field
                commondata['from'] << e
                next
              else
                rfc822part << e + "\n" if LongFields[previousfn]
                next unless e.empty?
              end
              rcptintext << e if previousfn == 'to'

            else
              # Get required headers only
              (lhs, rhs) = e.split(/:[ ]/, 2)
              next unless lhs
              lhs.downcase!

              previousfn  = lhs
              rfc822part << e + "\n"
              rcptintext  = rhs if lhs == 'to'
            end
          else
            # message/feedback-report part
            next unless readcursor & Indicators[:deliverystatus] > 0
            next if e.empty?

            # Feedback-Type: abuse
            # User-Agent: SomeGenerator/1.0
            # Version: 0.1
            # Original-Mail-From: <somespammer@example.net>
            # Original-Rcpt-To: <kijitora@example.jp>
            # Received-Date: Thu, 29 Apr 2009 00:00:00 JST
            # Source-IP: 192.0.2.1
            v = dscontents[-1]

            if e.start_with?('Original-Rcpt-To: ', 'Redacted-Address: ')
              # Original-Rcpt-To header field is optional and may appear any number of times as appropriate:
              # Original-Rcpt-To: <user@example.com>
              # Redacted-Address: localpart@
              if v['recipient']
                # There are multiple recipient addresses in the message body.
                dscontents << Sisimai::Lhost.DELIVERYSTATUS
                v = dscontents[-1]
              end
              v['recipient'] = Sisimai::Address.s3s4(e[e.index(' ') + 1, e.size])
              recipients += 1

            elsif e.start_with?('Feedback-Type: ')
              # The header field MUST appear exactly once.
              # Feedback-Type: abuse
              arfheaders['feedbacktype'] = e[e.index(' ') + 1, e.size]

            elsif e.start_with?('Authentication-Results: ')
              # "Authentication-Results" indicates the result of one or more authentication checks
              # run by the report generator.
              #   Authentication-Results: mail.example.jp; spf=fail smtp.mail=spammer@example.com
              arfheaders['authres'] = e[e.index(' ') + 1, e.size]

            elsif e.start_with?('User-Agent: ')
              # The header field MUST appear exactly once.
              # User-Agent: SomeGenerator/1.0
              arfheaders['agent'] = e[e.index(' ') + 1, e.size]

            elsif e.start_with?('Received-Date: ', 'Arrival-Date: ')
              # Arrival-Date header is optional and MUST NOT appear more than once.
              # Received-Date: Thu, 29 Apr 2010 00:00:00 JST
              # Arrival-Date: Thu, 29 Apr 2010 00:00:00 +0000
              arfheaders['date'] = e[e.index(' ') + 1, e.size]

            elsif e.start_with?('Reporting-MTA: dns; ')
              # The header is optional and MUST NOT appear more than once.
              # Reporting-MTA: dns; mx.example.jp
              commondata['rhost'] = e[e.index(';') + 2, e.size]

            elsif e.start_with?('Source-IP: ')
              # The header is optional and MUST NOT appear more than once.
              # Source-IP: 192.0.2.45
              arfheaders['rhost'] = e[e.index(' ') + 1, e.size]

            elsif e.start_with?('Original-Mail-From: ')
              # the header is optional and MUST NOT appear more than once.
              # Original-Mail-From: <somespammer@example.net>
              commondata['from'] = Sisimai::Address.s3s4(e[e.index(' ') + 1, e.size]) if commondata['from'].empty?

            end
          end
        end

        if arfheaders['feedbacktype'] == 'auth-failure' && arfheaders['authres']
          # Append the value of Authentication-Results header
          commondata['diagnosis'] << ' ' << arfheaders['authres']
        end

        if recipients == 0
          # The original recipient address was not found
          if Sisimai::String.aligned(rfc822part, ["\nTo: ", '@'])
            # pick the address from To: header in message/rfc822 part.
            p1 = rfc822part.index("\nTo: ") + 5
            p2 = rfc822part.index("\n", p1 + 1)
            cm = p2 > 0 ? p2 - p1 : 255
            dscontents[-1]['recipient'] = Sisimai::Address.s3s4(rfc822part[p1, cm])
            recipients = 1
          end

          while true
            # Insert pseudo recipient address when there is no valid recipient address in the message
            # for example,
            #   Date: Thu, 29 Apr 2015 23:34:45 +0000
            #   To: "undisclosed"
            #   Subject: Nyaan
            #   Message-ID: <ffffffffffffffffffffffff00000000@example.net>
            dscontents[-1]['recipient'] ||= ''
            break if dscontents[-1]['recipient'].include?('@')
            dscontents[-1]['recipient'] = Sisimai::Address.undisclosed(true)
            recipients = 1
            break
          end
        end

        unless Sisimai::String.aligned(rfc822part, ['From: ', '@'])
          # There is no "From:" header in the original message. Append the value of "Original-Mail-From"
          # value as a sender address.
          rfc822part << 'From: ' << commondata['from'] + "\n" unless commondata['from'].empty?
        end

        if mhead['subject'].include?('complaint about message from ')
          # Microsoft ARF: remote host address.
          arfheaders['rhost'] = mhead['subject'][mhead['subject'].rindex(' ') + 1, mhead['subject'].size]
          commondata['diagnosis'] =
            'This is a Microsoft email abuse report for an email message received from IP' << arfheaders['rhost'] + ' on ' << mhead['date']

        elsif mhead['subject'].include?('unsubscribe')
          # Apple Mail sent this email to unsubscribe from the message
          while true
            # Subject: unsubscribe
            # Content-Type: text/plain; charset=UTF-8
            # Auto-Submitted: auto-replied
            # X-Apple-Unsubscribe: true
            #
            # Apple Mail sent this email to unsubscribe from the message
            break unless mhead['x-apple-unsubscribe']
            break unless mhead['x-apple-unsubscribe'] == 'true'
            break unless mbody.include?('Apple Mail sent this email to unsubscribe from the message');

            dscontents[-1]['recipient'] = Sisimai::Address.s3s4(mhead['from'])
            dscontents[-1]['feedbacktype'] = 'opt-out'
            break
          end
        end

        dscontents.each do |e|
          # AOL = http://forums.cpanel.net/f43/aol-brutal-work-71473.html
          e['recipient'] = Sisimai::Address.s3s4(rcptintext) if e['recipient'][-1, 1] == '@'
          arfheaders.each_key { |a| e[a] ||= arfheaders[a] || '' }
          e.delete('authres')

          e['diagnosis']  = commondata['diagnosis'] unless e['diagnosis']
          e['diagnosis']  = Sisimai::String.sweep(e['diagnosis'])
          e['date']       = mhead['date'] if e['date'].empty?
          e['reason']     = 'feedback'
          e['agent']      = 'Feedback-Loop'
          %w[command action status alias].each { |a| e[a] = '' }

          # Get the remote IP address from the message body
          next unless e['rhost'].empty?
          if commondata['rhost'].size > 0
            # The value of "Reporting-MTA" header
            e['rhost'] = commondata['rhost']

          else
            # Try to get an IP address from the error message
            # This is an email abuse report for an email message received from IP address 24.64.1.1
            # on Thu, 29 Apr 2010 00:00:00 +0000
            ip = Sisimai::String.ipv4(e['diagnosis']) || []
            e['rhost'] = ip[0] if ip.size > 0
          end
        end
        return { 'ds' => dscontents, 'rfc822' => rfc822part }
      end
    end
  end
end

