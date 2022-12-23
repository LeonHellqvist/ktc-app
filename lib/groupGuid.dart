import 'package:flutter/material.dart';

import 'config.dart';

class MyGroupGuid with ChangeNotifier {
  static String groupGuid = "NTk4NzRhOGQtNDVjOS1mYzE2LTg0NTktNDc1ZjQ0MTQ3YjU4";

  MyGroupGuid() {
    if (box!.containsKey('currentGroupGuid')) {
      groupGuid = box!.get('currentGroupGuid');
    } else {
      box!.put('currentGroupGuid', groupGuid);
    }
  }

  String currentGroupGuid() {
    return groupGuid;
  }

  void setGroupGuid(String guid) {
    groupGuid = guid;
    box!.put('currentGroupGuid', groupGuid);
    notifyListeners();
  }
}
