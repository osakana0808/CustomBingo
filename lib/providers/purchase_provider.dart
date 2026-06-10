import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/purchase_service.dart';

// ── エンタイトルメント（購入済みか否か） ──────────────────────
class EntitlementNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() {
    // 解約・期限切れ・別端末での購入を即時反映する。
    // SDK はフォアグラウンド復帰時などにサーバーから CustomerInfo を再取得し、
    // 変化があるとこのリスナーが呼ばれる。
    void onInfoUpdate(CustomerInfo info) {
      state = AsyncData(
        info.entitlements.active.containsKey(PurchaseService.kEntitlementId),
      );
    }

    Purchases.addCustomerInfoUpdateListener(onInfoUpdate);
    ref.onDispose(
      () => Purchases.removeCustomerInfoUpdateListener(onInfoUpdate),
    );
    return PurchaseService.isEntitled();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(PurchaseService.isEntitled);
  }

  Future<bool> purchase(Package package) async {
    state = const AsyncLoading();
    try {
      final info = await PurchaseService.purchase(package);
      final entitled = info.entitlements.active
          .containsKey(PurchaseService.kEntitlementId);
      state = AsyncData(entitled);
      return entitled;
    } catch (e) {
      state = const AsyncData(false);
      rethrow;
    }
  }

  Future<bool> restore() async {
    state = const AsyncLoading();
    try {
      final info = await PurchaseService.restore();
      final entitled = info.entitlements.active
          .containsKey(PurchaseService.kEntitlementId);
      state = AsyncData(entitled);
      return entitled;
    } catch (e) {
      state = const AsyncData(false);
      rethrow;
    }
  }
}

final entitlementProvider =
    AsyncNotifierProvider<EntitlementNotifier, bool>(EntitlementNotifier.new);

// ── オファリング（価格情報） ────────────────────────────────
final offeringProvider = FutureProvider<Offering?>((ref) {
  return PurchaseService.getDefaultOffering();
});
