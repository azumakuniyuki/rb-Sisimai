module LhostEngineTest::Private
  module X3
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.3.0',   '553', 'userunknown',     true]],
      '1002'  => [['5.0.900', '',    'undefined',       false]],
      '1003'  => [['5.0.947', '',    'expired',         false]],
      '1004'  => [['5.3.0',   '553', 'userunknown',     true]],
      '1005'  => [['5.0.900', '',    'undefined',       false]],
      '1006'  => [['5.3.0',   '553', 'userunknown',     true]],
      '1007'  => [['5.0.947', '',    'expired',         false]],
      '1008'  => [['5.3.0',   '553', 'userunknown',     true]],
    }
  end
end

