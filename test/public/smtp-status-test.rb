require 'minitest/autorun'
require 'sisimai/smtp/status'

class SMTPStatusTest < Minitest::Test
  Methods = { class: %w[code name test find] }
  Reasons = %w[
      authfailure badreputation blocked contenterror exceedlimit expired filtered hasmoved
      hostunknown mailboxfull mailererror mesgtoobig networkerror notaccept onhold rejected
      norelaying spamdetected virusdetected policyviolation securityerror speeding suspend
      requireptr notcompliantrfc systemerror systemfull toomanyconn userunknown syntaxerror
    ]
  CodeSet = %w[
    2.1.5
    4.1.6 4.1.7 4.1.8 4.1.9 4.2.1 4.2.2 4.2.3 4.2.4 4.3.1 4.3.2 4.3.3 4.3.5
    4.4.1 4.4.2 4.4.4 4.4.5 4.4.6 4.4.7 4.5.3 4.5.5 4.6.0 4.6.2 4.6.5
    4.7.1 4.7.2 4.7.5 4.7.6 4.7.7
    5.1.0 5.1.1 5.1.2 5.1.3 5.1.4 5.1.6 5.1.7 5.1.8 5.1.9 5.2.0 5.2.1 5.2.2
    5.2.3 5.2.4 5.3.0 5.3.1 5.3.2 5.3.3 5.3.4 5.3.5 5.4.0 5.4.3 5.5.3 5.5.4
    5.5.5 5.5.6 5.6.0 5.6.1 5.6.2 5.6.3 5.6.5 5.6.6 5.6.7 5.6.8 5.6.9 5.7.0
    5.7.1 5.7.2 5.7.3 5.7.4 5.7.5 5.7.6 5.7.7 5.7.8 5.7.9
  ]
  Message = [
    'smtp; 2.1.5 250 OK',
    'smtp;550 5.2.2 <mikeneko@example.co.jp>... Mailbox Full',
    'smtp; 550 5.1.1 Mailbox does not exist',
    'smtp; 550 5.1.1 Mailbox does not exist',
    'smtp; 450 4.0.0 Temporary failure',
    'smtp; 552 5.2.2 Mailbox full',
    'smtp; 552 5.3.4 Message too large',
    'smtp; 500 5.6.1 Message content rejected',
    'smtp; 550 5.2.0 Message Filtered',
    '550 5.1.1 <kijitora@example.jp>... User Unknown',
    'SMTP; 552-5.7.0 This message was blocked because its content presents a potential',
    'SMTP; 550 5.1.1 Requested action not taken: mailbox unavailable',
    'SMTP; 550 5.7.1 IP address blacklisted by recipient',
    'SMTP; 550 5.7.25 The ip address sending this message does not have a ptr record setup',
    'smtp; 550-5.7.1 This message is not RFC 5322 compliant. There are multiple Subject 550-5.7.1 headers',
  ]

  def test_methods
    Methods[:class].each { |e| assert_respond_to Sisimai::SMTP::Status, e }
  end

  def test_code
    Reasons.each do |e|
      cv = Sisimai::SMTP::Status.code(e)
      assert_instance_of String, cv
      assert_match /\A5[.]\d[.]9\d+/, cv

      cv = Sisimai::SMTP::Status.code(e, true)
      assert_instance_of String, cv
      assert_match /\A[45][.]\d[.]9\d+/, cv

    end

    ce = assert_raises ArgumentError do
      Sisimai::SMTP::Status.code()
      Sisimai::SMTP::Status.code(nil, nil, nil)
    end
    assert_nil Sisimai::SMTP::Status.code('')
  end

  def test_name
    CodeSet.each do |e|
      cv = Sisimai::SMTP::Status.name(e)
      assert_instance_of String, cv
      assert_equal 'delivered', cv            if e.start_with?('2')
      assert_equal true, Reasons.include?(cv) if e.start_with?('4', '5')
    end

    ce = assert_raises ArgumentError do
      Sisimai::SMTP::Status.name()
      Sisimai::SMTP::Status.name(nil, nil)
    end
    assert_nil Sisimai::SMTP::Status.name('')
  end

  def test_test
    assert_equal false, Sisimai::SMTP::Status.test('')
    assert_equal false, Sisimai::SMTP::Status.test('3.14')
    assert_equal false, Sisimai::SMTP::Status.test('9.99')
    assert_equal false, Sisimai::SMTP::Status.test('5.0.3.2')
    assert_equal false, Sisimai::SMTP::Status.test('1.0.0')
    assert_equal false, Sisimai::SMTP::Status.test('3.1.4')
    assert_equal false, Sisimai::SMTP::Status.test('6.7.8')
    assert_equal false, Sisimai::SMTP::Status.test('5.-1.0')
    assert_equal false, Sisimai::SMTP::Status.test('5.12.0')
    assert_equal false, Sisimai::SMTP::Status.test('5.2.-2')
    assert_equal false, Sisimai::SMTP::Status.test('5.2.2220')

    ce = assert_raises ArgumentError do
      Sisimai::SMTP::Status.test()
      Sisimai::SMTP::Status.test(nil, nil)
    end
  end

  def test_find
    Message.each do |e|
      cv = Sisimai::SMTP::Status.find(e)
      assert_instance_of String, cv
      assert_match /\A[245][.]\d+[.]\d{1,3}\z/, cv
      assert_equal true, Sisimai::SMTP::Status.test(cv)
    end

    ce = assert_raises ArgumentError do
      Sisimai::SMTP::Status.find()
      Sisimai::SMTP::Status.find(nil, nil, nil)
    end
    assert_empty Sisimai::SMTP::Status.find('')
  end

  def test_prefer
    assert_nil            Sisimai::SMTP::Status.prefer(nil)
    assert_equal '5.2.2', Sisimai::SMTP::Status.prefer('5.2.2', '')
    assert_equal '5.3.5', Sisimai::SMTP::Status.prefer('', '5.3.5')
    assert_equal '5.1.1', Sisimai::SMTP::Status.prefer('5.0.0', '5.1.1')
    assert_equal '5.2.1', Sisimai::SMTP::Status.prefer('5.2.0', '5.2.1')
    assert_equal '4.2.2', Sisimai::SMTP::Status.prefer('4.4.7', '4.2.2')
    assert_equal '5.7.8', Sisimai::SMTP::Status.prefer('5.7.8', '4.4.0', 550)
    assert_equal '4.2.1', Sisimai::SMTP::Status.prefer('4.2.1', '5.7.0', 421)
    assert_equal '5.7.26',Sisimai::SMTP::Status.prefer('5.7', '5.7.26', 421)
    assert_equal '5.7.26',Sisimai::SMTP::Status.prefer('5.7.26', '5.7', 421)

    ce = assert_raises ArgumentError do
      Sisimai::SMTP::Status.prefer()
      Sisimai::SMTP::Status.prefer(nil, nil, nil, nil)
    end
    assert_empty Sisimai::SMTP::Status.find('')
  end

end

