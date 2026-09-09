import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';

/// GitHub Pages に置いた法的文書（プライバシーポリシー・利用規約）へのリンク。
///
/// App Store のガイドライン 3.1.2 により、サブスクリプションを販売する画面からも
/// 利用規約（EULA）とプライバシーポリシーに到達できる必要があるため、
/// リスト画面のメニューとペイウォールの両方から使う。
class LegalLinks {
  LegalLinks._();

  static const siteBase = 'https://osakana0808.github.io/CustomBingo';

  static const privacyPage = 'privacy.html';
  static const termsPage = 'terms.html';

  /// 端末の言語に合わせて日本語版／英語版を開く。
  static Future<void> open(
    BuildContext context,
    String page,
    AppLocalizations l10n,
  ) async {
    final isJa = Localizations.localeOf(context).languageCode == 'ja';
    final url = Uri.parse(isJa ? '$siteBase/$page' : '$siteBase/en/$page');
    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.menuLinkError)),
      );
    }
  }
}
