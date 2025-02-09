module LhostEngineTest::Private
  module X4
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1002'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1003'  => [['5.1.2',   '',    'hostunknown',     true]],
      '1004'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1005'  => [['5.0.911', '550', 'userunknown',     true]],
      '1006'  => [['5.1.1',   '',    'userunknown',     true]],
      '1007'  => [['5.0.911', '550', 'userunknown',     true]],
      '1008'  => [['5.0.921', '550', 'suspend',         false]],
      '1009'  => [['5.1.1',   '',    'userunknown',     true]],
      '1010'  => [['5.1.2',   '',    'hostunknown',     true]],
      '1011'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1012'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1013'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1014'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1015'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1016'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1018'  => [['5.1.1',   '',    'userunknown',     true]],
      '1019'  => [['5.0.911', '550', 'userunknown',     true]],
      '1020'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1022'  => [['5.1.1',   '',    'userunknown',     true]],
      '1023'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1024'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1025'  => [['5.1.1',   '',    'userunknown',     true]],
      '1026'  => [['5.0.911', '550', 'userunknown',     true]],
      '1027'  => [['5.0.922', '',    'mailboxfull',     false]],
    }
  end
end

