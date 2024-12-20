module RhostEngineTest::Public
  module Facebook
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '03' => [['5.1.1',   '550', 'userunknown',     true]],
      '04' => [['5.1.1',   '550', 'userunknown',     true]],
    }
  end
end

