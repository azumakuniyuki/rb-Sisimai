module Sisimai::Lhost
  # Sisimai::Lhost::Domino decodes a bounce email which created by HCL Domino https://www.hcl-software.com/domino.
  # Methods in the module are called from only Sisimai::Message.
  module Domino
    class << self
      require 'sisimai/lhost'

      Indicators = Sisimai::Lhost.INDICATORS
      Boundaries = ['Content-Type: message/rfc822'].freeze
      StartingOf = { message: ['Your message'] }.freeze
      MessagesOf = {
        'userunknown' => [
          'not listed in Domino Directory',
          'not listed in public Name & Address Book',
          "non répertorié dans l'annuaire Domino",
          'no se encuentra en el Directorio de Domino',
          'Domino ディレクトリには見つかりません',
        ],
        'filtered' => ['Cannot route mail to user'],
        'systemerror' => ['Several matches found in Domino Directory'],
      }.freeze

      # @abstract Decodes the bounce message from HCL Domino (formerly IBM Domino Server (formerly Lotus Domino))
      # @param  [Hash] mhead    Message headers of a bounce email
      # @param  [String] mbody  Message body of a bounce email
      # @return [Hash]          Bounce data list and message/rfc822 part
      # @return [Nil]           it failed to decode or the arguments are missing
      def inquire(mhead, mbody)
        return nil unless mhead['subject'].start_with?('DELIVERY FAILURE:', 'DELIVERY_FAILURE:')

        require 'sisimai/rfc1894'
        fieldtable = Sisimai::RFC1894.FIELDTABLE
        permessage = {}     # (Hash) Store values of each Per-Message field

        dscontents = [Sisimai::Lhost.DELIVERYSTATUS]
        emailparts = Sisimai::RFC5322.part(mbody, Boundaries)
        bodyslices = emailparts[0].split("\n")
        readcursor = 0      # (Integer) Points the current cursor position
        recipients = 0      # (Integer) The number of 'Final-Recipient' header
        subjecttxt = ''     # (String) The value of Subject:
        v = nil

        while e = bodyslices.shift do
          # Read error messages and delivery status lines from the head of the email to the previous
          # line of the beginning of the original message.
          next if e.empty?

          if readcursor == 0
            # Beginning of the bounce message or delivery status part
            readcursor |= Indicators[:deliverystatus] if e.start_with?(StartingOf[:message][0])
            next
          end
          next if (readcursor & Indicators[:deliverystatus]) == 0

          # Your message
          #
          #   Subject: Test Bounce
          #
          # was not delivered to:
          #
          #   kijitora@example.net
          #
          # because:
          #
          #   User some.name (kijitora@example.net) not listed in Domino Directory
          #
          v = dscontents[-1]

          if e.start_with?('was not delivered to:')
            # was not delivered to:
            #   kijitora@example.net
            if v['recipient']
              # There are multiple recipient addresses in the message body.
              dscontents << Sisimai::Lhost.DELIVERYSTATUS
              v = dscontents[-1]
            end
            v['recipient'] ||= e
            recipients += 1

          elsif e.start_with?('  ') && e.include?('@') && e.index(' ', 3).nil?
            # Continued from the line "was not delivered to:"
            #   kijitora@example.net
            v['recipient'] = Sisimai::Address.s3s4(e[2, e.size])

          elsif e.start_with?('because:')
            # because:
            #   User some.name (kijitora@example.net) not listed in Domino Directory
            v['diagnosis'] = e
          else
            if v['diagnosis'].to_s == 'because:'
              # Error message, continued from the line "because:"
              v['diagnosis'] = e

            elsif e.start_with?('  Subject: ')
              #   Subject: Nyaa
              subjecttxt = e[11, e.size]

            else
              # Other fields defined in RFC3464
              f = Sisimai::RFC1894.match(e); next if f < 1
              o = Sisimai::RFC1894.field(e); next if o.nil?
              next if o[3] == 'addr'

              if o[3] == 'code'
                # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                v['spec']      = o[1] if v['spec'].to_s.empty?
                v['diagnosis'] = o[2] if v['diagnosis'].to_s.empty?
              else
                # Other DSN fields defined in RFC3464
                next unless fieldtable[o[0]]
                v[fieldtable[o[0]]] = o[2]

                next unless f == 1
                permessage[fieldtable[o[0]]] = o[2]
              end
            end
          end
        end
        return nil unless recipients > 0

        dscontents.each do |e|
          e['diagnosis'] = Sisimai::String.sweep(e['diagnosis'])
          e['recipient'] = Sisimai::Address.s3s4(e['recipient'])
          permessage.each_key { |a| e[a] ||= permessage[a] || '' }

          MessagesOf.each_key do |r|
            # Check each regular expression of Domino error messages
            next unless MessagesOf[r].any? { |a| e['diagnosis'].include?(a) }
            e['reason']   = r
            e['status'] ||= Sisimai::SMTP::Status.code(r.to_s, false) || ''
            break
          end
        end

        # Set the value of subjecttxt as a Subject if there is no original message in the bounce mail.
        emailparts[1] << ('Subject: ' << subjecttxt << "\n") unless emailparts[1].include?("\nSubject:")

        return { 'ds' => dscontents, 'rfc822' => emailparts[1] }
      end
      def description; return 'IBM Domino Server'; end
    end
  end
end

