module LhostEngineTest::Private
  module Zoho
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1002'  => [['5.2.1',   '550', 'filtered',        false],
                  ['5.2.2',   '550', 'mailboxfull',     false]],
      '1003'  => [['5.0.910', '550', 'filtered',        false]],
      '1004'  => [['4.0.947', '421', 'expired',         false]],
    }
  end
end

