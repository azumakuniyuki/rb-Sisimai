module Sisimai::Lhost
  # Sisimai::Lhost::KDDI decodes a bounce email which created by au by KDDI https://www.au.com/.
  # Methods in the module are called from only Sisimai::Message.
  module KDDI
    class << self
      require 'sisimai/lhost'

      Indicators = Sisimai::Lhost.INDICATORS
      Boundaries = ['Content-Type: message/rfc822'].freeze
      StartingOf = { message: ['Your mail sent on:', 'Your mail attempted to be delivered on:'] }.freeze
      MessagesOf = {
        'mailboxfull' => ['As their mailbox is full'],
        'norelaying'  => ['Due to the following SMTP relay error'],
        'hostunknown' => ['As the remote domain doesnt exist'],
      }.freeze

      # @abstract Decodes the bounce message from au by KDDI
      # @param  [Hash] mhead    Message headers of a bounce email
      # @param  [String] mbody  Message body of a bounce email
      # @return [Hash]          Bounce data list and message/rfc822 part
      # @return [Nil]           it failed to decode or the arguments are missing
      def inquire(mhead, mbody)
        # :'message-id' => %r/[@].+[.]ezweb[.]ne[.]jp[>]\z/,
        match  = 0
        match += 1 if Sisimai::String.aligned(mhead['from'], ['no-reply@.', '.dion.ne.jp'])
        match += 1 if mhead['reply-to'].to_s == 'no-reply@app.auone-net.jp'
        match += 1 if mhead['received'].any? { |a| a.include?('ezweb.ne.jp (') }
        match += 1 if mhead['received'].any? { |a| a.include?('.au.com (') }
        return nil unless match > 0

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
            readcursor |= Indicators[:deliverystatus] if StartingOf[:message].any? { |a| e.start_with?(a) }
            next
          end
          next if (readcursor & Indicators[:deliverystatus]) == 0
          next if e.empty?

          v = dscontents[-1]
          if e.include?(' Could not be delivered to: <')
            # Your mail sent on: Thu, 29 Apr 2010 11:04:47 +0900
            #     Could not be delivered to: <******@**.***.**>
            #     As their mailbox is full.
            if v["recipient"] != ""
              # There are multiple recipient addresses in the message body.
              dscontents << Sisimai::Lhost.DELIVERYSTATUS
              v = dscontents[-1]
            end
            r = Sisimai::Address.s3s4(e[e.index('<') + 1, e.size])
            next unless Sisimai::Address.is_emailaddress(r)
            v['recipient'] = r
            recipients += 1

          elsif e.include?('Your mail sent on: ')
            # Your mail sent on: Thu, 29 Apr 2010 11:04:47 +0900
            v['date'] = e[19, e.size]
          else
            #     As their mailbox is full.
            v['diagnosis'] << e + ' ' if e.start_with?(' ')
          end
        end
        return nil unless recipients > 0

        require 'sisimai/smtp/command'
        dscontents.each do |e|
          e['diagnosis'] = Sisimai::String.sweep(e['diagnosis']) || ''
          e['command']   = Sisimai::SMTP::Command.find(e['diagnosis'])

          if mhead['x-spasign'].to_s == 'NG'
            # Content-Type: text/plain; ..., X-SPASIGN: NG (spamghetti, au by KDDI)
            # Filtered recipient returns message that include 'X-SPASIGN' header
            e['reason'] = 'filtered'
          else
            if e['command'] == 'RCPT'
              # set "userunknown" when the remote server rejected after RCPT command.
              e['reason'] = 'userunknown'
            else
              # SMTP command is not RCPT
              MessagesOf.each_key do |r|
                # Verify each regular expression of session errors
                next unless MessagesOf[r].any? { |a| e['diagnosis'].include?(a) }
                e['reason'] = r
                break
              end
            end
          end

        end

        return { 'ds' => dscontents, 'rfc822' => emailparts[1] }
      end
      def description; return 'au by KDDI: https://www.au.kddi.com'; end
    end
  end
end

