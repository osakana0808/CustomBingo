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
