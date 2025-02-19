module Sisimai::Lhost
  # Sisimai::Lhost::GMX decodes a bounce email which created by GMX https://gmx.net/.
  # Methods in the module are called from only Sisimai::Message.
  module GMX
    class << self
      require 'sisimai/lhost'

      Indicators = Sisimai::Lhost.INDICATORS
      Boundaries = ['--- The header of the original message is following. ---'].freeze
      StartingOf = { message: ['This message was created automatically by mail delivery software'] }.freeze
      MessagesOf = { 'expired' => ['delivery retry timeout exceeded'] }.freeze

      # @abstract Decodes the bounce message from GMX
      # @param  [Hash] mhead    Message headers of a bounce email
      # @param  [String] mbody  Message body of a bounce email
      # @return [Hash]          Bounce data list and message/rfc822 part
      # @return [Nil]           it failed to decode or the arguments are missing
      def inquire(mhead, mbody)
        # Envelope-To: <kijitora@mail.example.com>
        # X-GMX-Antispam: 0 (Mail was not recognized as spam); Detail=V3;
        # X-GMX-Antivirus: 0 (no virus found)
        # X-UI-Out-Filterresults: unknown:0;
        return nil unless mhead['x-gmx-antispam']

        require 'sisimai/smtp/command'
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
            readcursor |= Indicators[:deliverystatus] if e.start_with?(StartingOf[:message][0])
            next
          end
          next if (readcursor & Indicators[:deliverystatus]) == 0
          next if e.empty?

          # This message was created automatically by mail delivery software.
          #
          # A message that you sent could not be delivered to one or more of
          # its recipients. This is a permanent error. The following address
          # failed:
          #
          # "shironeko@example.jp":
          # SMTP error from remote server after RCPT command:
          # host: mx.example.jp
          # 5.1.1 <shironeko@example.jp>... User Unknown
          v = dscontents[-1]

          if e.include?('@') && ( e.start_with?('"') || e.start_with?('<') )
            # "shironeko@example.jp":
            # ---- OR ----
            # <kijitora@6jo.example.co.jp>
            #
            # Reason:
            # delivery retry timeout exceeded
            if v["recipient"] != ""
              # There are multiple recipient addresses in the message body.
              dscontents << Sisimai::Lhost.DELIVERYSTATUS
              v = dscontents[-1]
            end
            v['recipient'] = Sisimai::Address.s3s4(e)
            recipients += 1

          elsif e.start_with?('SMTP error ')
            # SMTP error from remote server after RCPT command:
            v['command'] = Sisimai::SMTP::Command.find(e)

          elsif e.start_with?('host:')
            # host: mx.example.jp
            v['rhost'] = e[6, e.size]
          else
            # Get error messages
            next if e.empty?
            v['diagnosis']  += e + ' '
          end
        end
        return nil unless recipients > 0

        dscontents.each do |e|
          e['diagnosis'] = Sisimai::String.sweep(e['diagnosis'].tr("\n", ' '))

          MessagesOf.each_key do |r|
            # Verify each regular expression of session errors
            next unless MessagesOf[r].any? { |a| e['diagnosis'].include?(a) }
            e['reason'] = r
            break
          end
        end

        return { 'ds' => dscontents, 'rfc822' => emailparts[1] }
      end
      def description; return 'GMX: https://www.gmx.net'; end
    end
  end
end

