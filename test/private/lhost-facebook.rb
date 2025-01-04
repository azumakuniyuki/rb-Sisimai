module LhostEngineTest::Private
  module Facebook
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.1.1',   '550', 'filtered',       false]],
      '1002'  => [['5.1.1',   '550', 'filtered',       false]],
      '1003'  => [['5.1.1',   '550', 'userunknown',     true]],
    }
  end
end

