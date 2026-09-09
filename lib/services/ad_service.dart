import 'dart:io';

/// AdMob 広告ユニットIDの定義。
///
/// ⚠️ 本番リリース前に必ず本番IDへ差し替えること（差し替え箇所は以下の3ファイル）:
///
/// 1. このファイル … バナー広告ユニットID（`_bannerAndroid` / `_bannerIos`）
/// 2. `android/app/src/main/AndroidManifest.xml`
///    … `com.google.android.gms.ads.APPLICATION_ID`（App ID）
/// 3. `ios/Runner/Info.plist` … `GADApplicationIdentifier`（App ID）
///
/// App ID は `ca-app-pub-XXXXXXXX~YYYYYYYY`（チルダ区切り）、
/// 広告ユニットIDは `ca-app-pub-XXXXXXXX/ZZZZZZZZ`（スラッシュ区切り）。
/// AdMob コンソールで Android / iOS それぞれのアプリを作成し、個別に取得する。
class AdService {
  AdService._();

  // ── バナー広告ユニットID ───────────────────────────────
  // TODO(release): Google 公式のテスト用IDのまま。本番IDに差し替える。
  static const String _bannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _bannerIos = 'ca-app-pub-3940256099942544/2934735716';

  static String get bannerAdUnitId =>
      Platform.isAndroid ? _bannerAndroid : _bannerIos;
}
