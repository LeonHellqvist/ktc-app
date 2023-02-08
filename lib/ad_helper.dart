import 'dart:io';

class AdHelper {
  static String get scheduleBannerAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1670699619757926/2395173982';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1670699619757926/6806369317';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get foodBannerAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1670699619757926/9024177425';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1670699619757926/5480296465';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get absentBannerAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1670699619757926/4662260585';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1670699619757926/1541051450';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
