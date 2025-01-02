module LhostEngineTest::Private
  module MXLogic
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1002'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1003'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1004'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1005'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1006'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1007'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1008'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1009'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1010'  => [['5.0.910', '550', 'filtered',        false]],
      '1011'  => [['5.0.910', '550', 'filtered',        false]],
    }
  end
end

