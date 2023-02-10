import 'dart:io';

class AdHelper {
  static String get scheduleBannerAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1670699619757926/7447219910';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1670699619757926/6517281628';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get foodBannerAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1670699619757926/9881811568';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1670699619757926/3699546590';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get absentBannerAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1670699619757926/8568729893';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1670699619757926/4511997013';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
