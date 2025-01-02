module LhostEngineTest::Private
  module ApacheJames
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.0.910', '550', 'filtered',        false]],
      '1002'  => [['5.0.910', '550', 'filtered',        false]],
      '1003'  => [['5.0.910', '550', 'filtered',        false]],
#     '1004'  => [['5.0.901', '',    'onhold',          false]],
#     '1005'  => [['5.0.901', '',    'onhold',          false]],
    }
  end
end

