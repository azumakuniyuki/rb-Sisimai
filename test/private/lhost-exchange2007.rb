module LhostEngineTest::Private
  module Exchange2007
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '01001' => [['5.1.1',   '550', 'userunknown',     true]],
      '01002' => [['5.2.3',   '550', 'exceedlimit',     false]],
      '01003' => [['5.1.1',   '550', 'userunknown',     true]],
      '01004' => [['5.1.1',   '550', 'userunknown',     true]],
      '01005' => [['5.2.2',   '550', 'mailboxfull',     false]],
      '01006' => [['5.2.3',   '550', 'exceedlimit',     false]],
      '01007' => [['5.2.2',   '550', 'mailboxfull',     false]],
      '01008' => [['5.7.1',   '550', 'securityerror',   false]],
      '01009' => [['5.1.1',   '550', 'userunknown',     true]],
      '01010' => [['5.1.1',   '550', 'userunknown',     true]],
      '01011' => [['5.2.3',   '550', 'exceedlimit',     false]],
      '01012' => [['5.1.1',   '550', 'userunknown',     true]],
      '01013' => [['5.0.910', '550', 'filtered',        false]],
      '01014' => [['4.2.0',   '',    'systemerror',     false]],
      '01015' => [['5.1.1',   '550', 'userunknown',     true]],
      '01016' => [['5.2.3',   '550', 'exceedlimit',     false]],
      '01017' => [['5.1.10',  '550', 'userunknown',     true]],
      '01018' => [['5.1.10',  '550', 'userunknown',     true]],
    }
  end
end

