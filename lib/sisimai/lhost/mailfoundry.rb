module Sisimai::Lhost
  # Sisimai::Lhost::MailFoundry decodes a bounce email which created by MailFoundry https://www.barracuda.com/.
  # Methods in the module are called from only Sisimai::Message.
  module MailFoundry
    class << self
      require 'sisimai/lhost'

      Indicators = Sisimai::Lhost.INDICATORS
      Boundaries = ['Content-Type: message/rfc822'].freeze
      StartingOf = {
        message: ['Unable to deliver message to:'],
        error:   ['Delivery failed for the following reason:'],
      }.freeze

      # @abstract Decodes the bounce message from MailFoundry
      # @param  [Hash] mhead    Message headers of a bounce email
      # @param  [String] mbody  Message body of a bounce email
      # @return [Hash]          Bounce data list and message/rfc822 part
      # @return [Nil]           it failed to decode or the arguments are missing
      def inquire(mhead, mbody)
        return nil unless mhead['subject'] == 'Message delivery has failed'
        return nil unless mhead['received'].any? { |a| a.include?('(MAILFOUNDRY) id ') }

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
          end
          next if (readcursor & Indicators[:deliverystatus]) == 0
          next if e.empty?

          # Unable to deliver message to: <kijitora@example.org>
          # Delivery failed for the following reason:
          # Server mx22.example.org[192.0.2.222] failed with: 550 <kijitora@example.org> No such user here
          #
          # This has been a permanent failure. No further delivery attempts will be made.
          v = dscontents[-1]

          if e.start_with?('Unable to deliver message to: <') && e.index('@') > 1
            # Unable to deliver message to: <kijitora@example.org>
            if v['recipient']
              # There are multiple recipient addresses in the message body.
              dscontents << Sisimai::Lhost.DELIVERYSTATUS
              v = dscontents[-1]
            end
            v['recipient'] = e[e.index('<'), e.size]
            recipients += 1
          else
            # Error messages
            if e == StartingOf[:error][0]
              # Delivery failed for the following reason:
              v['diagnosis'] = e
            else
              # Detect error message
              next if v['diagnosis'].nil? || v['diagnosis'].empty?
              next if e.start_with?('-')
              v['diagnosis'] << ' ' << e
            end
          end
        end
        return nil unless recipients > 0

        dscontents.each { |e| e['diagnosis'] = Sisimai::String.sweep(e['diagnosis']) }
        return { 'ds' => dscontents, 'rfc822' => emailparts[1] }
      end
      def description; return 'MailFoundry'; end
    end
  end
end
