import 'dart:async';

import 'package:ocsc_exam_prep/sqlite_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

/// A store of consumable items.
///
/// This is a development prototype tha stores consumables in the shared
/// preferences. Do not use this in real world apps.
class ConsumableStore {
  static const String _kPrefKey = 'consumables';
  static Future<void> _writes = Future.value();

  /// Adds a consumable with ID `id` to the store.
  ///
  /// The consumable is only added after the returned Future is complete.
  static Future<void> save(String id) {
    _writes = _writes.then((void _) => _doSave(id));
    print("id inside consumableStore: $id");
    // ตรงนี้ ต้องเพิ่มเก็บ id ลง hashTable
    addToHashTable(productID: id);
    return _writes;
  }

  /// Consumes a consumable with ID `id` from the store.
  ///
  /// The consumable was only consumed after the returned Future is complete.
  static Future<void> consume(String id) {
    _writes = _writes.then((void _) => _doConsume(id));
    print("_writes inside consumableStore: $_writes");
    return _writes;
  }

  /// Returns the list of consumables from the store.
  static Future<List<String>> load() async {
    return (await SharedPreferences.getInstance()).getStringList(_kPrefKey) ??
        [];
  }

  static Future<void> _doSave(String id) async {
    List<String> cached = await load();
    print("cached inside consumableStore before add to sharePref: $cached");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKey, cached);
  }

  static Future<void> _doConsume(String id) async {
    List<String> cached = await load();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKey, cached);
    print("isBoughtAlready before add to HashTable cached: $cached");
    //   await addToHashTable(productID: cached as String);
    print("isBoughtAlready after add to HashTable cached: $cached");
  }
}

void addToHashTable({required String productID}) async {
  print("enter update_hashTable function - consumable_store");
  print("product bought: $productID");
  // var dbClient = await SqliteDB().db;
  // await dbClient.rawInsert(
  //     'INSERT INTO hashTable (name, str_value) VALUES("sku", "true")'); // กำหนดค่าเริ่มต้นไว้เลย
  final dbClient = await SqliteDB().db;
  var count = Sqflite.firstIntValue(await dbClient!
      .rawQuery('SELECT COUNT (*) FROM hashTable WHERE name = "buy_ID"'));
  // print("theme, column name: $thisName");
  print("theme, count hashTbl: $count");
  if (count == 0) {
    print("x count xx: insert");
    await dbClient.rawQuery(
        'INSERT INTO hashTable (name, str_value) VALUES ("buy_ID", "$productID")');
    // } else {
    //   await dbClient
    //       .rawQuery('UPDATE hashTable SET str_value = "true" WHERE name = "sku"');
  }
}
