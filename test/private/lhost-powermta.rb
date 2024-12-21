module LhostEngineTest::Private
  module PowerMTA
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.0.0',   '554', 'userunknown',     true]],
      '1002'  => [['5.2.1',   '550', 'suspend',        false]],
    }
  end
end

