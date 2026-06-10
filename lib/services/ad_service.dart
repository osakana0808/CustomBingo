import 'dart:io';

/// AdMob 広告ユニットIDの定義。本番リリース時はここのIDを差し替える。
class AdService {
  AdService._();

  // Google 公式のテスト用バナーID
  static const String _bannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _bannerIos = 'ca-app-pub-3940256099942544/2934735716';

  static String get bannerAdUnitId =>
      Platform.isAndroid ? _bannerAndroid : _bannerIos;
}
