import 'dart:io';

class AdHelper {
  static String get scheduleBannerAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1670699619757926/1735265210';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1670699619757926/7981943514';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get foodBannerAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1670699619757926/6477290157';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1670699619757926/5355780173';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get absentBannerAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1670699619757926/7661275661';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1670699619757926/2600520677';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
