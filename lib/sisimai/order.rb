module Sisimai
  # Sisimai::Order - Parent class for making optimized order list for calling MTA modules
  module Order
    class << self
      require 'sisimai/lhost'

      # There are another patterns in the value of "Subject:" header of a bounce mail generated by the
      # following MTA/ESP modules
      OrderE0 = [
        'Sisimai::Lhost::Exim',
        'Sisimai::Lhost::Sendmail',
        'Sisimai::Lhost::Office365',
        'Sisimai::Lhost::Exchange2007',
        'Sisimai::Lhost::Exchange2003',
        'Sisimai::Lhost::AmazonSES',
        'Sisimai::Lhost::InterScanMSS',
        'Sisimai::Lhost::KDDI',
        'Sisimai::Lhost::Verizon',
        'Sisimai::Lhost::ApacheJames',
        'Sisimai::Lhost::X2',
        'Sisimai::Lhost::FML',
      ].freeze

      # Fallback list: The following MTA/ESP modules is not listed OrderE0
      OrderE1 = [
        'Sisimai::Lhost::Postfix',
        'Sisimai::Lhost::GoogleWorkspace',
        'Sisimai::Lhost::GMX',
        'Sisimai::Lhost::MessagingServer',
        'Sisimai::Lhost::EinsUndEins',
        'Sisimai::Lhost::Domino',
        'Sisimai::Lhost::Notes',
        'Sisimai::Lhost::Qmail',
        'Sisimai::Lhost::Courier',
        'Sisimai::Lhost::OpenSMTPD',
        'Sisimai::Lhost::Zoho',
        'Sisimai::Lhost::MailFoundry',
        'Sisimai::Lhost::V5sendmail',
        'Sisimai::Lhost::MFILTER',
        'Sisimai::Lhost::GoogleGroups',
        'Sisimai::Lhost::Gmail',
        'Sisimai::Lhost::EZweb',
        'Sisimai::Lhost::IMailServer',
        'Sisimai::Lhost::MailMarshalSMTP',
        'Sisimai::Lhost::Activehunter',
        'Sisimai::Lhost::Biglobe',
        'Sisimai::Lhost::X1',
        'Sisimai::Lhost::X3',
        'Sisimai::Lhost::X6',
      ].freeze

      # The following order is decided by the first 2 words of Subject: header
      Subject = {
        'abuse-report'     => ['Sisimai::ARF'],
        'auto'             => ['Sisimai::RFC3834'],
        'auto-reply'       => ['Sisimai::RFC3834'],
        'automatic-reply'  => ['Sisimai::RFC3834'],
        'aws-notification' => ['Sisimai::Lhost::AmazonSES'],
        'complaint-about'  => ['Sisimai::ARF'],
        'delivery-failure' => ['Sisimai::Lhost::Domino', 'Sisimai::Lhost::X2'],
        'delivery-notification' => ['Sisimai::Lhost::MessagingServer'],
        'delivery-status'  => [
          'Sisimai::Lhost::GoogleWorkspace',
          'Sisimai::Lhost::GoogleGroups',
          'Sisimai::Lhost::OpenSMTPD',
          'Sisimai::Lhost::AmazonSES',
          'Sisimai::Lhost::Gmail',
          'Sisimai::Lhost::X3',
        ],
        'dmarc-ietf-dmarc' => ['Sisimai::ARF'],
        'email-feedback'   => ['Sisimai::ARF'],
        'failed-delivery'  => ['Sisimai::Lhost::X2'],
        'failure-delivery' => ['Sisimai::Lhost::X2'],
        'failure-notice'   => [
          'Sisimai::Lhost::Qmail',
          'Sisimai::Lhost::MFILTER',
          'Sisimai::Lhost::Activehunter',
        ],
        'loop-alert'    => ['Sisimai::Lhost::FML'],
        'mail-delivery' => [
          'Sisimai::Lhost::Exim',
          'Sisimai::Lhost::DragonFly',
          'Sisimai::Lhost::GMX',
          'Sisimai::Lhost::EinsUndEins',
          'Sisimai::Lhost::Zoho',
        ],
        'mail-could'   => ['Sisimai::Lhost::InterScanMSS'],
        'mail-failure' => ['Sisimai::Lhost::Exim'],
        'mail-system'  => ['Sisimai::Lhost::EZweb'],
        'message-delivery' => ['Sisimai::Lhost::MailFoundry'],
        'message-frozen'   => ['Sisimai::Lhost::Exim'],
        'não-entregue'     => ['Sisimai::Lhost::Office365'],
        'non-recapitabile' => ['Sisimai::Lhost::Exchange2007'],
        'non-remis' => ['Sisimai::Lhost::Exchange2007'],
        'notice'    => ['Sisimai::Lhost::Courier'],
        'onbestelbaar'       => ['Sisimai::Lhost::Office365'],
        'postmaster-notify'  => ['Sisimai::Lhost::Sendmail'],
        'returned-mail' => [
          'Sisimai::Lhost::Sendmail',
          'Sisimai::Lhost::V5sendmail',
          'Sisimai::Lhost::Biglobe',
          'Sisimai::Lhost::X1',
        ],
        'there-was'  => ['Sisimai::Lhost::X6'],
        'undeliverable' => [
          'Sisimai::Lhost::Office365',
          'Sisimai::Lhost::Exchange2007',
          'Sisimai::Lhost::Exchange2003',
        ],
        'undeliverable-mail' => [
          'Sisimai::Lhost::MailMarshalSMTP',
          'Sisimai::Lhost::IMailServer',
        ],
        'undeliverable-message' => ['Sisimai::Lhost::Notes', 'Sisimai::Lhost::Verizon'],
        'undelivered-mail' => [
          'Sisimai::Lhost::Postfix',
          'Sisimai::Lhost::Zoho',
        ],
        'warning' => ['Sisimai::Lhost::Sendmail', 'Sisimai::Lhost::Exim'],
      }.freeze

      # @abstract Returns an MTA Order decided by the first word of the "Subject": header
      # @param    [String] argv0 Subject header string
      # @return   [Array]        Order of MTA modules
      # @since    v4.25.4
      def make(argv0 = '')
        return [] if argv0.empty?
        argv0 = argv0.downcase.tr('_[] ', ' ').squeeze(' ').sub(/\A[ ]+/, '')
        words = argv0.split(/[ ]/, 3)

        if words[0].include?(':')
          # Undeliverable: ..., notify: ...
          first = argv0.split(':').shift
        else
          # Postmaster notify, returned mail, ...
          first = words.slice(0, 2).join('-')
        end
        first.delete!(':",*')
        return Subject[first] || []
      end

      # @abstract Make MTA module list as a spare
      # @return   [Array] Ordered module list
      def another; return [OrderE0, OrderE1].flatten; end
    end
  end
end
