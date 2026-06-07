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
      version: 1,
      onCreate: _onCreate,
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
  }
}
