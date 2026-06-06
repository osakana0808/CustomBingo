import 'package:uuid/uuid.dart';
import '../models/bingo_card.dart';
import '../models/bingo_list.dart';

class CardService {
  static const _uuid = Uuid();

  static BingoCard generate({
    required BingoList list,
    required int size,
    required bool hasFreeSpace,
  }) {
    final totalCells = size * size;
    final neededCells = hasFreeSpace ? totalCells - 1 : totalCells;

    if (list.items.length < neededCells) {
      throw ArgumentError(
          'リストの要素数（${list.items.length}）がマスの数（$neededCells）より少ないです');
    }

    final shuffled = List.of(list.items)..shuffle();
    final selected = shuffled.take(neededCells).toList();

    int idx = 0;
    final centerRow = size ~/ 2;
    final centerCol = size ~/ 2;

    final cells = List.generate(size, (r) {
      return List.generate(size, (c) {
        if (hasFreeSpace && r == centerRow && c == centerCol) {
          return const BingoCell(word: 'FREE', isFree: true, isMarked: true);
        }
        return BingoCell(word: selected[idx++].word);
      });
    });

    return BingoCard(
      id: _uuid.v4(),
      listId: list.id,
      size: size,
      hasFreeSpace: hasFreeSpace,
      cells: cells,
    );
  }
}
