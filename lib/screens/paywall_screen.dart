import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../app.dart';
import '../l10n/app_localizations.dart';
import '../providers/purchase_provider.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final offeringAsync = ref.watch(offeringProvider);
    final entitlementAsync = ref.watch(entitlementProvider);

    final isLoading = entitlementAsync.isLoading;

    return Scaffold(
      backgroundColor: WaColors.navy,
      appBar: AppBar(
        title: Text(l10n.paywallTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // ── アイコン ─────────────────────────────────
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      WaColors.vermilion.withValues(alpha: 0.8),
                      WaColors.vermilionDim,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: WaColors.vermilion.withValues(alpha: 0.4),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.casino, size: 52, color: Colors.white),
              ),
              const SizedBox(height: 24),

              // ── タイトル ─────────────────────────────────
              Text(
                l10n.paywallHeadline,
                style: const TextStyle(
                  color: WaColors.gold,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.paywallSubheadline,
                style: const TextStyle(
                  color: WaColors.creamDim,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // ── 機能一覧 ─────────────────────────────────
              _FeatureCard(features: [
                (Icons.casino, l10n.paywallFeature1),
                (Icons.history, l10n.paywallFeature2),
                (Icons.format_list_bulleted, l10n.paywallFeature3),
                (Icons.skip_next, l10n.paywallFeature4),
              ]),
              const SizedBox(height: 32),

              // ── 購入ボタン（価格はRevenueCatから取得） ──────
              offeringAsync.when(
                loading: () => const _PriceButton(priceString: null, loading: true),
                error: (_, __) => _PriceButton(
                  priceString: null,
                  loading: false,
                  onTap: null,
                ),
                data: (offering) {
                  // Non-consumable (lifetime) or monthly を探す
                  final package = _pickPackage(offering);
                  return _PriceButton(
                    priceString: package?.storeProduct.priceString,
                    loading: isLoading,
                    onTap: package == null || isLoading
                        ? null
                        : () => _purchase(context, ref, package, l10n),
                  );
                },
              ),
              const SizedBox(height: 12),

              // ── 復元ボタン ──────────────────────────────
              TextButton(
                onPressed: isLoading ? null : () => _restore(context, ref, l10n),
                child: Text(
                  l10n.paywallRestore,
                  style: const TextStyle(color: WaColors.creamDim, fontSize: 13),
                ),
              ),

              const SizedBox(height: 8),
              Text(
                l10n.paywallLegal,
                style:
                    const TextStyle(color: WaColors.creamDim, fontSize: 11, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Offering から適切なパッケージを選ぶ（lifetime > monthly > annual の順）
  Package? _pickPackage(Offering? offering) {
    if (offering == null) return null;
    return offering.lifetime ??
        offering.monthly ??
        offering.annual ??
        (offering.availablePackages.isNotEmpty
            ? offering.availablePackages.first
            : null);
  }

  Future<void> _purchase(
    BuildContext context,
    WidgetRef ref,
    Package package,
    AppLocalizations l10n,
  ) async {
    try {
      final entitled = await ref.read(entitlementProvider.notifier).purchase(package);
      if (entitled && context.mounted) {
        Navigator.of(context).pop(true); // ペイウォールを閉じる
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paywallPurchaseSuccess)),
        );
      }
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) return;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paywallPurchaseError(e.name))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paywallPurchaseError(e.toString()))),
        );
      }
    }
  }

  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    try {
      final entitled = await ref.read(entitlementProvider.notifier).restore();
      if (!context.mounted) return;
      if (entitled) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paywallRestoreSuccess)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paywallRestoreNotFound)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paywallPurchaseError(e.toString()))),
        );
      }
    }
  }
}

// ── 機能カード ───────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.features});
  final List<(IconData, String)> features;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WaColors.navyCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: WaColors.gold.withValues(alpha: 0.35),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: features
            .map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: WaColors.gold.withValues(alpha: 0.15),
                        ),
                        child: Icon(f.$1, size: 18, color: WaColors.gold),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          f.$2,
                          style: const TextStyle(
                            color: WaColors.cream,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ── 購入ボタン ───────────────────────────────────────────────
class _PriceButton extends StatelessWidget {
  const _PriceButton({
    required this.priceString,
    required this.loading,
    this.onTap,
  });
  final String? priceString;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: FilledButton(
        onPressed: loading ? null : onTap,
        style: FilledButton.styleFrom(
          backgroundColor: WaColors.vermilion,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                priceString != null
                    ? l10n.paywallBuyButton(priceString!)
                    : l10n.paywallBuyButtonNoPrice,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
