import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    // iOS 18 以降はデフォルトの getDatabasesPath() が保護対象になる場合があるため
    // ApplicationSupportDirectory を使用する
    final dir = await getApplicationSupportDirectory();
    final path = join(dir.path, 'custom_bingo.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bingo_lists (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        has_free_space INTEGER NOT NULL DEFAULT 1,
        is_preset INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE bingo_items (
        id TEXT PRIMARY KEY,
        list_id TEXT NOT NULL,
        word TEXT NOT NULL,
        col TEXT,
        sort_order INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (list_id) REFERENCES bingo_lists(id) ON DELETE CASCADE
      )
    ''');

    await _createDrawSessions(db);
  }

  // 既存ユーザー（version 1）のデータを保持したまま draw_sessions を追加する
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createDrawSessions(db);
    }
  }

  static Future<void> _createDrawSessions(Database db) async {
    // 再開に必要な情報を自己完結で持つため、リスト削除時の連動は行わず
    // list_name をスナップショットとして保持する
    await db.execute('''
      CREATE TABLE draw_sessions (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        list_id TEXT NOT NULL,
        list_name TEXT NOT NULL DEFAULT '',
        drawn_items TEXT NOT NULL,
        remaining_items TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }
}
