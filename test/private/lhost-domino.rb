module LhostEngineTest::Private
  module Domino
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001' => [['5.0.0',   '',    'onhold',          false]],
      '1002' => [['5.1.1',   '',    'userunknown',     true]],
      '1003' => [['5.0.0',   '',    'userunknown',     true]],
      '1004' => [['5.0.0',   '',    'userunknown',     true]],
      '1005' => [['5.0.0',   '',    'onhold',          false]],
      '1006' => [['5.0.911', '',    'userunknown',     true]],
      '1007' => [['5.0.0',   '',    'userunknown',     true]],
      '1008' => [['5.0.911', '',    'userunknown',     true]],
      '1009' => [['5.0.911', '',    'userunknown',     true]],
      '1010' => [['5.0.911', '',    'userunknown',     true]],
      '1011' => [['5.1.1',   '',    'userunknown',     true]],
      '1012' => [['5.0.911', '',    'userunknown',     true]],
      '1013' => [['5.0.911', '',    'userunknown',     true]],
      '1014' => [['5.0.911', '',    'userunknown',     true]],
      '1015' => [['5.0.0',   '',    'networkerror',    false]],
      '1016' => [['5.0.0',   '',    'systemerror',     false]],
      '1017' => [['5.0.0',   '',    'userunknown',     true]],
      '1019' => [['5.0.0',   '',    'userunknown',     true]],
    }
  end
end

