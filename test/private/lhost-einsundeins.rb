module LhostEngineTest::Private
  module EinsUndEins
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1002'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1003'  => [['5.0.934', '',    'mesgtoobig',      false]],
      '1004'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1005'  => [['5.4.1',   '550', 'userunknown',     true]],
      '1006'  => [['5.4.1',   '550', 'userunknown',     true]],
      '1007'  => [['5.4.1',   '550', 'userunknown',     true]],
      '1008'  => [['5.4.1',   '550', 'userunknown',     true]],
      '1009'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1010'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1011'  => [['5.4.1',   '550', 'userunknown',     true]],
      '1012'  => [['5.4.1',   '550', 'userunknown',     true]],
      '1013'  => [['5.4.1',   '550', 'userunknown',     true]],

    }
  end
end

