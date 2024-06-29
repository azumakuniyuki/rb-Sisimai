module LhostEngineTest::Public
  module Postfix
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '01' => [['5.1.1',   '',    'mailererror',     false]],
      '02' => [['5.2.1',   '550', 'userunknown',     true],
               ['5.1.1',   '550', 'userunknown',     true]],
      '03' => [['5.0.0',   '550', 'filtered',        false]],
      '04' => [['5.1.1',   '550', 'userunknown',     true]],
      '05' => [['4.1.1',   '450', 'userunknown',     true]],
      '06' => [['5.4.4',   '',    'hostunknown',     true]],
      '07' => [['5.0.910', '550', 'filtered',        false]],
      '08' => [['4.4.1',   '',    'expired',         false]],
      '09' => [['4.3.2',   '452', 'toomanyconn',     false]],
      '10' => [['5.1.8',   '553', 'rejected',        false]],
      '11' => [['5.1.8',   '553', 'rejected',        false],
               ['5.1.8',   '553', 'rejected',        false]],
      '13' => [['5.2.1',   '550', 'userunknown',     true],
               ['5.2.2',   '550', 'mailboxfull',     false]],
      '14' => [['5.1.1',   '',    'userunknown',     true]],
      '15' => [['4.4.1',   '',    'expired',         false]],
      '16' => [['5.1.6',   '550', 'hasmoved',        true]],
      '17' => [['5.4.4',   '',    'networkerror',    false]],
      '28' => [['5.7.1',   '550', 'notcompliantrfc', false]],
      '29' => [['5.7.1',   '550', 'notcompliantrfc', false]],
      '30' => [['5.4.1',   '550', 'userunknown',     true]],
      '31' => [['5.1.1',   '550', 'userunknown',     true]],
      '32' => [['5.1.1',   '550', 'userunknown',     true]],
      '33' => [['5.1.1',   '550', 'userunknown',     true]],
      '34' => [['5.0.944', '',    'networkerror',    false]],
      '35' => [['5.0.0',   '550', 'filtered',        false]],
      '36' => [['5.0.0',   '550', 'userunknown',     true]],
      '37' => [['4.4.1',   '',    'expired',         false]],
      '38' => [['4.0.0',   '',    'blocked',         false]],
      '39' => [['5.6.0',   '554', 'spamdetected',    false]],
      '40' => [['4.0.0',   '451', 'systemerror',     false]],
      '41' => [['5.0.0',   '550', 'policyviolation', false]],
      '42' => [['5.0.0',   '550', 'policyviolation', false]],
      '43' => [['4.3.0',   '',    'mailererror',     false]],
      '44' => [['5.7.1',   '501', 'norelaying',      false]],
      '45' => [['4.3.0',   '',    'mailboxfull',     false]],
      '46' => [['5.0.0',   '550', 'userunknown',     true]],
      '47' => [['5.0.0',   '554', 'systemerror',     false]],
      '48' => [['5.0.0',   '552', 'toomanyconn',     false]],
      '49' => [['4.0.0',   '421', 'blocked',         false]],
      '50' => [['4.0.0',   '421', 'blocked',         false]],
      '51' => [['5.7.0',   '550', 'policyviolation', false]],
      '52' => [['5.0.0',   '554', 'suspend',         false]],
      '53' => [['5.0.0',   '504', 'syntaxerror',     false]],
      '54' => [['5.7.1',   '550', 'rejected',        false]],
      '55' => [['5.0.0',   '552', 'toomanyconn',     false]],
      '56' => [['4.4.2',   '',    'networkerror',    false]],
      '57' => [['5.2.1',   '550', 'userunknown',     true]],
      '58' => [['5.7.1',   '550', 'badreputation',   false]],
      '59' => [['5.2.1',   '550', 'speeding',        false]],
      '60' => [['4.0.0',   '',    'requireptr',      false]],
      '61' => [['5.0.0',   '550', 'suspend',         false]],
      '62' => [['5.0.0',   '550', 'virusdetected',   false]],
      '63' => [['5.2.2',   '552', 'mailboxfull',     false]],
      '64' => [['5.0.900', '',    'undefined',       false]],
      '65' => [['5.0.0',   '550', 'securityerror',   false]],
      '66' => [['5.7.9',   '554', 'policyviolation', false]],
      '67' => [['5.7.9',   '554', 'policyviolation', false]],
      '68' => [['5.0.0',   '554', 'policyviolation', false]],
      '69' => [['5.7.9',   '554', 'policyviolation', false]],
      '70' => [['5.7.26',  '550', 'authfailure',     false]],
      '71' => [['5.7.1',   '554', 'authfailure',     false]],
      '72' => [['5.7.1',   '550', 'authfailure',     false]],
      '73' => [['5.7.1',   '550', 'authfailure',     false]],
      '74' => [['4.7.0',   '421', 'rejected',        false]],
      '75' => [['4.3.0',   '451', 'systemerror',     false]],
      '76' => [['5.0.0',   '550', 'userunknown',     true]],
      '77' => [['5.0.0',   '554', 'norelaying',      false]],
      '78' => [['5.0.0',   '554', 'contenterror',    false]],
    }
  end
end

