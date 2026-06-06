class BingoCell {
  final String word;
  final bool isFree;
  final bool isMarked;

  const BingoCell({
    required this.word,
    this.isFree = false,
    this.isMarked = false,
  });

  BingoCell copyWith({String? word, bool? isFree, bool? isMarked}) {
    return BingoCell(
      word: word ?? this.word,
      isFree: isFree ?? this.isFree,
      isMarked: isMarked ?? this.isMarked,
    );
  }
}

class BingoCard {
  final String id;
  final String listId;
  final int size;
  final bool hasFreeSpace;
  final List<List<BingoCell>> cells;

  const BingoCard({
    required this.id,
    required this.listId,
    required this.size,
    required this.hasFreeSpace,
    required this.cells,
  });

  BingoCard copyWith({List<List<BingoCell>>? cells}) {
    return BingoCard(
      id: id,
      listId: listId,
      size: size,
      hasFreeSpace: hasFreeSpace,
      cells: cells ?? this.cells,
    );
  }

  BingoCard markCell(int row, int col) {
    final newCells = cells
        .asMap()
        .entries
        .map((rowEntry) => rowEntry.value
            .asMap()
            .entries
            .map((colEntry) => (rowEntry.key == row && colEntry.key == col)
                ? colEntry.value.copyWith(isMarked: !colEntry.value.isMarked)
                : colEntry.value)
            .toList())
        .toList();
    return copyWith(cells: newCells);
  }

  List<List<bool>> get markedGrid =>
      cells.map((row) => row.map((c) => c.isMarked).toList()).toList();

  bool get hasBingo {
    final marked = markedGrid;
    // 横
    for (final row in marked) {
      if (row.every((m) => m)) return true;
    }
    // 縦
    for (int c = 0; c < size; c++) {
      if (marked.every((row) => row[c])) return true;
    }
    // 斜め（左上→右下）
    if (List.generate(size, (i) => marked[i][i]).every((m) => m)) return true;
    // 斜め（右上→左下）
    if (List.generate(size, (i) => marked[i][size - 1 - i]).every((m) => m)) {
      return true;
    }
    return false;
  }
}
