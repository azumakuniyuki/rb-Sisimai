module LhostEngineTest::Private
  module Biglobe
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1002'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1003'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1004'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1005'  => [['5.0.910', '',    'filtered',        false]],
      '1006'  => [['5.0.910', '',    'filtered',        false]],
    }
  end
end

