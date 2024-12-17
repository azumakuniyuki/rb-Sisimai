module LhostEngineTest::Private
  module RFC3464
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
#     '01001' => [['5.0.947', '',    'expired',         false]],
#     '01002' => [['5.0.911', '550', 'userunknown',     true]],
      '01003' => [['5.0.934', '553', 'mesgtoobig',      false]],
#     '01004' => [['5.0.910', '550', 'filtered',        false]],
#     '01005' => [['5.0.944', '554', 'networkerror',    false]],
#     '01007' => [['5.0.901', '',    'onhold',          false]],
#     '01008' => [['5.0.947', '',    'expired',         false]],
      '01009' => [['5.1.1',   '550', 'userunknown',     true]],
      '01011' => [['5.1.2',   '550', 'hostunknown',     true]],
      '01013' => [['5.1.0',   '550', 'userunknown',     true]],
      '01014' => [['5.1.1',   '550', 'userunknown',     true]],
#     '01015' => [['5.0.912', '',    'hostunknown',     true]],
      '01016' => [['5.1.1',   '',    'userunknown',     true]],
      '01017' => [['5.1.1',   '550', 'userunknown',     true]],
#     '01018' => [['5.0.922', '',    'mailboxfull',     false]],
      '01020' => [['5.1.1',   '550', 'userunknown',     true]],
      '01021' => [['5.2.0',   '',    'filtered',        false]],
      '01022' => [['5.1.1',   '550', 'userunknown',     true]],
#     '01024' => [['5.1.0',   '550', 'userunknown',     true]],
#     '01025' => [['5.0.910', '',    'filtered',        false]],
#     '01026' => [['5.0.910', '',    'filtered',        false]],
      '01031' => [['5.1.1',   '550', 'userunknown',     true]],
      '01033' => [['5.1.1',   '',    'userunknown',     true]],
      '01035' => [['5.1.1',   '550', 'userunknown',     true]],
      '01036' => [['5.2.0',   '',    'filtered',        false]],
      '01037' => [['5.5.0',   '554', 'systemerror',     false]],
      '01038' => [['5.2.0',   '',    'filtered',        false]],
      '01039' => [['5.1.2',   '550', 'hostunknown',     true]],
      '01040' => [['5.4.6',   '554', 'networkerror',    false]],
      '01041' => [['5.2.0',   '',    'filtered',        false]],
      '01042' => [['5.2.0',   '',    'filtered',        false]],
#     '01043' => [['5.0.901', '',    'onhold',          false],
#                 ['5.0.911', '550', 'userunknown',     true]],
      '01044' => [['5.1.1',   '550', 'userunknown',     true]],
#     '01045' => [['5.0.911', '550', 'userunknown',     true]],
      '01046' => [['5.1.1',   '550', 'userunknown',     true]],
      '01047' => [['5.0.900', '',    'undefined',       false]],
      '01048' => [['5.2.0',   '',    'filtered',        false]],
      '01049' => [['5.1.1',   '550', 'userunknown',     true],
                  ['5.1.1',   '550', 'userunknown',     true]],
      '01050' => [['5.2.0',   '',    'filtered',        false]],
      '01051' => [['5.1.1',   '550', 'userunknown',     true],
                  ['5.1.1',   '550', 'userunknown',     true]],
      '01052' => [['5.0.900', '',    'undefined',       false]],
      '01053' => [['5.0.0',   '554', 'mailererror',     false]],
      '01054' => [['5.0.900', '',    'undefined',       false]],
#     '01055' => [['5.0.910', '',    'filtered',        false]],
#     '01056' => [['5.0.922', '554', 'mailboxfull',     false]],
      '01057' => [['5.2.0',   '',    'filtered',        false]],
      '01058' => [['5.0.900', '',    'undefined',       false]],
      '01059' => [['5.1.1',   '550', 'userunknown',     true]],
      '01060' => [['5.2.0',   '',    'filtered',        false]],
      '01062' => [['5.1.1',   '550', 'userunknown',     true]],
      '01063' => [['5.2.0',   '',    'filtered',        false]],
      '01064' => [['5.2.0',   '',    'filtered',        false]],
      '01065' => [['5.7.1',   '550', 'spamdetected',    false]],
      '01066' => [['5.2.0',   '',    'filtered',        false]],
#     '01067' => [['5.0.930', '',    'systemerror',     false]],
      '01068' => [['5.0.900', '',    'undefined',       false]],
      '01069' => [['4.4.7',   '',    'expired',         false]],
      '01070' => [['5.5.0',   '',    'userunknown',     true]],
#     '01071' => [['5.0.922', '',    'mailboxfull',     false]],
      '01072' => [['5.2.0',   '',    'filtered',        false]],
#     '01073' => [['5.0.911', '550', 'userunknown',     true]],
      '01074' => [['5.2.0',   '',    'filtered',        false]],
#     '01075' => [['5.0.910', '',    'filtered',        false]],
      '01076' => [['5.5.0',   '554', 'systemerror',     false]],
      '01077' => [['5.2.0',   '',    'filtered',        false]],
#     '01078' => [['5.1.1',   '550', 'userunknown',     true]],
#     '01079' => [['5.0.910', '',    'filtered',        false]],
      '01083' => [['5.2.0',   '',    'filtered',        false]],
      '01085' => [['5.2.0',   '',    'filtered',        false]],
      '01087' => [['5.2.0',   '',    'filtered',        false]],
      '01089' => [['5.2.0',   '',    'filtered',        false]],
      '01090' => [['5.2.0',   '',    'filtered',        false]],
      '01091' => [['5.0.900', '',    'undefined',       false]],
      '01092' => [['5.0.900', '',    'undefined',       false]],
      '01093' => [['5.2.0',   '',    'filtered',        false]],
      '01095' => [['5.1.0',   '550', 'userunknown',     true]],
      '01096' => [['5.2.0',   '',    'filtered',        false]],
      '01097' => [['5.1.0',   '550', 'userunknown',     true]],
      '01098' => [['5.2.0',   '',    'filtered',        false]],
      '01099' => [['4.7.0',   '',    'securityerror',   false]],
      '01100' => [['4.7.0',   '',    'securityerror',   false]],
      '01101' => [['5.2.0',   '',    'filtered',        false]],
#     '01102' => [['5.3.0',   '553', 'userunknown',     true]],
#     '01103' => [['5.0.947', '',    'expired',         false]],
      '01104' => [['5.2.0',   '',    'filtered',        false]],
#     '01105' => [['5.0.910', '',    'filtered',        false]],
#     '01106' => [['5.0.947', '',    'expired',         false]],
      '01107' => [['5.2.0',   '',    'filtered',        false]],
      '01108' => [['5.0.900', '',    'undefined',       false]],
      '01111' => [['5.0.922', '',    'mailboxfull',     false]],
      '01112' => [['5.1.0',   '550', 'userunknown',     true]],
      '01113' => [['5.2.0',   '',    'filtered',        false]],
#     '01114' => [['5.0.930', '',    'systemerror',     false]],
      '01117' => [['5.0.934', '553', 'mesgtoobig',      false]],
      '01118' => [['4.4.1',   '',    'expired',         false]],
      '01120' => [['5.2.0',   '',    'filtered',        false]],
      '01121' => [['4.4.0',   '',    'expired',         false]],
#     '01122' => [['5.0.911', '550', 'userunknown',     true]],
      '01123' => [['4.4.1',   '',    'expired',         false]],
      '01124' => [['4.0.0',   '',    'mailererror',     false]],
#     '01125' => [['5.0.944', '',    'networkerror',    false]],
      '01126' => [['5.1.1',   '550', 'userunknown',     true]],
      '01127' => [['5.2.0',   '',    'filtered',        false]],
#     '01128' => [['5.0.930', '',    'systemerror',     false],
#                 ['5.0.901', '',    'onhold',          false]],
      '01129' => [['5.1.1',   '',    'userunknown',     true]],
#     '01130' => [['5.0.930', '',    'systemerror',     false]],
      '01131' => [['5.1.1',   '550', 'userunknown',     true]],
#     '01132' => [['5.0.930', '',    'systemerror',     false]],
      '01133' => [['5.0.930', '',    'systemerror',     false]],
      '01134' => [['5.2.0',   '',    'filtered',        false]],
      '01135' => [['5.1.1',   '550', 'userunknown',     true]],
      '01136' => [['5.0.900', '',    'undefined',       false]],
      '01138' => [['5.1.1',   '550', 'userunknown',     true]],
      '01139' => [['4.4.1',   '',    'expired',         false]],
      '01140' => [['5.2.0',   '',    'filtered',        false]],
      '01142' => [['5.2.0',   '',    'filtered',        false]],
      '01143' => [['5.0.900', '',    'undefined',       false]],
#     '01146' => [['5.0.922', '',    'mailboxfull',     false]],
#     '01148' => [['5.0.922', '',    'mailboxfull',     false]],
      '01149' => [['4.4.7',   '',    'expired',         false]],
#     '01150' => [['5.0.922', '',    'mailboxfull',     false]],
#     '01153' => [['5.0.972', '',    'policyviolation', false]],
      '01154' => [['5.1.1',   '',    'userunknown',     true]],
      '01155' => [['5.4.6',   '554', 'networkerror',    false]],
      '01156' => [['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false],
                  ['5.7.1',   '550', 'spamdetected',    false]],
      '01157' => [['5.3.0',   '',    'filtered',        false]],
#     '01158' => [['5.0.947', '',    'expired',         false],
#                 ['5.0.901', '',    'onhold',          false]],
      '01159' => [['5.1.1',   '550', 'mailboxfull',     false]],
#     '01160' => [['5.0.910', '',    'filtered',        false]],
      '01163' => [['5.1.1',   '550', 'mesgtoobig',      false]],
      '01164' => [['5.1.1',   '550', 'userunknown',     true]],
#     '01165' => [['5.0.944', '554', 'networkerror',    false]],
#     '01166' => [['5.0.930', '',    'systemerror',     false]],
#     '01167' => [['5.0.912', '',    'hostunknown',     true]],
#     '01168' => [['5.0.922', '',    'mailboxfull',     false]],
#     '01169' => [['5.0.911', '550', 'userunknown',     true]],
#     '01170' => [['5.0.901', '',    'onhold',          false]],
#     '01171' => [['5.0.901', '',    'onhold',          false]],
#     '01172' => [['5.0.922', '552', 'mailboxfull',     false]],
#     '01173' => [['5.0.944', '554', 'networkerror',    false]],
#     '01175' => [['5.0.910', '',    'filtered',        false]],
#     '01177' => [['5.0.918', '',    'rejected',        false],
#                 ['5.0.901', '',    'onhold',          false]],
#     '01179' => [['5.1.1',   '550', 'userunknown',     true]],
#     '01180' => [['5.0.922', '',    'mailboxfull',     false]],
#     '01181' => [['5.0.910', '550', 'filtered',        false]],
#     '01182' => [['5.0.901', '',    'onhold',          false]],
      '01183' => [['5.0.922', '',    'mailboxfull',     false]],
#     '01184' => [['5.0.901', '',    'onhold',          false],
#                 ['5.0.901', '',    'onhold',          false]],
      '01212' => [['4.2.2',   '',    'mailboxfull',     false]],
      '01213' => [['5.0.0',   '501', 'spamdetected',    false]],
#     '01216' => [['5.0.901', '',    'onhold',          false]],
      '01217' => [['5.1.1',   '550', 'userunknown',     true]],
#     '01218' => [['5.0.945', '',    'toomanyconn',     false]],
#     '01219' => [['5.0.901', '',    'onhold',          false]],
      '01220' => [['5.2.0',   '',    'filtered',        false]],
#     '01222' => [['5.2.2',   '552', 'mailboxfull',     false]],
      '01223' => [['4.0.0',   '',    'mailboxfull',     false]],
#     '01224' => [['5.1.1',   '550', 'authfailure',     false]],
#     '01225' => [['4.4.7',   '',    'expired',         false]],
      '01227' => [['5.5.0',   '',    'userunknown',     true],
                  ['5.5.0',   '',    'userunknown',     true]],
#     '01228' => [['5.0.901', '',    'onhold',          false]],
      '01229' => [['5.2.0',   '',    'filtered',        false]],
      '01230' => [['5.2.0',   '',    'filtered',        false]],
#     '01232' => [['5.0.944', '554', 'networkerror',    false]],
      '01233' => [['5.5.0',   '554', 'mailererror',     false]],
#     '01234' => [['5.0.901', '',    'onhold',          false],
#                 ['5.0.911', '550', 'userunknown',     true],
#                 ['5.0.911', '550', 'userunknown',     true]],
      '01235' => [['5.0.0',   '550', 'filtered',        false],
                  ['5.0.0',   '550', 'filtered',        false],
                  ['5.0.0',   '550', 'filtered',        false],
                  ['5.0.0',   '550', 'filtered',        false]],
      '01236' => [['5.1.1',   '',    'userunknown',     true]],
      '01237' => [['5.1.1',   '',    'userunknown',     true]],
      '01238' => [['5.1.1',   '',    'userunknown',     true]],
      '01239' => [['5.1.1',   '',    'userunknown',     true]],
      '01240' => [['5.1.1',   '',    'userunknown',     true]],
      '01241' => [['5.1.1',   '',    'userunknown',     true]],
      '01242' => [['5.1.1',   '',    'userunknown',     true]],
      '01243' => [['5.5.0',   '503', 'syntaxerror',     false]],
      '01244' => [['5.2.2',   '',    'mailboxfull',     false]],
      '01245' => [['5.2.2',   '',    'mailboxfull',     false]],
      '01246' => [['5.1.1',   '',    'userunknown',     true]],
      '01247' => [['5.1.1',   '',    'userunknown',     true],
                  ['5.1.1',   '',    'userunknown',     true]],
      '01248' => [['5.2.2',   '',    'mailboxfull',     false]],
      '01249' => [['5.5.0',   '503', 'syntaxerror',     false]],
      '01250' => [['5.0.922', '',    'mailboxfull',     false]],
      '01251' => [['5.2.2',   '552', 'mailboxfull',     false]],
      '01252' => [['5.0.944', '554', 'networkerror',    false]],
#     '01253' => [['5.0.912', '',    'hostunknown',     true]],
      '01255' => [['4.4.7',   '',    'expired',         false]],
#     '01260' => [['5.0.945', '',    'toomanyconn',     false]],
#     '01262' => [['5.0.947', '',    'expired',         false]],
      '01263' => [['4.4.1',   '',    'networkerror',    false]],
      '01265' => [['5.0.0',   '554', 'policyviolation', false]],
      '01266' => [['4.7.0',   '',    'policyviolation', false]],
      '01267' => [['5.1.6',   '550', 'hasmoved',        true]],
#     '01268' => [['5.7.1',   '554', 'spamdetected',    false]],
      '01271' => [['5.1.1',   '550', 'userunknown',     true]],
      '01272' => [['5.0.980', '554', 'spamdetected',    false]],
      '01273' => [['4.3.0',   '',    'mailboxfull',     false]],
      '01274' => [['4.2.2',   '',    'mailboxfull',     false]],
#     '01275' => [['5.0.971', '',    'virusdetected',   false]],
#     '01276' => [['5.0.910', '',    'filtered',        false]],
      '01277' => [['5.0.0',   '550', 'rejected',        false],
                  ['4.0.0',   '',    'expired',         false],
                  ['5.0.0',   '550', 'filtered',        false]],
      '01278' => [['4.0.0',   '',    'expired',         false]],
      '01279' => [['4.4.6',   '',    'networkerror',    false]],
#     '01280' => [['5.4.0',   '',    'networkerror',    false]],
      '01282' => [['5.1.1',   '550', 'userunknown',     true]],
#     '01283' => [['5.0.947', '',    'expired',         false]],
#     '01284' => [['5.0.972', '',    'policyviolation', false]],
      '01285' => [['5.7.0',   '554', 'spamdetected',    false]],
      '01286' => [['5.5.0',   '550', 'rejected',        false]],
      '01287' => [['5.0.0',   '550', 'filtered',        false]],
      '01288' => [['5.3.0',   '552', 'exceedlimit',     false]],
      '01289' => [['4.0.0',   '',    'notaccept',       false]],
      '01290' => [['4.3.0',   '451', 'onhold',          false]],
      '01300' => [['5.1.0',   '550', 'userunknown',     true]],
      '01301' => [['5.0.0',   '',    'spamdetected',    false]],
      '01302' => [['5.0.0',   '550', 'filtered',        false]],
      '01303' => [['5.0.0',   '550', 'userunknown',     true]],
      '01304' => [['4.0.0',   '',    'notaccept',       false]],
      '01305' => [['5.1.8',   '501', 'rejected',        false]],
      '01306' => [['4.0.0',   '',    'networkerror',    false]],
      '01307' => [['5.1.1',   '550', 'userunknown',     true]],
      '01308' => [['5.0.0',   '',    'policyviolation', false]],
      '01309' => [['5.0.0',   '553', 'systemerror',     false]],
      '01310' => [['4.0.0',   '',    'networkerror',    false]],
      '01311' => [['5.1.10',  '550', 'userunknown',     true]],
      '01312' => [['5.1.1',   '',    'userunknown',     true]],
      '01313' => [['5.1.1',   '550', 'userunknown',     true]],
      '01314' => [['5.1.1',   '550', 'userunknown',     true]],
      '01315' => [['5.1.1',   '550', 'userunknown',     true]],
      '01316' => [['5.2.3',   '550', 'exceedlimit',     false]],
      '01317' => [['5.1.10',  '550', 'userunknown',     true]],
      '01318' => [['5.4.1',   '550', 'rejected',        false]],
      '01319' => [['5.0.0',   '',    'userunknown',      true]],
    }
  end
end

