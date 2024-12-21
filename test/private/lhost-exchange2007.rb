module LhostEngineTest::Private
  module Exchange2007
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1002'  => [['5.2.3',   '550', 'exceedlimit',     false]],
      '1003'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1004'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1005'  => [['5.2.2',   '550', 'mailboxfull',     false]],
      '1006'  => [['5.2.3',   '550', 'exceedlimit',     false]],
      '1007'  => [['5.2.2',   '550', 'mailboxfull',     false]],
      '1008'  => [['5.7.1',   '550', 'securityerror',   false]],
      '1009'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1010'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1011'  => [['5.2.3',   '550', 'exceedlimit',     false]],
      '1012'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1013'  => [['5.0.910', '550', 'filtered',        false]],
      '1014'  => [['4.2.0',   '',    'systemerror',     false]],
      '1015'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1016'  => [['5.2.3',   '550', 'exceedlimit',     false]],
      '1017'  => [['5.1.10',  '550', 'userunknown',     true]],
      '1018'  => [['5.1.10',  '550', 'userunknown',     true]],
    }
  end
end

