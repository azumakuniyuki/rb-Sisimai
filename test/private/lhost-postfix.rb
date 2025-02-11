module LhostEngineTest::Private
  module Postfix
    IsExpected = {
      # INDEX => [['D.S.N.', 'replycode', 'REASON', 'hardbounce'], [...]]
      '1001'  => [['5.0.0',   '550', 'rejected',        false]],
      '1002'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1003'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1004'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1005'  => [['5.0.0',   '554', 'filtered',        false]],
      '1006'  => [['5.7.1',   '550', 'userunknown',     true]],
      '1007'  => [['5.0.0',   '554', 'filtered',        false]],
      '1008'  => [['5.0.910', '',    'filtered',        false]],
      '1009'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1010'  => [['5.0.0',   '',    'hostunknown',     true]],
      '1011'  => [['5.0.0',   '551', 'systemerror',     false]],
      '1012'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1013'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1014'  => [['5.1.1',   '',    'userunknown',     true]],
      '1015'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1016'  => [['4.3.2',   '452', 'toomanyconn',     false]],
      '1017'  => [['4.4.1',   '',    'expired',         false]],
      '1018'  => [['5.4.6',   '',    'systemerror',     false]],
      '1019'  => [['5.7.1',   '553', 'userunknown',     true]],
      '1020'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1021'  => [['4.4.1',   '',    'expired',         false]],
      '1022'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1023'  => [['5.0.0',   '550', 'blocked',         false]],
      '1024'  => [['5.1.1',   '',    'userunknown',     true]],
      '1025'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1026'  => [['4.4.1',   '',    'expired',         false]],
      '1027'  => [['5.4.6',   '',    'systemerror',     false]],
      '1028'  => [['5.0.0',   '551', 'suspend',         false]],
      '1029'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1030'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1031'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1032'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1033'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1034'  => [['5.0.0',   '550', 'rejected',        false]],
      '1035'  => [['4.2.2',   '',    'mailboxfull',     false]],
      '1036'  => [['5.4.4',   '',    'hostunknown',     true]],
      '1037'  => [['5.0.0',   '550', 'rejected',        false]],
      '1038'  => [['5.0.0',   '550', 'blocked',         false]],
      '1039'  => [['5.1.1',   '',    'userunknown',     true]],
      '1040'  => [['5.7.1',   '550', 'userunknown',     true]],
      '1041'  => [['5.1.1',   '',    'userunknown',     true]],
      '1042'  => [['5.4.4',   '',    'networkerror',    false]],
      '1043'  => [['5.1.6',   '550', 'hasmoved',        true]],
      '1044'  => [['5.3.4',   '',    'mesgtoobig',      false]],
      '1045'  => [['5.3.4',   '',    'mesgtoobig',      false]],
      '1046'  => [['5.0.0',   '534', 'mesgtoobig',      false]],
      '1047'  => [['5.7.1',   '554', 'mesgtoobig',      false]],
      '1048'  => [['5.1.1',   '550', 'userunknown',     true],
                  ['5.1.1',   '550', 'userunknown',     true],
                  ['5.1.1',   '550', 'userunknown',     true],
                  ['5.1.1',   '550', 'userunknown',     true],
                  ['5.1.1',   '550', 'userunknown',     true]],
      '1049'  => [['5.0.0',   '550', 'hostunknown',     true]],
      '1050'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1051'  => [['5.7.1',   '553', 'norelaying',      false]],
      '1052'  => [['5.7.1',   '550', 'spamdetected',    false]],
      '1053'  => [['5.4.6',   '',    'systemerror',     false]],
      '1054'  => [['5.1.1',   '',    'userunknown',     true]],
      '1055'  => [['5.2.1',   '550', 'filtered',        false]],
      '1056'  => [['5.1.1',   '',    'mailererror',     false]],
      '1057'  => [['5.2.1',   '550', 'userunknown',     true],
                  ['5.1.1',   '550', 'userunknown',     true]],
      '1058'  => [['5.0.0',   '550', 'filtered',        false]],
      '1059'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1060'  => [['4.1.1',   '450', 'userunknown',     true]],
      '1061'  => [['5.4.4',   '',    'hostunknown',     true]],
      '1062'  => [['5.0.910', '550', 'filtered',        false]],
      '1063'  => [['5.1.1',   '',    'mailererror',     false]],
      '1064'  => [['5.0.0',   '',    'hostunknown',     true]],
      '1065'  => [['5.0.0',   '',    'networkerror',    false]],
      '1066'  => [['5.0.0',   '554', 'norelaying',      false]],
      '1067'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1068'  => [['5.0.0',   '554', 'norelaying',      false]],
      '1069'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1070'  => [['5.0.944', '',    'networkerror',    false]],
      '1071'  => [['5.0.922', '',    'mailboxfull',     false]],
      '1072'  => [['5.0.901', '554', 'onhold',          false]],
      '1073'  => [['4.0.0',   '452', 'mailboxfull',     false]],
      '1074'  => [['5.0.0',   '550', 'mailboxfull',     false]],
      '1075'  => [['5.7.0',   '',    'mailboxfull',     false]],
      '1076'  => [['5.0.0',   '554', 'filtered',        false]],
      '1077'  => [['5.7.1',   '553', 'norelaying',      false]],
      '1078'  => [['5.0.0',   '550', 'norelaying',      false]],
      '1079'  => [['5.7.1',   '550', 'spamdetected',    false]],
      '1080'  => [['5.7.1',   '554', 'spamdetected',    false]],
      '1081'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1082'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1083'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1084'  => [['5.7.1',   '554', 'spamdetected',    false]],
      '1085'  => [['5.7.1',   '554', 'spamdetected',    false]],
      '1086'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1087'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1088'  => [['5.6.0',   '554', 'spamdetected',    false]],
      '1089'  => [['5.7.1',   '554', 'spamdetected',    false]],
      '1090'  => [['5.7.1',   '554', 'spamdetected',    false]],
      '1091'  => [['5.0.0',   '500', 'spamdetected',    false]],
      '1092'  => [['5.0.0',   '554', 'spamdetected',    false]],
      '1093'  => [['5.7.1',   '554', 'spamdetected',    false]],
      '1094'  => [['5.7.1',   '550', 'policyviolation', false]],
      '1095'  => [['5.0.0',   '554', 'spamdetected',    false]],
      '1096'  => [['5.0.0',   '554', 'spamdetected',    false]],
      '1097'  => [['5.7.3',   '553', 'spamdetected',    false]],
      '1098'  => [['5.7.1',   '550', 'spamdetected',    false]],
      '1099'  => [['5.7.1',   '550', 'spamdetected',    false]],
      '1100'  => [['5.0.0',   '554', 'spamdetected',    false]],
      '1101'  => [['5.0.0',   '554', 'virusdetected',   false]],
      '1102'  => [['5.7.1',   '550', 'spamdetected',    false]],
      '1103'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1104'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1105'  => [['5.0.0',   '551', 'spamdetected',    false]],
      '1106'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1107'  => [['5.7.1',   '554', 'spamdetected',    false]],
      '1108'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1109'  => [['5.7.1',   '550', 'spamdetected',    false]],
      '1110'  => [['5.7.1',   '550', 'spamdetected',    false]],
      '1111'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1112'  => [['5.0.0',   '554', 'spamdetected',    false]],
      '1113'  => [['5.7.1',   '550', 'spamdetected',    false]],
      '1114'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1115'  => [['5.0.0',   '554', 'blocked',         false]],
      '1116'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1117'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1118'  => [['5.0.0',   '554', 'spamdetected',    false]],
      '1119'  => [['5.0.0',   '553', 'spamdetected',    false]],
      '1120'  => [['5.7.1',   '550', 'spamdetected',    false]],
      '1121'  => [['5.3.0',   '554', 'spamdetected',    false]],
      '1122'  => [['5.4.4',   '',    'hostunknown',     true]],
      '1123'  => [['5.7.1',   '554', 'userunknown',     true]],
      '1124'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1125'  => [['5.2.3',   '',    'mailboxfull',     false]],
      '1126'  => [['5.0.0',   '',    'systemerror',     false]],
      '1127'  => [['5.7.17',  '550', 'userunknown',     true]],
      '1128'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1129'  => [['5.0.0',   '554', 'filtered',        false]],
      '1130'  => [['5.0.0',   '552', 'mailboxfull',     false]],
      '1131'  => [['5.2.3',   '',    'mailboxfull',     false]],
      '1132'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1133'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1134'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1135'  => [['5.2.1',   '550', 'suspend',         false]],
      '1136'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1137'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1138'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1139'  => [['5.1.3',   '501', 'userunknown',     true]],
      '1140'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1141'  => [['5.0.0',   '',    'filtered',        false]],
      '1142'  => [['5.0.0',   '550', 'blocked',         false]],
      '1143'  => [['5.3.0',   '553', 'userunknown',     true]],
      '1144'  => [['5.0.0',   '554', 'suspend',         false]],
      '1145'  => [['5.0.0',   '550', 'rejected',        false]],
      '1146'  => [['5.1.3',   '',    'userunknown',     true]],
      '1147'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1148'  => [['5.2.1',   '550', 'userunknown',     true]],
      '1149'  => [['5.2.2',   '550', 'mailboxfull',     false]],
      '1150'  => [['5.0.910', '',    'filtered',        false]],
      '1151'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1152'  => [['5.3.0',   '553', 'blocked',         false]],
      '1153'  => [['5.7.1',   '550', 'badreputation',   false]],
      '1154'  => [['4.7.0',   '421', 'blocked',         false]],
      '1155'  => [['5.1.0',   '550', 'userunknown',     true]],
      '1156'  => [['5.1.0',   '550', 'userunknown',     true]],
      '1157'  => [['4.0.0',   '',    'blocked',         false]],
      '1158'  => [['5.6.0',   '554', 'spamdetected',    false]],
      '1159'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1160'  => [['4.0.0',   '451', 'systemerror',     false]],
      '1161'  => [['5.0.0',   '',    'mailboxfull',     false]],
      '1162'  => [['5.0.0',   '550', 'policyviolation', false]],
      '1163'  => [['5.0.0',   '550', 'policyviolation', false]],
      '1164'  => [['5.0.0',   '550', 'blocked',         false]],
      '1165'  => [['5.5.0',   '550', 'userunknown',     true]],
      '1166'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1167'  => [['4.0.0',   '',    'blocked',         false]],
      '1168'  => [['5.0.0',   '',    'rejected',        false]],
      '1169'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1170'  => [['5.0.0',   '550', 'requireptr',      false]],
      '1171'  => [['5.2.0',   '',    'mailboxfull',     false]],
      '1172'  => [['4.3.0',   '',    'mailererror',     false]],
      '1173'  => [['4.4.2',   '',    'networkerror',    false]],
      '1174'  => [['4.3.2',   '451', 'notaccept',       false]],
      '1175'  => [['5.7.9',   '554', 'policyviolation', false]],
      '1176'  => [['5.7.1',   '554', 'userunknown',     true]],
      '1177'  => [['5.7.1',   '550', 'userunknown',     true]],
      '1178'  => [['5.7.1',   '550', 'blocked',         false]],
      '1179'  => [['5.7.1',   '501', 'norelaying',      false]],
      '1180'  => [['5.4.1',   '550', 'userunknown',     true]],
      '1181'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1182'  => [['5.7.0',   '550', 'spamdetected',    false]],
      '1183'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1184'  => [['5.7.1',   '550', 'norelaying',      false]],
      '1185'  => [['4.0.0',   '451', 'systemerror',     false]],
      '1186'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1187'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1188'  => [['4.4.1',   '',    'expired',         false]],
      '1189'  => [['5.4.4',   '',    'hostunknown',     true]],
      '1190'  => [['5.1.1',   '',    'userunknown',     true]],
      '1191'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1192'  => [['5.1.1',   '550', 'speeding',        false]],
      '1193'  => [['5.0.0',   '550', 'filtered',        false]],
      '1194'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1195'  => [['4.4.1',   '',    'expired',         false]],
      '1196'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1197'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1198'  => [['5.0.0',   '554', 'systemerror',     false]],
      '1199'  => [['5.0.0',   '552', 'toomanyconn',     false]],
      '1200'  => [['4.0.0',   '421', 'blocked',         false]],
      '1201'  => [['4.0.0',   '421', 'blocked',         false]],
      '1202'  => [['5.7.0',   '550', 'policyviolation', false]],
      '1203'  => [['5.0.0',   '554', 'suspend',         false]],
      '1204'  => [['5.0.0',   '504', 'syntaxerror',     false]],
      '1205'  => [['5.7.1',   '550', 'rejected',        false]],
      '1206'  => [['5.0.0',   '552', 'toomanyconn',     false]],
      '1207'  => [['5.0.0',   '550', 'toomanyconn',     false]],
      '1208'  => [['5.0.0',   '550', 'toomanyconn',     false]],
      '1209'  => [['4.4.2',   '',    'networkerror',    false]],
      '1210'  => [['5.0.0',   '550', 'authfailure',     false]],
      '1211'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1212'  => [['5.2.1',   '550', 'userunknown',     true]],
      '1213'  => [['5.1.1',   '550', 'userunknown',     true]],
      '1214'  => [['5.2.1',   '550', 'speeding',        false]],
      '1215'  => [['5.2.1',   '550', 'speeding',        false]],
      '1216'  => [['4.0.0',   '',    'requireptr',      false]],
      '1217'  => [['4.0.0',   '',    'requireptr',      false]],
      '1218'  => [['4.0.0',   '',    'requireptr',      false]],
      '1219'  => [['5.0.0',   '550', 'suspend',         false]],
      '1220'  => [['5.0.0',   '550', 'virusdetected',   false]],
      '1221'  => [['5.1.1',   '',    'userunknown',     true]],
      '1222'  => [['5.2.2',   '552', 'mailboxfull',     false]],
      '1223'  => [['5.7.9',   '554', 'policyviolation', false]],
      '1224'  => [['5.7.9',   '554', 'policyviolation', false]],
      '1225'  => [['5.0.0',   '554', 'policyviolation', false]],
      '1226'  => [['5.7.9',   '554', 'policyviolation', false]],
      '1227'  => [['5.7.26',  '550', 'authfailure',     false]],
      '1228'  => [['5.7.1',   '554', 'authfailure',     false]],
      '1229'  => [['5.7.1',   '550', 'authfailure',     false]],
      '1230'  => [['5.7.1',   '550', 'authfailure',     false]],
      '1231'  => [['5.7.9',   '550', 'policyviolation', false],
                  ['5.7.1',   '550', 'authfailure',     false],
                  ['5.7.1',   '550', 'authfailure',     false]],
      '1232'  => [['4.7.0',   '421', 'rejected',        false]],
      '1233'  => [['5.0.0',   '550', 'blocked',         false]],
      '1234'  => [['5.0.0',   '553', 'rejected',        false]],
      '1235'  => [['5.0.0',   '554', 'spamdetected',    false]],
      '1236'  => [['5.0.0',   '550', 'badreputation',   false]],
      '1237'  => [['5.0.0',   '550', 'norelaying',      false]],
      '1238'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1239'  => [['5.0.0',   '550', 'blocked',         false]],
      '1240'  => [['5.0.0',   '550', 'rejected',        false]],
      '1241'  => [['5.0.0',   '550', 'rejected',        false]],
      '1242'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1243'  => [['5.0.0',   '554', 'badreputation',   false]],
      '1244'  => [['5.8.5',   '550', 'policyviolation', false]],
      '1245'  => [['5.0.0',   '554', 'blocked',         false]],
      '1246'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1247'  => [['5.0.0',   '550', 'norelaying',      false]],
      '1248'  => [['5.0.0',   '550', 'blocked',         false]],
      '1249'  => [['5.0.0',   '550', 'blocked',         false]],
      '1250'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1251'  => [['5.0.0',   '550', 'spamdetected',    false]],
      '1252'  => [['5.0.0',   '',    'onhold',          false]],
      '1253'  => [['5.0.0',   '554', 'spamdetected',    false]],
      '1254'  => [['5.0.0',   '554', 'policyviolation', false]],
      '1255'  => [['5.4.6',   '554', 'systemerror',     false]],
      '1256'  => [['5.5.1',   '554', 'blocked',         false]],
      '1257'  => [['5.0.0',   '550', 'notaccept',       true]],
      '1258'  => [['5.0.0',   '550', 'rejected',        false]],
      '1259'  => [['5.0.0',   '',    'onhold',          false]],
      '1260'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1261'  => [['5.0.0',   '550', 'norelaying',      false]],
      '1262'  => [['5.0.0',   '550', 'norelaying',      false]],
      '1263'  => [['5.0.0',   '550', 'filtered',        false]],
      '1264'  => [['5.0.0',   '550', 'userunknown',     true]],
      '1265'  => [['5.0.0',   '554', 'rejected',        false]],
      '1266'  => [['5.0.0',   '550', 'suspend',         false]],
      '1267'  => [['5.0.0',   '550', 'onhold',          false]], # spamdetected
      '1268'  => [['5.0.0',   '550', 'suspend',         false]],
      '1269'  => [['5.0.0',   '550', 'virusdetected',   false]],
      '1270'  => [['5.0.0',   '554', 'norelaying',      false]],
      '1271'  => [['5.0.0',   '554', 'notcompliantrfc', false]],
      '1272'  => [['5.0.0',   '550', 'rejected',        false]],
      '1273'  => [['5.0.0',   '550', 'rejected',        false]],
      '1274'  => [['5.0.939', '',    'mailererror',     false]],
      '1275'  => [['5.4.14',  '554', 'networkerror',    false],
                  ['5.4.14',  '554', 'networkerror',    false]],
      '1276'  => [['5.7.26',  '550', 'authfailure',     false]],
      '1277'  => [['5.7.26',  '550', 'authfailure',     false]],
      '1278'  => [['5.7.25',  '550', 'requireptr',      false]],
      '1279'  => [['5.2.2',   '552', 'mailboxfull',     false]],
      '1280'  => [['5.7.1',   '550', 'notcompliantrfc', false]],
    }
  end
end

