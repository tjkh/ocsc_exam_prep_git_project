import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

// Singleton Database Manager
class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  Database? _database;

  factory DatabaseManager() => _instance;

  DatabaseManager._internal();

  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'ocsc_exam.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create hashTable
    await db.execute('''
      CREATE TABLE IF NOT EXISTS hashTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        str_value TEXT,
        UNIQUE (name) ON CONFLICT REPLACE
      )
    ''');

    // Insert default appMode
    await db.insert(
      'hashTable',
      {'name': 'appMode', 'str_value': 'light'},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Create OcscTjkTable
    await db.execute('''
      CREATE TABLE IF NOT EXISTS OcscTjkTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        menu_name TEXT,
        file_name TEXT,
        progress_pic_name TEXT,
        dateCreated INTEGER,
        isNew INTEGER,
        exam_type INTEGER,
        field_2 INTEGER,
        position TEXT,
        open_last TEXT DEFAULT "top",
        field_5 TEXT,
        UNIQUE (menu_name, file_name) ON CONFLICT REPLACE
      )
    ''');

    // Create itemTable
    await db.execute('''
      CREATE TABLE IF NOT EXISTS itemTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        file_name TEXT,
        item_id TEXT,
        item_date TEXT,
        isClicked TEXT DEFAULT "false",
        isNew TEXT,
        UNIQUE (item_id) ON CONFLICT REPLACE
      )
    ''');
  }

  // Initialize database and create tables if they don't exist
  Future<void> initialize() async {
    await db; // Ensures database is opened and tables are created
  }

  // Batch insert or update OcscTjkTable records
  Future<void> syncOcscTjkTable(List<List<dynamic>> records) async {
    final db = await this.db;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var record in records) {
        batch.insert(
          'OcscTjkTable',
          {
            'menu_name': record[0],
            'file_name': record[1],
            'progress_pic_name': 'p00.png',
            'dateCreated': int.parse(record[2]),
            'isNew': 0,
            'exam_type': int.parse(record[3]),
            'field_2': 0,
            'position': record[4],
            'open_last': 'top',
            'field_5': 'reserved',
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  // Delete orphaned records not in the provided menu list
  Future<void> deleteOrphanedMenus(List<String> menuListInMain) async {
    final db = await this.db;
    await db.transaction((txn) async {
      await txn.delete(
        'OcscTjkTable',
        where: 'menu_name NOT IN (${List.filled(menuListInMain.length, '?').join(',')})',
        whereArgs: menuListInMain,
      );
    });
  }

  // Delete orphaned itemTable records
  Future<void> deleteOrphanedItems() async {
    final db = await this.db;
    await db.transaction((txn) async {
      await txn.rawDelete(
        'DELETE FROM itemTable WHERE file_name NOT IN (SELECT file_name FROM OcscTjkTable)',
      );
    });
  }

  // Retrieve position, dateCreated, and field_2 for a file
  Future<Map<String, dynamic>> retrieveDateFromSQflite(String fileName) async {
    final db = await this.db;
    final result = await db.query(
      'OcscTjkTable',
      columns: ['position', 'dateCreated', 'field_2'],
      where: 'file_name = ?',
      whereArgs: [fileName],
    );
    if (result.isNotEmpty) {
      return {
        'position': result.first['position'] as String,
        'dateCreated': result.first['dateCreated'] as int,
        'field_2': result.first['field_2'] as int,
      };
    }
    return {
      'position': '00',
      'dateCreated': 111111,
      'field_2': 0,
    };
  }

  // Update position in OcscTjkTable
  Future<void> updatePositionInOcscTjkTable({
    required String fileName,
    required String position,
  }) async {
    final db = await this.db;
    await db.update(
      'OcscTjkTable',
      {'position': position},
      where: 'file_name = ?',
      whereArgs: [fileName],
    );
  }

  // Get all menu names from OcscTjkTable
  Future<List<String>> getMenuNames() async {
    final db = await this.db;
    final results = await db.query('OcscTjkTable', columns: ['menu_name']);
    return results.map((row) => row['menu_name'] as String).toList();
  }
}