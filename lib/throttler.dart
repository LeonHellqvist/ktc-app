import 'package:flutter/foundation.dart';
import 'dart:async';

class Throttler {
  final int milliseconds;

  Timer? timer;

  static const kDefaultDelay = 1000;

  Throttler({this.milliseconds = kDefaultDelay});

  void run(VoidCallback action) {
    if (timer?.isActive ?? false) return;

    timer?.cancel();
    action();
    timer = Timer(Duration(milliseconds: milliseconds), () {});
  }

  void dispose() {
    timer?.cancel();
  }
}
