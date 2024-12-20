module RhostEngineTest::Public
  module FrancePTT
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '01' => [['5.1.1',   '550', 'userunknown',     true]],
      '02' => [['5.5.0',   '550', 'userunknown',     true]],
      '03' => [['5.2.0',   '550', 'spamdetected',    false]],
      '04' => [['5.2.0',   '550', 'spamdetected',    false]],
      '05' => [['5.5.0',   '550', 'suspend',         false]],
      '06' => [['4.0.0',   '',    'blocked',         false]],
      '07' => [['4.0.0',   '421', 'blocked',         false]],
      '08' => [['4.2.0',   '421', 'systemerror',     false]],
      '10' => [['5.5.0',   '550', 'blocked',         false]],
      '11' => [['4.2.1',   '421', 'blocked',         false]],
      '12' => [['5.7.1',   '554', 'policyviolation', false]],
    }
  end
end

