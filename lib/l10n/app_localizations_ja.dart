// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get navList => 'リスト';

  @override
  String get navCard => 'カード';

  @override
  String get navDraw => '抽選';

  @override
  String get listTitle => 'ビンゴリスト';

  @override
  String get listImportTooltip => 'インポート';

  @override
  String listError(String message) {
    return 'エラー: $message';
  }

  @override
  String get listEmpty => 'リストがありません';

  @override
  String get listSectionMy => 'マイリスト';

  @override
  String get listSectionPreset => 'プリセット';

  @override
  String get listDeleteTitle => '削除';

  @override
  String listDeleteConfirm(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String get listCopied => 'クリップボードにコピーしました';

  @override
  String get listCancel => 'キャンセル';

  @override
  String get listDelete => '削除';

  @override
  String listItemCount(int count) {
    return '$count件';
  }

  @override
  String get editTitleCreate => 'リストを作成';

  @override
  String get editTitleEdit => 'リストを編集';

  @override
  String get editSave => '保存';

  @override
  String get editNameLabel => 'リスト名';

  @override
  String get editDescLabel => '概要（任意）';

  @override
  String get editFreeSpace => 'フリーマス';

  @override
  String editWords(int count) {
    return '単語リスト（$count件）';
  }

  @override
  String get editAddWord => '追加';

  @override
  String get editWordDialogAdd => '単語を追加';

  @override
  String get editWordDialogEdit => '単語を編集';

  @override
  String get editWordHint => '単語を入力';

  @override
  String get editWordOk => 'OK';

  @override
  String get editNameRequired => 'リスト名を入力してください';

  @override
  String get importTitle => 'リストをインポート';

  @override
  String get importHint => '共有されたテキストを貼り付けてください';

  @override
  String get importPaste => 'クリップボードから貼り付け';

  @override
  String get importImport => 'インポート';

  @override
  String get importEmpty => 'テキストを入力してください';

  @override
  String get importInvalid => '形式が正しくありません。[BingoList]から始まるテキストを貼り付けてください';

  @override
  String importSuccess(String name) {
    return '「$name」をインポートしました';
  }

  @override
  String get cardSetupTitle => 'カードを作成';

  @override
  String get cardSetupListLabel => 'リストを選択';

  @override
  String get cardSetupSizeLabel => 'マスのサイズ';

  @override
  String get cardSetupFreeSpace => 'フリーマス（中央）';

  @override
  String get cardSetupGenerate => 'カードを生成';

  @override
  String cardSetupRequired(int needed, int have) {
    return '必要な単語数: $needed件（現在 $have件）';
  }

  @override
  String get cardPlayTitle => 'ビンゴカード';

  @override
  String get cardPlayReset => 'リセット';

  @override
  String get cardPlayEmpty => 'カードがありません';

  @override
  String get cardPlayBingo => '🎉　BINGO!　🎉';

  @override
  String get drawTitle => '抽選';

  @override
  String get drawHistory => '履歴';

  @override
  String get drawStop => '終了';

  @override
  String get drawListLabel => 'リストを選択';

  @override
  String get drawStart => '抽選スタート';

  @override
  String drawRemaining(int remaining, int drawn) {
    return '残り $remaining 件 / 抽選済み $drawn 件';
  }

  @override
  String get drawHint => 'ボタンを押して抽選開始';

  @override
  String get drawResult => '抽選結果';

  @override
  String get drawAllDone => '全て抽選済み';

  @override
  String drawNext(int remaining) {
    return '次を引く（残り$remaining件）';
  }

  @override
  String get drawSkip => 'タップでスキップ';

  @override
  String get drawSkinLabel => 'ガラガラのスキン';

  @override
  String get drawSkinWooden => '木製';

  @override
  String get drawSkinCasino => 'カジノ';

  @override
  String historyTitle(int count) {
    return '抽選履歴（$count件）';
  }

  @override
  String get historyEmpty => 'まだ抽選していません';

  @override
  String get presetNumberName => '数字ビンゴ';

  @override
  String get presetNumberDesc => '1〜75の数字';

  @override
  String get presetHiraganaName => 'ひらがな';

  @override
  String get presetHiraganaDesc => 'あ〜ん（46文字）';

  @override
  String get presetAlphabetName => 'アルファベット';

  @override
  String get presetAlphabetDesc => 'A〜Z';

  @override
  String get presetMahjongName => '麻雀の役';

  @override
  String get presetMahjongDesc => '麻雀の役一覧';

  @override
  String get paywallTitle => '司会者モード';

  @override
  String get paywallHeadline => '司会者モードを\nアンロック';

  @override
  String get paywallSubheadline => 'ガラガラ抽選・履歴管理・全リスト対応。\nビンゴ司会をもっと楽しく、盛り上げよう。';

  @override
  String get paywallFeature1 => 'ガラガラ演出で抽選を盛り上げる';

  @override
  String get paywallFeature2 => '抽選履歴をいつでも確認';

  @override
  String get paywallFeature3 => '全リスト・プリセットに対応';

  @override
  String get paywallFeature4 => 'アニメーションのスキップ機能';

  @override
  String paywallBuyButton(String price) {
    return '$price で購入';
  }

  @override
  String get paywallBuyButtonNoPrice => '購入する';

  @override
  String get paywallRestore => '購入を復元';

  @override
  String get paywallLegal =>
      '購入は Apple ID に請求されます。\nサブスクリプションは次の更新日の 24 時間前にキャンセルしない限り自動更新されます。';

  @override
  String get paywallPurchaseSuccess => '購入が完了しました！';

  @override
  String get paywallRestoreSuccess => '購入を復元しました！';

  @override
  String get paywallRestoreNotFound => '復元できる購入がありませんでした';

  @override
  String paywallPurchaseError(String error) {
    return '購入エラー: $error';
  }

  @override
  String get drawLocked => '司会者モードは有料機能です';

  @override
  String get drawLockedSub => 'ガラガラ演出付きの抽選機能をアンロックしましょう';

  @override
  String get drawUnlock => 'アンロックする';

  @override
  String get drawStopConfirmTitle => '抽選を終了しますか？';

  @override
  String get drawStopConfirmMessage => '終了すると、抽選の履歴はすべて失われます。';

  @override
  String get drawStopConfirm => '終了';

  @override
  String get drawStopCancel => 'キャンセル';

  @override
  String get cardPlayExitTitle => 'カードを閉じますか？';

  @override
  String get cardPlayExitMessage => 'ゲームの途中です。閉じると、このカードには戻れません。';

  @override
  String get cardPlayExitConfirm => '閉じる';

  @override
  String get cardPlayExitCancel => 'キャンセル';

  @override
  String get cardPlayResetConfirmTitle => 'リセットしますか？';

  @override
  String get cardPlayResetConfirmMessage => 'マークがすべて消えます。この操作は取り消せません。';

  @override
  String get cardPlayResetConfirm => 'リセット';

  @override
  String get cardPlayResetCancel => 'キャンセル';

  @override
  String get menuPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get menuTerms => '利用規約';

  @override
  String get menuAbout => 'アプリについて';

  @override
  String get menuLinkError => 'ページを開けませんでした';

  @override
  String get appName => 'カスタムビンゴ';
}
