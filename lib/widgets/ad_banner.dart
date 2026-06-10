import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../providers/purchase_provider.dart';
import '../services/ad_service.dart';

/// 無料ユーザーにのみ表示するバナー広告。
///
/// プロ（司会者モード購読中）は広告非表示特典として、読み込み自体を行わない。
/// 購読状態が変わると即座に反映される（購入→広告破棄、失効→読み込み開始）。
/// 読み込み失敗時は領域ごと非表示にする。
class AdBanner extends ConsumerStatefulWidget {
  const AdBanner({super.key});

  @override
  ConsumerState<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends ConsumerState<AdBanner> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (ref.read(entitlementProvider).valueOrNull == false) {
      _load();
    }
  }

  void _load() {
    if (_ad != null) return;
    final ad = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _ad = null;
        },
      ),
    );
    _ad = ad;
    ad.load();
  }

  void _disposeAd() {
    _ad?.dispose();
    _ad = null;
    _loaded = false;
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(entitlementProvider, (_, next) {
      final entitled = next.valueOrNull;
      if (entitled == false) {
        _load();
      } else if (entitled == true && _ad != null) {
        setState(_disposeAd);
      }
    });

    final entitled = ref.watch(entitlementProvider).valueOrNull;
    final ad = _ad;
    if (entitled != false || !_loaded || ad == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: double.infinity,
      height: ad.size.height.toDouble(),
      child: Center(
        child: SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}
