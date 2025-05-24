//import 'pdfViewer.dart';
import 'dart:io' show Platform;
// สำหรับตรวจว่า เป็น android หรือ iphone จะได้ส่งลิงค์ไปให้คะแนน ถูกเว็บ

import 'dart:math'; // สำหรับคำนวณหาเลขสุ่ม เพื่อเอาไปสุ่มแสดงข่าวสาร

// import 'package:flutter/src/widgets/visibility.dart' as isVisible;

// import 'package:chaleno/chaleno.dart'; //สำหรับ ไปอ่านข้อความ จากเว็บ pastebin
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ocsc_exam_prep/ProviderModel.dart';
import 'package:ocsc_exam_prep/exam_model.dart';
import 'package:ocsc_exam_prep/itemPageView.dart';
import 'package:ocsc_exam_prep/pdfView.dart';

//import 'package:ocsc_exam_prep/pdfViewer.dart';
import 'package:ocsc_exam_prep/theme.dart';
import 'package:ocsc_exam_prep/utils.dart';
import 'package:ocsc_exam_prep/video_list.dart';
import 'package:ocsc_exam_prep/video_list_math.dart';

import 'package:ocsc_exam_prep/youTubePageView.dart';
//import 'package:pastebin/pastebin.dart';  // ใช้กับ webview_flutter 3.0.1
//import 'package:pastebin/pastebin.dart' as pbn; // ใช้กับ webview_flutter 3.0.1
//import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'aboutDialog.dart';
//import 'htmlPageView.dart';
import 'htmlPageView_inappWebView.dart';
import 'sqlite_db.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // สำหรับ animate ข้อความใต้ชื่อ
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:ocsc_exam_prep/app_utils.dart';

class MainMenu extends StatefulWidget {


  final int
  examScheduleIndex; //  ไม่ได้ใช้ ใช้เรียกจาก theme provider getExamScheduleIndex() แทน
  // ไม่เอา pastebin แต่เอาเป็นกำหนดเอง
  // ถ้าเปลี่ยน ก็มาเปลี่ยนที่นี่ แล้ว upload ขึ้น play store
  static const String msg_global =
      "**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขยันตอนมีแรง ดีกว่านอนซดน้ำแกงตอนชรา**xyz**ไม่มีใครไม่เคยผิดพลาด&&&จงเอาทุกอย่างที่ผิดในวันนั้น&&&มาเป็นบทเรียน **xyz**ขึ้นชื่อว่าชีวิต ย่อมไม่มีวันง่ายแน่นอน**xyz**วันนี้  \"ท้อ\" ไม่เป็นไรขอ  \"ใจสู้\" **xyz**ยืนได้ด้วยขาตัวเอง ถึงจะเหนื่อยหน่อย แต่ก็ภูมิใจ**xyz**คนเรากว่าจะสบายได้ ไม่ใช่เรื่องง่ายนะคะ**xyzDon’t stop until you’re proud.&&&อย่่าเพิ่งหยุด จนกว่าคุณจะภูมิใจ  xyzทุกอย่างมักจะยากตอนเริ่มต้นเสมอxyzห า ก ชี วิ ต ม นุ ษ ย์ &&&มั น จ ะ เ รี ย บ ง่ า ย &&&ค ง ไ ม่ เ ริ่ ม ต้ น ด้ ว ย ก า ร &&&ร้ อ ง ไ ห้ เ มื่ อ ลื ม ต า ดู โ ล กxyzที่ไหนมีความพยายาม ที่นั่นมีความสำเร็จ&&&Where there 's a will there 's a way.&&&will (n.) = ความตั้งใจ, พินัยกรรมxyz**In the middle of every difficulty lies opportunity.**&&&ในท่ามกลางทุกความยาก ย่อมมีโอกาสxyzFailure is success if we learn from it.&&&ความผิดพลาดคือความสำเร็จ ถ้าเราเรียนรู้กับมันxyzความสำเร็จมันต้องไขว่คว้า&&&ไม่ได้อยู่บนฟ้ารอวันตกลงมาxyz**Nothing is impossible.**&&&ไม่มีอะไรที่เป็นไปไม่ได้ &&&impossible = I (a)m possible.xyzTrust yourself,&&&you know more than you think you do.&&&ขอให้เชื่อมั่นในตัวเอง&&&คุณมีความรู้มากกว่าที่คุณคิดว่ารู้xyz**Life only has one rule: Never quit.**&&&ชีวิตมีกฎอยู่ข้อเดียว คือ อย่ายอมแพ้&&&quit=หยุด เลิก ออกจากงาน ยอมแพ้xyzNothing worth having comes easy.&&&อะไรที่ได้มาง่าย ไม่มีค่าxyz**พิสูจน์ตัวเราให้กับ  \"ตัวเรา\" เอง**xyzNever, never, never give up.&&&อย่า อย่า อย่ายอมแพ้xyz**Dreams don’t work unless you do.**&&&ฝันจะไม่เป็นจริง ถ้าท่านไม่ทำ&&&unless = if notxyzDon’t regret the past, just learn from it.&&&อย่าไปเสียใจกับอดีต ให้เรียนรู้กับมันxyzBelieve you can and you’re halfway there.&&&เพียงแค่เชื่อว่าทำได้ ก็ไปถึงครึ่งทางแล้วxyz**ข้อสอบจะอยู่ข้างคนที่ตั้งใจเสมอ**xyzกระจกไม่เคยดูถูกใคร&&&มีแต่คนที่ไม่มั่นใจที่ดูถูกตัวเองxyzมองปัญหาให้เหมือนกับเม็ดทราย&&&ถึงจะเยอะมากมาย&&&แต่เม็ดทรายก็เล็กนิดเดียวxyzจงฝากชีวิตไว้กับ  \"สติและปัญญา\" &&&อย่าฝากไว้กับ  \"โชคชะตา ที่มองไม่เห็น\" xyzท้อแท้ได้ แต่อย่าท้อถอย&&&อิจฉาได้ แต่อย่าริษยา&&&พักได้ แต่อย่าหยุด&&&ทำให้ถึงที่สุด แล้วหยุดที่คำว่า  \"พอ\" xyz**อนาคตที่ดี เริ่มต้นจากวันนี้**xyzในขณะที่เราหยุด คนอื่นกำลังก้าวแซงเราไปxyzในวันที่ทุกสิ่งดูผิดพลาดไปหมด &&&ใจที่ดีจะนำทุกสิ่งกลับเข้าที่เองxyzIt 's OK to fail sometime, just come back harder. &&&สอบตกบ้างไม่เป็นไร ขอให้พยายามใหม่ให้หนักกว่าเดิม&&&sometime = ณ เวลาใดเวลาหนึ่ง&&&sometimes = ไม่บ่อยนัก&&&some time = นานมาแล้ว เช่น quite some time";
  static const String msg_global_for_potential_customers =
      "รุ่นเต็ม เพียง 199.- เท่านั้นxyz**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขยันตอนมีแรง ดีกว่านอนซดน้ำแกงตอนชรา**xyz**ไม่มีใครไม่เคยผิดพลาด&&&จงเอาทุกอย่างที่ผิดในวันนั้น&&&มาเป็นบทเรียน **xyz**ขึ้นชื่อว่าชีวิต ย่อมไม่มีวันง่ายแน่นอน**xyz**วันนี้  \"ท้อ\" ไม่เป็นไรขอ  \"ใจสู้\" **xyz**ยืนได้ด้วยขาตัวเอง ถึงจะเหนื่อยหน่อย แต่ก็ภูมิใจ**xyz**คนเรากว่าจะสบายได้ ไม่ใช่เรื่องง่ายนะคะ**xyzDon’t stop until you’re proud.&&&อย่่าเพิ่งหยุด จนกว่าคุณจะภูมิใจ  xyzทุกอย่างมักจะยากตอนเริ่มต้นเสมอxyzห า ก ชี วิ ต ม นุ ษ ย์ &&&มั น จ ะ เ รี ย บ ง่ า ย &&&ค ง ไ ม่ เ ริ่ ม ต้ น ด้ ว ย ก า ร &&&ร้ อ ง ไ ห้ เ มื่ อ ลื ม ต า ดู โ ล กxyzที่ไหนมีความพยายาม ที่นั่นมีความสำเร็จ&&&Where there 's a will there 's a way.&&&will (n.) = ความตั้งใจ, พินัยกรรมxyz**In the middle of every difficulty lies opportunity.**&&&ในท่ามกลางทุกความยาก ย่อมมีโอกาสxyzFailure is success if we learn from it.&&&ความผิดพลาดคือความสำเร็จ ถ้าเราเรียนรู้กับมันxyzความสำเร็จมันต้องไขว่คว้า&&&ไม่ได้อยู่บนฟ้ารอวันตกลงมาxyz**Nothing is impossible.**&&&ไม่มีอะไรที่เป็นไปไม่ได้ &&&impossible = I (a)m possible.xyzTrust yourself,&&&you know more than you think you do.&&&ขอให้เชื่อมั่นในตัวเอง&&&คุณมีความรู้มากกว่าที่คุณคิดว่ารู้xyz**Life only has one rule: Never quit.**&&&ชีวิตมีกฎอยู่ข้อเดียว คือ อย่ายอมแพ้&&&quit=หยุด เลิก ออกจากงาน ยอมแพ้xyzNothing worth having comes easy.&&&อะไรที่ได้มาง่าย ไม่มีค่าxyz**พิสูจน์ตัวเราให้กับ  \"ตัวเรา\" เอง**xyzNever, never, never give up.&&&อย่า อย่า อย่ายอมแพ้xyz**Dreams don’t work unless you do.**&&&ฝันจะไม่เป็นจริง ถ้าท่านไม่ทำ&&&unless = if notxyzDon’t regret the past, just learn from it.&&&อย่าไปเสียใจกับอดีต ให้เรียนรู้กับมันxyzBelieve you can and you’re halfway there.&&&เพียงแค่เชื่อว่าทำได้ ก็ไปถึงครึ่งทางแล้วxyz**ข้อสอบจะอยู่ข้างคนที่ตั้งใจเสมอ**xyzกระจกไม่เคยดูถูกใคร&&&มีแต่คนที่ไม่มั่นใจที่ดูถูกตัวเองxyzมองปัญหาให้เหมือนกับเม็ดทราย&&&ถึงจะเยอะมากมาย&&&แต่เม็ดทรายก็เล็กนิดเดียวxyzจงฝากชีวิตไว้กับ  \"สติและปัญญา\" &&&อย่าฝากไว้กับ  \"โชคชะตา ที่มองไม่เห็น\" xyzท้อแท้ได้ แต่อย่าท้อถอย&&&อิจฉาได้ แต่อย่าริษยา&&&พักได้ แต่อย่าหยุด&&&ทำให้ถึงที่สุด แล้วหยุดที่คำว่า  \"พอ\" xyz**อนาคตที่ดี เริ่มต้นจากวันนี้**xyzในขณะที่เราหยุด คนอื่นกำลังก้าวแซงเราไปxyzในวันที่ทุกสิ่งดูผิดพลาดไปหมด &&&ใจที่ดีจะนำทุกสิ่งกลับเข้าที่เองxyzIt 's OK to fail sometime, just come back harder. &&&สอบตกบ้างไม่เป็นไร ขอให้พยายามใหม่ให้หนักกว่าเดิม&&&sometime = ณ เวลาใดเวลาหนึ่ง&&&sometimes = ไม่บ่อยนัก&&&some time = นานมาแล้ว เช่น quite some timexyzเพียง 199.- บาท ลงทุนเพื่ออนาคต&&&คุ้มยิ่งกว่าคุ้มxyzการซื้อของท่าน ช่วยให้เราพัฒนาแอพนี้ ต่อไปได้xyzของฟรีไม่มีในโลก&&&ถ้าท่านต้องการรุ่นเต็ม ให้สมัครเข้าร่วมทดสอบโปรแกรม&&&ส่งอีเมลถึงผม ผ่านทางเมนู 3 จุดxyzถ้าท่านต้องการรุ่นเต็มฟรี ให้สมัครเข้าร่วมทดสอบโปรแกรม&&&ส่งอีเมลถึงผม ผ่านทางเมนู 3 จุด";
  final String title;
  final String myType;
  final List fileList; // ที่จะส่งเข้ามา
  final String countDownMessage;
  final List msgFromGSheets;

  static const String cutDate =
      "1622174264"; // ถ้าก่อนวันที่ 28 พ.ค. 64 ไม่ต้องแสดง จุดแดง

  MainMenu(
      {required int this.examScheduleIndex,
        required String this.myType,
        required String this.title,
        required List this.fileList,
        required String this.countDownMessage,
        required List
        this.msgFromGSheets}); // เครื่องหมาย {} คือ เวลาส่งตัวแปรเข้ามา บังคับว่า ต้องระบุชื่อตัวแปรด้วย
// fileList สำหรับ ชื่อเมนู(fileList[0]) ชื่อไฟล์(fileList[1]) วันที่(fileList[2]) และ ประเภท(fileList[3]  ประเภท: 1=ทั่วไป 2=อังกฤษ 3=กฏหมาย 4=ลองทำ )


  @override
  MainMenuState createState() => MainMenuState(examScheduleIndex, myType, title,
      fileList, countDownMessage, msgFromGSheets);
}

class MainMenuState extends State<MainMenu> {
  // List<List<OcscTjkTable>>
  //     myMenuContents; //เนื้อหาสารบัญ ของแต่ละหน้า เช่น หน้าความสามารถทั่วไป หน้าภาษาอังกฤษ เป็นต้น(ยกเว้น หน้าหลักสูตร เพราะมีหน้าเดียว ไม่ต้องมีสารบัญ)
  int examScheduleIndex;
  String myType;
  String title;
  List fileList;
  String countDownMessage;
  List msgFromGSheets;

  String? msg, header, msge, countDownMsg;
  bool abcdAlready = false;

  // bool isBoughtFromHash = false;
  bool isModeDark = false; // move here -- new

  int? exmSchdleIndx; // สำหรับเก็บข้อมูล examSchedule ที่เก็บใน sharePref
  String? whatExam;
  bool _isPastebinLoading = false;

  // สำหรับข้อมูลจาก Google Sheets
  String examScheduleFromSheets = "";
  String msgBoughtAndroidFromSheets = "";
  String msgNotBoughtAndroidFromSheets = "";
  String msgBoughtIosFromSheets = "";
  String msgNotBoughtIosFromSheets = "";
  String curr_version_from_sheets = "";

  // =============== นับถอยหลัง count down data ==============================

  List examSchedule = [];


  Map<String, bool> fileNewStatus = {}; // Store file -> isNew status

  // =============== end of  นับถอยหลัง count down data ==============================

  MainMenuState(this.examScheduleIndex, this.myType, this.title, this.fileList,
      this.countDownMessage, this.msgFromGSheets);


  void scrapData() async {
    debugPrint("beginning of scrapData countDownMsg ...");
    final provider = Provider.of<ProviderModel>(context, listen: false);


    debugPrint("msgFromGSheets in MainMenu: $msgFromGSheets"); // OK

    // ข้อมูลจาก Google Sheets
    if (msgFromGSheets.isNotEmpty) {
      // OK  พอแค่นี้ก่อน แล้วค่อยว่ากัน มาหมดแล้ว
      for (int i = 0; i < msgFromGSheets.length; i++) {
        String description = msgFromGSheets[i]['description'];
        debugPrint("Description from GSheets $i: $description");
      }
      examScheduleFromSheets = msgFromGSheets[0]['description'];
      msgBoughtAndroidFromSheets = msgFromGSheets[1]['description'];
      msgNotBoughtAndroidFromSheets = msgFromGSheets[2]['description'];
      msgBoughtIosFromSheets = msgFromGSheets[3]['description'];
      msgNotBoughtIosFromSheets = msgFromGSheets[4]['description'];
      curr_version_from_sheets = msgFromGSheets[5]['description'];
    }

    debugPrint("examScheduleFromSheets  in MainMenu: $examScheduleFromSheets");
    debugPrint(
        "msgBoughtAndroidFromSheets  in MainMenu: $msgBoughtAndroidFromSheets");
    debugPrint("examScheduleIndex in MainMenu: $examScheduleIndex");
    // String url = "";  // สำหรับแสดงข้อความจาก pastebin ให้กำลังใจหรืออื่น ๆ ในหน้าข้อสอบ มีลิงค์ได้
    // String countDownUrl = "TmqFdgNA";  // สำหรับแสดงข้อความจาก pastebin นับถอยหลัง ในหน้า เมนู

    abcdAlready = provider.removeAds;
    debugPrint("isBought abcdAlready from Provider: $abcdAlready");
    if (abcdAlready == false) {
      // ถ้ายังไม่ได้ซื้อ แสดงข่าวสารแบบยังไม่ซื้อ คือกระตุ้นให้ซื้อ และให้กำลังใจ

      // msg = MainMenu.msg_global_for_potential_customers;
      msg = msgNotBoughtAndroidFromSheets;
      debugPrint("msg for potential customers: $msg");
    } else {
      countDownMsg = examScheduleFromSheets;
      debugPrint("111 countDownMsg from Google Sheets: $countDownMsg");
      debugPrint(
          "111 countDownMsg length from pastebin: ${countDownMsg?.length}");


      // ซื้อแล้ว
      msg = msgBoughtAndroidFromSheets;
      debugPrint("msg for customers: $msg");
    } // end of if
  } // end of scrapData()


  // // use transaction to avoid database locking
  // Future<List<ExamModel>> getDataFromSqlite({String? whatType}) async {
  //   final dbClient = await SqliteDB().db;
  //
  //   // Use transaction for database operation
  //   return await dbClient!.transaction((txn) async {
  //     var result = await txn.rawQuery(
  //       'SELECT * FROM OcscTjkTable WHERE exam_type = ? ORDER BY position',
  //       ["$whatType"],
  //     );

  Future<List<ExamModel>> getDataFromSqlite({String? whatType}) async {
    final dbClient = await SqliteDB().db;
    final prefs = await SharedPreferences.getInstance();

    var result = await dbClient!.rawQuery(
      'SELECT * FROM OcscTjkTable WHERE exam_type = ? ORDER BY position',
      ["$whatType"],
    );

    List<ExamModel> fileData = [];

    // Iterate through the query results and map them to ExamModel
    for (var map in result) {
      // Fetch progress_pic_name from SharedPreferences using file_name
      String fileName = map['file_name']?.toString() ?? '';
      String progressPicName = prefs.getString('progress_image_$fileName') ?? 'p00.png'; // ความก้าวหน้า เก็บไว้ใน SharePref
      debugPrint("progressPicName from sharePref: $progressPicName fileName: $fileName");


      // Create ExamModel, safely converting types
      var examModel = ExamModel(
        id: map['id'] as int? ?? 0,
        menu_name: map['menu_name']?.toString() ?? '',
        file_name: fileName,
        progress_pic_name: progressPicName,
        dateCreated: map['dateCreated'] as int? ?? 1,
        isNew: map['isNew'] as int? ?? 0,
        exam_type: map['exam_type'] as int? ?? 0,
        field_2: map['field_2'] as int? ?? 0,
        position: map['position']?.toString() ?? '',
        open_last: map['open_last']?.toString() ?? '',
        field_5: map['field_5']?.toString() ?? '',
      );

      fileData.add(examModel);
      print('Retrieved for file_name=$fileName, progress_pic_name=$progressPicName, id=${examModel.id}');
    }

    print('Total exams retrieved: ${fileData.length} for exam_type: $whatType');
    return fileData;
  }





  // Future<List<ExamModel>> getDataFromSqlite({String? whatType}) async {
  //   final dbClient = await SqliteDB().db;
  //
  //   var result = await dbClient!.rawQuery(
  //     'SELECT * FROM OcscTjkTable WHERE exam_type = ? ORDER BY position',
  //     ["$whatType"],
  //   );
  //
  //   List<ExamModel> fileData = [];
  //   var examModel = ExamModel(
  //     id: 0,
  //     menu_name: '',
  //     file_name: '',
  //     progress_pic_name: '',
  //     dateCreated: 1,
  //     isNew: 0,
  //     exam_type: 0,
  //     field_2: 0,
  //     position: '',
  //     open_last: '',
  //     field_5: '',
  //   );
  //
  //   // Iterate through the query results and map them to ExamModel
  //   result.forEach((map) {
  //     fileData.add(examModel.fromMap(map));
  //   });

 //   debugPrint("xamapxyz: $fileData");
 //   return fileData;
//    });  // for database transaction -- not use as chatGPT said good for writing to db only.
 // }


  // ถ้ากลับมาใหม่ จากหน้า itemPageView ให้ปรับรูป วงกลมความก้าวหน้า แสดงว่า ทำได้ถึงไหน เสร็จแล้วหรือยัง
  Future onComeBack(dynamic value) async {
    // debugPrint("come back from itemPageView");
 //   await getDataFromSqlite(); // ไปเอาข้อมูล ในตาราง OcscTjkTable
    setState(() {}); // ปรับข้อมูล รูปวงกลม ว่าทำไปได้มากน้อยแค่ไหน
  }

  // ปรับรูปแสดงความก้าวหน้า ให้เป็นเริ่มใหม่ เพราะไฟล์ใหม่
  Future updatePictureIconToStart({String? file_Name}) async {
    final dbClient = await SqliteDB().db;
    // Use transaction for database operation
    return await dbClient?.transaction((txn) async {
      var result = await txn.rawQuery(
          'UPDATE OcscTjkTable SET progress_pic_name = ? WHERE file_name = ?',
          ["p00.png", "$file_Name"]);
    });
  }


  // use transaction to avoid database locking. Thus, make it quicker.
  Future resetPictureIconToStart({required String whatType}) async {
    final dbClient = await SqliteDB().db;
    print("myType in resetPictureIconToStart: $whatType");
    // Use transaction for the update operation
    return await dbClient!.transaction((txn) async {
      int count = await txn.rawUpdate(
        // 'UPDATE OcscTjkTable SET progress_pic_name = ? WHERE exam_type = ?',
        // ["p00.png", "$whatType"]
          'UPDATE OcscTjkTable SET progress_pic_name = ?, open_last = ? WHERE exam_type = ?',
          [
            "p00.png",
            "top",
            "$whatType"
          ] // Ensure the order of values matches the placeholders
      );
      return count;
    });
  }

  @override
  void dispose() {
    debugPrint('Disposing in mainMenu.dart');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final providerModel = Provider.of<ProviderModel>(context, listen: false);

    final provider = Provider.of<ProviderModel>(context, listen: false);

    provider.initPlatformState(); // revenuCat
    bool isBuyFromPlayStore = providerModel.removeAds;

    debugPrint("removeAds in mainMenu isBuyFromPlayStore: $isBuyFromPlayStore");
    // bool isModeDark;
    //  add new
    final theme = Provider.of<ThemeNotifier>(context, listen: false);
    isModeDark = theme.darkTheme;
    bool isBuyFromHash = theme
        .isBoughtFromHashTbl; // เอาข้อมูลจากตาราง ที่ฝากเอาไว้ที่ themeNotifier
    bool isBuyFromPrefer = theme
        .isBoughtFromPref; // เอาข้อมูลจาก sharePref ที่ฝากเอาไว้ที่ themeNotifier
    // exmSchdleIndx = theme.thisExamIndexFromPref;

    debugPrint("isBuyFromHash: $isBuyFromHash");
    debugPrint("isBuyFromPref: $isBuyFromPrefer");
    // debugPrint("exmSchdleIndx in initState: $exmSchdleIndx");

    if (isBuyFromPlayStore == true ||
        isBuyFromHash == true ||
        isBuyFromPrefer == true) {
      abcdAlready = true;
    } else {
      abcdAlready = false;
    }
// end of add new
    debugPrint("abcdAlready isBuyFromPlayStore: $isBuyFromPlayStore");
    debugPrint("abcdAlready isBuyFromHash: $isBuyFromHash");
    debugPrint("abcdAlready isBuyFromPrefer: $isBuyFromPrefer ");
    debugPrint("isBought abcdAlready in mainMenu after checking: $abcdAlready");

    scrapData(); // get message from Sheets -- google drive

  }

  @override
  Widget build(BuildContext context) {
    String? thisMsg = msg;
    debugPrint("thisMsg : $thisMsg");

    // จาก Google Sheets
    String? thisCountDownMsg = examScheduleFromSheets;

    debugPrint("222 countDown thisCountDownMsg: $thisCountDownMsg");

    if (thisCountDownMsg != "null") {
      // อันนี้ ส่งมาจาก main ถ้าไม่มีอินเทอร์เน็ต จะเป็นค่า "null"
      // คือ เป็น String ที่มีคำว่า null
      if (thisCountDownMsg.contains("div") ||
          thisCountDownMsg.contains("error")) {
        // มีคำว่า div ไหม ถ้ามีแสดงว่าไม่ใช่ข้อความที่ถูก ให้ใช้อันนี้แทน
        // เว็บ pastebin ล่ม จะส่ง error code 522 มาให้ ทำให้ ของเราล่มไปด้วย เลยต้องเชคตรงนี้ด้วย
        debugPrint("333 countDownMsg: $countDownMsg");
        // ถ้าข้อมูลจาก pastebin ส่งมาเป็น html ทั้งไฟล์ ให้ใช้ข้อความนี้  ---------------
        List countDownOffLineLst = [
          // ถ้าไม่มีข้อมูลจาก pastebin ให้ใช้ข้อความนี้  ---------------
          ["วันขึ้นปีใหม่ 2567", "1 ม.ค. 2568", "2025-01-01 00:00:01"],
          ["วันสงกรานต์ 2567", "13 เม.ย.. 2567", "2024-04-13 00:00:01"],
          [
            "วันเฉลิมพระชนมพรรษา\nสมเด็จพระนางเจ้าสิริกิติ์ พระบรมราชินีนาถ\nพระบรมราชชนนีพันปีหลวง",
            "12 สิงหาคม ของทุกปี",
            "2024-08-12 00:00:01"
          ],
          [
            "วันนวมินทรมหาราช\nรำลึกถึงในหลวง รัชกาลที่ ๙",
            "13 ตุลาคม ของทุกปี",
            "2024-10-13 00:00:01"
          ],
          ["วันปิยมหาราช", "23 ตุลาคม ของทุกปี", "2024-10-23 00:00:01"],
          //      ["นับถอยหลัง","วันสอบ 3","2023-01-01 00:00:01"],
          //     ["นับถอยหลัง","วันสอบ 4","2023-01-01 00:00:01"],
        ];
        examSchedule = countDownOffLineLst;
      } else {
        // ถ้าเป็นข้อความถูกต้อง ให้ส่งไปแยก เป็นข้อมูล ชนิด TwoDimensionalArray
        examSchedule = convertToTwoDimensionalArray(thisCountDownMsg);
      }
    } else {
      debugPrint("444 countDownMsg ไม่มี: $countDownMsg");
      List countDownOffLineLst = [
        // ถ้าไม่มีข้อมูลจาก pastebin ให้ใช้ข้อความนี้  ---------------
        // ["วันขึ้นปีใหม่ 2567","1 ม.ค. 2567","2024-01-11 00:00:01"],
        // ["วันสงกรานต์ 2567","13 เม.ย.. 2567","2024-04-13 00:00:01"],
        ["นับถอยหลัง", "วันสอบ", "2023-01-01 00:00:01"],
        ["นับถอยหลัง", "วันสอบ", "2023-01-01 00:00:01"],
      ];
      examSchedule = countDownOffLineLst;
    }

    debugPrint("examSchedule after convert: $examSchedule");
    debugPrint("examSchedule length after convert: ${examSchedule.length}");

    String msgToShow = "";
    String? msgToSh = "";
    debugPrint("thisMsg: $thisMsg msg: $msg");
    if (msg != null) {
      // msg ถ้าไม่ใช่ null
      if (msg!.contains("div") || msg!.contains("error")) {
        // ถ้ามีปัญหา ส่งมาเป็น html code หรือ มี error ก็ไม่เอา
        // ถ้าไม่มีข้อมูลจาก pastebin หรือ pastebin is down ให้ใช้ ข้อความ offline ต่อไปนี้
        List<String> msgOffLineLst = [
          "ขอให้ท่านโชคดีในการสอบ",
          "อย่าเพิ่งหยุด จนกว่าคุณจะภูมิใจ",
          "Where there's a will there's a way.\nที่ไหนมีความพยายาม ที่นั่นมีความสำเร็จ",
          "ในท่ามกลางทุกความยาก ย่อมมีโอกาส",
          "Life only has one rule: Never quit.\nชีวิตมีกฎอยู่ข้อเดียว คือ อย่ายอมแพ้",
        ];
        Random random = new Random();
        int ranNum = random.nextInt(msgOffLineLst.length);
        msgToShow = msgOffLineLst[ranNum];
      } else {
        // debugPrint("pastebin is available");
        // ถ้าเกิดว่า ข้อมูลมาไม่ทัน  // ส่งข้อความมาจาก pastebin.com เพื่อว่า สะดวกกว่า ถ้าต้องการแสดง ข้อความใหม่ ๆ ไม่ต้อง upload ขึ้นใน play store ถ้าจะเปลี่ยนข้อความอย่างเดียว
        List<String> msgList = thisMsg!.split("xyz"); // ข่าวสาร คั่นด้วย xyz
        Random random = new Random();
        int ranNum = random.nextInt(msgList
            .length); // from 0 upto จำนวนสมาชิกที่มี included ตัวเลขที่ได้ สูงสุด จะน้อยกว่าจำนวนสมาชิกอยู่ 1 เอาไปเรียกตำแหน่งได้ ไม่มี out of bound
        msgToSh = msgList[ranNum]; //สุ่มข้อความที่ส่งมาจาก pastebin.com
        msgToShow = getNewLineString(msgToSh);
        debugPrint("msgToSh: $msgToSh");
        debugPrint("msgToShow: $msgToShow");
      }
    } else {
//      debugPrint("pastebin is NOT available  ไม่มี อินเทอร์เน็ต");
      // ถ้าไม่มีข้อมูลจาก pastebin ให้ใช้ ข้อความ offline ต่อไปนี้
      List<String> msgOffLineLst = [
        "ขอให้ท่านโชคดีในการสอบ",
        "อย่าเพิ่งหยุด จนกว่าคุณจะภูมิใจ",
        "Where there's a will there's a way.\nที่ไหนมีความพยายาม ที่นั่นมีความสำเร็จ",
        "ในท่ามกลางทุกความยาก ย่อมมีโอกาส",
        "Life only has one rule: Never quit.\nชีวิตมีกฎอยู่ข้อเดียว คือ อย่ายอมแพ้",
      ];
      Random random = new Random();
      int ranNum = random.nextInt(msgOffLineLst.length);
      msgToShow = msgOffLineLst[ranNum];
    }


    Future saveIntegerInSharePref(String whatKey, int schIndx) async {
      SharedPreferences myPref = await SharedPreferences.getInstance();
      await myPref.setInt(whatKey, schIndx);
    }


    Future<int?> retrieveInstallDate() async {
      int? installDateEpoch = await AppUtils.getInstallDateEpochSeconds();
      print("App Installed Date (Epoch Seconds): $installDateEpoch");
      return installDateEpoch;
    }


    int thisIndex; // ไม่ได้ใช้จากที่ส่งมาจาก main.dart
    int thisIndex_for_plus_btn = 0;

    final theme = Provider.of<ThemeNotifier>(context,
        listen: false); // ใช้สำหรับ update ตัวแปร index ด้วย
    //  int thisIndex = examScheduleIndex;
    thisIndex = theme.thisExamIndexFromPref;
    debugPrint(
        "thisIndex from sharePref is NOT null. The value of thisIndex is: $thisIndex");

    debugPrint("thisIndex from exmSchdleIndx: $thisIndex");

    int examScheduleLength = examSchedule.length;
    int indexDummyLength = examScheduleLength;
    debugPrint("examScheduleLength: $examScheduleLength");
    debugPrint("indexDummyLength: $indexDummyLength");

    // กรณีปรับรายการนับถอยหลัง น้อยกว่าเดิม ถ้า index ที่เก็บไว้มากกว่า ก็ให้ไปเริ่มต้นใหม่
    if (thisIndex >= examScheduleLength - 1) {
      // ลบ 1 เพราะ array เริ่มที่ 0
      thisIndex = 0;
    }

    debugPrint("examScheduleLength: ${examSchedule.length}");
    debugPrint("examSchedule: $examSchedule");
    debugPrint("thisIndex -- ตัวปัญหา-- : $thisIndex");
    debugPrint("examSchedule[thisIndex][2]: ${examSchedule[thisIndex][2]}");

    // final String examScheduleDate = "2023-04-04 09:00:00"; // วันที่ - เวลา เริ่มสอบ
    final String examScheduleDate =
    examSchedule[thisIndex][2]; // บรรทัดนี้ บางที error เกี่ยวกับ index

    debugPrint("examSchedule: $examSchedule");
    debugPrint("thisIndex -- ตัวปัญหา-- : $thisIndex");
    debugPrint("examScheduleDate $examScheduleDate");


    whatExam = examSchedule[thisIndex][0];

    debugPrint("tapppppp _minus whatExam: ${examSchedule[thisIndex][1]}");

    // สำหรับ animated text ใต้ชื่อ
    const colorizeColors = [
      Colors.white,
      Colors.greenAccent,
      Colors.white,
      Colors.yellow,
      Colors.red,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 12.0,
      // fontFamily: 'Horizon',
    );

// =======================================================

    final DateTime date3 = DateTime.parse(examScheduleDate);
    int endTime = date3.millisecondsSinceEpoch;

    String pageTitle = title;
    String thisType = myType;
    List thisFileList = fileList;

    int currFileDate;

    return SafeArea(
      minimum: const EdgeInsets.all(1.0),
      child: Scaffold(
          appBar: AppBar(
            //title: Text('$pageTitle'),
            title: Text('เตรียมสอบ ก.พ. ภาค ก. (ป.ตรี)'),
            actions: [
              PopupMenuButton(
                  onSelected: (selectedValue) {
                    //debugPrint(selectedValue);
                    handleClick(selectedValue.toString());
                  },
                  itemBuilder: (BuildContext ctx) =>
                  [
                    const PopupMenuItem(
                        child: Text('Reset ไอคอนหน้าชื่อเมนู'),
                        value: 'reset_circle_icon'),
                    const PopupMenuItem(
                        child: Text('ให้คะแนน App นี้'), value: 'vote'),
                    const PopupMenuItem(
                        child: Text('แชร์กับเพื่อน'), value: 'share'),
                    const PopupMenuItem(
                        child: Text(
                            'ส่งอีเมล ติชม เสนอแนะ หรือแจ้งข้อผิดพลาด'),
                        value: 'sendMyMail'),
                    const PopupMenuItem(
                        child: Text('เกี่ยวกับ'), value: 'about'),
                  ])
            ],
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                color: Theme
                    .of(context)
                    .primaryColorDark,
                //color: Colors.blue[400],
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        '$pageTitle',
                        // style: TextStyle(fontSize: 18.0, color: Colors.white),
                        style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),

                      // สำหรับข้อความใต้ชื่อหัวเรื่องในหน้าเมนู เพื่อโปรโหมดเมนูใดเมนูหนึ่ง
                      if (pageTitle.contains("ทั่วไป"))
                        const Column(
                          children: [
                            Text(
                              "คะแนนเต็ม 100 คะแนน",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // ตัวหนังสือวิ่งด้านบน มีสีหลากสี
                            // AnimatedTextKit(
                            //   animatedTexts: [
                            //     ColorizeAnimatedText(
                            //       //  "คะแนนเต็ม 100 คะแนน",
                            //       'ใหม่!! เพิ่มกระดาษทด สำหรับคิด-คำนวณ',
                            //       textStyle: colorizeTextStyle,
                            //       colors: colorizeColors,
                            //     ),
                            //   ],
                            //   repeatForever:
                            //   true, // This makes the animation loop forever
                            // ),

                          ],
                        )
                      else
                        if (pageTitle.contains("อังกฤษ"))
                          Column(
                            children: [
                              const Text(
                                "คะแนนเต็ม 50 คะแนน",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white70,
                                ),
                              ),
                              AnimatedTextKit(
                                animatedTexts: [
                                  ColorizeAnimatedText(
                                    //  "คะแนนเต็ม 100 คะแนน",
                                    'แนะนำ เมนูคำศัพท์ที่ควรรู้จัก',
                                    textStyle: colorizeTextStyle,
                                    colors: colorizeColors,
                                  ),
                                ],
                                repeatForever:
                                true, // This makes the animation loop forever
                              ),



                            ],
                          )
                        else
                          if (pageTitle.contains("ราชการ"))
                          //
                            Column(
                              children: [
                                const Text(
                                  "คะแนนเต็ม 50 คะแนน",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Center(
                                  child: SizedBox(
                                    width: 250.0,
                                    height: 25.0,
                                    child: DefaultTextStyle(
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.yellow,
                                      ),
                                      child: AnimatedTextKit(
                                        animatedTexts: [
                                          TyperAnimatedText(
                                              'ฟรี ข้อสอบเสมือนจริง 67-68 100++ ข้อ'),
                                          TyperAnimatedText(
                                              'เมนู ข้อสอบเสมือนจริง 67-68 ด้านล่าง'),

                                          // FadeAnimatedText(
                                          //     '    ฟรี!! ข้อสอบเสมือนจริง 2567 (กฎหมาย) เมนู ข้อสอบเสมือนจริง ด้านล่าง'),
                                          //FadeAnimatedText(
                                          //   'ฟรี!! ข้อสอบเสมือนจริง(กฎหมาย)\n(Paper&Pencil และ e-Exam 2567)'),
                                        ],
                                        repeatForever: true,
                                        // pause: const Duration(milliseconds: 1000),
                                        //displayFullTextOnTap: true,
                                        //stopPauseOnTap: true,
                                      ),
                                    ),
                                  ),
                                )
                                // AnimatedTextKit(
                                //   animatedTexts: [
                                //     ColorizeAnimatedText(
                                //       'ฟรี!! ข้อสอบเสมือนจริง 2567 (Paper&Pencil และ e-Exam)',
                                //       textStyle: colorizeTextStyle,
                                //       colors: colorizeColors,
                                //     ),
                                //   ],
                                //   repeatForever:
                                //   true, // This makes the animation loop forever
                                // ),
                              ],
                            )
                          else
                            if (pageTitle.contains("จับเวลา"))
                              AnimatedTextKit(
                                animatedTexts: [
                                  ColorizeAnimatedText(
                                    'ฟรี!! ข้อสอบชุดเต็ม ชุดที่ 1, 2',
                                    textStyle: colorizeTextStyle,
                                    colors: colorizeColors,
                                  ),
                                ],
                                repeatForever:
                                true, // This makes the animation loop forever
                              )
                            // const Text(
                            //   "ฟรี!! ข้อสอบชุดเต็ม ชุดที่ 1, 2",
                            //   style: TextStyle(
                            //     fontSize: 12.0,
                            //     color: Colors.white70,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // )
                            else
                              const Text(""),

                      // // สำหรับ ข้อความใต้ชื่อ เช่น โปรโหมดบางหัวข้อ
                      // pageTitle.contains("ราชการ")
                      //     ?Text("data",
                      //       style: TextStyle(
                      //           fontSize: 16.0,
                      //           color: Colors.white70,
                      //           fontWeight: FontWeight.bold),
                      // )
                      //     :Text(""),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  //color: Colors.blue[700],
                  color: Theme
                      .of(context)
                      .primaryColorDark,
                  border: Border(
                    top: BorderSide(width: 1, color: Colors.white70),
                  ),
                  // color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // <- center items
                  children: [
                    Flexible(
                      flex: 1,
                      // <-- flexible space
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 30),
                        child: GestureDetector(
                            onTap: (thisIndex <= 0)
                                ? null
                                : () {
                              // ถ้าคลิกถึงอันแรกแล้ว ให้ไม่ทำงาน
                              debugPrint(
                                  "thisIndex_pm minus: $thisIndex");
                              debugPrint(
                                  "tapppppp _minus ${examSchedule[thisIndex][0]}");
                              thisIndex--;
                              thisIndex_for_plus_btn = thisIndex;
                              if (thisIndex < 0) {
                                thisIndex = 0;
                              }
                              saveIntegerInSharePref(
                                  "examSchedule", thisIndex);

                              theme.updateExamScheduleIndex();
                              //    theme.getExamScheduleIndex();

                              debugPrint(
                                  "thisIndex (--- minus) after save in sharePref: $thisIndex");
                              //    debugPrint("examSchedule after save in sharePref: ${examSchedule[thisIndex][0]}");
                              // widget.controller.previousPage(
                              // widget.controller.jumpToPage(0);
                              thisIndex_for_plus_btn = thisIndex;
                            },
                            child: (thisIndex <= 0)
                                ? new Image.asset(
                                'assets/images/btn_minus_disabled.png',
                                //   child: new Image.asset('assets/images/go_start.png',
                                width: 25.0,
                                height: 110.0)
                                : new Image.asset('assets/images/btn_minus.png',
                                //   child: new Image.asset('assets/images/go_start.png',
                                width: 25.0,
                                height: 110.0)),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Container(
                        // <-- center
                        alignment: Alignment.center,
                        // color: Colors.blue,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          color: Theme
                              .of(context)
                              .primaryColorDark,
                          border: Border(
                            top: BorderSide(width: 0, color: Colors.white70),
                          ),
                          // color: Colors.white,
                        ),
                        child: Linkify(
                          onOpen: _onOpen,
                          textScaleFactor: 1,
                          // text: myMessage,
                          text: '${examSchedule[thisIndex][0]}',
                          // หน่วยงาน รับสมัคร ...
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                          // style: TextStyle(
                          //     fontSize: 18.0,
                          //     color: Colors.white54,
                          //     fontWeight: FontWeight.bold),

                          linkStyle: const TextStyle(
                            // กำหนดสีของลิงค์
                              fontSize: 14.0,
                              color: Colors.yellowAccent),
                          options: const LinkifyOptions(
                              humanize:
                              false), // ให้แสดงตัวหนังสือ https:// ด้วย ไม่งั้นจะถูกตัดออกไป
                        ),
                        // child: Text(
                        //   '${examSchedule[thisIndex][0]}',
                        //   textAlign: TextAlign.center,
                        //   //whatExam,
                        //   style: TextStyle(fontSize: 16.0, color: Colors.white),
                        // ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      // <-- flexible space
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 30),
                        child: GestureDetector(
                            onTap: (thisIndex >= examSchedule.length - 1)
                                ? null
                                : () {
                              debugPrint(
                                  "thisIndex_pm before plus: $thisIndex");
                              debugPrint(
                                  "thisIndex_pm scheduleLength: ${examSchedule
                                      .length}");
                              debugPrint(
                                  "tapppppp_ plus ${examSchedule[thisIndex][1]}");
                              thisIndex++;
                              thisIndex_for_plus_btn = thisIndex;
                              setState(() {
                                thisIndex_for_plus_btn;
                              });

                              debugPrint(
                                  "thisIndex_pm after plus: $thisIndex");
                              debugPrint(
                                  "thisIndex_pm scheduleLength: ${examSchedule
                                      .length - 1}");
                              if (thisIndex >= examSchedule.length - 1) {
                                // thisIndex = examSchedule.length - 1;
                                thisIndex = 0;
                              }

                              saveIntegerInSharePref(
                                  "examSchedule", thisIndex);
                              theme.updateExamScheduleIndex();
                              //  theme.getExamScheduleIndex();

                              debugPrint(
                                  "thisIndex (plus) after save in sharePref: $thisIndex");
                              debugPrint(
                                  "thisIndex_for_plus_btn (plus) after save in sharePref: $thisIndex_for_plus_btn");
                              debugPrint(
                                  "examSchedule.length-1 after save in sharePref: ${examSchedule
                                      .length - 1}");
                              //   debugPrint("examSchedule after save in sharePref: ${examSchedule[0][0]}");
                            },
                            //child: (thisIndex >= examSchedule.length - 1)

                            child: (thisIndex_for_plus_btn >=
                                examSchedule.length - 1)
                            //child:(5>3)
                                ? new Image.asset(
                                'assets/images/btn_plus_disabled.png',
                                //   child: new Image.asset('assets/images/go_start.png',
                                width: 25.0,
                                height: 110.0)
                                : new Image.asset('assets/images/btn_plus.png',
                                //   child: new Image.asset('assets/images/go_start.png',
                                width: 25.0,
                                height: 110.0)),
                      ),
                      // child: Container(
                      //   alignment: Alignment.centerLeft,
                      //   color: Colors.red,
                      //   child: Text('left'),
                      // ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  color: Theme
                      .of(context)
                      .primaryColorDark,
                  border: Border(
                    top: BorderSide(width: 1, color: Colors.white70),
                  ),
                  // color: Colors.white,
                ),
                child: Center(
                  child: Linkify(
                    onOpen: _onOpen,
                    textScaleFactor: 1,
                    // text: myMessage,
                    text: '${examSchedule[thisIndex][1]}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                    // style: TextStyle(
                    //     fontSize: 18.0,
                    //     color: Colors.white54,
                    //     fontWeight: FontWeight.bold),

                    linkStyle: const TextStyle(
                      // กำหนดสีของลิงค์
                        fontSize: 14.0,
                        color: Colors.yellowAccent),
                    options: const LinkifyOptions(
                        humanize:
                        false), // ให้แสดงตัวหนังสือ https:// ด้วย ไม่งั้นจะถูกตัดออกไป
                  ),
                  // child: Text(
                  //   '${examSchedule[thisIndex][1]}',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //       fontSize: 14.0,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold),
                  //   // style: TextStyle(
                  //   //     fontSize: 20.0,
                  //   //     color: Colors.white70,
                  //   //     fontWeight: FontWeight.bold),
                  // ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  //color: Colors.blue[700],
                  color: Theme
                      .of(context)
                      .primaryColorDark,
                  border: Border(
                    top: BorderSide(width: 1, color: Colors.white70),
                  ),
                  // color: Colors.white,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CountdownTimer(
                        endTime: endTime,
                        widgetBuilder: (_, CurrentRemainingTime? time) {
                          if (time == null) {
                            return Text(
                              '00 : 00 : 00 : 00',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold),
                            );
                          }
                          return Text(
                            '${time.days ?? 00} วัน: ${time.hours ??
                                00} ชั่วโมง: ${time.min ?? 00} นาที: ${time
                                .sec ?? 00} วินาที',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: getDataFromSqlite(whatType: thisType),
                    // ไม่ใช่แล้ว ต้องเอาข้อมูลจาก fileList ที่ส่งเข้ามา ไม่งั้น ตำแหน่งจะเพี้ยนไป
                    // เช่น พอมีการเพิ่มหัวข้อวิชาใหม่ มันไปต่อท้ายเมนูเลย คือ ตำแหน่งใน ฐานข้อมูล มันอยู่ท้าย เพราะเข้าด้วย insert
                    // เลยต้องกลับไปใช้ข้อมูลจาก ที่ส่งเข้ามา ส่วนฐานข้อมูล เอาไว้เชค ใหม่หรือเปล่า เท่านั้น
                    builder: (BuildContext context,
                        //  AsyncSnapshot<List<OcscTjkTable>> snapshot) {
                        AsyncSnapshot<List<ExamModel>> snapshot) {
                      debugPrint("snapshot.hasData:   ${snapshot.hasData}");
                      debugPrint("xxx xxx xx whatType: $thisType");


                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            bool isRedDot = false; // ยกเลิกแสดงจุดแดง -- เอากลับมาใหม่

                            int isClicked_main = snapshot.data![index].field_2;
                            int isNew_main = snapshot.data![index].isNew;

                            if (isClicked_main == 0 && isNew_main == 1){
                              isRedDot = true;
                            }

                            debugPrint("isRedDot in mainMenu: $isRedDot");
                            bool isRedDot_brandNew = false; // ไม่เอาแล้ว

                            String thisFileName = snapshot.data![index]
                                .file_name;
                            String thisMenuName = snapshot.data![index]
                                .menu_name;
                            debugPrint(
                                "snapshot_fileName in ListView.builder: $thisFileName");

                            // Get app install date (not needed for red dot logic, but keeping for your context)
                            final myInstallDate = Provider.of<ThemeNotifier>(
                                context, listen: false);
                            int? dateInstalled = myInstallDate.installDate;
                            print(
                                "App Installed Date ใน mainMenu: $dateInstalled");

                            int isNewFromDatabase = snapshot.data![index]
                                .isNew; // From OcscTjkTable
                            int fileDate = snapshot.data![index].dateCreated;
                            debugPrint(
                                "ในตาราง OcscTjkTable: file: $thisFileName, date: $fileDate, isNew: $isNewFromDatabase");

                            String? curr_file_date = '';
                            if (!thisFileName.contains("label")) {
                              curr_file_date = findFileDateAndPos(
                                examList: thisFileList,
                                fileName: thisFileName,
                              );
                             // int currFileDate;
                              debugPrint(
                                  "fileName: $thisFileName; menu: $thisMenuName; file date: $curr_file_date");

                              if (curr_file_date != null) {
                                currFileDate = int.parse(curr_file_date);
                              } else {
                                currFileDate = 111111; // Default fallback
                              }

                              // Get current date in epoch seconds
                              int currentDateSeconds = (DateTime
                                  .now()
                                  .millisecondsSinceEpoch / 1000).floor();
                              if (thisFileName == "2_th_3_word_order_1.xml") {
                                debugPrint("thisFileName: $thisFileName");
                                debugPrint(
                                    "DateTimeNow_in_Seconds: $currentDateSeconds");
                                debugPrint("currFileDate: $currFileDate");
                              }

                              int dateDiff = ((currentDateSeconds -
                                  currFileDate) / 86400).ceil();
                              debugPrint("dateDiff in mainMenu: $dateDiff");
                            }

                            // Build the Card with red dot if applicable
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                dense: true,
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                //   leading:
                                leading: !snapshot.data![index]
                                    .file_name // ถ้าไม่มีคำว่า label จะเป็นชื่อเมนูให้เลือกคลิก จะมีรูปวงกลม แสดงว่าได้เคยทำไปมากน้อย แค่ไหน แต่ถ้าเป็น label จะไม่แสดงวงกลม ข้างหน้า
                                    .contains('label')
                                    ? SizedBox(
                                  // สำหรับวงกลม แสดงประวัติทำไปกี่มาก-น้อยแล้ว
                                  //  width: 30,
                                  width: 35,
                                  height: 35,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Image.asset(
                                      // ตรงนี้ จะเอารูปวงกลม ประวัติที่เคยทำข้อสอบว่า ทำไปมาก-น้อย แค่ไหน
                                      'assets/images/${snapshot.data![index]
                                          .progress_pic_name}',

                                    ),
                                  ),
                                )
                                    : null,
                                // ไม่แสดงวงกลม ประวัติที่เคยทำมาแล้ว

                                title: snapshot.data![index]
                                    .file_name // ถ้า มีคำว่า label
                                    .contains(
                                    'label') // ถ้ามีคำว่า label แสดงว่าเป็นชื่อหัวข้อ ไม่ใช่ข้อสอบ คลิกไม่ไปไหน
                                    ? snapshot
                                    .data![
                                index] // เชคต่อว่า เป็นหัวข้อหลักหรือเปล่า ถ้าเป็นจะมีคำว่า main
                                    .file_name
                                    .contains('main')
                                    ? isModeDark ==
                                    true // เชคต่อว่า อยู่ในโหมดมืดหรือไม่
                                    ? Text(
                                  // ถ้าอยู่ใน darkMode ปรับสีตัวหนังสือ label main เป็นสีน้ำเงินออ่น
                                  snapshot.data![index].menu_name,
                                  style: const TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF87cefa)),
                                  textAlign: TextAlign.center,
                                )
                                    : Text(
                                  // ถ้าไม่ได้อยู่ใน darkMode สีตัวหนังสือ label main เป็นสีน้ำเงินเข้ม
                                  snapshot.data![index].menu_name,
                                  style: const TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1B3F8B)),
                                  textAlign: TextAlign.center,
                                )
                                    : isModeDark == true
                                    ? Text(
                                  // ถ้าเป็นหัวเรื่องรอง คือไม่มีคำว่า main  เชคต่อไปว่า อยู่โหมดมือ หรือไม่ ถ้าอยู่ ก็เปลี่ยนสีตัวหนังสือเป็นน้ำเงินอ่อน
                                  snapshot.data![index].menu_name,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFadd8e6)),
                                  // color: Colors.brown),
                                  textAlign: TextAlign.center,
                                )
                                    : Text(
                                  // ถ้าไม่อยู่ ในโหมดมืด สีตัวหนังสือเป็นน้ำเงินเข้ม
                                  //  และจัดกลาง ตัวหนา
                                  snapshot.data![index].menu_name,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3232CD)),
                                  textAlign: TextAlign.center,
                                )
                                    : (isRedDot ==
                                    true // ถ้าเป็นไฟล์ใหม่ หรือมีการปรับปรุง โดยเชคกับ ฐานข่้อมูล
                                    ? Text.rich(
                                  //เอาจุดแดงมาไว้ข้างหลังชื่อเมนู ต้องใช้ Text.rich เพื่อแสดงสี ที่ต่างกัน
                                  TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: snapshot
                                              .data![index].menu_name,
                                          // style: TextStyle(
                                          //     fontSize: 20.0,
                                          //     color: Colors.black)),
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodyMedium),
                                      const TextSpan(
                                        text: ' \u25CF', // จุด
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.red, // สีแดง
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '',
                                        //' [มีข้อใหม่]', // ข้อความหลังจุด  // เอาออกดีกว่า
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.red, // สีแดง
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : (isRedDot_brandNew ==
                                    true // ถ้าเป็นไฟล์ใหม่ทั้งหมด ที่เพิ่มมาใหม่
                                    ? Text.rich(
                                  //เอาจุดแดงมาไว้ข้างหลังชื่อเมนู ต้องใช้ Text.rich เพื่อแสดงสี ที่ต่างกัน
                                  TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: snapshot
                                              .data![index]
                                              .menu_name,
                                          // style: TextStyle(
                                          //     fontSize: 20.0,
                                          //     color:
                                          //         Colors.black)),
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodyMedium),
                                      const TextSpan(
                                        text: ' \u25CF', // จุด
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color:
                                          //Colors.green, // สีเขียว
                                          Colors.red, // สีแดง
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '',
                                        // ' [ใหม่ทั้งชุด]', // วงเล็บต่อท้ายเมนู // เอาข้อความออกดีกว่า
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color:
                                          Colors.green, // สี
                                          fontWeight:
                                          FontWeight.bold,
                                          fontStyle:
                                          FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : Text(
                                  // ตัวปกติ
                                    snapshot.data![index].menu_name,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyMedium
                                  // style: TextStyle(
                                  //     fontSize: 20.0,
                                  //     //    fontWeight: FontWeight.bold,
                                  //     color: Colors.black),
                                ))),
                                onTap: () {
                                  debugPrint(
                                      "fileName tapped: ${snapshot.data![index]
                                          .file_name}");

                                  // ไปเอจุดแดงใน เมนูนี้ (ถ้ามี) ออก
                                  String thisFName = snapshot.data![index]
                                      .file_name;

                                  // ไปเอาวันที่ในตัวแปรที่ส่งเข้ามาใน main.dart โดยไปเอามาจาก thisFileList ซึ่งเก็บข้อมูลไฟล์ทั้งหมด ที่่พิมพ์(hard codeing) ใน Main.dart

                                  String? thisDateInMain = findFileDateAndPos(examList: thisFileList, fileName: thisFileName);
                                  int? thisDateInMainVariable = int.parse(thisDateInMain!);
                                  debugPrint("before removeRedDot - fileName: $thisFName dateFromVar: $thisDateInMainVariable");
                                  removeRedDotAfterMenuName(thisFName, thisDateInMainVariable);

                                  if (snapshot.data![index].file_name
                                      .contains('xml')) {
                                    // debugPrint(
                                    //     "abcdef fileName xml: ${snapshot.data[index].file_name}");
                                    Route route = MaterialPageRoute(
                                      // ส่วนนี้ เพื่อส่งไป เมื่อกลับมา จะเรียกให้ปรับข้อมูลใหม่
                                      // คือไปเอาข้อมูลจาก ฐานข้อมูล ข้อสุดท้ายว่าทำถึงไหน ซึ่งปรับโดย itemPageView แล้วมาแสดงความก้าวหน้า รูปวงกลม ใน leading ของ listTile
                                      // from:  https://www.nstack.in/blog/flutter-refresh-on-navigator-pop-or-go-back/
                                      builder: (context) =>
                                          ItemPageView(
                                            // ส่งไปหน้า ItemPageView พร้อมทั้งข้อมูล เช่น ชื่อไฟล์
                                            myExams:
                                            snapshot.data![index].file_name,
                                            // ชื่อไฟล
                                            title: snapshot.data![index]
                                                .menu_name,
                                            // ชื่อเมนู
                                            createDate: curr_file_date
                                                .toString(),
                                            // วันที่ของไฟล์ที่ส่งเข้ามา
                                            // createDate: snapshot
                                            //     .data[index].dateCreated // วันที่เก่า ในฐานข้อมูล
                                            //     .toString(), // วันที่
                                            msg: msgToShow,
                                            //ส่งข่่าวสาร จาก pastebin ให้กำลังใจ ไปด้วย
                                            buyStatus: abcdAlready,
                                            currPageNum: 0,
                                            currQstnNum: 0,
                                            numOfQstn: 0,
                                          ),
                                    );
                                    Navigator.push(context, route).then(
                                        onComeBack); // ตอนกลับมา ให้เรียกใช้ onComeBack
//    }

                                    // ถ้ายังไม่ซื้อ ไมให้ทำข้อสอบ ชุดลองทำทั้งหมด
                                    // ยกเลิก ให้ทำดีกว่า เพราะมีคนสงสัย หาปุ่มซื้อไม่เจอ เพราะหน้านี้ ไม่มีปุ่มซื้อ
                                    // } else if (snapshot.data[index].file_name
                                    //         .contains('full') &&
                                    //     abcdAlready == false) {
                                    //    ();
                                    //                               }else if(snapshot.data![index].file_name
                                    //                                     .contains('answer') && (abcdAlready == false)) {
                                    //                                   _showNotAvailable(context);
                                  } else if (snapshot.data![index].file_name
                                      .contains('html')) {
                                    // debugPrint(
                                    //     "abcdef fileName html: ${snapshot.data[index].file_name}");
                                    Route route = MaterialPageRoute(
                                      //builder: (context) => HtmlPageView(
                                      builder: (context) =>
                                          HtmlPageView_inappWebView(
                                            // ส่งไปหน้า HtmlPageView พร้อมทั้งข้อมูล เช่น ชื่อไฟล์
                                            myExams:
                                            snapshot.data![index].file_name,
                                            // ชื่อไฟล
                                            title: snapshot.data![index]
                                                .menu_name,
                                            // ชื่อเมนู
                                            createDate: curr_file_date
                                                .toString(),
                                            // วันที่ของไฟล์ที่ส่งเข้ามา
                                            // createDate: snapshot
                                            //     .data[index].dateCreated // วันที่เก่า ในฐานข้อมูล
                                            //     .toString(), // วันที่
                                            msg: msgToShow,
                                            //ส่งข่่าวสาร จาก pastebin ให้กำลังใจ ไปด้วย
                                            buyStatus: abcdAlready,
                                            currPageNum: 0,
                                            currQstnNum: 0,
                                            numOfQstn: 0,
                                          ), //HtmlPageView
                                    );
                                    Navigator.push(context, route).then(
                                        onComeBack); // ตอนกลับมา ให้เรียกใช้ onComeBack
                                  } else if (snapshot.data![index]
                                      .file_name // pdf ยังไม่ทำงาน เอาออกไปก่อน
                                      .contains('pdf')) {
                                    debugPrint(
                                        "before sending to pdf: ${snapshot
                                            .data![index].file_name}");
                                    Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          PdfView(
                                            myExams:
                                            snapshot.data![index].file_name,
                                            title: snapshot.data![index]
                                                .menu_name,
                                            createDate: curr_file_date
                                                .toString(),
                                            msg: msgToShow,
                                          ),
                                    );
                                    Navigator.push(context, route)
                                        .then(onComeBack);

                                    // ============
// เปิดหน้าแสดงชื่อ วิดีโอ กฎหมาย ให้เลือก เมื่อคลิกจะไปเล่นวิดีโออีกหน้า

                                  } else if (snapshot.data![index]
                                      .file_name //
                                      .contains(
                                      'youtube_law')) { // สำหรับ youTube
                                    debugPrint(
                                        "before open youTube: ${snapshot
                                            .data![index].file_name}");
                                    Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          VideoList(
                                            // myExams:
                                            // snapshot.data![index].file_name,
                                            myPageName: snapshot.data![index]
                                                .menu_name,
                                            createdDate: curr_file_date
                                                .toString(),
                                            msgToShow: msgToShow,
                                          ),
                                    );
                                    Navigator.push(context, route)
                                        .then(onComeBack);
                                  } else if (snapshot.data![index]
                                      .file_name //
                                      .contains(
                                      'youtube_math')) { // สำหรับ youTube
                                    debugPrint(
                                        "before open youTube: ${snapshot
                                            .data![index].file_name}");
                                    Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          VideoListMath(
                                            // myExams:
                                            // snapshot.data![index].file_name,
                                            myPageName: snapshot.data![index]
                                                .menu_name,
                                            createdDate: curr_file_date
                                                .toString(),
                                            msgToShow: msgToShow,
                                          ),
                                    );
                                    Navigator.push(context, route)
                                        .then(onComeBack);


                                    // เปิดวิดีโอจาก youTube เรียกจาก video_list.dart
                                    // แต่เวลากลับออกมา มี error
                                    // E/chromium( 7475): [ERROR:aw_browser_terminator.cc(166)] Renderer process (8160) crash detected (code -1).
// เลยยังไม่เอาดีกว่า

                                    // } else if (snapshot.data![index]
                                    //     .file_name // pdf ยังไม่ทำงาน เอาออกไปก่อน
                                    //     .contains('?v=')) { // สำหรับ youTube
                                    //   debugPrint(
                                    //       "before open youTube: ${snapshot.data![index].file_name}");
                                    //   Route route = MaterialPageRoute(
                                    //     builder: (context) => VideoList(
                                    //       // myExams:
                                    //       // snapshot.data![index].file_name,
                                    //    //   title: snapshot.data![index].menu_name,
                                    //       createdDate: curr_file_date.toString(),
                                    //      msgToShow: msgToShow,
                                    //     ),
                                    //   );
                                    //   Navigator.push(context, route)
                                    //       .then(onComeBack);
                                    //


                                    //===================

                                    // เปิดวิดีโอจาก youTube เรียกจาก youTubePageView.dart ส่ง url เขามา
                                    //               } else if (snapshot.data![index].file_name
                                    //                   .contains('?v=')) {
                                    //                 debugPrint(
                                    //                     "before sending to vdo: ${snapshot.data![index].file_name}");
                                    //                 // List vdo_id = snapshot.data[index].file_name
                                    //                 //     .split('?v=');
                                    //                 //String thisVideoID = vdo_id[1];
                                    //                 String thisVideoID =
                                    //                     YoutubePlayer.convertUrlToId(
                                    //                         snapshot.data![index].file_name) ?? "";
                                    //                 debugPrint("video_id: $thisVideoID");
                                    //                 Route route = MaterialPageRoute(
                                    //                   //  builder: (context) => YouTubePlayer(
                                    //                   builder: (context) => YouTubePageView(
                                    //                     fileName_youtube_url:
                                    //                         snapshot.data![index].file_name,
                                    //                     myExams: snapshot.data![index].file_name,
                                    //                     title: snapshot.data![index].menu_name,
                                    //                     videoID: thisVideoID,
                                    //                     msg:
                                    //                         msgToShow, //ส่งข่่าวสาร จาก pastebin ให้กำลังใจ ไปด้วย
                                    //                     //buyStatus: abcdAlready,
                                    //                     createDate: snapshot
                                    //                         .data![index].dateCreated
                                    //                         .toString(),
                                    //                   ),
                                    //                 );
                                    //                 Navigator.push(context, route)
                                    //                     .then(onComeBack);
                                  }
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ],
          )),
    );
    //   );
  }

  Future<void> handleClick(String value) async {
    switch (value) {
      case 'sendMyMail':
        final Uri params = Uri(
          scheme: 'mailto',
          path: 'thongjoon@gmail.com',
          query:
          'subject=หัวข้อเรื่อง (โปรดระบุ)&body=สวัสดีครับ/ค่ะ', //add subject and body here
        );

        var url = params;
        if (canLaunchUrl(url) != null) {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw 'Could not launch $url';
        }
        break;

      case 'reset_circle_icon':
        resetPictureIconToStart(whatType: myType);
        setState(() {});
        break;

      case 'vote':
        if (Platform.isAndroid) {
          Utils.openLink(
              url:
              'https://play.google.com/store/apps/details?id=com.thongjoon.ocsc_exam_prep');
        } else if (Platform.isIOS) {
          // iOS-specific code
          Utils.openLink(
              url:
              'https://apps.apple.com/app/เตร-ยมสอบ-กพ-ภาค-ก/id1622156979');
        }

        break;
      case 'share':
        Share.share(
            "แนะนำ แอพเตรียมสอบ กพ ใช้ได้ทั้ง Android และ iPhone ดาวโหลดที่ Play Store และ App Store");
        break;
      case 'about':
        openAboutDialog();
        break;
    }
  }

  void openAboutDialog() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new aboutDialog();
        },
        fullscreenDialog: true));
  }

  _showMaterialDialog(String msg) {
    showDialog(
        context: context,
        builder: (_) =>
        new AlertDialog(
          title: new Text("Material Dialog"),
          content: new Text(msg),
          actions: <Widget>[
            TextButton(
              child: Text('Close me!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }


  String? findFileDateAndPos(
      {required List examList, required String fileName}) {
    debugPrint(
        "examList: ${examList.toString()} fileName in findFileDate: $fileName");
    for (var i = 0; i < examList.length; i++) {
      if (examList[i][1] == fileName) {
        String thisDate = examList[i][2].toString(); // Ensure it's a String
        debugPrint(
            "findFileDate fileName in findFileDateAndPos: $fileName date: $thisDate");
        return thisDate;
      }
    }
    return null;
  }

  Future<bool> getAppMode() async {
    var thisData;
    var currMode;
    String modeName = "appMode";
    bool isDarkMode;
    final dbClient = await SqliteDB().db;
    var result = await dbClient!
        .rawQuery('SELECT * FROM hashTable WHERE name = "$modeName"');
    if (result.isNotEmpty) {
      thisData = result.first["str_value"];
      if (thisData == "light") {
        isDarkMode = false;
      } else {
        isDarkMode = true;
      } // end of if (thisData ==
      currMode = isDarkMode;
    } else {
      currMode = false;
    } // end of if (result.isNotEmpty)
    //   debugPrint("appMode from hashTBL: $currMode");
    return currMode;
  }

  void updateIsPositionInOcscTjkTable(
      {required String file_Name, required String thisPos}) async {
    final dbClient = await SqliteDB().db;
    int count = await dbClient!.rawUpdate(
        'UPDATE OcscTjkTable SET position = ? WHERE file_name = ?',
        ['$thisPos', "$file_Name"]);
  }

  Future<int?> getExamScheduleIndex(String key_to_check) async {
    debugPrint("keyToCheck after sending: $key_to_check");
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? thisIndx = pref.getInt(key_to_check);
    debugPrint("return value (previousQstnNum): $thisIndx");
    return thisIndx;
  }

  String getNewLineString(String msgToSh) {
    // ข้อความใน pastebin.com ถ้าจะให้ขึ้นบรรทัดใหม่ ให้คั่นด้วย &&& เพื่อบอกว่าขึ้นบรรทัดใหม่
    if (msgToSh.contains("&&&")) {
      List<String> newStList = msgToSh.split("&&&");
      StringBuffer sb = new StringBuffer();
      for (var i = 0; i < (newStList.length); i++) {
        if (i < (newStList.length) - 1) {
          sb.write(newStList[i] + "\n");
        } else {
          sb.write(newStList[i]);
          // ตัวสุดท้าย ไม่ต้องใส่เครื่องขึ้นบรรทัดใหม่ ไม่งั้น จะมีบรรทัดว่างเป็นบรรทัดสุดท้าย
        }
      }
      return sb.toString();
    } else {
      return msgToSh;
    }
  }

  // chatGPT ช่วยเขียน function นี้ให้  สำหรับ ข้อมูลนับถอยหลัง ที่เอามาจาก pastebin
  List<List<String>> convertToTwoDimensionalArray(String input) {
    // convert string to 2D array with new line
    // xyz สำหรับคั่นแต่ละเรื่องที่นับถอยหลัง
    // _X_ สำหรับคั่นระหว่างข้อความ และ ในแต่ละข้อความ ถ้ามี &&& ให้ขึ้นบรรทัดใหม่
    List<List<String>> result = [];
    List<String> currentRow = [];

    List<String> arrays = input.split("xyz");

    for (String arrayString in arrays) {
      List<String> lines = arrayString.split("_X_");
      for (String line in lines) {
        currentRow.add(line.replaceAll("&&&", "\n").trim());
      }
      result.add(List.from(currentRow));
      currentRow.clear();
    }

    return result;
  }


  Future<void> _onOpen(LinkableElement link) async {
    debugPrint("this link: $link");
    // สำหรับ link ในข้อความ
    Uri thisLink = Uri.parse(link.url); // แปลง LinkableElement เป็น Uri
    debugPrint("this link: $thisLink");


    if (link != null) {
      debugPrint("OK: The link is not null");
      if (await canLaunchUrl(thisLink)) {
        // await launchUrl(thisLink);
        await launchUrl(thisLink, mode: LaunchMode.externalApplication);
        //  inAppWebView);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            //content: Text('ไม่สามารถเปิด: ${link.url} \nกรุณาตรวจสอบ Default browser app บนมือถือของท่าน'),
            content: Text(
                'เปิดลิงค์ไม่ได้ \nกรุณาตรวจสอบ Default browser app บนมือถือของท่าน'),
            duration:
            Duration(seconds: 8), // Optional: Adjust duration as needed
          ),
        );
        throw 'Could not launch $link';
      }
    } else {
      debugPrint("Error: The link is null");
    }
  } // end of _onOpen

  Future<bool> checkItemTbl(String thisFileName) async {
    final dbClient = await SqliteDB().db;
    // Check if there’s at least one row with isNew = "1" for this file
    var result = await dbClient!.rawQuery(
      'SELECT COUNT(*) FROM itemTable WHERE file_name = ? AND isNew = ?',
      [thisFileName, "1"],
    );
    int count = Sqflite.firstIntValue(result) ?? 0;
    debugPrint("fileName: $thisFileName, count of isNew = '1': $count");
    // Return true if isNew = "1" exists, false otherwise
    return count > 0;
  }

  // ถ้ายังไม่คลิกเข้าเมนู จุดแดงจะยังไม่ลบ เพราะ วันที่ยังไม่เปลี่ยน
  void removeRedDotAfterMenuName(String thisFName, int dateFromMainVar) async {
    var myDbClient = await SqliteDB().db;
    print("inside removeRedDotAfterMenuName thisFName: $thisFName dateToAddToOcscTjkTable: $dateFromMainVar");
    await myDbClient?.transaction((
        txn) async { // field_2 คือ คลิกเมนูนี้แล้วหรือยัง 0 =  ยัง , 1 = คลิกแล้ว สำหรับกำหนดจุดแดง ถ้าคลิกแล้ว เอาจุดแดงออก
      await txn.rawUpdate('''
        UPDATE OcscTjkTable SET field_2 = ?,
            isNew = ?, dateCreated = ?
        WHERE file_name = ?
        ''', [1, 0, dateFromMainVar, thisFName]);
    });
  }

 // // int getDateFromMenuInMain(String thisFName) {}
 //  int? getDateFromMenuInMain(String firstElement, fileList) {
 //    for (var sublist in fileList) {
 //      if (sublist[0] == firstElement) {
 //        return int.parse(sublist[2]);
 //      }
 //    }
 //    return null; // Return null if no match is found
 //  }

}  // end of class MainMenuState extends State<MainMenu>



void _showNotAvailable(BuildContext context) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: const Text('เฉลย เฉพาะรุ่นเต็ม (Full Version) นะครับ'),
      backgroundColor: Colors.deepOrange,
      action: SnackBarAction(
          label: 'CLOSE', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
} // end of _loadFromSqlite

_saveBuyStatusInHashTable(bool buyStatus) async {
//  debugPrint("sqlDate update date to: $create_date");
  final dbClient = await SqliteDB().db;
  await dbClient!.rawInsert(
      'INSERT INTO hashTable (name, str_value) VALUES("sku", $buyStatus)');
}

_saveBuyStatusInSharePref(bool buyStatus) async {
  SharedPreferences myPref = await SharedPreferences.getInstance();
  await myPref.setBool('sku', buyStatus);
}

// void updateIsNewAndDateOfOcscTjkTable(
//     {required String file_Name, required int create_date}) async {
//   debugPrint("sqlDate update date to: $create_date");
//   final dbClient = await SqliteDB().db;
//   int count = await dbClient!.rawUpdate(
//       'UPDATE OcscTjkTable SET isNew = ?, dateCreated = ? WHERE file_name = ?',
//       [1, create_date, "$file_Name"]);
// }

Column _buildBottomNavigationMenu() {
  return Column(
    children: <Widget>[
      if (Platform.isAndroid) ...[
        const SizedBox(
          width: 5,
          height: 20,
        ),
        const Text(
          'ทดลองทำข้อสอบเสมือนจริง\nมีเฉพาะรุ่นเต็ม',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 25,
          height: 15,
        ),
        const Text(
          'ลงทุนเพื่ออนาคต เพียง 199 บาท เท่านั้น',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 15,
          height: 15,
        ),
        const Text(
          'สามารถจ่ายผ่าน',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'สแกนจ่ายบนมือถือ, บัตรเครดิต, TrueMoney, LinePay, และ อื่น ๆ ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'ซื้อครั้งเดียว ใช้ได้ตลอด ฟรี อัพเดท!! คุ้มกว่าเยอะ ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ] else if (Platform.isIOS) ...[
        const SizedBox(
          width: 5,
          height: 20,
        ),
        const Text(
          'ทดลองทำข้อสอบเสมือนจริง\nมีเฉพาะรุ่นเต็ม',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 25,
          height: 15,
        ),
        const Text(
          'ลงทุนเพื่ออนาคต เพียง 199 บาท เท่านั้น\nซื้อครั้งเดียว ใช้ได้ตลอด\nฟรี อัพเดท!!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]
    ],
  );
}
//
