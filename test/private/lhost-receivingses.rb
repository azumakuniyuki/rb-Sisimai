module LhostEngineTest::Private
  module ReceivingSES
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.2.3',   '552', 'exceedlimit',     false]],
    }
  end
end

