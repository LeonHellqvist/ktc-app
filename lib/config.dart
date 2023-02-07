library config.globals;

import 'package:ktc_app/group_guid.dart';
import 'package:ktc_app/login_status.dart';

import 'theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

MyTheme currentTheme = MyTheme();
MyGroupGuid currentGroupGuid = MyGroupGuid();
MyLoginStatus currentLoginStatus = MyLoginStatus();
Box? box;
