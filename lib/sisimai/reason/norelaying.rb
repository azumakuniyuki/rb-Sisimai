module Sisimai
  module Reason
    # Sisimai::Reason::NoRelaying checks the bounce reason is "norelaying" or not. This class is
    # called only Sisimai::Reason class.
    #
    #    ... while talking to mailin-01.mx.example.com.:
    #    >>> RCPT To:<kijitora@example.org>
    #    <<< 554 5.7.1 <kijitora@example.org>: Relay access denied
    #    554 5.0.0 Service unavailable
    module NoRelaying
      class << self
        Index = [
          'as a relay',
          'email address is not verified.',
          'insecure mail relay',
          'is not permitted to relay through this server without authentication',
          'mail server requires authentication when attempting to send to a non-local e-mail address', # MailEnable
          'no relaying',
          'not a gateway',
          'not allowed to relay through this machine',
          'not an open relay, so get lost',
          'not local host',
          'relay access denied',
          'relay denied',
          'relay not permitted',
          'relaying denied',  # Sendmail
          'relaying mail to ',
          'specified domain is not allowed',
          "that domain isn't in my list of allowed rcpthost",
          'this system is not configured to relay mail',
          'unable to relay for',
          "we don't handle mail for",
        ].freeze

        def text; return 'norelaying'; end
        def description; return 'Email rejected with error message "Relaying Denied"'; end

        # Try to match that the given text and regular expressions
        # @param    [String] argv1  String to be matched with regular expressions
        # @return   [True,False]    false: Did not match
        #                           true: Matched
        def match(argv1)
          return nil unless argv1
          return true if Index.any? { |a| argv1.include?(a) }
          return false
        end

        # Whether the message is rejected by 'Relaying denied'
        # @param    [Sisimai::Fact] argvs   Object to be detected the reason
        # @return   [True,False]            true: Rejected for "relaying denied"
        #                                   false: is not
        # @see http://www.ietf.org/rfc/rfc2822.txt
        def true(argvs)
          r = argvs['reason'] || ''
          return false if r.start_with?('securityerror', 'systemerror', 'undefined')
          return false if %w[CONN EHLO HELO].include?(argvs['command'])
          return match(argvs['diagnosticcode'].downcase)
        end

      end
    end
  end
end



