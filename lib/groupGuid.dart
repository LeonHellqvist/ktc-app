import 'package:flutter/material.dart';

import 'config.dart';

class MyGroupGuid with ChangeNotifier {
  static String groupGuid = "NTk4NzRhOGQtNDVjOS1mYzE2LTg0NTktNDc1ZjQ0MTQ3YjU4";
  static String groupGuidAlt =
      "ZDY4NDFmMjctM2I0NS1mYWEwLTk2ZWItY2Q0NDQzMGYwM2Qy";

  MyGroupGuid() {
    if (box!.containsKey('currentGroupGuid')) {
      groupGuid = box!.get('currentGroupGuid');
    } else {
      box!.put('currentGroupGuid', groupGuid);
    }
    if (box!.containsKey('currentGroupGuidAlt')) {
      groupGuidAlt = box!.get('currentGroupGuidAlt');
    } else {
      box!.put('currentGroupGuidAlt', groupGuidAlt);
    }
  }

  String currentGroupGuid() {
    return groupGuid;
  }

  String currentGroupGuidAlt() {
    return groupGuidAlt;
  }

  void setGroupGuid(String guid) {
    groupGuid = guid;
    box!.put('currentGroupGuid', groupGuid);
    notifyListeners();
  }

  void setGroupGuidAlt(String guid) {
    groupGuidAlt = guid;
    box!.put('currentGroupGuidAlt', groupGuidAlt);
    notifyListeners();
  }
}
