import 'dart:io';

class AdHelper {
  static String get scheduleBannerAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1670699619757926/6806369317';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get foodBannerAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1670699619757926/6806369317';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1670699619757926/6806369317';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get absentBannerAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1670699619757926/6806369317';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1670699619757926/6806369317';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
