import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ocsc_exam_prep/sharePreferencesManager.dart';
import 'package:ocsc_exam_prep/sqlite_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'app_utils.dart';


ThemeData light = ThemeData(
    useMaterial3: true, // อีกหน่อยต้องใช้ เพราะจะยกเลิก material 2
    primaryColor: Colors.lightBlue[800],
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 20.0)),
    appBarTheme: const AppBarTheme(

        backgroundColor: Colors.indigo,
        // This will be applied to the "back" icon
        iconTheme: IconThemeData(color: Colors.white60),
        // This will be applied to the action icon buttons that locates on the right side
        actionsIconTheme: IconThemeData(color: Colors.amber),
        centerTitle: false,
        elevation: 15,
        titleTextStyle: TextStyle(
          color: Colors.lightBlueAccent,
          fontFamily: 'Athiti',
          fontSize: 25,
          fontWeight: FontWeight.bold,
         // color: Colors.white60,
        ),

    ),
    scaffoldBackgroundColor: Color(0xfff1f1f1));

ThemeData themeForGreetingDialog = light.copyWith(
//  textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 20.0)),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontSize: 50,
      fontFamily: 'Athiti',
      fontWeight: FontWeight.bold,
      color: Colors.indigo, // Color for bodyLarge
    ),
    displayMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.blue, // Color for headline2
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.green, // Color for bodyText1
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: Colors.orange, // Color for bodyText2
    ),
    // Add more text styles as needed
  ),
primaryColor: Colors.indigo, // Change the primary color
 // accentColor: Colors.orange, // Change the accent color
);


ThemeData dark = ThemeData(
  useMaterial3: true,  // อีกหน่อยต้องใช้ เพราะจะยกเลิก material 2
  brightness: Brightness.dark,
  primaryColor: Colors.lightBlue[800],
 // primarySwatch: Colors.indigo,
  primarySwatch: Colors.indigo,
  textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 20.0)),


  appBarTheme: AppBarTheme(
  //  backgroundColor: Colors.indigo,
    backgroundColor: Colors.black,
    // This will be applied to the "back" icon
    iconTheme: IconThemeData(color: Colors.white60),
    // This will be applied to the action icon buttons that locates on the right side
    actionsIconTheme: IconThemeData(color: Colors.amber),
    centerTitle: false,
    elevation: 15,
    titleTextStyle: TextStyle(
      color: Colors.lightBlueAccent,
      fontFamily: 'Athiti',
      fontSize: 25,
      fontWeight: FontWeight.bold,
      // color: Colors.white60,
    ),
  ),

);

class ThemeNotifier extends ChangeNotifier {
  //from https://www.youtube.com/watch?v=1t5SbwHscMs
  final String key = "sku";
// late SharedPreferences _prefs;
  var _prefs;
  bool _isBought = false;
  int _thisScheduleIndex = 0;
  bool _darkTheme = false;
  bool _darkThemeForGreetingDialog = false;
  late bool isBoughtFromHash;
  bool get darkTheme => _darkTheme;
  bool get darkThemeForGreetingDialog => _darkThemeForGreetingDialog;
  bool get isBoughtFromHashTbl => isBoughtFromHash;
  bool get isBoughtFromPref => _isBought;
  int get thisExamIndexFromPref => _thisScheduleIndex;
  bool isFirstRun = false;

  int? installDate;

  ThemeNotifier() {
    // _darkTheme = true;
    _darkTheme = false;
    _darkThemeForGreetingDialog=false;
    _loadFromSqlite();
    _getInstallDate();
    _loadSkuFromPrefs();
    _loadSkuFromHashTbl();
    _check_if_first_run();
    updateExamScheduleIndex();
  }
  toggleTheme() {
    _darkTheme = !_darkTheme;
    _darkThemeForGreetingDialog = !_darkThemeForGreetingDialog;
    _saveToHashTable();
    notifyListeners();
  }

 updateExamScheduleIndex() async {
  // Future<void> getExamScheduleIndex() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _thisScheduleIndex = _pref.getInt("examSchedule") ?? 0; // ถ้าไม่มีให้เป็น 0
    notifyListeners();
  }

  _loadFromSqlite() async {
    var thisData;
    String modeName = "appMode";
    bool isDarkMode;
    final dbClient = await SqliteDB().db;
    var result = await dbClient!
        .rawQuery('SELECT * FROM hashTable WHERE name = "$modeName"');
    if (result != null && result.isNotEmpty) {
      thisData = result.first["str_value"];
      if (thisData == "light") {
        isDarkMode = false;
      } else {
        isDarkMode = true;
      } // end of if (thisData ==
      _darkTheme = isDarkMode;
      _darkThemeForGreetingDialog = isDarkMode;

    } else {
      _darkTheme = false;
      _darkThemeForGreetingDialog = false;
    } // end of if (result.isNotEmpty)
    print("darkTheme $_darkTheme");
    notifyListeners();
  } // end of _loadFromSqlite

  _saveToHashTable() async {
    String appModeValue;
    String appModeValueForGreetingDialogValue;
    if (_darkTheme == true) {
      appModeValue = "dark";
      appModeValueForGreetingDialogValue = "dark";
    } else {
      appModeValue = "light";
      appModeValueForGreetingDialogValue = "light";
    }

    debugPrint("appMode before saving to Table: $appModeValue");
    String thisName = "appMode";
    String thisNameForGreetingDialog = "greetingDialogMode";
    String thisValue = appModeValue; // Use appModeValue here
    String thisValueForGreetingDialog = appModeValueForGreetingDialogValue; // Use appModeValueForGreetingDialogValue here

    final dbClient = await SqliteDB().db;
    // Update or insert for appMode
    await _updateOrInsert(dbClient, thisName, thisValue);

    // Update or insert for greetingDialogMode
    await _updateOrInsert(dbClient, thisNameForGreetingDialog, thisValueForGreetingDialog);
  }

// Helper function to update or insert into the hashTable
  _updateOrInsert(Database? dbClient, String thisName, String thisValue) async {
    var count = Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT COUNT (*) FROM hashTable WHERE name = ?', [thisName]));
    print("column name: $thisName");
    print("count hashTbl: $count");
    if (count == 0) {
      print("x count xx: insert");
      await dbClient.rawQuery(
          'INSERT INTO hashTable (name, str_value) VALUES (?, ?)', [thisName, thisValue]);
    } else {
      await dbClient.rawQuery('''
                        UPDATE hashTable 
                        SET str_value = ?
                        WHERE name = ?
                        ''', [thisValue, thisName]);
    }
  }



  // _saveToHashTable() async {
  //   String appModeValue;
  //   String appModeValueForGreetingDialogValue;
  //   if (_darkTheme == true) {
  //     appModeValue = "dark";
  //     appModeValueForGreetingDialogValue = "dark";
  //   } else {
  //     appModeValue = "light";
  //     appModeValueForGreetingDialogValue = "light";
  //   }
  //
  //   print("appMode before saving to Table: $appModeValue");
  //   String thisName = "appMode";
  //   String thisNameForGreetingDialog = "greetingDialogMode";
  //   String thisValue = "light";
  //   String thisValueForGreetingDialog =  "light";
  //   final dbClient = await SqliteDB().db;
  //   var count = Sqflite.firstIntValue(await dbClient!.rawQuery(
  //       'SELECT COUNT (*) FROM hashTable WHERE name = ?', ["$thisName"]));
  //   print("theme, column name: $thisName");
  //   print("theme, count hashTbl: $count");
  //   if (count == 0) {
  //     print("x count xx: insert");
  //     await dbClient!.rawQuery(
  //         'INSERT INTO hashTable (name, str_value) VALUES ("$thisName", "$thisValue")');
  //     //    'INSERT INTO hashTable (name, str_value) VALUES ("$thisName", "$thisValue")');
  //   } else {
  //     await dbClient!.rawQuery('''
  //                             UPDATE hashTable
  //                             SET str_value = ?
  //                             WHERE name = ?
  //                             ''', ['$appModeValue', '$thisName']);
  //   }
  // }

  // คนละเรื่องกัน แต่ฝากไว้ที่นี่เพื่อใช้ Sharepreferences สำหรับเก็บค่า sku (ชื้อแล้วหรือยัง)
  _iniPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  _check_if_first_run() async {
    bool firstRun = false;
    bool isFirstRunValue = await getBooleanValue(
        "is_First_Run"); // is_First_Run คือ key ใน SharedPref ถ้าเปิดใช้งานครั้งแรก จะไม่มี มีค่าเป็น false ไม่ใช่ null
    if(isFirstRunValue == false){  // ถ้า is_First_Run ไม่มี ใน SharedPref หรือมี แต่มีค่าเป็น false แสดงว่า เป็นการใช้งานครั้งแรก
      firstRun = true;
    }else{
      firstRun = false;
    }

    bool isTableEmpty = await isItemTableEmpty();
    debugPrint(
        "firstRunFromPref inside theme: $firstRun, isTableEmpty: $isTableEmpty");
    if (firstRun == true && isTableEmpty == true) { // ถ้ามีข้อมูลในตรฃาราง แต่ firstRun เป็น true แสดงว่า เป็นรุ่นเก่า เคยใช้งานมาแล้ว จึงไม่ใช่การเปิดใช้งานครั้งแรก
      isFirstRun = true;
    } else {
      isFirstRun = false;
    }
    notifyListeners();
  }

  _loadSkuFromHashTbl() async {
    // ไปเอาข้อมูลว่า ซื้อแล้วหรือยัง
    isBoughtFromHash = await check_if_already_bought_from_hashTable();
    notifyListeners();
  }

  // _getInstallDate(){  // ไม่ใช้อันนี้ ใช้ข้างล่างแทน
  //   installDate = SharedPreferencesManager().getInt('timeOfFirstRun') ?? 1691821278;
  //   // ถ้าไม่มี กำหนดให้ติดตั้ง 12 สิงหาคม 2566
  //   notifyListeners();
  // }

  _getInstallDate() async { // เชควันที่ วันที่สร้างห้องสำหรับเก็บแอบนี้
    installDate = (await AppUtils.getInstallDateEpochSeconds())!;
    print("App Installed Date in theme: $installDate");
    notifyListeners();
  }

  _loadSkuFromPrefs() async {
    // ไปเอาข้อมูลว่า ซื้อแล้วหรือยัง
    await _iniPrefs();
    _isBought = _prefs.getBool(key) ??
        false; // if it is null, make it false (not bought yet.)
    notifyListeners();
  }

  _saveToPrefs(bool whatValue) async {
    // สำหรับกำหนดค่า ว่าซื้อหรือยัง เพื่อทดสอบ ใช้ขณะที่ทำโปรแกรมเท่านั้น จริง ๆ จะรับค่ามาจาก PlayStore
    await _iniPrefs();
    _prefs.setBool(key, whatValue);
  }

  Future<bool> check_if_already_bought_from_hashTable() async {
    // ตรงนี้ทำให้ไม่แสดงหน้าข้อสอบ มีแต่หมุน ๆ  -- ได้แล้ว ผิดตรงที่เอาค่าจาก result ออกมาไม่ถูก
    bool isBuy;
    final dbClient = await SqliteDB().db;
    var result =
        await dbClient!.rawQuery('SELECT * FROM hashTable WHERE name = "sku"');
    if (result.isNotEmpty) {
      // ค่าของ result อยู่ในรูป list เช่น result: [{id: 312, name: sku, str_value: true}]
      if (kDebugMode) {
        print("isBoughtAlready inside function is not empty.");
      }
      Object? val = result.first['str_value'];
      if (val == "true") {
        isBuy = true;
      } else {
        isBuy = false;
      }
    } else {
      isBuy = false;
    }
    if (kDebugMode) {
      print("isBoughtAlready inside function - result: $result");
      print("isBoughtAlready inside function: $isBuy");
  }
    return isBuy;
  }
}

//  ตรวจสอบว่า เป็นการใช้งานครั้งแรกหรือเปล่า ใช้คู่กับ การตรวจว่าใน ตาราง itemTable มีข้อมูลหรือเปล่า
// เพราะเพิ่งมาตรวจเอาตอนหลัง คนที่ใช้งานไปแล้ว ถ้าไมเชคอีกชั้น ก็จะกลายเป็นการเปิดใช้งานครั้งแรกไป
//  การตรวจสอบนี้ ใช้สำหรับ่การแสดงจุดแดง หน้าข้อ แต่ละข้อ และ จุดแดง หลังชื่อในหน้าเมนู
Future<bool> getBooleanValue(String key) async {
  bool _isFirstRun = SharedPreferencesManager().getBool(key);

  debugPrint("the value of _isFirstRun from getBooleanValue function : $_isFirstRun");

  // SharedPreferences myPrefs = await SharedPreferences.getInstance();
  // bool _isFirstRun = myPrefs.getBool(key) ?? true;
  // // ถ้า myPrefs.getBool(key) มีค่าเป็น null คือไม่มีอะไร แสดงว่า เป็นการใช้งานครั้งแรก กำหนดค่าให้เป็น true
   if (_isFirstRun) {

// ถ้าเป็นการใช้งานครั้งแรก กำหนดค่า is_First_Run เป็น false เก็บไว้ใน
// SharedPreferences เพื่อว่า ครั้งต่อไป มาเชค จะได้เป็น false ตลอด
     SharedPreferencesManager().setBool('is_First_Run', false);

 // timeOfFirstRun ใช้สำหรับเพื่อให้ ชวนให้ โหวต 5 ดาว หลังจากเปิดใช้งานครั้งแรกได้ 7 วัน
 //    SharedPreferencesManager().setInt('timeOfFirstRun', DateTime.now().toUtc().millisecondsSinceEpoch);

     SharedPreferencesManager().setInt('timeOfFirstRun', (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).round());
     int storedTime = SharedPreferencesManager().getInt('timeOfFirstRun');
     if (kDebugMode) {
       print("storedTime in theme.dart: $storedTime");
     }


       // ตั้งค่า default ไว้ก่อนว่า ยังไม่คลิกไปโหวต 5 ดาว ตรงนี้ ถ้าคลิกแล้ว
     // ใน dialog ตอนเปิด จะมีข้อความให้ปิดไม่แสดงอีกเลย แทนที่ข้อความว่า ไม่ต้องแสดงอีก 7 วัน
     SharedPreferencesManager().setBool('isVote_5_stars_Clicked', false);



    //
    //    //ถ้าใช้ครั้งแรก จาก null เรากำหนดให้เป็น true แล้วตรง _isFirstRun = myPrefs.getBool(key) ?? true;
    // await myPrefs.setBool('is_First_Run',
    //     false); // ถ้าเป็นการใช้งานครั้งแรก กำหนดค่า is_First_Run เป็น false เก็บไว้ใน SharedPreferences เพื่อว่า ครั้งต่อไป มาเชค จะได้เป็น false ตลอด
    //
    // // timeOfFirstRun ใช้สำหรับเพื่อให้ ชวนให้ โหวต 5 ดาว หลังจากเปิดใช้งานครั้งแรกได้ 7 วัน
    // myPrefs.setInt('timeOfFirstRun', DateTime.now().toUtc().millisecondsSinceEpoch);
    // int storedTime = myPrefs.getInt('timeOfFirstRun') ?? 0;
    // print("storedTime in theme.dart: $storedTime");
    //
    //
    //
    // // ตั้งค่า default ไว้ก่อนว่า ยังไม่คลิกไปโหวต 5 ดาว ตรงนี้ ถ้าคลิกแล้ว ใน dialog ตอนเปิด จะให้ปิดไม่แสดงอีกเลย แทนที่ ไม่ต้องแสดงอีก 7 วัน
    // myPrefs.setBool('isVote_5_stars_Clicked', false);
    //

    return true;
  } else {
    // chatGPT บอกว่า ไม่จำเป็นต้อง set ใน sharePref เป็น false ให้ซ้ำกันอีก
    // await myPrefs.setBool('is_First_Run',
    //     false); // ถ้าไม่ใช่เป็นการใช้งานครั้งแรก กำหนดค่า is_First_Run เป็น false เก็บไว้ใน SharedPreferences
    return false;
  }
}

Future<bool> isItemTableEmpty() async {
  // ตรวจสอบว่า ในตาราง itemTable มีข้อมูลหรือไม่
  final dbClient = await SqliteDB().db;
  // ตรวจสอบใน sqlite_master ว่ามีตารางชื่อ itemTable หรือไม่
  var tables = await dbClient!
      .rawQuery('SELECT * FROM sqlite_master WHERE name="itemTable";');
  if (tables.isEmpty) {
    // ไม่มีตารางนี้ (รุ่นก่อนมาก ๆ จะไม่มีตารางนี้ เพราะสร้างสมัยใช้ Flutter)
    return true; //
  } else {
    // มี เชคต่อไปว่า มีข้อมูลหรือไม่
    var count = Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT (*) FROM itemTable'));
    if (count! > 0) {
      return false; // itemTable is not empty
    } else {
      return true; // itemTable is empty
    } // end of if (count > 0)
  } // end of  if (tables.isEmpty)
} // end of Future<bool>  isItemTableEmpty()
