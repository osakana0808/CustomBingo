import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';

/// 参加者モード用のバナー広告。読み込み失敗時は null を返し、
/// 画面側でバナー領域ごと非表示にする。
final bannerAdProvider = FutureProvider.autoDispose<BannerAd?>((ref) {
  final completer = Completer<BannerAd?>();
  final ad = BannerAd(
    adUnitId: AdService.bannerAdUnitId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (ad) => completer.complete(ad as BannerAd),
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        completer.complete(null);
      },
    ),
  );
  ref.onDispose(ad.dispose);
  ad.load();
  return completer.future;
});
