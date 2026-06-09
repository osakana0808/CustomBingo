import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat のラッパー。
///
/// ▶ [_androidApiKey] は RevenueCat ダッシュボードの Android Public API Key に差し替える。
/// ▶ [_iosApiKey]     は Apple Developer 登録後に iOS Public API Key に差し替える。
/// ▶ Google Play Console / App Store Connect で [kMonthlyProductId] を登録し、
///   RevenueCat で [kEntitlementId] と紐付けること。
class PurchaseService {
  PurchaseService._();

  // ── API キー ─────────────────────────────────────────────
  /// RevenueCat Android API キー（goog_xxx... の形式）
  static const _androidApiKey = 'goog_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';

  /// RevenueCat iOS API キー（appl_xxx... の形式）
  static const _iosApiKey = 'appl_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';

  // ── 商品・エンタイトルメント ID ───────────────────────────
  /// RevenueCat のエンタイトルメント ID
  static const kEntitlementId = 'custom_bingo_host_mode';

  /// Google Play / App Store Connect に登録するサブスク Product ID（月額）
  static const kMonthlyProductId = 'custom_bingo_pro_monthly';

  // ─────────────────────────────────────────────────────────

  static Future<void> init() async {
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);
    // プラットフォームに応じて API キーを切り替える
    const apiKey = String.fromEnvironment('REVENUECAT_API_KEY',
        defaultValue: _androidApiKey); // CI/CD では env 注入も可
    final config = PurchasesConfiguration(apiKey);
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
