import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @navList.
  ///
  /// In ja, this message translates to:
  /// **'リスト'**
  String get navList;

  /// No description provided for @navCard.
  ///
  /// In ja, this message translates to:
  /// **'カード'**
  String get navCard;

  /// No description provided for @navDraw.
  ///
  /// In ja, this message translates to:
  /// **'抽選'**
  String get navDraw;

  /// No description provided for @listTitle.
  ///
  /// In ja, this message translates to:
  /// **'ビンゴリスト'**
  String get listTitle;

  /// No description provided for @listImportTooltip.
  ///
  /// In ja, this message translates to:
  /// **'インポート'**
  String get listImportTooltip;

  /// No description provided for @listError.
  ///
  /// In ja, this message translates to:
  /// **'エラー: {message}'**
  String listError(String message);

  /// No description provided for @listEmpty.
  ///
  /// In ja, this message translates to:
  /// **'リストがありません'**
  String get listEmpty;

  /// No description provided for @listSectionMy.
  ///
  /// In ja, this message translates to:
  /// **'マイリスト'**
  String get listSectionMy;

  /// No description provided for @listSectionPreset.
  ///
  /// In ja, this message translates to:
  /// **'プリセット'**
  String get listSectionPreset;

  /// No description provided for @listDeleteTitle.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get listDeleteTitle;

  /// No description provided for @listDeleteConfirm.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」を削除しますか？'**
  String listDeleteConfirm(String name);

  /// No description provided for @listCopied.
  ///
  /// In ja, this message translates to:
  /// **'クリップボードにコピーしました'**
  String get listCopied;

  /// No description provided for @listCancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get listCancel;

  /// No description provided for @listDelete.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get listDelete;

  /// No description provided for @listItemCount.
  ///
  /// In ja, this message translates to:
  /// **'{count}件'**
  String listItemCount(int count);

  /// No description provided for @editTitleCreate.
  ///
  /// In ja, this message translates to:
  /// **'リストを作成'**
  String get editTitleCreate;

  /// No description provided for @editTitleEdit.
  ///
  /// In ja, this message translates to:
  /// **'リストを編集'**
  String get editTitleEdit;

  /// No description provided for @editSave.
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get editSave;

  /// No description provided for @editNameLabel.
  ///
  /// In ja, this message translates to:
  /// **'リスト名'**
  String get editNameLabel;

  /// No description provided for @editDescLabel.
  ///
  /// In ja, this message translates to:
  /// **'概要（任意）'**
  String get editDescLabel;

  /// No description provided for @editFreeSpace.
  ///
  /// In ja, this message translates to:
  /// **'フリーマス'**
  String get editFreeSpace;

  /// No description provided for @editWords.
  ///
  /// In ja, this message translates to:
  /// **'単語リスト（{count}件）'**
  String editWords(int count);

  /// No description provided for @editAddWord.
  ///
  /// In ja, this message translates to:
  /// **'追加'**
  String get editAddWord;

  /// No description provided for @editWordDialogAdd.
  ///
  /// In ja, this message translates to:
  /// **'単語を追加'**
  String get editWordDialogAdd;

  /// No description provided for @editWordDialogEdit.
  ///
  /// In ja, this message translates to:
  /// **'単語を編集'**
  String get editWordDialogEdit;

  /// No description provided for @editWordHint.
  ///
  /// In ja, this message translates to:
  /// **'単語を入力'**
  String get editWordHint;

  /// No description provided for @editWordOk.
  ///
  /// In ja, this message translates to:
  /// **'OK'**
  String get editWordOk;

  /// No description provided for @editNameRequired.
  ///
  /// In ja, this message translates to:
  /// **'リスト名を入力してください'**
  String get editNameRequired;

  /// No description provided for @importTitle.
  ///
  /// In ja, this message translates to:
  /// **'リストをインポート'**
  String get importTitle;

  /// No description provided for @importHint.
  ///
  /// In ja, this message translates to:
  /// **'共有されたテキストを貼り付けてください'**
  String get importHint;

  /// No description provided for @importPaste.
  ///
  /// In ja, this message translates to:
  /// **'クリップボードから貼り付け'**
  String get importPaste;

  /// No description provided for @importImport.
  ///
  /// In ja, this message translates to:
  /// **'インポート'**
  String get importImport;

  /// No description provided for @importEmpty.
  ///
  /// In ja, this message translates to:
  /// **'テキストを入力してください'**
  String get importEmpty;

  /// No description provided for @importInvalid.
  ///
  /// In ja, this message translates to:
  /// **'形式が正しくありません。[BingoList]から始まるテキストを貼り付けてください'**
  String get importInvalid;

  /// No description provided for @importSuccess.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」をインポートしました'**
  String importSuccess(String name);

  /// No description provided for @cardSetupTitle.
  ///
  /// In ja, this message translates to:
  /// **'カードを作成'**
  String get cardSetupTitle;

  /// No description provided for @cardSetupListLabel.
  ///
  /// In ja, this message translates to:
  /// **'リストを選択'**
  String get cardSetupListLabel;

  /// No description provided for @cardSetupSizeLabel.
  ///
  /// In ja, this message translates to:
  /// **'マスのサイズ'**
  String get cardSetupSizeLabel;

  /// No description provided for @cardSetupFreeSpace.
  ///
  /// In ja, this message translates to:
  /// **'フリーマス（中央）'**
  String get cardSetupFreeSpace;

  /// No description provided for @cardSetupGenerate.
  ///
  /// In ja, this message translates to:
  /// **'カードを生成'**
  String get cardSetupGenerate;

  /// No description provided for @cardSetupRequired.
  ///
  /// In ja, this message translates to:
  /// **'必要な単語数: {needed}件（現在 {have}件）'**
  String cardSetupRequired(int needed, int have);

  /// No description provided for @cardPlayTitle.
  ///
  /// In ja, this message translates to:
  /// **'ビンゴカード'**
  String get cardPlayTitle;

  /// No description provided for @cardPlayReset.
  ///
  /// In ja, this message translates to:
  /// **'リセット'**
  String get cardPlayReset;

  /// No description provided for @cardPlayEmpty.
  ///
  /// In ja, this message translates to:
  /// **'カードがありません'**
  String get cardPlayEmpty;

  /// No description provided for @cardPlayBingo.
  ///
  /// In ja, this message translates to:
  /// **'🎉　BINGO!　🎉'**
  String get cardPlayBingo;

  /// No description provided for @drawTitle.
  ///
  /// In ja, this message translates to:
  /// **'抽選'**
  String get drawTitle;

  /// No description provided for @drawHistory.
  ///
  /// In ja, this message translates to:
  /// **'履歴'**
  String get drawHistory;

  /// No description provided for @drawStop.
  ///
  /// In ja, this message translates to:
  /// **'終了'**
  String get drawStop;

  /// No description provided for @drawListLabel.
  ///
  /// In ja, this message translates to:
  /// **'リストを選択'**
  String get drawListLabel;

  /// No description provided for @drawStart.
  ///
  /// In ja, this message translates to:
  /// **'抽選スタート'**
  String get drawStart;

  /// No description provided for @drawRemaining.
  ///
  /// In ja, this message translates to:
  /// **'残り {remaining} 件 / 抽選済み {drawn} 件'**
  String drawRemaining(int remaining, int drawn);

  /// No description provided for @drawHint.
  ///
  /// In ja, this message translates to:
  /// **'ボタンを押して抽選開始'**
  String get drawHint;

  /// No description provided for @drawResult.
  ///
  /// In ja, this message translates to:
  /// **'抽選結果'**
  String get drawResult;

  /// No description provided for @drawAllDone.
  ///
  /// In ja, this message translates to:
  /// **'全て抽選済み'**
  String get drawAllDone;

  /// No description provided for @drawNext.
  ///
  /// In ja, this message translates to:
  /// **'次を引く（残り{remaining}件）'**
  String drawNext(int remaining);

  /// No description provided for @drawSkip.
  ///
  /// In ja, this message translates to:
  /// **'タップでスキップ'**
  String get drawSkip;

  /// No description provided for @drawSkinLabel.
  ///
  /// In ja, this message translates to:
  /// **'ガラガラのスキン'**
  String get drawSkinLabel;

  /// No description provided for @drawSkinWooden.
  ///
  /// In ja, this message translates to:
  /// **'木製'**
  String get drawSkinWooden;

  /// No description provided for @drawSkinCasino.
  ///
  /// In ja, this message translates to:
  /// **'カジノ'**
  String get drawSkinCasino;

  /// No description provided for @historyTitle.
  ///
  /// In ja, this message translates to:
  /// **'抽選履歴（{count}件）'**
  String historyTitle(int count);

  /// No description provided for @historyEmpty.
  ///
  /// In ja, this message translates to:
  /// **'まだ抽選していません'**
  String get historyEmpty;

  /// No description provided for @presetNumberName.
  ///
  /// In ja, this message translates to:
  /// **'数字ビンゴ'**
  String get presetNumberName;

  /// No description provided for @presetNumberDesc.
  ///
  /// In ja, this message translates to:
  /// **'1〜75の数字'**
  String get presetNumberDesc;

  /// No description provided for @presetHiraganaName.
  ///
  /// In ja, this message translates to:
  /// **'ひらがな'**
  String get presetHiraganaName;

  /// No description provided for @presetHiraganaDesc.
  ///
  /// In ja, this message translates to:
  /// **'あ〜ん（46文字）'**
  String get presetHiraganaDesc;

  /// No description provided for @presetAlphabetName.
  ///
  /// In ja, this message translates to:
  /// **'アルファベット'**
  String get presetAlphabetName;

  /// No description provided for @presetAlphabetDesc.
  ///
  /// In ja, this message translates to:
  /// **'A〜Z'**
  String get presetAlphabetDesc;

  /// No description provided for @presetMahjongName.
  ///
  /// In ja, this message translates to:
  /// **'麻雀の役'**
  String get presetMahjongName;

  /// No description provided for @presetMahjongDesc.
  ///
  /// In ja, this message translates to:
  /// **'麻雀の役一覧'**
  String get presetMahjongDesc;

  /// No description provided for @paywallTitle.
  ///
  /// In ja, this message translates to:
  /// **'司会者モード'**
  String get paywallTitle;

  /// No description provided for @paywallHeadline.
  ///
  /// In ja, this message translates to:
  /// **'司会者モードを\nアンロック'**
  String get paywallHeadline;

  /// No description provided for @paywallSubheadline.
  ///
  /// In ja, this message translates to:
  /// **'ガラガラ抽選・履歴管理・全リスト対応。\nビンゴ司会をもっと楽しく、盛り上げよう。'**
  String get paywallSubheadline;

  /// No description provided for @paywallFeature1.
  ///
  /// In ja, this message translates to:
  /// **'ガラガラ演出で抽選を盛り上げる'**
  String get paywallFeature1;

  /// No description provided for @paywallFeature2.
  ///
  /// In ja, this message translates to:
  /// **'抽選履歴をいつでも確認'**
  String get paywallFeature2;

  /// No description provided for @paywallFeature3.
  ///
  /// In ja, this message translates to:
  /// **'全リスト・プリセットに対応'**
  String get paywallFeature3;

  /// No description provided for @paywallFeature4.
  ///
  /// In ja, this message translates to:
  /// **'アニメーションのスキップ機能'**
  String get paywallFeature4;

  /// No description provided for @paywallBuyButton.
  ///
  /// In ja, this message translates to:
  /// **'{price} で購入'**
  String paywallBuyButton(String price);

  /// No description provided for @paywallBuyButtonNoPrice.
  ///
  /// In ja, this message translates to:
  /// **'購入する'**
  String get paywallBuyButtonNoPrice;

  /// No description provided for @paywallRestore.
  ///
  /// In ja, this message translates to:
  /// **'購入を復元'**
  String get paywallRestore;

  /// No description provided for @paywallLegal.
  ///
  /// In ja, this message translates to:
  /// **'購入は Apple ID に請求されます。\nサブスクリプションは次の更新日の 24 時間前にキャンセルしない限り自動更新されます。'**
  String get paywallLegal;

  /// No description provided for @paywallPurchaseSuccess.
  ///
  /// In ja, this message translates to:
  /// **'購入が完了しました！'**
  String get paywallPurchaseSuccess;

  /// No description provided for @paywallRestoreSuccess.
  ///
  /// In ja, this message translates to:
  /// **'購入を復元しました！'**
  String get paywallRestoreSuccess;

  /// No description provided for @paywallRestoreNotFound.
  ///
  /// In ja, this message translates to:
  /// **'復元できる購入がありませんでした'**
  String get paywallRestoreNotFound;

  /// No description provided for @paywallPurchaseError.
  ///
  /// In ja, this message translates to:
  /// **'購入エラー: {error}'**
  String paywallPurchaseError(String error);

  /// No description provided for @drawLocked.
  ///
  /// In ja, this message translates to:
  /// **'司会者モードは有料機能です'**
  String get drawLocked;

  /// No description provided for @drawLockedSub.
  ///
  /// In ja, this message translates to:
  /// **'ガラガラ演出付きの抽選機能をアンロックしましょう'**
  String get drawLockedSub;

  /// No description provided for @drawUnlock.
  ///
  /// In ja, this message translates to:
  /// **'アンロックする'**
  String get drawUnlock;

  /// No description provided for @menuPrivacyPolicy.
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get menuPrivacyPolicy;

  /// No description provided for @menuTerms.
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get menuTerms;

  /// No description provided for @menuAbout.
  ///
  /// In ja, this message translates to:
  /// **'アプリについて'**
  String get menuAbout;

  /// No description provided for @menuLinkError.
  ///
  /// In ja, this message translates to:
  /// **'ページを開けませんでした'**
  String get menuLinkError;

  /// No description provided for @appName.
  ///
  /// In ja, this message translates to:
  /// **'カスタムビンゴ'**
  String get appName;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
