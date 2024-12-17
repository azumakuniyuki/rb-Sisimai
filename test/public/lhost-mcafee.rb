module LhostEngineTest::Public
  module McAfee
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '01' => [['5.0.910', '550', 'filtered',       false]],
      '02' => [['5.1.1',   '550', 'userunknown',     true]],
      '03' => [['5.1.1',   '550', 'userunknown',     true]],
      '04' => [['5.0.910', '550', 'filtered',       false]],
      '05' => [['5.0.910', '550', 'filtered',       false]],
    }
  end
end

