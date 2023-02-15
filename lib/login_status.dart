import 'package:flutter/material.dart';

import 'config.dart';

class MyLoginStatus with ChangeNotifier {
  // Possible options are: in, out, logout
  static String loginStatus = "out";

  MyLoginStatus() {
    if (box!.containsKey('loginStatus')) {
      loginStatus = box!.get('loginStatus');
    } else {
      box!.put('loginStatus', loginStatus);
    }
  }

  String getLoginStatus() => loginStatus;

  void setLoginStatus(String status) {
    loginStatus = status;
    box!.put('loginStatus', loginStatus);
    notifyListeners();
  }
}
