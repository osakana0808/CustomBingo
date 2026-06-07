// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navList => 'Lists';

  @override
  String get navCard => 'Card';

  @override
  String get navDraw => 'Draw';

  @override
  String get listTitle => 'Bingo Lists';

  @override
  String get listImportTooltip => 'Import';

  @override
  String listError(String message) {
    return 'Error: $message';
  }

  @override
  String get listEmpty => 'No lists available';

  @override
  String get listSectionMy => 'My Lists';

  @override
  String get listSectionPreset => 'Presets';

  @override
  String get listDeleteTitle => 'Delete';

  @override
  String listDeleteConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get listCopied => 'Copied to clipboard';

  @override
  String get listCancel => 'Cancel';

  @override
  String get listDelete => 'Delete';

  @override
  String listItemCount(int count) {
    return '$count items';
  }

  @override
  String get editTitleCreate => 'Create List';

  @override
  String get editTitleEdit => 'Edit List';

  @override
  String get editSave => 'Save';

  @override
  String get editNameLabel => 'List name';

  @override
  String get editDescLabel => 'Description (optional)';

  @override
  String get editFreeSpace => 'Free space';

  @override
  String editWords(int count) {
    return 'Words ($count)';
  }

  @override
  String get editAddWord => 'Add';

  @override
  String get editWordDialogAdd => 'Add word';

  @override
  String get editWordDialogEdit => 'Edit word';

  @override
  String get editWordHint => 'Enter word';

  @override
  String get editWordOk => 'OK';

  @override
  String get editNameRequired => 'Please enter a list name';

  @override
  String get importTitle => 'Import List';

  @override
  String get importHint => 'Paste shared text here';

  @override
  String get importPaste => 'Paste from clipboard';

  @override
  String get importImport => 'Import';

  @override
  String get importEmpty => 'Please enter text';

  @override
  String get importInvalid =>
      'Invalid format. Please paste text starting with [BingoList]';

  @override
  String importSuccess(String name) {
    return 'Imported \"$name\"';
  }

  @override
  String get cardSetupTitle => 'Create Card';

  @override
  String get cardSetupListLabel => 'Select a list';

  @override
  String get cardSetupSizeLabel => 'Grid size';

  @override
  String get cardSetupFreeSpace => 'Free space (center)';

  @override
  String get cardSetupGenerate => 'Generate Card';

  @override
  String cardSetupRequired(int needed, int have) {
    return 'Required: $needed words (current: $have)';
  }

  @override
  String get cardPlayTitle => 'Bingo Card';

  @override
  String get cardPlayReset => 'Reset';

  @override
  String get cardPlayEmpty => 'No card available';

  @override
  String get cardPlayBingo => '🎉  BINGO!  🎉';

  @override
  String get drawTitle => 'Draw';

  @override
  String get drawHistory => 'History';

  @override
  String get drawStop => 'Stop';

  @override
  String get drawListLabel => 'Select a list';

  @override
  String get drawStart => 'Start Drawing';

  @override
  String drawRemaining(int remaining, int drawn) {
    return '$remaining left / $drawn drawn';
  }

  @override
  String get drawHint => 'Press the button to start';

  @override
  String get drawResult => 'Result';

  @override
  String get drawAllDone => 'All drawn';

  @override
  String drawNext(int remaining) {
    return 'Draw next ($remaining left)';
  }

  @override
  String get drawSkip => 'Tap to skip';

  @override
  String historyTitle(int count) {
    return 'History ($count)';
  }

  @override
  String get historyEmpty => 'No draws yet';

  @override
  String get presetNumberName => 'Number Bingo';

  @override
  String get presetNumberDesc => 'Numbers 1–75';

  @override
  String get presetHiraganaName => 'Hiragana';

  @override
  String get presetHiraganaDesc => 'Japanese hiragana (46 chars)';

  @override
  String get presetAlphabetName => 'Alphabet';

  @override
  String get presetAlphabetDesc => 'A–Z';

  @override
  String get presetMahjongName => 'Mahjong Hands';

  @override
  String get presetMahjongDesc => 'List of mahjong winning hands';
}
