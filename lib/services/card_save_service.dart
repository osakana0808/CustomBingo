import 'package:sqflite/sqflite.dart';
import '../models/saved_bingo_card.dart';
import 'database_service.dart';

/// 名前付きで保存されたビンゴカードの永続化を担う。
/// CRUD は [DrawSessionService] と同じ upsert パターンに揃えている。
class CardSaveService {
  Future<List<SavedBingoCard>> fetchAll() async {
    final db = await DatabaseService.database;
    final maps = await db.query('saved_cards', orderBy: 'updated_at DESC');
    return maps.map((m) => SavedBingoCard.fromMap(m)).toList();
  }

  Future<void> save(SavedBingoCard card) async {
    final db = await DatabaseService.database;
    await db.insert('saved_cards', card.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(String id) async {
    final db = await DatabaseService.database;
    await db.delete('saved_cards', where: 'id = ?', whereArgs: [id]);
  }
}
