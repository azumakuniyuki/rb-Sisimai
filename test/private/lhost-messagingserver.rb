module LhostEngineTest::Private
  module MessagingServer
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.4.4',   '',    'hostunknown',     true]],
      '1002'  => [['5.0.0',   '',    'mailboxfull',     false]],
      '1003'  => [['5.7.1',   '550', 'filtered',        false],
                  ['5.7.1',   '550', 'filtered',        false]],
      '1004'  => [['5.2.2',   '550', 'mailboxfull',     false]],
      '1005'  => [['5.4.4',   '',    'hostunknown',     true]],
      '1006'  => [['5.7.1',   '550', 'filtered',        false]],
      '1007'  => [['5.2.0',   '',    'mailboxfull',     false]],
      '1008'  => [['5.2.1',   '550', 'filtered',        false]],
      '1009'  => [['5.0.0',   '',    'mailboxfull',     false]],
      '1010'  => [['5.2.0',   '',    'mailboxfull',     false]],
      '1011'  => [['4.4.7',   '',    'expired',         false]],
      '1012'  => [['5.0.0',   '550', 'filtered',        false]],
      '1013'  => [['4.2.2',   '',    'mailboxfull',     false]],
      '1014'  => [['4.2.2',   '',    'mailboxfull',     false]],
      '1015'  => [['5.0.0',   '550', 'filtered',        false]],
      '1016'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1017'  => [['5.1.10',  '',    'notaccept',       true]],
      '1018'  => [['5.1.8',   '501', 'rejected',        false]],
      '1019'  => [['4.2.2',   '',    'mailboxfull',     false]],
    }
  end
end

