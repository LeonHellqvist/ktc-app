import 'package:flutter/material.dart';

import 'config.dart';

class MyTheme with ChangeNotifier {
  static bool _isDark = true;
  static bool _isDynamic = true;
  static String _scheduleView = "standard";

  MyTheme() {
    if (box!.containsKey('currentTheme')) {
      _isDark = box!.get('currentTheme');
    } else {
      box!.put('currentTheme', _isDark);
    }
    if (box!.containsKey('currentThemeDynamic')) {
      _isDynamic = box!.get('currentThemeDynamic');
    } else {
      box!.put('currentThemeDynamic', _isDynamic);
    }
    if (box!.containsKey('currentThemeScheduleView')) {
      _scheduleView = box!.get('currentThemeScheduleView');
    } else {
      box!.put('currentThemeScheduleView', _scheduleView);
    }
  }

  ThemeMode currentTheme() => _isDark ? ThemeMode.dark : ThemeMode.light;

  bool currentThemeDynamic() => _isDynamic;

  String currentThemeScheduleView() => _scheduleView;

  void switchTheme() {
    _isDark = !_isDark;
    box!.put('currentTheme', _isDark);
    notifyListeners();
  }

  void switchThemeDynamic() {
    _isDynamic = !_isDynamic;
    box!.put('currentThemeDynamic', _isDynamic);
    notifyListeners();
  }

  void switchThemeScheduleView() {
    _scheduleView = _scheduleView == "standard" ? "block" : "standard";
    box!.put('currentThemeScheduleView', _scheduleView);
    notifyListeners();
  }
}
