module LhostEngineTest::Private
  module Postfix
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '01001' => [['5.0.0',   '550', 'rejected',        false]],
      '01002' => [['5.1.1',   '550', 'userunknown',     true]],
      '01003' => [['5.0.0',   '550', 'userunknown',     true]],
      '01004' => [['5.1.1',   '550', 'userunknown',     true]],
      '01005' => [['5.0.0',   '554', 'filtered',        false]],
      '01006' => [['5.7.1',   '550', 'userunknown',     true]],
      '01007' => [['5.0.0',   '554', 'filtered',        false]],
      '01008' => [['5.0.910', '',    'filtered',        false]],
      '01009' => [['5.0.0',   '550', 'userunknown',     true]],
      '01010' => [['5.0.0',   '',    'hostunknown',     true]],
      '01011' => [['5.0.0',   '551', 'systemerror',     false]],
      '01012' => [['5.1.1',   '550', 'userunknown',     true]],
      '01013' => [['5.0.0',   '550', 'userunknown',     true]],
      '01014' => [['5.1.1',   '',    'userunknown',     true]],
      '01015' => [['5.1.1',   '550', 'userunknown',     true]],
      '01016' => [['4.3.2',   '452', 'toomanyconn',     false]],
      '01017' => [['4.4.1',   '',    'expired',         false]],
      '01018' => [['5.4.6',   '',    'systemerror',     false]],
      '01019' => [['5.7.1',   '553', 'userunknown',     true]],
      '01020' => [['5.1.1',   '550', 'userunknown',     true]],
      '01021' => [['4.4.1',   '',    'expired',         false]],
      '01022' => [['5.1.1',   '550', 'userunknown',     true]],
      '01023' => [['5.0.0',   '550', 'blocked',         false]],
      '01024' => [['5.1.1',   '',    'userunknown',     true]],
      '01025' => [['5.0.0',   '550', 'userunknown',     true]],
      '01026' => [['4.4.1',   '',    'expired',         false]],
      '01027' => [['5.4.6',   '',    'systemerror',     false]],
      '01028' => [['5.0.0',   '551', 'suspend',         false]],
      '01029' => [['5.0.0',   '550', 'userunknown',     true]],
      '01030' => [['5.0.0',   '550', 'userunknown',     true]],
      '01031' => [['5.0.0',   '550', 'userunknown',     true]],
      '01032' => [['5.0.0',   '550', 'userunknown',     true]],
      '01033' => [['5.0.0',   '550', 'userunknown',     true]],
      '01034' => [['5.0.0',   '550', 'rejected',        false]],
      '01035' => [['4.2.2',   '',    'mailboxfull',     false]],
      '01036' => [['5.4.4',   '',    'hostunknown',     true]],
      '01037' => [['5.0.0',   '550', 'rejected',        false]],
      '01038' => [['5.0.0',   '550', 'blocked',         false]],
      '01039' => [['5.1.1',   '',    'userunknown',     true]],
      '01040' => [['5.7.1',   '550', 'userunknown',     true]],
      '01041' => [['5.1.1',   '',    'userunknown',     true]],
      '01042' => [['5.4.4',   '',    'networkerror',    false]],
      '01043' => [['5.1.6',   '550', 'hasmoved',        true]],
      '01044' => [['5.3.4',   '',    'mesgtoobig',      false]],
      '01045' => [['5.3.4',   '',    'mesgtoobig',      false]],
      '01046' => [['5.0.0',   '534', 'mesgtoobig',      false]],
      '01047' => [['5.7.1',   '554', 'mesgtoobig',      false]],
      '01048' => [['5.1.1',   '550', 'userunknown',     true],
                  ['5.1.1',   '550', 'userunknown',     true],
                  ['5.1.1',   '550', 'userunknown',     true],
                  ['5.1.1',   '550', 'userunknown',     true],
                  ['5.1.1',   '550', 'userunknown',     true]],
      '01049' => [['5.0.0',   '550', 'hostunknown',     true]],
      '01050' => [['5.0.0',   '550', 'userunknown',     true]],
      '01051' => [['5.7.1',   '553', 'norelaying',      false]],
      '01052' => [['5.7.1',   '550', 'spamdetected',    false]],
      '01053' => [['5.4.6',   '',    'systemerror',     false]],
      '01054' => [['5.1.1',   '',    'userunknown',     true]],
      '01055' => [['5.2.1',   '550', 'filtered',        false]],
      '01056' => [['5.1.1',   '',    'mailererror',     false]],
      '01057' => [['5.1.1',   '550', 'userunknown',     true],
                  ['5.1.1',   '550', 'userunknown',     true]],
      '01058' => [['5.0.0',   '550', 'filtered',        false]],
      '01059' => [['5.1.1',   '550', 'userunknown',     true]],
      '01060' => [['4.1.1',   '450', 'userunknown',     true]],
      '01061' => [['5.4.4',   '',    'hostunknown',     true]],
      '01062' => [['5.0.910', '550', 'filtered',        false]],
      '01063' => [['5.1.1',   '',    'mailererror',     false]],
      '01064' => [['5.0.0',   '',    'hostunknown',     true]],
      '01065' => [['5.0.0',   '',    'networkerror',    false]],
      '01066' => [['5.0.0',   '554', 'norelaying',      false]],
      '01067' => [['5.1.1',   '550', 'userunknown',     true]],
      '01068' => [['5.0.0',   '554', 'norelaying',      false]],
      '01069' => [['5.1.1',   '550', 'userunknown',     true]],
      '01070' => [['5.0.944', '',    'networkerror',    false]],
      '01071' => [['5.0.922', '',    'mailboxfull',     false]],
      '01072' => [['5.0.901', '554', 'onhold',          false]],
      '01073' => [['4.0.0',   '452', 'mailboxfull',     false]],
      '01074' => [['5.0.0',   '550', 'mailboxfull',     false]],
      '01075' => [['5.7.0',   '',    'mailboxfull',     false]],
      '01076' => [['5.0.0',   '554', 'filtered',        false]],
      '01077' => [['5.7.1',   '553', 'norelaying',      false]],
      '01078' => [['5.0.0',   '550', 'norelaying',      false]],
      '01079' => [['5.7.1',   '550', 'spamdetected',    false]],
      '01080' => [['5.7.1',   '554', 'spamdetected',    false]],
      '01081' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01082' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01083' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01084' => [['5.7.1',   '554', 'spamdetected',    false]],
      '01085' => [['5.7.1',   '554', 'spamdetected',    false]],
      '01086' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01087' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01088' => [['5.6.0',   '554', 'spamdetected',    false]],
      '01089' => [['5.7.1',   '554', 'spamdetected',    false]],
      '01090' => [['5.7.1',   '554', 'spamdetected',    false]],
      '01091' => [['5.0.0',   '500', 'spamdetected',    false]],
      '01092' => [['5.0.0',   '554', 'spamdetected',    false]],
      '01093' => [['5.7.1',   '554', 'spamdetected',    false]],
      '01094' => [['5.7.1',   '550', 'spamdetected',    false]],
      '01095' => [['5.0.0',   '554', 'spamdetected',    false]],
      '01096' => [['5.0.0',   '554', 'spamdetected',    false]],
      '01097' => [['5.7.3',   '553', 'spamdetected',    false]],
      '01098' => [['5.7.1',   '550', 'spamdetected',    false]],
      '01099' => [['5.7.1',   '550', 'spamdetected',    false]],
      '01100' => [['5.0.0',   '554', 'spamdetected',    false]],
      '01101' => [['5.0.0',   '554', 'virusdetected',   false]],
      '01102' => [['5.7.1',   '550', 'spamdetected',    false]],
      '01103' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01104' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01105' => [['5.0.0',   '551', 'spamdetected',    false]],
      '01106' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01107' => [['5.7.1',   '554', 'spamdetected',    false]],
      '01108' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01109' => [['5.7.1',   '550', 'spamdetected',    false]],
      '01110' => [['5.7.1',   '550', 'spamdetected',    false]],
      '01111' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01112' => [['5.0.0',   '554', 'spamdetected',    false]],
      '01113' => [['5.7.1',   '550', 'spamdetected',    false]],
      '01114' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01115' => [['5.0.0',   '554', 'blocked',         false]],
      '01116' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01117' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01118' => [['5.0.0',   '554', 'spamdetected',    false]],
      '01119' => [['5.0.0',   '553', 'spamdetected',    false]],
      '01120' => [['5.7.1',   '550', 'spamdetected',    false]],
      '01121' => [['5.3.0',   '554', 'spamdetected',    false]],
      '01122' => [['5.4.4',   '',    'hostunknown',     true]],
      '01123' => [['5.7.1',   '554', 'userunknown',     true]],
      '01124' => [['5.1.1',   '550', 'userunknown',     true]],
      '01125' => [['5.2.3',   '',    'exceedlimit',     false]],
      '01126' => [['5.0.0',   '',    'systemerror',     false]],
      '01127' => [['5.7.17',  '550', 'userunknown',     true]],
      '01128' => [['5.0.0',   '550', 'userunknown',     true]],
      '01129' => [['5.0.0',   '554', 'filtered',        false]],
      '01130' => [['5.0.0',   '552', 'mailboxfull',     false]],
      '01131' => [['5.2.3',   '',    'exceedlimit',     false]],
      '01132' => [['5.0.0',   '550', 'userunknown',     true]],
      '01133' => [['5.1.1',   '550', 'userunknown',     true]],
      '01134' => [['5.0.0',   '550', 'userunknown',     true]],
      '01135' => [['5.2.1',   '550', 'suspend',         false]],
      '01136' => [['5.0.0',   '550', 'userunknown',     true]],
      '01137' => [['5.0.0',   '550', 'userunknown',     true]],
      '01138' => [['5.0.0',   '550', 'userunknown',     true]],
      '01139' => [['5.1.3',   '501', 'userunknown',     true]],
      '01140' => [['5.0.0',   '550', 'userunknown',     true]],
      '01141' => [['5.0.0',   '',    'filtered',        false]],
      '01142' => [['5.0.0',   '550', 'blocked',         false]],
      '01143' => [['5.3.0',   '553', 'userunknown',     true]],
      '01144' => [['5.0.0',   '554', 'suspend',         false]],
      '01145' => [['5.0.0',   '550', 'rejected',        false]],
      '01146' => [['5.1.3',   '',    'userunknown',     true]],
      '01147' => [['5.1.1',   '550', 'userunknown',     true]],
      '01148' => [['5.2.1',   '550', 'userunknown',     true]],
      '01149' => [['5.2.2',   '550', 'mailboxfull',     false]],
      '01150' => [['5.0.910', '',    'filtered',        false]],
      '01151' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01152' => [['5.3.0',   '553', 'blocked',         false]],
      '01153' => [['5.7.1',   '550', 'badreputation',   false]],
      '01154' => [['4.7.0',   '421', 'blocked',         false]],
      '01155' => [['5.1.0',   '550', 'userunknown',     true]],
      '01156' => [['5.1.0',   '550', 'userunknown',     true]],
      '01157' => [['4.0.0',   '',    'blocked',         false]],
      '01158' => [['5.6.0',   '554', 'spamdetected',    false]],
      '01159' => [['5.0.0',   '550', 'userunknown',     true]],
      '01160' => [['4.0.0',   '451', 'systemerror',     false]],
      '01161' => [['5.0.0',   '',    'mailboxfull',     false]],
      '01162' => [['5.0.0',   '550', 'policyviolation', false]],
      '01163' => [['5.0.0',   '550', 'policyviolation', false]],
      '01164' => [['5.0.0',   '550', 'blocked',         false]],
      '01165' => [['5.5.0',   '550', 'userunknown',     true]],
      '01166' => [['5.0.0',   '550', 'userunknown',     true]],
      '01167' => [['4.0.0',   '',    'blocked',         false]],
      '01168' => [['5.0.0',   '571', 'rejected',        false]],
      '01169' => [['5.0.0',   '550', 'userunknown',     true]],
      '01170' => [['5.0.0',   '550', 'blocked',         false]],
      '01171' => [['5.2.0',   '',    'mailboxfull',     false]],
      '01172' => [['4.3.0',   '',    'mailererror',     false]],
      '01173' => [['4.4.2',   '',    'networkerror',    false]],
      '01174' => [['4.3.2',   '451', 'notaccept',       false]],
      '01175' => [['5.7.9',   '554', 'policyviolation', false]],
      '01176' => [['5.7.1',   '554', 'userunknown',     true]],
      '01177' => [['5.7.1',   '550', 'userunknown',     true]],
      '01178' => [['5.7.1',   '550', 'blocked',         false]],
      '01179' => [['5.7.1',   '501', 'norelaying',      false]],
      '01180' => [['5.4.1',   '550', 'rejected',        false]],
      '01181' => [['5.1.1',   '550', 'userunknown',     true]],
      '01182' => [['5.7.0',   '550', 'spamdetected',    false]],
      '01183' => [['5.1.1',   '550', 'userunknown',     true]],
      '01184' => [['5.7.1',   '550', 'norelaying',      false]],
      '01185' => [['4.0.0',   '451', 'systemerror',     false]],
      '01186' => [['5.1.1',   '550', 'userunknown',     true]],
      '01187' => [['5.0.0',   '550', 'userunknown',     true]],
      '01188' => [['4.4.1',   '',    'expired',         false]],
      '01189' => [['5.4.4',   '',    'hostunknown',     true]],
      '01190' => [['5.1.1',   '',    'userunknown',     true]],
      '01191' => [['5.1.1',   '550', 'userunknown',     true]],
      '01192' => [['5.1.1',   '550', 'toomanyconn',     false]],
      '01193' => [['5.0.0',   '550', 'filtered',        false]],
      '01194' => [['5.0.0',   '550', 'userunknown',     true]],
      '01195' => [['4.4.1',   '',    'expired',         false]],
      '01196' => [['5.0.0',   '550', 'userunknown',     true]],
      '01197' => [['5.0.0',   '550', 'userunknown',     true]],
      '01198' => [['5.0.0',   '554', 'systemerror',     false]],
      '01199' => [['5.0.0',   '552', 'toomanyconn',     false]],
      '01200' => [['4.0.0',   '421', 'blocked',         false]],
      '01201' => [['4.0.0',   '421', 'blocked',         false]],
      '01202' => [['5.7.0',   '550', 'policyviolation', false]],
      '01203' => [['5.0.0',   '554', 'suspend',         false]],
      '01204' => [['5.0.0',   '504', 'syntaxerror',     false]],
      '01205' => [['5.7.1',   '550', 'rejected',        false]],
      '01206' => [['5.0.0',   '552', 'toomanyconn',     false]],
      '01207' => [['5.0.0',   '550', 'toomanyconn',     false]],
      '01208' => [['5.0.0',   '550', 'toomanyconn',     false]],
      '01209' => [['4.4.2',   '',    'networkerror',    false]],
      '01210' => [['5.0.0',   '550', 'blocked',         false]],
      '01211' => [['5.1.1',   '550', 'userunknown',     true]],
      '01212' => [['5.2.1',   '550', 'userunknown',     true]],
      '01213' => [['5.1.1',   '550', 'userunknown',     true]],
      '01214' => [['5.2.1',   '550', 'speeding',        false]],
      '01215' => [['5.2.1',   '550', 'speeding',        false]],
      '01216' => [['4.0.0',   '',    'blocked',         false]],
      '01217' => [['4.0.0',   '',    'blocked',         false]],
      '01218' => [['4.0.0',   '',    'blocked',         false]],
      '01219' => [['5.0.0',   '550', 'suspend',         false]],
      '01220' => [['5.0.0',   '550', 'virusdetected',   false]],
      '01221' => [['5.1.1',   '',    'userunknown',     true]],
      '01222' => [['5.2.2',   '552', 'mailboxfull',     false]],
      '01223' => [['5.7.9',   '554', 'policyviolation', false]],
      '01224' => [['5.7.9',   '554', 'policyviolation', false]],
      '01225' => [['5.0.0',   '554', 'policyviolation', false]],
      '01226' => [['5.7.9',   '554', 'policyviolation', false]],
      '01227' => [['5.7.26',  '550', 'authfailure',     false]],
      '01228' => [['5.7.1',   '554', 'authfailure',     false]],
      '01229' => [['5.7.1',   '550', 'authfailure',     false]],
      '01230' => [['5.7.1',   '550', 'authfailure',     false]],
      '01231' => [['5.7.1',   '550', 'authfailure',     false],
                  ['5.7.1',   '550', 'authfailure',     false],
                  ['5.7.1',   '550', 'authfailure',     false]],
      '01232' => [['4.7.0',   '421', 'blocked',         false]],
      '01233' => [['5.0.0',   '550', 'blocked',         false]],
      '01234' => [['5.0.0',   '553', 'blocked',         false]],
      '01235' => [['5.0.0',   '554', 'spamdetected',    false]],
      '01236' => [['5.0.0',   '550', 'badreputation',   false]],
      '01237' => [['5.0.0',   '550', 'norelaying',      false]],
      '01238' => [['5.0.0',   '550', 'userunknown',     true]],
      '01239' => [['5.0.0',   '550', 'blocked',         false]],
      '01240' => [['5.0.0',   '550', 'rejected',        false]],
      '01241' => [['5.0.0',   '550', 'rejected',        false]],
      '01242' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01243' => [['5.0.0',   '554', 'badreputation',   false]],
      '01244' => [['5.8.5',   '550', 'policyviolation', false]],
      '01245' => [['5.0.0',   '554', 'blocked',         false]],
      '01246' => [['5.0.0',   '550', 'userunknown',     true]],
      '01247' => [['5.0.0',   '550', 'norelaying',      false]],
      '01248' => [['5.0.0',   '550', 'blocked',         false]],
      '01249' => [['5.0.0',   '550', 'blocked',         false]],
      '01250' => [['5.0.0',   '550', 'userunknown',     true]],
      '01251' => [['5.0.0',   '550', 'spamdetected',    false]],
      '01252' => [['5.0.0',   '',    'onhold',          false]],
      '01253' => [['5.0.0',   '554', 'spamdetected',    false]],
      '01254' => [['5.0.0',   '554', 'policyviolation', false]],
      '01255' => [['5.4.6',   '554', 'systemerror',     false]],
      '01256' => [['5.5.1',   '554', 'blocked',         false]],
      '01257' => [['5.0.0',   '550', 'notaccept',       true]],
      '01258' => [['5.0.0',   '550', 'rejected',        false]],
      '01259' => [['5.0.0',   '',    'onhold',          false]],
      '01260' => [['5.0.0',   '550', 'userunknown',     true]],
      '01261' => [['5.0.0',   '550', 'norelaying',      false]],
      '01262' => [['5.0.0',   '550', 'norelaying',      false]],
      '01263' => [['5.0.0',   '550', 'filtered',        false]],
      '01264' => [['5.0.0',   '550', 'userunknown',     true]],
      '01265' => [['5.0.0',   '554', 'rejected',        false]],
      '01266' => [['5.0.0',   '550', 'suspend',         false]],
      '01267' => [['5.0.0',   '550', 'onhold',          false]], # spamdetected
      '01268' => [['5.0.0',   '550', 'suspend',         false]],
      '01269' => [['5.0.0',   '550', 'virusdetected',   false]],
      '01270' => [['5.0.0',   '554', 'norelaying',      false]],
      '01271' => [['5.0.0',   '554', 'contenterror',    false]],
      '01272' => [['5.0.0',   '550', 'rejected',        false]],
      '01273' => [['5.0.0',   '550', 'rejected',        false]],
    }
  end
end

