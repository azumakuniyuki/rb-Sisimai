module LhostEngineTest::Private
  module Verizon
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.0.911', '',    'userunknown',     true]],
      '1002'  => [['5.0.911', '550', 'userunknown',     true]],
    }
  end
end

