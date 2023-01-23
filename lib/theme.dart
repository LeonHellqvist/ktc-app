import 'package:flutter/material.dart';

import 'config.dart';

class MyTheme with ChangeNotifier {
  static bool _isDark = true;
  static bool _isDynamic = true;

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
  }

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool currentThemeDynamic() {
    return _isDynamic;
  }

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
}
