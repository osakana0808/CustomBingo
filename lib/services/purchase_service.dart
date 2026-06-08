import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat のラッパー。
/// ▶ Apple Developer 登録後に [_apiKey] を差し替えること。
/// ▶ App Store Connect で product ID [kProProductId]、
///   entitlement ID [kEntitlementId] を作成して RevenueCat と紐付けること。
class PurchaseService {
  PurchaseService._();

  // ── 定数（Apple Developer 登録後に変更） ──────────────────
  /// RevenueCat iOS API キー（appl_xxx... の形式）
  static const _apiKey = 'appl_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';

  /// RevenueCat のエンタイトルメント ID
  static const kEntitlementId = 'host_mode';

  /// App Store Connect で登録する In-App Purchase の Product ID
  static const kProProductId = 'bingo_maker_pro';

  // ─────────────────────────────────────────────────────────

  static Future<void> init() async {
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);
    final config = PurchasesConfiguration(_apiKey);
    await Purchases.configure(config);
  }

  /// 現在のエンタイトルメント取得（エラー時は false を返す）
  static Future<bool> isEntitled() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey(kEntitlementId);
    } catch (e) {
      debugPrint('[PurchaseService] isEntitled error: $e');
      return false;
    }
  }

  /// デフォルト Offering を取得
  static Future<Offering?> getDefaultOffering() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current;
    } catch (e) {
      debugPrint('[PurchaseService] getOfferings error: $e');
      return null;
    }
  }

  /// パッケージを購入して CustomerInfo を返す
  static Future<CustomerInfo> purchase(Package package) async {
    final params = PurchaseParams.package(package);
    final result = await Purchases.purchase(params);
    return result.customerInfo;
  }

  /// 購入を復元して CustomerInfo を返す
  static Future<CustomerInfo> restore() {
    return Purchases.restorePurchases();
  }
}
