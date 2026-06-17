import 'package:flutter_test/flutter_test.dart';
import 'package:custom_bingo/models/bingo_card.dart';
import 'package:custom_bingo/models/saved_bingo_card.dart';

BingoCard _card() => BingoCard(
      id: 'card1',
      listId: 'list1',
      size: 3,
      hasFreeSpace: true,
      cells: [
        [
          const BingoCell(word: 'A', isMarked: true),
          const BingoCell(word: 'B\n改行'),
          const BingoCell(word: 'C', isMarked: true),
        ],
        [
          const BingoCell(word: 'D'),
          const BingoCell(word: 'FREE', isFree: true, isMarked: true),
          const BingoCell(word: 'E'),
        ],
        [
          const BingoCell(word: 'F'),
          const BingoCell(word: 'G'),
          const BingoCell(word: 'H'),
        ],
      ],
    );

void main() {
  group('SavedBingoCard', () {
    test('toMap → fromMap で盤面とマーク状態が往復する', () {
      final saved = SavedBingoCard.fromCard(
        id: 'sid',
        name: '途中のカード',
        listName: 'テスト',
        card: _card(),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(1700000000000),
      );
      final restored = SavedBingoCard.fromMap(saved.toMap());

      expect(restored.id, 'sid');
      expect(restored.name, '途中のカード');
      expect(restored.cardId, 'card1');
      expect(restored.listId, 'list1');
      expect(restored.listName, 'テスト');
      expect(restored.size, 3);
      expect(restored.hasFreeSpace, isTrue);
      expect(restored.updatedAt, saved.updatedAt);
      // 盤面の中身（改行・FREE・マーク）が保持される
      expect(restored.cells[0][1].word, 'B\n改行');
      expect(restored.cells[0][0].isMarked, isTrue);
      expect(restored.cells[1][1].isFree, isTrue);
      expect(restored.cells[1][1].isMarked, isTrue);
      expect(restored.cells[2][0].isMarked, isFalse);
    });

    test('markedCount は FREE を除いたマーク数を返す', () {
      final saved = SavedBingoCard.fromCard(
        id: 'sid',
        name: 'n',
        listName: '',
        card: _card(),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      );
      // A と C の2マス（FREE は除外）
      expect(saved.markedCount, 2);
    });

    test('toBingoCard で再開用の BingoCard に戻せる', () {
      final saved = SavedBingoCard.fromCard(
        id: 'sid',
        name: 'n',
        listName: '',
        card: _card(),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      );
      final card = saved.toBingoCard();
      expect(card.id, 'card1');
      expect(card.size, 3);
      expect(card.cells[0][0].isMarked, isTrue);
    });
  });
}
