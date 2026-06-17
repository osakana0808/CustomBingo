import 'package:sqflite/sqflite.dart';
import '../models/saved_draw_session.dart';
import 'database_service.dart';

/// 名前付きで保存された抽選セッションの永続化を担う。
/// CRUD は [ListService] と同じ upsert パターンに揃えている。
class DrawSessionService {
  Future<List<SavedDrawSession>> fetchAll() async {
    final db = await DatabaseService.database;
    final maps = await db.query('draw_sessions', orderBy: 'updated_at DESC');
    return maps.map((m) => SavedDrawSession.fromMap(m)).toList();
  }

  Future<void> save(SavedDrawSession session) async {
    final db = await DatabaseService.database;
    await db.insert('draw_sessions', session.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(String id) async {
    final db = await DatabaseService.database;
    await db.delete('draw_sessions', where: 'id = ?', whereArgs: [id]);
  }
}
