module LhostEngineTest::Private
  module Barracuda
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.7.1',   '550', 'spamdetected',    false]],
      '1002'  => [['5.7.1',   '550', 'spamdetected',    false]],
    }
  end
end

