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
      version: 3,
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
    await _createSavedCards(db);
  }

  // 既存ユーザーのデータを保持したまま保存用テーブルを段階的に追加する。
  // 開発途中で version 2 に draw_sessions のみ作成した端末も救済できるよう、
  // 各ステップは IF NOT EXISTS で冪等にしている。
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createDrawSessions(db);
    }
    if (oldVersion < 3) {
      await _createSavedCards(db);
    }
  }

  // 進捗保存のテーブルは、再開に必要な情報を自己完結で持つため、リスト削除時の
  // 連動は行わず list_name をスナップショットとして保持する。
  static Future<void> _createDrawSessions(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS draw_sessions (
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

  static Future<void> _createSavedCards(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS saved_cards (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        card_id TEXT NOT NULL,
        list_id TEXT NOT NULL,
        list_name TEXT NOT NULL DEFAULT '',
        size INTEGER NOT NULL,
        has_free_space INTEGER NOT NULL,
        cells TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }
}
