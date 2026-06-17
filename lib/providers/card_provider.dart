import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bingo_card.dart';

class CardNotifier extends Notifier<BingoCard?> {
  @override
  BingoCard? build() => null;

  void setCard(BingoCard card) => state = card;

  void toggleCell(int row, int col) {
    final card = state;
    if (card == null) return;
    state = card.markCell(row, col);
  }

  void reset() => state = null;
}

final cardProvider =
    NotifierProvider<CardNotifier, BingoCard?>(CardNotifier.new);

/// 直近に保存した時点のカード状態の署名。現在のカードの署名と一致すれば
/// 「保存後に変更がない」とみなし、閉じる確認を省略できる。
/// 新規カード生成時は null（未保存）にリセットする。
final lastSavedCardSignatureProvider = StateProvider<String?>((ref) => null);

/// マーク状態を含むカードの署名。マークが変わると変化する。
String cardSignature(BingoCard card) => '${card.id}:${card.markedGrid}';
