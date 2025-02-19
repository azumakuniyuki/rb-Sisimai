module Sisimai
  module Reason
    # Sisimai::Reason::Filtered checks the bounce reason is "filtered" or not. This class is called
    # only Sisimai::Reason class.
    #
    # This is the error that an email has been rejected by a header content after SMTP DATA command.
    # In Japanese cellular phones, the error will incur that a sender's email address or a domain
    # is rejected by recipient's email configuration. Sisimai will set "filtered" to the reason of
    # email bounce if the value of Status: field in a bounce email is "5.2.0" or "5.2.1".
    module Filtered
      class << self
        Index = [
          'because the recipient is only accepting mail from specific email addresses',   # AOL Phoenix
          'bounced address',  # SendGrid|a message to an address has previously been Bounced.
          'due to extended inactivity new mail is not currently being accepted for this mailbox',
          'has restricted sms e-mail',    # AT&T
          'is not accepting any mail',
          "message filtered",
          'message rejected due to user rules',
          'not found recipient account',
          'refused due to recipient preferences', # Facebook
          'resolver.rst.notauthorized',   # Microsoft Exchange
          'this account is protected by',
          'user not found',   # Filter on MAIL.RU
          'user refuses to receive this mail',
          'user reject',
          'we failed to deliver mail because the following address recipient id refuse to receive mail',  # Willcom
          'you have been blocked by the recipient',
        ].freeze

        def text; return 'filtered'; end
        def description; return 'Email rejected due to a header content after SMTP DATA command'; end

        # Try to match that the given text and regular expressions
        # @param    [String] argv1  String to be matched with regular expressions
        # @return   [True,False]    false: Did not match
        #                           true: Matched
        def match(argv1)
          return nil unless argv1
          return true if Index.any? { |a| argv1.include?(a) }
          return false
        end

        # Rejected by a sender domain or a sender address by a filter ?
        # @param    [Sisimai::Fact] argvs   Object to be detected the reason
        # @return   [True,False]            true: is filtered
        #                                   false: is not filtered
        # @see http://www.ietf.org/rfc/rfc2822.txt
        def true(argvs)
          return true if argvs['reason'] == 'filtered'

          require 'sisimai/reason/userunknown'
          tempreason = Sisimai::SMTP::Status.name(argvs['deliverystatus']) || ''
          return false if tempreason == 'suspend'

          issuedcode = argvs['diagnosticcode'].downcase || ''
          thecommand = argvs['command']                 || ''
          if tempreason == 'filtered'
            # Delivery status code points "filtered".
            return true if Sisimai::Reason::UserUnknown.match(issuedcode)
            return true if match(issuedcode)
          else
            # The value of "reason" isn't "filtered" when the value of "command" is an SMTP command
            # to be sent before the SMTP DATA command because all the MTAs read the headers and the
            # entire message body after the DATA command.
            return false if %w[CONN EHLO HELO MAIL RCPT].include?(thecommand)
            return true  if match(issuedcode)
            return true  if Sisimai::Reason::UserUnknown.match(issuedcode)
          end
          return false
        end

      end
    end
  end
end

