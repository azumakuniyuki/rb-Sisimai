module Sisimai
  module Rhost
    # Sisimai::Rhost detects the bounce reason from the content of Sisimai::Fact object as an argument
    # of find() method when the value of "destination" of the object is "*.yahoodns.net".
    # This class is called only Sisimai::Fact class.
    module YahooInc
      class << self
        MessagesOf = {
          'authfailure' => [
            # - 550 5.7.9 This mail has been blocked because the sender is unauthenticated. Yahoo
            #   requires all senders to authenticate with either SPF or DKIM.
            'yahoo requires all senders to authenticate with either spf or dkim',
          ],
          'blocked' => [
            # - 553 5.7.1 [BL21] Connections will not be accepted from 192.0.2.25,
            #   because the ip is in Spamhaus's list; see http://postmaster.yahoo.com/550-bl23.html
            # - 553 5.7.1 [BL23] Connections not accepted from IP addresses on Spamhaus XBL;
            #   see http://postmaster.yahoo.com/errors/550-bl23.html [550]",
            " because the ip is in spamhaus's list;",
            'not accepted from ip addresses on spamhaus xbl',
          ],
          'norelaying' => [
            # - 550 relaying denied for <***@yahoo.com>
            'relaying denied for ',
          ],
          'notcompliantrfc' => ['headers are not rfc compliant'],
          'policyviolation' => [
            # - 554 Message not allowed - [PH01] Email not accepted for policy reasons.
            #   Please visit https://postmaster.yahooinc.com/error-codes
            # - 554 5.7.9 Message not accepted for policy reasons. 
            #   See https://postmaster.yahooinc.com/error-codes
            'not accepted for policy reasons',
          ],
          'rejected' => [
            # Observed the following error message since around March 2024:
            #
            # - 421 4.7.0 [TSS04] Messages from 192.0.2.25 temporarily deferred due to unexpected
            #   volume or user complaints - 4.16.55.1;
            #   see https://postmaster.yahooinc.com/error-codes (in reply to MAIL FROM command))
            #
            # However, the same error message is returned even for domains that are considered to
            # have a poor reputation without SPF, DKIM, or DMARC settings, or for other reasons.
            # It seems that the error message is not as granular as Google's.
            'temporarily deferred due to unexpected volume or user complaints',

            # - 451 Message temporarily deferred due to unresolvable RFC.5321 from domain.
            #   See https://senders.yahooinc.com/error-codes#unresolvable-from-domain
            'due to unresolvable rfc.5321 domain',

            # - 553 5.7.2 [TSS09] All messages from 192.0.2.25 will be permanently deferred;
            #   Retrying will NOT succeed. See https://postmaster.yahooinc.com/error-codes
            # - 553 5.7.2 [TSS11] All messages from 192.0.2.25 will be permanently deferred;
            #   Retrying will NOT succeed. See https://postmaster.yahooinc.com/error-codes
            ' will be permanently deferred',
          ],
          'speeding' => [
            # - 450 User is receiving mail too quickly
            'user is receiving mail too quickly',
          ],
          'suspend' => [
            # - 554 delivery error: dd ****@yahoo.com is no longer valid.
            # - 554 30 Sorry, your message to *****@aol.jp cannot be delivered.
            #   This mailbox is disabled (554.30)
            ' is no longer valid.',
            'this mailbox is disabled',
          ],
          'syntaxerror' => [
            # - 501 Syntax error in parameters or arguments
            'syntax error in parameters or arguments',
          ],
          'toomanyconn' => [
            # - 421 Max message per connection reached, closing transmission channel
            'max message per connection reached',
          ],
          'userunknown' => [
            # - 554 delivery error: dd This user doesn't have a yahoo.com account (***@yahoo.com)
            # - 552 1 Requested mail action aborted, mailbox not found (in reply to end of DATA command)
            "dd this user doesn't have a ",
            'mailbox not found',
          ],
        }.freeze

        # Detect bounce reason from Yahoo Inc. (*.yahoodns.net)
        # @param    [Sisimai::Fact] argvs   Decoded email object
        # @return   [String]                The bounce reason for YahooInc
        # @see      https://senders.yahooinc.com/smtp-error-codes
        #           https://smtpfieldmanual.com/provider/yahoo
        #           https://www.postmastery.com/yahoo-postmaster/
        # @since v5.1.0
        def find(argvs)
          return argvs['reason'] unless argvs['reason'].empty?
          issuedcode = argvs['diagnosticcode'].downcase
          reasontext = ''

          MessagesOf.each_key do |e|
            MessagesOf[e].each do |f|
              next unless issuedcode.include?(f)
              reasontext = e
              break
            end
            break if reasontext.size > 0
          end

          return reasontext
        end

      end
    end
  end
end

