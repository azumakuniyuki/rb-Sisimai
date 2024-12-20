module LhostEngineTest::Public
  module ReceivingSES
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '01' => [['5.1.1',   '550', 'userunknown',      true]],
      '02' => [['5.1.1',   '550', 'userunknown',      true]],
      '03' => [['4.0.0',   '450', 'onhold',          false]],
      '04' => [['5.2.2',   '552', 'mailboxfull',     false]],
      '05' => [['5.3.4',   '552', 'mesgtoobig',      false]],
      '06' => [['5.6.1',   '500', 'spamdetected',    false]],
      '07' => [['5.2.0',   '550', 'filtered',        false]],
      '08' => [['5.2.3',   '552', 'exceedlimit',     false]],
    }
  end
end

