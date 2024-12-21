module LhostEngineTest::Private
  module SurfControl
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.0.0',   '550', 'filtered',        false]],
      '1002'  => [['5.0.0',   '550', 'filtered',        false]],
      '1003'  => [['5.0.0',   '550', 'filtered',        false]],
      '1004'  => [['5.0.0',   '554', 'systemerror',     false]],
      '1005'  => [['5.0.0',   '554', 'systemerror',     false]],
    }
  end
end

