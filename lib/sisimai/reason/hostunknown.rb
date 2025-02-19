module Sisimai
  module Reason
    # This is the error that a domain part ( Right hand side of @ sign ) of a recipient's email
    # address does not exist. In many case, the domain part is misspelled, or the domain name has
    # been expired. Sisimai will set "hostunknown" to the reason of email bounce if the value of
    # Status: field in a bounce mail is "5.1.2".
    module HostUnknown
      class << self
        require 'sisimai/string'

        Index = [
          'domain does not exist',
          'domain is not reachable',
          'domain must exist',
          'host or domain name not found',
          'host unknown',
          'host unreachable',
          'mail domain mentioned in email address is unknown',
          'name or service not known',
          'no such domain',
          'recipient address rejected: unknown domain name',
          'recipient domain must exist',
          'the account or domain may not exist',
          'unknown host',
          'unroutable address',
          'unrouteable address',
        ].freeze
        Pairs = [['553 ', ' does not exist']].freeze

        def text; return 'hostunknown'; end
        def description; return "Delivery failed due to a domain part of a recipient's email address does not exist"; end

        # Try to match that the given text and regular expressions
        # @param    [String] argv1  String to be matched with regular expressions
        # @return   [True,False]    false: Did not match
        #                           true:  Matched
        # @since v4.0.0
        def match(argv1)
          return nil unless argv1
          return true if Index.any? { |a| argv1.include?(a) }
          return true if Pairs.any? { |a| Sisimai::String.aligned(argv1, a) }
          return false
        end

        # Whether the host is unknown or not
        # @param    [Sisimai::Fact] argvs   Object to be detected the reason
        # @return   [True,False]            true: is unknown host
        #                                   false: is not unknown host.
        # @see http://www.ietf.org/rfc/rfc2822.txt
        def true(argvs)
          return true if argvs['reason'] == 'hostunknown'

          issuedcode = argvs['diagnosticcode'].downcase || ''
          statuscode = argvs['deliverystatus'] || ''

          if Sisimai::SMTP::Status.name(statuscode).to_s == 'hostunknown'
            # To prevent classifying DNS errors as "HostUnknown"
            require 'sisimai/reason/networkerror'
            return true unless Sisimai::Reason::NetworkError.match(issuedcode)
          else
            # Status: 5.1.2
            # Diagnostic-Code: SMTP; 550 Host unknown
            return true if match(issuedcode)
          end

          return false
        end

      end
    end
  end
end

