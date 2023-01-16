import 'package:flutter/material.dart';

import 'config.dart';

class MyGroupGuid with ChangeNotifier {
  static String groupGuid = "NTk4NzRhOGQtNDVjOS1mYzE2LTg0NTktNDc1ZjQ0MTQ3YjU4";
  static String groupGuidAlt =
      "ZDY4NDFmMjctM2I0NS1mYWEwLTk2ZWItY2Q0NDQzMGYwM2Qy";

  static String groupName = "TE21";
  static String groupNameAlt = "NA21";

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

    if (box!.containsKey('currentGroupName')) {
      groupName = box!.get('currentGroupName');
    } else {
      box!.put('currentGroupName', groupName);
    }
    if (box!.containsKey('currentGroupNameAlt')) {
      groupNameAlt = box!.get('currentGroupNameAlt');
    } else {
      box!.put('currentGroupNameAlt', groupNameAlt);
    }
  }

  String currentGroupGuid() {
    return groupGuid;
  }

  String currentGroupName() {
    return groupName;
  }

  String currentGroupGuidAlt() {
    return groupGuidAlt;
  }

  String currentGroupNameAlt() {
    return groupNameAlt;
  }

  void setGroup(String guid, String name) {
    groupGuid = guid;
    groupName = name;
    box!.put('currentGroupGuid', groupGuid);
    box!.put('currentGroupName', groupName);
    notifyListeners();
  }

  void setGroupAlt(String guid, String name) {
    groupGuidAlt = guid;
    groupNameAlt = name;
    box!.put('currentGroupGuidAlt', groupGuidAlt);
    box!.put('currentGroupNameAlt', groupNameAlt);
    notifyListeners();
  }
}
