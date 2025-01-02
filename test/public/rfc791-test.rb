require 'minitest/autorun'
require 'sisimai/rfc791'

class RFC791Test < Minitest::Test
  Methods = { class: %w[is_ipv4address find] }

  def test_is_upv4address
    addr0 = ["123.456.78.9"]
    addr1 = ["192.0.2.22"]

    addr0.each do |e|
      assert_equal false, Sisimai::RFC791.is_ipv4address(e)
    end
    addr1.each do |e|
      assert_equal true,  Sisimai::RFC791.is_ipv4address(e)
    end
  end

  def test_find
    ip4address = [
      ['host smtp.example.jp 127.0.0.4 SMTP error from remote mail server', '127.0.0.4'],
      ['mx.example.jp (192.0.2.2) reason: 550 5.2.0 Mail rejete.', '192.0.2.2'],
      ['Client host [192.0.2.49] blocked using cbl.abuseat.org (state 13).', '192.0.2.49'],
      ['127.0.0.1', '127.0.0.1'],
      ['365.31.7.1', ''],
      ['a.b.c.d', ''],
    ]
    ip4address.each do |e|
      assert_equal e[1], Sisimai::RFC791.find(e[0]).shift.to_s
    end
    assert_nil Sisimai::RFC791.find('')
    assert_instance_of Array, Sisimai::RFC791.find('3.14')

    ce = assert_raises ArgumentError do
      Sisimai::RFC791.find()
      Sisimai::RFC791.find("nekochan", nil)
    end
  end

end

