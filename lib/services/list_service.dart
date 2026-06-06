import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/bingo_item.dart';
import '../models/bingo_list.dart';
import 'database_service.dart';
import 'presets.dart';

class ListService {
  static const _uuid = Uuid();

  Future<void> init() async {
    final db = await DatabaseService.database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM bingo_lists WHERE is_preset = 1'));
    if (count == 0) {
      for (final preset in Presets.all) {
        await save(preset);
      }
    }
  }

  Future<List<BingoList>> fetchAll() async {
    final db = await DatabaseService.database;
    final listMaps = await db.query('bingo_lists', orderBy: 'is_preset DESC, name ASC');
    final result = <BingoList>[];
    for (final map in listMaps) {
      final itemMaps = await db.query(
        'bingo_items',
        where: 'list_id = ?',
        whereArgs: [map['id']],
        orderBy: 'sort_order ASC',
      );
      result.add(BingoList.fromMap(
          map, itemMaps.map((m) => BingoItem.fromMap(m)).toList()));
    }
    return result;
  }

  Future<BingoList?> fetchById(String id) async {
    final db = await DatabaseService.database;
    final maps = await db.query('bingo_lists', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    final itemMaps = await db.query('bingo_items',
        where: 'list_id = ?', whereArgs: [id], orderBy: 'sort_order ASC');
    return BingoList.fromMap(
        maps.first, itemMaps.map((m) => BingoItem.fromMap(m)).toList());
  }

  Future<BingoList> save(BingoList list) async {
    final db = await DatabaseService.database;
    await db.insert('bingo_lists', list.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await db.delete('bingo_items', where: 'list_id = ?', whereArgs: [list.id]);
    for (int i = 0; i < list.items.length; i++) {
      final item = list.items[i];
      await db.insert('bingo_items', {
        ...item.toMap(),
        'list_id': list.id,
        'sort_order': i,
      });
    }
    return list;
  }

  Future<BingoList> create({
    required String name,
    String description = '',
    List<BingoItem> items = const [],
    bool hasFreeSpace = true,
  }) async {
    final list = BingoList(
      id: _uuid.v4(),
      name: name,
      description: description,
      items: items,
      hasFreeSpace: hasFreeSpace,
    );
    return save(list);
  }

  Future<void> delete(String id) async {
    final db = await DatabaseService.database;
    await db.delete('bingo_lists', where: 'id = ? AND is_preset = 0', whereArgs: [id]);
  }

  BingoItem newItem(String word, {String? column}) =>
      BingoItem(id: _uuid.v4(), word: word, column: column);
}
