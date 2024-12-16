module Sisimai::Lhost
  # Sisimai::Lhost::Biglobe decodes a bounce email which created by BIGLOBE https://www.biglobe.ne.jp/.
  # Methods in the module are called from only Sisimai::Message.
  module Biglobe
    class << self
      require 'sisimai/lhost'

      Indicators = Sisimai::Lhost.INDICATORS
      Boundaries = ['Content-Type: message/rfc822'].freeze
      StartingOf = {
        message: ['   ----- The following addresses had delivery problems -----'],
        error:   ['   ----- Non-delivered information -----'],
      }.freeze
      MessagesOf = {
        'filtered'    => ['Mail Delivery Failed... User unknown'],
        'mailboxfull' => ["The number of messages in recipient's mailbox exceeded the local limit."],
      }.freeze

      # @asbtract Decodes the bounce message from Biglobe
      # @param  [Hash] mhead    Message headers of a bounce email
      # @param  [String] mbody  Message body of a bounce email
      # @return [Hash]          Bounce data list and message/rfc822 part
      # @return [Nil]           it failed to decode or the arguments are missing
      def inquire(mhead, mbody)
        return nil unless mhead['from'].include?('postmaster@')
        return nil unless %w[biglobe inacatv tmtv ttv].any? { |a| mhead['from'].include?('@' + a + '.ne.jp') }
        return nil unless mhead['subject'].start_with?('Returned mail:')

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
            # Beginning of the bounce message or delivery status part
            readcursor |= Indicators[:deliverystatus] if e == StartingOf[:message][0]
            next
          end
          next if (readcursor & Indicators[:deliverystatus]) == 0
          next if e.empty?

          # This is a MIME-encapsulated message.
          #
          # ----_Biglobe000000/00000.biglobe.ne.jp
          # Content-Type: text/plain; charset="iso-2022-jp"
          #
          #    ----- The following addresses had delivery problems -----
          # ********@***.biglobe.ne.jp
          #
          #    ----- Non-delivered information -----
          # The number of messages in recipient's mailbox exceeded the local limit.
          #
          # ----_Biglobe000000/00000.biglobe.ne.jp
          # Content-Type: message/rfc822
          #
          v = dscontents[-1]

          if e.include?('@') && e.include?(' ') == false
            #    ----- The following addresses had delivery problems -----
            # ********@***.biglobe.ne.jp
            if v['recipient']
              # There are multiple recipient addresses in the message body.
              dscontents << Sisimai::Lhost.DELIVERYSTATUS
              v = dscontents[-1]
            end

            next unless Sisimai::Address.is_emailaddress(e)
            v['recipient'] = e
            recipients += 1
          else
            next if e.include?('--')
            v['diagnosis'] << e + ' '
          end
        end
        return nil unless recipients > 0

        dscontents.each do |e|
          e['diagnosis'] = Sisimai::String.sweep(e['diagnosis'])

          MessagesOf.each_key do |r|
            # Verify each regular expression of session errors
            next unless MessagesOf[r].any? { |a| e['diagnosis'].include?(a) }
            e['reason'] = r
            break
          end
        end

        return { 'ds' => dscontents, 'rfc822' => emailparts[1] }
      end
      def description; return 'BIGLOBE: https://www.biglobe.ne.jp'; end
    end
  end
end

