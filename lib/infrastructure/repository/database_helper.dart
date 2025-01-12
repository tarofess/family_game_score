import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<void> initDatabase() async {
    try {
      _database ??= await openDatabase(
        'family_game_score.db',
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE Player(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, image TEXT, status INTEGER)',
          );
          await db.execute(
            'CREATE TABLE Session(id INTEGER PRIMARY KEY AUTOINCREMENT, round INTEGER, begTime TEXT, endTime TEXT, gameType TEXT)',
          );
          await db.execute(
            'CREATE TABLE Result(id INTEGER PRIMARY KEY AUTOINCREMENT, playerId INTEGER, sessionId INTEGER, score INTEGER, rank INTEGER)',
          );
        },
      );
    } catch (e) {
      throw Exception('データベースの初期化に失敗しました。');
    }
  }

  Database get database {
    if (_database == null) {
      throw StateError("Database not initialized");
    }
    return _database!;
  }
}
