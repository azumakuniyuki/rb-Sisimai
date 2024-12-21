module LhostEngineTest::Private
  module Activehunter
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.0.910', '550', 'filtered',        false]],
      '1002'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1003'  => [['5.3.0',   '553', 'filtered',        false]],
      '1004'  => [['5.7.17',  '550', 'filtered',        false]],
      '1005'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1006'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1007'  => [['5.0.910', '550', 'filtered',        false]],
      '1008'  => [['5.0.910', '550', 'filtered',        false]],
      '1009'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1010'  => [['5.3.0',   '553', 'filtered',        false]],
      '1011'  => [['5.7.17',  '550', 'filtered',        false]],
      '1012'  => [['5.1.1',   '550', 'userunknown',     true]],
    }
  end
end

