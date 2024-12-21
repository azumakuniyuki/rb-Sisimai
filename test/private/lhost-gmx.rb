module LhostEngineTest::Private
  module GMX
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.0.947', '',    'expired',         false]],
      '1002'  => [['5.1.1',   '',    'userunknown',     true]],
      '1003'  => [['5.2.2',   '',    'mailboxfull',     false]],
      '1004'  => [['5.2.1',   '',    'userunknown',     true],
                  ['5.2.2',   '',    'mailboxfull',     false]],
    }
  end
end

