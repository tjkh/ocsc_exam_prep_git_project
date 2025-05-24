import "dart:io" as io;

import 'package:ocsc_exam_prep/exam_progress.dart';
import "package:path/path.dart";
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// from: https://educity.app/flutter/the-right-way-to-use-sqlite-in-flutter-apps-using-sqflite-package-with-examples
class SqliteDB {
  static final SqliteDB _instance = new SqliteDB.internal();

  factory SqliteDB() => _instance;
  // static Database _db = " " as Database;
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  SqliteDB.internal();

  /// Initialize DB
  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "tjk_ExamPrep_DB.db");
    var taskDb = await openDatabase(path, version: 1);
    return taskDb;
  }

  /// Count number of tables in DB
  Future countTable() async {
    var dbClient = await db;
    var res =
    await dbClient!.rawQuery("""SELECT count(*) as count FROM sqlite_master
         WHERE type = 'table'
         AND name != 'android_metadata'
         AND name != 'sqlite_sequence';""");
    return res[0]['count'];
  }
}

Future updateFileCreateDate(
    {required String fileName, required int createdDate}) async {
  var dbClient = await SqliteDB().db;
  var res = await dbClient!.rawQuery('''
    UPDATE ExamProgress 
    SET dateCreated = ? 
    WHERE file_name = ?
    ''', [createdDate, '$fileName']);

  // print("res: $res");
  return res;
}

Future itemTableCount() async {
  var dbClient = await SqliteDB().db;
  var res =
  await dbClient!.rawQuery("""SELECT count(*) as count FROM itemTable""");
  return res[0]['count'];
  //return res;
}

Future insertItemTable(
    {required String fileName,
      required String thisID,
      required String thisDate,
      required String isNew,
      required String is_clicked}) async {
  dynamic myData = {
    "file_name": fileName,
    "item_id": thisID,
    "item_date": thisDate,
    "isClicked": is_clicked,
    "isNew": isNew
  };

  /// Adds user to table
  final dbClient = await SqliteDB().db;
  int res = await dbClient!.insert("itemTable", myData);
  return res;
}
//
// Future updateItemTable(
//     {String fileName,
//     String itemId,
//     String createdDate,
//     String isClicked,
//     String isNew}) async {
//   var dbClient = await SqliteDB().db;
//   var res = await dbClient.rawQuery('''
//     UPDATE itemTable
//     SET item_date = ?,
//     isClicked =?,
//     isNew =?
//     WHERE file_name = ? AND item_id = ?
//     ''', ['$createdDate', '$isClicked', '$isNew' '$fileName', '$itemId']);
//   print("update ItemTable -- res: $res");
//   return res;
// }

//
// Future retrieveItemDate({String fileName, String itemID}) async {
//   var dbClient = await SqliteDB().db;
//   final res = (await dbClient.rawQuery(
//       """ SELECT item_date FROM itemTable WHERE file_name = '$fileName' AND item_id = '$itemID' """));
//   //return res;
//   return res.first;
// }

Future<int?> checkThisExamFileExistsInTable({required String fileName}) async {
  var dbClient = await SqliteDB().db;

  int? count = Sqflite.firstIntValue(await dbClient!.rawQuery(
      'SELECT COUNT(*) FROM itemTable WHERE file_name = "$fileName" '));
  // print("x count xx fileName in Future: $fileName");
//  print("x count xx fileName in Future count: $count");
  return count;
  //
  // var res = await dbClient.rawQuery("""SELECT count(*) as count FROM itemTable
  //        WHERE file_name = ?
  //        """, ['$fileName']);
  // return res[0]['count'];
}

Future insertFileCreateDate(
    {required String fileName, required int thisDate}) async {
  dynamic myData = {"file_name": fileName, "dateCreated": thisDate};

  /// Adds user to table
  final dbClient = await SqliteDB().db;
  int res = await dbClient!.insert("ExamProgress", myData);
  return res;
}

Future insertOcscTjkTableData(
    {required String fileName,
      required String progressPicName,
      required String trailingPicName,
      required int date_Created,
      required int is_New,
      required int field1,
      required int field2,
      required String field3,
      required String field4,
      required String field5}) async {
  dynamic myData = {
    "file_name": fileName,
    "progress_pic_name": progressPicName,
    "trailing_pic_name": trailingPicName,
    "dateCreated": date_Created,
    "isNew": is_New,
    "exam_type": field1,
    "int field_2": field2,
    "position": field3,
    "open_last": field4,
    "field_5": field5
  };

  /// Adds data to table
  final dbClient = await SqliteDB().db;
  int res = await dbClient!.insert("OcscTjkTable", myData);
  return res;
}

// Future insertFileData(
//     {String fileName, String picName, int fileDate, int isNew}) async {
//   dynamic myData = {
//     "file_name": fileName,
//     "progress_pic_name": picName,
//     "dateCreated": fileDate,
//     "isNew": isNew
//   };

//   /// Adds user to table
//   final dbClient = await SqliteDB().db;
//   int res = await dbClient.insert("ExamProgress", myData);
//   return res;
// }

Future createExamProgressTableIfNotExist() async {
  var dbClient = await SqliteDB().db;
  var res = await dbClient!.execute("""
      CREATE TABLE IF NOT EXISTS ExamProgress(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        file_name TEXT,
        progress_pic_name TEXT,
        trailing_pic_name TEXT,
        dateCreated INTEGER,
        isClicked INTEGER,
        exam_type INTEGER,
        field_2 INTEGER,
        position TEXT,
        open_last TEXT,
        field_5 TEXT
      )""");
  return res;
}

Future createExamTableIfNotExist({required String tableName}) async {
  var dbClient = await SqliteDB().db;
  var res = await dbClient!.execute("""
      CREATE TABLE IF NOT EXISTS ?(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        file_name TEXT,
        leading_pic_name TEXT,
        trailing_pic_name TEXT,
        dateCreated INTEGER,
        isClicked INTEGER,
        exam_type INTEGER,
        field_2 INTEGER,
        position TEXT,
        open_last TEXT,
        field_5 TEXT
      )""", ['$tableName']);
  return res;
}
// UPDATE ExamProgress
// SET dateCreated = ?
// WHERE file_name = ?
// ''', [createdDate, '$fileName']);
//
// Future<List<ItemModel>> retrieveItemDate(
//     {String fileName, String itemID}) async {
//   var dbClient = await SqliteDB().db;
//   // final List<Map<String, dynamic>> maps = (await dbClient.rawQuery(
//   //     """ SELECT item_date FROM itemTable WHERE file_name = '$fileName' AND item_id = '$itemID' """));
//   // return result.isNotEmpty ? Product.fromMap(result.first) : Null;
//   // return List.generate(maps.length, (i) {
//   //   return ItemModel(item_date: maps[i]['item_date']);
//   // });
//   final res = (await dbClient.rawQuery(
//       """ SELECT item_date FROM itemTable WHERE file_name = '$fileName' AND item_id = '$itemID' """));
//
//   return res.isNotEmpty ? ItemModel.fromMap(res.first) : Null;
// }

// A method that retrieves all the dogs from the dogs table.
Future<List<ExamProgress>> retrieveProgressData() async {
  // Get a reference to the database.
  final db = await SqliteDB().db;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db!.query('myExamProgressData');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return ExamProgress(
      id: maps[i]['id'],
      file_name: maps[i]['name'],
      dateCreated: maps[i]['age'],
      progress_pic_name: maps[i]['progress_pic_name'],
      isClicked: maps[i]['is_click'],
      exam_type: maps[i]['exam_type'],
      field_2: maps[i]['field_2'],
      position: maps[i]['position'],
      open_last: maps[i]['open_last'],
      field_5: maps[i]['field_5'],
      trailing_pic_name: '',
    );
  });
}
