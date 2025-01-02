module Sisimai
  module Reason
    # Sisimai::Reason::VirusDetected checks the bounce reason is "virusdetected" or not. This class
    # is called only Sisimai::Reason class.
    #
    # This is an error that any virus or trojan horse detected in the message by a virus scanner program
    # at a destination mail server. This reason has been divided from "securityerror" at Sisimai 4.22.0.
    #
    #   Your message was infected with a virus. You should download a virus
    #   scanner and check your computer for viruses.
    #
    #     Sender:    <sironeko@libsisimai.org>
    #     Recipient: <kijitora@example.jp>
    #
    module VirusDetected
      class << self
        Index = [
          'it has a potentially executable attachment',
          'the message was rejected because it contains prohibited virus or spam content',
          'this form of attachment has been used by recent viruses or other malware',
          'virus detected',
          'virus phishing/malicious_url detected',
          'your message was infected with a virus',
        ].freeze

        def text; return 'virusdetected'; end
        def description; return 'Email rejected due to a virus scanner on a destination host'; end

        # Try to match that the given text and regular expressions
        # @param    [String] argv1  String to be matched with regular expressions
        # @return   [True,False]    false: Did not match
        #                           true: Matched
        # @since 4.22.0
        def match(argv1)
          return nil unless argv1
          return true if Index.any? { |a| argv1.include?(a) }
          return false
        end

        # The bounce reason is "virusdetected" or not
        # @param    [Sisimai::Fact] argvs   Object to be detected the reason
        # @return   [True,False]            true: virus detected
        #                                   false: virus was not detected
        # @since 4.22.0
        # @see http://www.ietf.org/rfc/rfc2822.txt
        def true(argvs)
          # The value of "reason" isn't "visusdetected" when the value of "command" is an SMTP command
          # to be sent before the SMTP DATA command because all the MTAs read the headers and the
          # entire message body after the DATA command.
          return true  if argvs['reason'] == 'virusdetected'
          return false if %w[CONN EHLO HELO MAIL RCPT].include?(argvs['command'])
          return match(argvs['diagnosticcode'].downcase)
        end

      end
    end
  end
end


