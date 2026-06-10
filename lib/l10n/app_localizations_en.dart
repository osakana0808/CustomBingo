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
  String get drawSkinLabel => 'Drum Skin';

  @override
  String get drawSkinWooden => 'Wooden';

  @override
  String get drawSkinCasino => 'Casino';

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

  @override
  String get paywallTitle => 'Host Mode';

  @override
  String get paywallHeadline => 'Unlock\nHost Mode';

  @override
  String get paywallSubheadline =>
      'Tombola draw, history & all lists.\nMake your bingo event unforgettable.';

  @override
  String get paywallFeature1 => 'Tombola drum animation for every draw';

  @override
  String get paywallFeature2 => 'View full draw history anytime';

  @override
  String get paywallFeature3 => 'Works with all lists & presets';

  @override
  String get paywallFeature4 => 'Skip animation with a tap';

  @override
  String paywallBuyButton(String price) {
    return 'Buy for $price';
  }

  @override
  String get paywallBuyButtonNoPrice => 'Buy Now';

  @override
  String get paywallRestore => 'Restore Purchases';

  @override
  String get paywallLegal =>
      'Payment will be charged to your Apple ID.\nSubscriptions auto-renew unless cancelled at least 24 hours before the end of the current period.';

  @override
  String get paywallPurchaseSuccess => 'Purchase complete!';

  @override
  String get paywallRestoreSuccess => 'Purchase restored!';

  @override
  String get paywallRestoreNotFound => 'No purchases found to restore';

  @override
  String paywallPurchaseError(String error) {
    return 'Purchase error: $error';
  }

  @override
  String get drawLocked => 'Host Mode is a premium feature';

  @override
  String get drawLockedSub => 'Unlock the tombola draw with animation';

  @override
  String get drawUnlock => 'Unlock';

  @override
  String get drawStopConfirmTitle => 'End this draw session?';

  @override
  String get drawStopConfirmMessage =>
      'Ending the session will erase the entire draw history.';

  @override
  String get drawStopConfirm => 'End';

  @override
  String get drawStopCancel => 'Cancel';

  @override
  String get cardPlayExitTitle => 'Close this card?';

  @override
  String get cardPlayExitMessage =>
      'The game is still in progress. Once you close it, you can\'t get this card back.';

  @override
  String get cardPlayExitConfirm => 'Close';

  @override
  String get cardPlayExitCancel => 'Cancel';

  @override
  String get menuPrivacyPolicy => 'Privacy Policy';

  @override
  String get menuTerms => 'Terms of Service';

  @override
  String get menuAbout => 'About This App';

  @override
  String get menuLinkError => 'Could not open the page';

  @override
  String get appName => 'Custom Bingo';
}
