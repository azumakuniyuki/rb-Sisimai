module LhostEngineTest::Private
  module MailMarshalSMTP
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.3.0',   '553', 'filtered',        false],
                  ['5.3.0',   '553', 'filtered',        false]],
      '1002'  => [['5.1.1',   '550', 'userunknown',     true]],
    }
  end
end

