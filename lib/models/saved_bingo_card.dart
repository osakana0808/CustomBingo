import 'dart:convert';

import 'bingo_card.dart';

/// 名前付きで保存されたビンゴカードの進行状況。
///
/// マークの状態を含めてカード全体を保持するため、保存時点の盤面を
/// そのまま再開できる。[listName] は一覧表示用のスナップショット。
class SavedBingoCard {
  final String id;
  final String name;
  final String cardId;
  final String listId;
  final String listName;
  final int size;
  final bool hasFreeSpace;
  final List<List<BingoCell>> cells;
  final DateTime updatedAt;

  const SavedBingoCard({
    required this.id,
    required this.name,
    required this.cardId,
    required this.listId,
    required this.listName,
    required this.size,
    required this.hasFreeSpace,
    required this.cells,
    required this.updatedAt,
  });

  /// マーク済みのマス数（FREE は除く）
  int get markedCount => cells
      .expand((row) => row)
      .where((c) => c.isMarked && !c.isFree)
      .length;

  /// 再開用に実行時の [BingoCard] へ変換する。
  BingoCard toBingoCard() => BingoCard(
        id: cardId,
        listId: listId,
        size: size,
        hasFreeSpace: hasFreeSpace,
        cells: cells,
      );

  factory SavedBingoCard.fromCard({
    required String id,
    required String name,
    required String listName,
    required BingoCard card,
    required DateTime updatedAt,
  }) =>
      SavedBingoCard(
        id: id,
        name: name,
        cardId: card.id,
        listId: card.listId,
        listName: listName,
        size: card.size,
        hasFreeSpace: card.hasFreeSpace,
        cells: card.cells,
        updatedAt: updatedAt,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'card_id': cardId,
        'list_id': listId,
        'list_name': listName,
        'size': size,
        'has_free_space': hasFreeSpace ? 1 : 0,
        'cells': jsonEncode(
            cells.map((row) => row.map((c) => c.toMap()).toList()).toList()),
        'updated_at': updatedAt.millisecondsSinceEpoch,
      };

  factory SavedBingoCard.fromMap(Map<String, dynamic> map) => SavedBingoCard(
        id: map['id'] as String,
        name: map['name'] as String,
        cardId: map['card_id'] as String,
        listId: map['list_id'] as String,
        listName: map['list_name'] as String? ?? '',
        size: map['size'] as int,
        hasFreeSpace: (map['has_free_space'] as int) == 1,
        cells: _decodeCells(map['cells']),
        updatedAt:
            DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      );

  static List<List<BingoCell>> _decodeCells(Object? value) {
    if (value is! String || value.isEmpty) return [];
    final decoded = jsonDecode(value) as List;
    return decoded
        .map((row) => (row as List)
            .map((c) => BingoCell.fromMap(c as Map<String, dynamic>))
            .toList())
        .toList();
  }
}
