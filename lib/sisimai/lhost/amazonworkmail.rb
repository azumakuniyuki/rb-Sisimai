module Sisimai::Lhost
  # Sisimai::Lhost::AmazonWorkMail decodes a bounce email which created by Amazon WorkMail https://aws.amazon.com/workmail/.
  # Methods in the module are called from only Sisimai::Message.
  module AmazonWorkMail
    class << self
      require 'sisimai/lhost'

      # https://aws.amazon.com/workmail/
      Indicators = Sisimai::Lhost.INDICATORS
      Boundaries = ['Content-Type: message/rfc822'].freeze
      StartingOf = { message: ['Technical report:'] }.freeze

      # @abstract Decodes the bounce message from Amazon WorkMail
      # @param  [Hash] mhead    Message headers of a bounce email
      # @param  [String] mbody  Message body of a bounce email
      # @return [Hash]          Bounce data list and message/rfc822 part
      # @return [Nil]           it failed to decode or the arguments are missing
      def inquire(mhead, mbody)
        # X-Mailer: Amazon WorkMail
        # X-Original-Mailer: Amazon WorkMail
        # X-Ses-Outgoing: 2016.01.14-54.240.27.159
        match = 0
        xmail = mhead['x-original-mailer'] || mhead['x-mailer'] || ''

        match += 1 if mhead['x-ses-outgoing']
        unless xmail.empty?
          # X-Mailer: Amazon WorkMail
          # X-Original-Mailer: Amazon WorkMail
          match += 1 if xmail == 'Amazon WorkMail'
        end
        return nil if match < 2

        require 'sisimai/rfc1894'
        fieldtable = Sisimai::RFC1894.FIELDTABLE
        permessage = {}     # (Hash) Store values of each Per-Message field

        dscontents = [Sisimai::Lhost.DELIVERYSTATUS]
        emailparts = Sisimai::RFC5322.part(mbody, Boundaries)
        bodyslices = emailparts[0].split("\n")
        readcursor = 0      # (Integer) Points the current cursor position
        recipients = 0      # (Integer) The number of 'Final-Recipient' header
        v = nil

        while e = bodyslices.shift do
          # Read error messages and delivery status lines from the head of the email to the previous
          # line of the beginning of the original message.

          if readcursor == 0
            # Beginning of the bounce message or message/delivery-status part
            readcursor |= Indicators[:deliverystatus] if e == StartingOf[:message][0]
            next
          end
          next if (readcursor & Indicators[:deliverystatus]) == 0
          next if e.empty?

          if f = Sisimai::RFC1894.match(e)
            # "e" matched with any field defined in RFC3464
            o = Sisimai::RFC1894.field(e) || next
            v = dscontents[-1]

            if o[3] == 'addr'
              # Final-Recipient: rfc822; kijitora@example.jp
              # X-Actual-Recipient: rfc822; kijitora@example.co.jp
              if o[0] == 'final-recipient'
                # Final-Recipient: rfc822; kijitora@example.jp
                if v['recipient']
                  # There are multiple recipient addresses in the message body.
                  dscontents << Sisimai::Lhost.DELIVERYSTATUS
                  v = dscontents[-1]
                end
                v['recipient'] = o[2]
                recipients += 1
              else
                # X-Actual-Recipient: rfc822; kijitora@example.co.jp
                v['alias'] = o[2]
              end
            elsif o[3] == 'code'
              # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
              v['spec'] = o[1]
              v['diagnosis'] = o[2]
            else
              # Other DSN fields defined in RFC3464
              next unless fieldtable[o[0]]
              v[fieldtable[o[0]]] = o[2]

              next unless f
              permessage[fieldtable[o[0]]] = o[2]
            end
          end

          # <!DOCTYPE HTML><html>
          # <head>
          # <meta name="Generator" content="Amazon WorkMail v3.0-2023.77">
          # <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
          break if e.start_with?('<!DOCTYPE HTML><html>')
        end
        return nil unless recipients > 0

        dscontents.each do |e|
          # Set default values if each value is empty.
          permessage.each_key { |a| e[a] ||= permessage[a] || '' }

          e['diagnosis'] = Sisimai::String.sweep(e['diagnosis'])
          if e['status'].to_s.end_with?('.0.0', '.1.0')
            # Get other D.S.N. value from the error message
            errormessage = e['diagnosis']

            if cv = e['diagnosis'].match(/["'](\d[.]\d[.]\d.+)['"]/)
              # 5.1.0 - Unknown address error 550-'5.7.1 ...
              errormessage = cv[1]
            end
            e['status'] = Sisimai::SMTP::Status.find(errormessage) || e['status']
          end

          # 554 4.4.7 Message expired: unable to deliver in 840 minutes.
          # <421 4.4.2 Connection timed out>
          e['replycode'] = Sisimai::SMTP::Reply.find(e['diagnosis']) || ''
          e['reason']  ||= Sisimai::SMTP::Status.name(e['status'])   || ''
        end

        return { 'ds' => dscontents, 'rfc822' => emailparts[1] }
      end
      def description; return 'Amazon WorkMail: https://aws.amazon.com/workmail/'; end
    end
  end
end

