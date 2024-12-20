require 'minitest/autorun'
require 'sisimai/reason'
require 'sisimai'

class ReasonChildrenTest < Minitest::Test
  Reasons = {
    'AuthFailure'     => ["550 5.1.0 192.0.2.222 is not allowed to send from <example.net> per it's SPF Record"],
    'BadReputation'   => ['451 4.7.650 The mail server [192.0.2.2] has been temporarily rate limited due to IP reputation.'],
    'Blocked'         => ['550 Access from ip address 192.0.2.1 blocked.'],
    'ContentError'    => ['550 5.6.0 the headers in this message contain improperly-formatted binary content'],
    'ExceedLimit'     => ['5.2.3 Message too large'],
    'Expired'         => ['421 4.4.7 Delivery time expired'],
    'Filtered'        => ['550 5.1.2 User reject'],
    'HasMoved'        => ['550 5.1.6 address neko@cat.cat has been replaced by neko@example.jp'],
    'HostUnknown'     => ['550 5.2.1 Host Unknown'],
    'MailboxFull'     => ['450 4.2.2 Mailbox full'],
    'MailerError'     => ['X-Unix; 255'],
    'MesgTooBig'      => ['400 4.2.3 Message too big'],
    'NetworkError'    => ['554 5.4.6 Too many hops'],
    'NoRelaying'      => ['550 5.0.0 Relaying Denied'],
    'NotAccept'       => ['556 SMTP protocol returned a permanent error'],
    'NotCompliantRFC' => ['550 5.7.1 This message is not RFC 5322 compliant. There are multiple Subject headers.'],
    'OnHold'          => ['5.0.901 error'],
    'Rejected'        => ['550 5.1.8 Domain of sender address example.org does not exist'],
    'RequirePTR'      => ['550 5.7.25 [192.0.2.25] The IP address sending this message does not have a PTR record setup'],
    'PolicyViolation' => ['570 5.7.7 Email not accepted for policy reasons'],
    'SecurityError'   => ['570 5.7.0 Authentication failure'],
    'SpamDetected'    => ['570 5.7.7 Spam Detected'],
    'Speeding'        => ['451 4.7.1 <smtp3.example.jp[192.0.2.1]>: Client host rejected: Please try again slower'],
#   'Suppressed'      => ['There is no sample email which is returned due to being listed in the suppression list'],
    'Suspend'         => ['550 5.0.0 Recipient suspend the service'],
    'SystemError'     => ['500 5.3.5 System config error'],
    'SystemFull'      => ['550 5.0.0 Mail system full'],
    'TooManyConn'     => ['421 Too many connections'],
    'UserUnknown'     => ['550 5.1.1 Unknown User'],
    'VirusDetected'   => ['550 5.7.9 The message was rejected because it contains prohibited virus or spam content'],
  }

  def test_reason
    cv = Sisimai.rise('./set-of-emails/maildir/bsd/lhost-sendmail-01.eml').shift
    cw = cv.damn
    assert_instance_of Sisimai::Fact, cv
    assert_instance_of Hash, cw

    Reasons.each_key do |e|
      cr = 'Sisimai::Reason::' << e
      require cr.downcase.gsub('::', '/')
      cx = Module.const_get(cr)

      assert_equal Module, cx.class
      assert_equal e.downcase, cx.text;
      refute_empty cx.description
      assert_includes [true, false, nil], cx.true(cw)

      unless e.match(/\A(?:Content|Expire|Mailer|Network|Policy|Security|System|User|NoRelay|OnHold)/)
        # Skip a class its true() method always return undef
        cw['reason'] = e.downcase
        assert_equal true, cx.true(cw)

        cw['reason'] = 'undefined'
        cw['diagnosticcode'] = Reasons[e][0]
        cw['command'] = if e.match(/(Rejected|NotAccept)/) then 'MAIL' else cv.command end
        assert_equal true, cx.true(cw)
      end

      next if e == 'OnHold'
      Reasons[e].each do |ee|
        assert_equal true, cx.match(ee.downcase)
      end
      assert_nil cx.match(nil)

      ce = assert_raises ArgumentError do
        cx.text(nil)
        cx.true()
        cx.match()
        cx.description(nil)
      end
    end

    %w[Delivered Feedback Undefined Vacation SyntaxError].each do |e|
      cr = 'Sisimai::Reason::' << e
      require cr.downcase.gsub('::', '/')
      cx = Module.const_get(cr)

      assert_equal Module, cx.class
      assert_equal e.downcase, cx.text;
      refute_empty cx.description
      assert_includes [false, nil], cx.true(cw)
    end


  end

end

