module LhostEngineTest::Private
  module MailRu
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.0.911', '',    'userunknown',     true]],
      '1002'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1003'  => [['5.2.2',   '550', 'mailboxfull',     false]],
      '1004'  => [['5.2.2',   '550', 'mailboxfull',     false],
                  ['5.2.1',   '550', 'userunknown',     true]],
      '1005'  => [['5.0.910', '',    'filtered',        false]],
      '1006'  => [['5.2.2',   '550', 'mailboxfull',     false]],
      '1007'  => [['5.0.911', '',    'userunknown',     true]],
      '1008'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1009'  => [['5.0.910', '550', 'filtered',        false]],
      '1010'  => [['5.0.911', '550', 'userunknown',     true]],
      '1011'  => [['5.1.8',   '501', 'rejected',        false]],
    }
  end
end

