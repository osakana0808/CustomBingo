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
}
