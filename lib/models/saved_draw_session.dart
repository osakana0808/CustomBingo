import 'dart:convert';

import 'draw_session.dart';

/// 名前付きで保存された抽選の進行状況。
///
/// 再開に必要なデータ（[listId]・[drawnItems]・[remaining]）を自己完結で保持
/// するため、元のリストが削除されても再開できる。[listName] は一覧表示用の
/// スナップショット。
class SavedDrawSession {
  final String id;
  final String name;
  final String listId;
  final String listName;
  final List<String> drawnItems;
  final List<String> remaining;
  final DateTime updatedAt;

  const SavedDrawSession({
    required this.id,
    required this.name,
    required this.listId,
    required this.listName,
    required this.drawnItems,
    required this.remaining,
    required this.updatedAt,
  });

  /// 再開用に実行時の [DrawSession] へ変換する。
  DrawSession toDrawSession() => DrawSession(
        listId: listId,
        drawnItems: drawnItems,
        remaining: remaining,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'list_id': listId,
        'list_name': listName,
        'drawn_items': jsonEncode(drawnItems),
        'remaining_items': jsonEncode(remaining),
        'updated_at': updatedAt.millisecondsSinceEpoch,
      };

  factory SavedDrawSession.fromMap(Map<String, dynamic> map) => SavedDrawSession(
        id: map['id'] as String,
        name: map['name'] as String,
        listId: map['list_id'] as String,
        listName: map['list_name'] as String? ?? '',
        drawnItems: _decodeList(map['drawn_items']),
        remaining: _decodeList(map['remaining_items']),
        updatedAt:
            DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      );

  static List<String> _decodeList(Object? value) {
    if (value is! String || value.isEmpty) return [];
    final decoded = jsonDecode(value);
    return (decoded as List).map((e) => e as String).toList();
  }
}
