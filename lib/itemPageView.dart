
import 'dart:async'; // สำหรับให้ตัวหนังสือ มีลิงค์ได้
import 'dart:io' show Platform;
// import 'package:flutter_math_fork/flutter_math.dart' as Math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

//import 'package:flutter_html_math/flutter_html_math.dart';
import 'package:flutter_math_fork/flutter_math.dart';
//import 'package:flutter_html_table/flutter_html_table.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_linkify/flutter_linkify.dart'; // สำหรับให้ตัวหนังสือ มีลิงค์ได้
//import 'package:katex_flutter/katex_flutter.dart';
import 'package:ocsc_exam_prep/exam.dart'; //  รูปแบบโครงสร้างข้อสอบ
import 'package:ocsc_exam_prep/paymentScreen.dart';
import 'package:ocsc_exam_prep/theme.dart';
import 'package:ocsc_exam_prep/utils.dart';

// import 'package:package_info/package_info.dart'; // สำหรับ เรียก version และชื่อ
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart'; // สำหรับ อ่านข้อมูล xml

// สำหรับตรวจว่า เป็น android หรือ iphone จะได้ส่งลิงค์ไปให้คะแนน ถูกเว็บ
import 'ProviderModel.dart';
import 'aboutDialog.dart';
import 'drawingDialog.dart';
import 'explanation.dart'; // สำหรับให้ตัวหนังสือ มีลิงค์ได้
//import 'noteAppLauncher.dart';
import 'sqlite_db.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ItemPageView extends StatefulWidget {
  final String myExams;
  final String
  createDate; // สำหรับวันที่ ของไฟล์ที่ส่งเข้า จะเอาไป update ในฐานข้อมูล ถ้า
  // คลิกข้อใหม่หมดแล้ว ทุกข้อ  -- คือ ต้องคลิกข้อใหม่หมดทุกข้อ จึงเอาจุดแดงออกจากหน้าเมนู
  final String title;
  final int currPageNum;
  final int currQstnNum;
  final int numOfQstn;
  final String msg;
  final bool buyStatus;

  ItemPageView(
      {Key? key,
        required this.myExams,
        required this.title,
        required this.currPageNum,
        required this.currQstnNum,
        required this.numOfQstn,
        required this.createDate,
        required this.msg,
        required this.buyStatus})
      : super(key: key);

  @override
  _PageViewCustomState createState() => _PageViewCustomState();
}

class _PageViewCustomState extends State<ItemPageView> {
  @override
  void dispose() {
    _saveProgressPicName(picName, widget.myExams);
    _savePageNumber(_currPageNum, widget.myExams);

    _pageController.dispose();
    super.dispose();
  }

  late List<Exam> items;

  late String _myExams;
  late String _title;
  late int _currPageNum;
  late int _currQstnNum;
  late int _numOfQstn;
  late String _createDate;
  late String _messageToShow;
  late bool _buyStatus;

  // สำหรับตรวจสถานะการซื้อ ว่า ซื้อแล้วหรือยัง จะได้เอาเป็นเงื่อนไขการแสดงปุ่มซื้อ
  late SharedPreferences buyStatus;
  late bool isBoughtAlready;
  late bool isBought;

  bool ActiveConnection = false;

  PageController _pageController = PageController();
  PageController myController = PageController();

  int ocscAppInstallDate = 111111;

  String get picName => picName;  // เอาไปใช้ ตอน Dispose

  @override
  initState() {
    super.initState();

    // Retrieve page number from SharedPreferences
    _getPageNumber();

    _myExams = widget.myExams; // ชื่อไฟล์ ที่ส่งเข้ามาจากหน้า mainMenu
    _title = widget.title; //ชื่อหัวข้อ ที่ส่งเข้ามาจากหน้า mainMenu
    _createDate = widget.createDate; // วันที่ที่ส่งเข้ามาจากหน้า mainMenu
    _messageToShow = widget.msg; // ข่าวสาร
    _buyStatus = widget.buyStatus; // ซื้อหรือยัง

    debugPrint("enter initState of itemPageView");

    CheckUserConnection();

    final provider = Provider.of<ProviderModel>(context, listen: false);

    provider.initPlatformState();
    debugPrint(
        "offering from provider -- caling from itemPageView: ${provider.offering}");
    debugPrint(
        "removeAds from provider -- caling from itemPageView:  ${provider.removeAds}");

    debugPrint(
        "ชื่อไฟล์  ใน initState: $_myExams วันที่: $_createDate ซื้อหรือยัง buyStatus in itemPageView: $_buyStatus");
    debugPrint("buyStatus from mainMenu - itemPageView (isBought): $_buyStatus");

    if (_buyStatus == false) {
      setState(() {
        _buyStatus = provider.removeAds;
      });
      debugPrint(
          "_buyStatus (isBought ส่งมาจาก Provider โดย เอามาจาก removeAds และ sku ในตาราง hashTable และ sharePref $_buyStatus");
    }

    // ไปเอาวันที่ติตตั้งแอพ จากใน sharePref
    final myInstallDate = Provider.of<ThemeNotifier>(context, listen: false);
    int dateInstalled = ((myInstallDate.installDate)! / 1000).round();
    debugPrint("install at: $dateInstalled");
    ocscAppInstallDate = dateInstalled;

    // เชค future:
    insertOrUpdateTableRow(fileName: _myExams, appInstallDate: ocscAppInstallDate);
  }

  Future<void> _getPageNumber() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currPageNum = prefs.getInt('last_page_${widget.myExams}') ?? 0;
      _pageController = PageController(initialPage: _currPageNum);
      _pageController.addListener(() {
        final newPage = _pageController.page?.round() ?? _currPageNum;
        if (newPage != _currPageNum) {
          _currPageNum = newPage;
          _savePageNumber(_currPageNum, widget.myExams);
         // _saveProgressPicName(pic_name, widget.myExams)
        }
      });
      debugPrint('Retrieved page $_currPageNum for file ${widget.myExams}');
    } catch (e) {
      debugPrint('Error retrieving page number: $e');
      _currPageNum = 0;
      _pageController = PageController(initialPage: _currPageNum);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMath = false;

    if (widget.myExams.contains("num") ||
        widget.myExams.contains("math") ||
        widget.myExams.contains("cndtng") ||
        widget.myExams.contains("thai_conclusion") ||
        widget.myExams.contains("ocsc_answer")) {
      isMath = true;
    } else {
      isMath = false;
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        debugPrint("Back button is pressed.");
        debugPrint("หน้าปัจจุบัน $_currQstnNum");
        debugPrint("หน้าทั้งหมด $_numOfQstn");
        debugPrint("ชื่อไฟล์ ใน Willpopscope   $_myExams");
        debugPrint("วันที่ : $_createDate");

        double progress = _currQstnNum / _numOfQstn * 100;

        int myProgress;
        if (progress > 50) {
          myProgress = progress.floor();
        } else {
          myProgress = progress.ceil();
        }

        String picName;
        debugPrint("myProgress: $myProgress");
        if (myProgress >= 100) {
          picName = "p100.png";
        } else if (myProgress >= 90) {
          picName = "p90.png";
        } else if (myProgress >= 80) {
          picName = "p80.png";
        } else if (myProgress >= 70) {
          picName = "p70.png";
        } else if (myProgress >= 60) {
          picName = "p60.png";
        } else if (myProgress >= 50) {
          picName = "p50.png";
        } else if (myProgress >= 40) {
          picName = "p40.png";
        } else if (myProgress >= 30) {
          picName = "p30.png";
        } else if (myProgress >= 20) {
          picName = "p20.png";
        } else if (myProgress >= 1) {
          picName = "p10.png";
        } else {
          picName = "p00.png";
        }

        debugPrint("aaxx file name to check for isNew: $_myExams");
        int fileDate = int.parse(_createDate);

       // await _savePageNumber(_currPageNum, widget.myExams);
        debugPrint("picName before saving to sharePrefs: $picName");
        await _saveProgressPicName(picName, widget.myExams);

        debugPrint("whatFileName: $_myExams, whatDate: $fileDate");
        checkAndActOnIsNewOfOcscTjkTable(
            whatFileName: _myExams, whatDate: fileDate);

        var dbClient = await SqliteDB().db;

        var queryResult = await dbClient!.rawQuery(
            """ SELECT * FROM OcscTjkTable WHERE file_name = '$_myExams'; """);
        debugPrint("queryResult: $queryResult");
        debugPrint("picName: $picName");

        if (queryResult.isNotEmpty) {
          updateFileCreateDate(
              fileName: _myExams, createdDate: fileDate, picName: picName);
        }

        clearSharedDrawingData();

        return Future.value(true);
      },
      child: SafeArea(
        minimum: const EdgeInsets.all(1.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'เตรียมสอบ ก.พ. ภาค ก.',
            ),
            centerTitle: true,
            elevation: 0,
            actions: [
              GestureDetector(
                onTap: () => _showDrawingWindow(context),
                child: (isMath)
                    ? const Icon(
                  Icons.edit_note,
                  size: 30.0,
                )
                    : const Visibility(
                  child: Icon(
                    Icons.help_outline,
                    size: 26.0,
                  ),
                  visible: false,
                ),
              ),
              PopupMenuButton(
                  onSelected: (selectedValue) {
                    handleClick(selectedValue.toString());
                  },
                  itemBuilder: (BuildContext ctx) => [
                    const PopupMenuItem(
                        child: Text('ให้คะแนน App นี้'), value: 'vote'),
                    const PopupMenuItem(
                        child: Text('แชร์กับเพื่อน'), value: 'share'),
                    const PopupMenuItem(
                        child: Text(
                            'ส่งอีเมล ติชม เสนอแนะ หรือแจ้งข้อผิดพลาด'),
                        value: 'sendMyMail'),
                    const PopupMenuItem(child: Text('เกี่ยวกับ'), value: 'about'),
                  ])
            ],
          ),
          body: FutureBuilder(
            future: getExamDataFromXML(context),
            builder: (context, data) {
              debugPrint(
                  "_buyStatus (isBought ส่งมาจาก mainMenu โดย เอามาจาก sku ในตาราง hashTable และ sharePref $_buyStatus");
              String myMessage = "แสดงข่าวสาร หน้า itemPageView";

              if (data.hasData) {
                List<Exam> items = data.data as List<Exam>;
                debugPrint("itemssss: $items");
                debugPrint("buyStatus - isBought เงื่อนไขแสดงปุ่มซื้อ: $_buyStatus");
                final isDarkMode =
                    Provider.of<ThemeNotifier>(context, listen: false)
                        .darkTheme;
                debugPrint("isShowAns in itemPageView: $isDarkMode");
                debugPrint("isBought in itemPageView: $_buyStatus");
                final _isFirstRun =
                    Provider.of<ThemeNotifier>(context, listen: false)
                        .isFirstRun;
                debugPrint("isFirstRun in itemPageView: $_isFirstRun");
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        border: const Border(
                          top: BorderSide(width: 1, color: Colors.white70),
                        ),
                      ),
                      child: Linkify(
                        onOpen: _onOpen,
                        textScaleFactor: 1,
                        text: _messageToShow,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14.0, color: Colors.white),
                        linkStyle: const TextStyle(
                            fontSize: 14.0, color: Colors.yellowAccent),
                        options: const LinkifyOptions(humanize: false),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        border: const Border(
                          top: BorderSide(width: 1, color: Colors.white70),
                        ),
                      ),
                      child: Text(
                        "$_title",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        border: const Border(
                          top: BorderSide(width: 1, color: Colors.white70),
                          bottom: BorderSide(width: 1, color: Colors.black45),
                        ),
                      ),
                      child: !(_buyStatus)
                          ? SizedBox(
                        height: 38,
                        width: 120,
                        child: TextButton(
                          child: Text(
                            'วิธีซื้อรุ่นเต็ม',
                            style: TextStyle(
                              fontFamily: 'Athiti',
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.blue[900],
                            ),
                          ),
                          onPressed: () {
                            if (ActiveConnection) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                    key: const ValueKey('uniqueKey'),
                                    isDarkMde: isDarkMode,
                                    isBuy: _buyStatus,
                                  ),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'ไม่มีการเชื่อมต่ออินเทอร์เน็ต',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: RichText(
                                      text: const TextSpan(
                                        text:
                                        'ท่านต้องเชื่อมต่อกับอินเทอร์เน็ตก่อน นะครับ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black87),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              '\n\n(กดปุ่มลูกศรออกจากหน้านี้ ต่อเชื่อมอินเทอร์เน็ต แล้วจึงกดปุ่มซื้ออีกครั้ง)',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),
                    Expanded(
                      child: Scaffold(
                          body: PageView.custom(
                            controller: _pageController,
                            childrenDelegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                _currQstnNum = index + 1;
                                debugPrint("_currQstnNum ข้อ: $_currQstnNum");
                                _numOfQstn = items.length;
                                var i = 0;
                                items.forEach((item) {
                                  i++;
                                  debugPrint(
                                      'ข้อที่: $i || qNum: ${item.qNum} || question: ${item.question} || isExplain: ${item.isExplain}');
                                });
                                debugPrint("item ทดลองดู: ${items[3]}");
                                debugPrint(
                                    "_pageController.hasClients: ${_pageController.hasClients}");

                                return KeepAlive(
                                  data: items[index],
                                  key: ValueKey<Exam>(items[index]),
                                  currQNum: _currQstnNum,
                                  numOfQstns: _numOfQstn,
                                  fileName: _myExams,
                                  controller: _pageController,
                                );
                              },
                              childCount: items.length,
                              findChildIndexCallback: (Key key) {
                                final ValueKey valueKey = key as ValueKey<dynamic>;
                                final Exam data = valueKey.value;
                                return items.indexOf(data);
                              },
                            ),
                          )),
                    ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
      });
    }
    debugPrint("ActiveConnection: $ActiveConnection");
  }

  Future<bool> check_if_already_bought_from_hashTable() async {
    bool isBuy;
    final dbClient = await SqliteDB().db;
    var result =
    await dbClient!.rawQuery('SELECT * FROM hashTable WHERE name = "sku"');
    if (result.isNotEmpty) {
      debugPrint("isBoughtAlready inside function is not empty.");
      String val = result.first['str_value'] as String;
      if (val == "true") {
        isBuy = true;
      } else {
        isBuy = false;
      }
    } else {
      isBuy = false;
    }
    debugPrint("isBoughtAlready inside function - result: $result");
    debugPrint("isBoughtAlready inside function: $isBuy");
    return isBuy;
  }

  Future<List<Exam>> getExamDataFromXML(BuildContext context) async {
    String xmlString = await DefaultAssetBundle.of(context)
        .loadString("assets/data/$_myExams");
    final document = XmlDocument.parse(xmlString);
    var elements = document.findAllElements("thisQuestion");

    return elements.map((element) {
      debugPrint("qNum_text: ${element.findElements("qNum").first.innerText}");

      return Exam(
          element.findElements("qNum").first.innerText,
          element.findElements("question").first.innerText,
          element.findElements("choice_A").first.innerText,
          element.findElements("choice_B").first.innerText,
          element.findElements("choice_C").first.innerText,
          element.findElements("choice_D").first.innerText,
          element.findElements("choice_E").first.innerText,
          element.findElements("explanation").first.innerText,
          element.findElements("isExplain").first.innerText,
          int.parse(element.findElements("correctAns").first.innerText));
    }).toList();
  }

  Future<void> handleClick(String value) async {
    switch (value) {
      case 'sendMyMail':
        final Uri params = Uri(
          scheme: 'mailto',
          path: 'thongjoon@gmail.com',
          query:
          'subject=หัวข้อเรื่อง (โปรดระบุ)&body=สวัสดีครับ/ค่ะ',
        );

        var url = params;
        if (canLaunchUrl(url) != null) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $url';
        }
        break;
      case 'vote':
        Utils.openLink(
            url:
            'https://play.google.com/store/apps/details?id=com.thongjoon.ocsc_exam_prep');
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
        builder: (_) => new AlertDialog(
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

  void insertOrUpdateTableRow({String? fileName, int? appInstallDate}) async {
    final dbClient = await SqliteDB().db;
    var count = Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT COUNT (*) FROM itemTable WHERE file_name = ?', ["$fileName"]));
    debugPrint("fileName x count xx: $fileName");
    debugPrint("x count xx: $count");
    if (count == 0) {
      debugPrint("x count xx: (Not in itemTable) count = $count");
      getExamDataFromXmlAndWriteToItemTable(context, fileName!);
    } else {
      debugPrint("ไฟล์เก่า -- file name: $fileName");
      debugPrint("count not equal to 0");
      debugPrint("date created of $fileName from main.dart: $_createDate");

      getDateAndUpdateItemTable(context, fileName!, appInstallDate!);
    }
  }

  void checkAndActOnIsNewOfOcscTjkTable(
      {String? whatFileName, int? whatDate}) async {
    final dbClient = await SqliteDB().db;
    var count = Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT COUNT (*) FROM itemTable WHERE file_name = ? AND isClicked = "false" AND isNew = "1" ',
        ["$whatFileName"]));
    if (whatFileName!.startsWith("2_th_3_word_order")) {
      debugPrint(
          "file: $whatFileName  count isNew before going back to MainMenu  x count xx: $count ");
    }

    if (count == 0) {
      updateIsNewOfOcscTjkTable(context, whatFileName, whatDate!);
    } else {
      updateIsNewOfOcscTjkTableToOne(context, whatFileName, whatDate!);
    }
  }

  void updateIsNewOfOcscTjkTable(
      BuildContext context, String whatFileName, int whatDate) async {
    final dbClient = await SqliteDB().db;
    var res = await dbClient!.rawQuery('''
    UPDATE OcscTjkTable 
    SET isNew = ?,
    dateCreated =?
    WHERE file_name = ?
    ''', [0, whatDate, '$whatFileName']);
  }

  void updateIsNewOfOcscTjkTableToOne(
      BuildContext context, String whatFileName, int whatDate) async {
    final dbClient = await SqliteDB().db;
    var res = await dbClient!.rawQuery('''
    UPDATE OcscTjkTable 
    SET isNew = ?,
    dateCreated =?
    WHERE file_name = ?
    ''', [1, whatDate, '$whatFileName']);
  }

  Future<void> clearSharedDrawingData() async {
    debugPrint("try to clear sharedDrawing");
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("savedDrawing");
  }
}


Future<void> _saveProgressPicName(String pic_name, String fileName) async {
  try {
    final prefs = await SharedPreferences.getInstance();
     await prefs.setString('progress_image_$fileName', pic_name);
    debugPrint('File: $fileName :: Progress: $pic_name ');
  } catch (e) {
    debugPrint('Error saving page number: $e');
  }

}

//
Future<void> _savePageNumber(int pageNum, String fileName) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_page_$fileName', pageNum);
   // await prefs.setInt('last_question_$fileName', pageNum);
    debugPrint('Saved page $pageNum for file $fileName');
  } catch (e) {
    debugPrint('Error saving page number: $e');
  }
}

void _showDrawingWindow(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => DrawingDialog(),
    ),
  );
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    title: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.0),
          topLeft: Radius.circular(12.0),
        ),
        color: Colors.deepPurple,
      ),
      child: const Text(
        'วิธีใช้',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    titlePadding: const EdgeInsets.all(0),
    content: const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("ปัดซ้าย หรือแตะ > เพื่อไปข้อต่อไป "),
        Text("ปัดขวา หรือแตะ < เพื่อย้อนกลับ "),
        Text("แตะที่ \"คำอธิบาย\" เพื่อดูการเฉลย"),
      ],
    ),
    actions: <Widget>[
      new TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'ปิด',
          style:
          TextStyle(fontSize: 14.0, color: Theme.of(context).primaryColor),
        ),
      ),
    ],
  );
}

void getDateAndUpdateItemTable(
    BuildContext context, String fileName, int appInstallDate) async {
  List lstQNumID_FromXML = <String>[];

  String xmlString =
  await DefaultAssetBundle.of(context).loadString("assets/data/$fileName");
  final document = XmlDocument.parse(xmlString);
  var idAndDate = document.findAllElements("qNum");
  for (var element in idAndDate) {
    var str = element.innerText;
    if (str.contains(":date")) {
      const start = "id";
      const end = ":date";
      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);
      final startIndex2 = str.indexOf(end);
      String qNumId = str.substring(startIndex + start.length, endIndex);
      String qNumDate = str.substring(startIndex2 + end.length);
      debugPrint(
          "inside getDateAndUpdateItemTable -- fileName: $fileName   qNum id: $qNumId qNum date: $qNumDate");

      if (!lstQNumID_FromXML.contains(qNumId)) {
        lstQNumID_FromXML.add(qNumId);
      }

      updateItemData(
          file_name: fileName,
          item_id: qNumId,
          curr_item_date: qNumDate,
          ocscAppInstallDate: appInstallDate);
    }
  }
  debugPrint("lstQNumID_FromXML: $lstQNumID_FromXML");

  final dbClient = await SqliteDB().db;
  final result = (await dbClient!.rawQuery(
      """ SELECT item_id FROM itemTable WHERE file_name = '$fileName' """));
  List<String> itemIds_fromItemTble =
  result.map((row) => row['item_id'] as String).toList();
  debugPrint("itemIds_fromItemTble: $itemIds_fromItemTble");

  List<String> listC =
  itemIds_fromItemTble.where((element) => !lstQNumID_FromXML.contains(element)).toList();

  debugPrint("listC: $listC");
  listC.forEach((element) async {
    final result2 = (await dbClient.rawQuery(
        """ DELETE FROM itemTable WHERE item_id = '$element' """));
    print("record $element has been deleted!");
  });
}

Future updateItemData(
    {String? file_name,
      String? item_id,
      String? curr_item_date,
      int? ocscAppInstallDate}) async {
  debugPrint("check_id: $item_id");

  final dbClient = await SqliteDB().db;

  var countThisQuestionID = Sqflite.firstIntValue(await dbClient!.rawQuery(
      '''SELECT COUNT (*) FROM itemTable WHERE file_name = ? AND  item_id = ? ''',
      ['$file_name', '$item_id']));

  if (countThisQuestionID! <= 0) {
    debugPrint("item not found: NEW Question");
    debugPrint("updateItemData - all New");

    insertItemData(
        file_name: file_name,
        item_id: item_id,
        item_date: curr_item_date,
        isClicked: "false",
        isNew: "1");
  } else {
    debugPrint("item found: update it Question");

    List<Map<String, dynamic>> result = await dbClient.rawQuery('''
        SELECT item_date FROM itemTable
        WHERE file_name = ?
        AND item_id =? 
        ''', [file_name, item_id]);

    String dateFromSQlite = '';
    String isNew_itemTbl = '';
    String isClicked_itemTbl = '';

    if (result.isNotEmpty) {
      dateFromSQlite = result.first['item_date'] as String? ?? "111111";
      isNew_itemTbl = result.first['isNew'] as String? ?? "0";
      isClicked_itemTbl = result.first['isClicked'] as String? ?? "false";
    }

    debugPrint("ข้อสอบเก่า -- file name: $file_name dateFromSQlite $dateFromSQlite");

    int dateDiff =
    ((int.parse(curr_item_date!) - ocscAppInstallDate!) / 86400).ceil();
    debugPrint(
        "id: $item_id curr_item_date: $curr_item_date จำนวนวันหลังติดตั้ง dateDiff: $dateDiff");

    if (dateDiff > 5) {
      debugPrint(
          "id: $item_id ไฟล์เก่า: $file_name date: $curr_item_date dateDiff: $dateDiff -- OLD");
      var res = await dbClient.rawQuery('''
          UPDATE itemTable 
          SET item_date = ?,
          isNew = ? 
           WHERE file_name = ?
          AND item_id =?
          ''', ['$curr_item_date', '0', '$file_name', '$item_id']);
    } else {
      debugPrint(
          "id: $item_id ไฟล์ใหม่: $file_name date: $curr_item_date dateDiff: $dateDiff -- NEW within 90 days");
      if (isClicked_itemTbl == "false") {
        var res = await dbClient.rawQuery('''
          UPDATE itemTable 
          SET item_date = ? ,
          isNew = ?
          WHERE file_name = ?
          AND item_id = ?
          AND isClicked = ?
          ''', ['$curr_item_date', '1', '$file_name', '$item_id', "false"]);
      }
    }
  }
}

void getExamDataFromXmlAndWriteToItemTable(
    BuildContext context, String fileName) async {
  String xmlString =
  await DefaultAssetBundle.of(context).loadString("assets/data/$fileName");
  final document = XmlDocument.parse(xmlString);
  var idAndDate = document.findAllElements("qNum");
  for (var element in idAndDate) {
    var str = element.innerText;
    if (str.contains(":date")) {
      const start = "id";
      const end = ":date";
      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);
      final startIndex2 = str.indexOf(end);
      String qNumId = str.substring(startIndex + start.length, endIndex);
      String qNumDate = str.substring(startIndex2 + end.length);
      insertItemData(
          file_name: fileName,
          item_id: qNumId,
          item_date: qNumDate,
          isClicked: "false",
          isNew: "1");
    }
  }
}

Future insertItemData(
    {String? file_name,
      String? item_id,
      String? item_date,
      isClicked,
      isNew}) async {
  int res;
  final dbClient = await SqliteDB().db;
  res = await dbClient!.rawInsert(
      'INSERT INTO "itemTable" (file_name,item_id,item_date,isClicked,isNew) VALUES(?,?,?,?,?)',
      ['$file_name', '$item_id', '$item_date', '$isClicked', '$isNew']);
  return res;
}

class KeepAlive extends StatefulWidget {
  const KeepAlive({
    required Key key,
    required this.data,
    required this.currQNum,
    required this.numOfQstns,
    required this.fileName,
    required this.controller,
  }) : super(key: key);

  final Exam data;
  final int currQNum;
  final int numOfQstns;
  final String fileName;
  final PageController controller;

  @override
  _KeepAliveState createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isShowCheckMark_A = false;
  bool isShowCheckMark_B = false;
  bool isShowCheckMark_C = false;
  bool isShowCheckMark_D = false;
  bool isShowCheckMark_E = false;

  bool isThisItemNew = false;
  var isNew_arrayList = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bool isShowAns = true;
    String check_isExplain = widget.data.isExplain.toString();
    if (check_isExplain == "yes") {
      isShowAns = true;
    } else {
      isShowAns = false;
    }

    String choiceE = widget.data.choice_E.toString();
    bool isChoice_E_Empty = choiceE.trim().isEmpty ?? true;

    String id_and_date = widget.data.qNum;
    const start = "id";
    const end = ":date";
    final startIndex = id_and_date.indexOf(start);
    final endIndex = id_and_date.indexOf(end, startIndex + start.length);
    final startIndex2 = id_and_date.indexOf(end);
    String qNumId = id_and_date.substring(startIndex + start.length, endIndex);
    String qNumDate = id_and_date.substring(startIndex2 + end.length);
    String thisFile = widget.fileName;
    bool isDisplay_with_katex = false;
    if (qNumId.contains("_katex")) {
      isDisplay_with_katex = true;
    }

    checkItemTable(fileName: thisFile, qNumId: qNumId, qNumDate: qNumDate);

    final provider = Provider.of<ProviderModel>(context, listen: false);
    bool isFullVer = provider.removeAds;
    debugPrint("isFullver : $isFullVer");
    debugPrint("removeAds provider.removeAds: ${provider.removeAds}");

    final isDarkMode = Provider.of<ThemeNotifier>(context, listen: false).darkTheme;
    debugPrint("isShowAns in itemPageView: $isDarkMode");

        return Container(
        child: Column(
        children: [
        Container(
        padding: const EdgeInsets.all(8),
    color: Theme.of(context).primaryColorDark,
    height: 35,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Expanded(
    child: Align(
    alignment: Alignment.topLeft,
    child: Visibility(
    child: Container(
    child: GestureDetector(
    onTap: () {
    widget.controller.jumpToPage(0);
    debugPrint(
    "widget.currQNum-1:  ${widget.currQNum - 1}");
    },
    child: new Image.asset(
    'assets/images/previous_first.png',
    width: 30.0,
    height: 110.0)),
    ),
    visible: !(widget.currQNum - 1 <= 0),
    ),
    ),
    ),
    SizedBox(width: 2),
    Expanded(
    child: Align(
    alignment: Alignment.topLeft,
    child: Visibility(
    child: Container(
    child: GestureDetector(
    onTap: () {
    widget.controller.previousPage(
    duration: Duration(milliseconds: 250),
    curve: Curves.easeOut);
    debugPrint(
    "widget.currQNum-1:  ${widget.currQNum - 1}");
    debugPrint("total page:  ${widget.numOfQstns}");
    },
    child: new Image.asset('assets/images/previous.png',
    width: 30.0, height: 110.0)),
    ),
    visible: !(widget.currQNum - 1 <= 0),
    ),
    ),
    ),
    Expanded(
    child: Align(
    alignment: Alignment.center,
    child: Container(
    child: !(isThisItemNew)
    ? Container(
    alignment: Alignment.center,
    width: 490,
    decoration: BoxDecoration(
    border: Border.all(color: Colors.white)),
    child: Text(
    "${widget.currQNum}/${widget.numOfQstns}",
    style: TextStyle(
    fontSize: 14.0, color: Colors.white),
    ),
    )
        : Container(
    alignment: Alignment.center,
    width: 490,
    decoration: BoxDecoration(
    border: Border.all(color: Colors.white)),
    child: RichText(
    text: TextSpan(
    style: TextStyle(fontSize: 14.0),
    children: <TextSpan>[
    TextSpan(
    text:
    "${widget.currQNum}/${widget.numOfQstns}",
    style: TextStyle(
    fontSize: 14.0,
    color: Colors.white
        .withValues(alpha: 0.8))),
    TextSpan(
    text: '\u2022',
    style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14.0,
    color: Colors.redAccent))
    ],
    ),
    ),
    )),
    ),
    ),
    Expanded(
    child: Align(
    alignment: Alignment.topRight,
    child: GestureDetector(
    onTap: () {
    widget.controller.nextPage(
    duration: Duration(milliseconds: 250),
    curve: Curves.easeOut);
    debugPrint(
    "_pageController.hasClientsYYY: ${widget.controller.hasClients}");
    debugPrint("widget.currQNum+1:  ${widget.currQNum + 1}");
    },
    child: Visibility(
    child: Container(
    child: new Image.asset('assets/images/next.png',
    width: 30.0, height: 110.0),
    ),
    visible: !(widget.currQNum + 1 > widget.numOfQstns),
    ),
    ),
    ),
    ),
    Expanded(
    child: Align(
    alignment: Alignment.topRight,
    child: Visibility(
    child: Container(
    child: GestureDetector(
    onTap: () {
    widget.controller.jumpToPage(widget.numOfQstns);
    debugPrint(
    "widget.currQNum-1:  ${widget.currQNum - 1} total page:  ${widget.numOfQstns}");
    },
    child: new Image.asset(
    'assets/images/next_last.png',
    width: 30.0,
    height: 110.0)),
    ),
    visible: !(widget.currQNum >= widget.numOfQstns),
    ),
    ),
    ),
    ],
    ),
    ),
    Expanded(
    child: ListView(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    children: [
    Html(
    data: "${widget.data.question}",
    shrinkWrap: true,
    extensions: [
    TagExtension(
    tagsToExtend: {"tex"},
    builder: (extensionContext) {
    return Math.tex(
    extensionContext.innerHtml,
    mathStyle: MathStyle.text,
    textStyle: extensionContext.styledElement?.style
        .generateTextStyle(),
    onErrorFallback: (FlutterMathException e) {
    return Text(e.message);
    },
    );
    }),
    ],
    ),
    Card(
    child: InkWell(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
    width: 30,
    height: 45,
    child: Image.asset('assets/images/choice_1.png'),
    ),
    ),
    Expanded(
    child: Container(
    padding: EdgeInsets.only(left: 5),
    width: double.infinity,
    child: Html(
    data: widget.data.choice_A,
    extensions: [
    TagExtension(
    tagsToExtend: {"tex"},
    builder: (extensionContext) {
    return Math.tex(
    extensionContext.innerHtml,
    mathStyle: MathStyle.text,
    textStyle: extensionContext
        .styledElement?.style
        .generateTextStyle(),
    onErrorFallback:
    (FlutterMathException e) {
    return Text(e.message);
    },
    );
    }),
    ],
    ),
    ),
    ),
    Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
    width: 30,
    height: 45,
    child: showTrueFalse(
    thisCorrectAns:
    widget.data.correctAns.toString(),
    usrAns: "2",
    thisVisibleVar: isShowCheckMark_A),
    ),
    ),
    ],
    ),
    onTap: () {
    if (isFullVer == true || isShowAns == true) {
    updateItemTable(
    fileName: widget.fileName,
    itemId: qNumId,
    createdDate: qNumDate,
    isClicked: 'true',
    isNew: '0');
    setState(() {
    isShowCheckMark_A = true;
    });
    } else {
    showAnsNotAvailable();
    }
    },
    ),
    elevation: 2,
    ),
    Card(
    child: InkWell(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
    width: 30,
    height: 45,
    child: Image.asset('assets/images/choice_2.png'),
    ),
    ),
    Expanded(
    child: Container(
    width: double.infinity,
    child: Html(
    data: widget.data.choice_B,
    extensions: [
    TagExtension(
    tagsToExtend: {"tex"},
    builder: (extensionContext) {
    return Math.tex(
    extensionContext.innerHtml,
    mathStyle: MathStyle.text,
    textStyle: extensionContext
        .styledElement?.style
        .generateTextStyle(),
    onErrorFallback:
    (FlutterMathException e) {
    return Text(e.message);
    },
    );
    }),
    ],
    )),
    ),
    Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
    width: 30,
    height: 45,
    child: showTrueFalse(
    thisCorrectAns:
    widget.data.correctAns.toString(),
    usrAns: "3",
    thisVisibleVar: isShowCheckMark_B),
    ),
    ),
    ],
    ),
    onTap: () {
    if (isFullVer == true || isShowAns == true) {
    updateItemTable(
    fileName: widget.fileName,
    itemId: qNumId,
    createdDate: qNumDate,
    isClicked: 'true',
    isNew: '0');
    setState(() {
    isShowCheckMark_B = true;
    });
    } else {
    showAnsNotAvailable();
    }
    },
    ),
    elevation: 2,
    ),
    Card(
    child: InkWell(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
    width: 30,
    height: 45,
    child: Image.asset('assets/images/choice_3.png'),
    ),
    ),
    Expanded(
    child: Container(
    width: double.infinity,
    child: Html(
    data: widget.data.choice_C,
    extensions: [
    TagExtension(
    tagsToExtend: {"tex"},
    builder: (extensionContext) {
    return Math.tex(
    extensionContext.innerHtml,
    mathStyle: MathStyle.text,
    textStyle: extensionContext
        .styledElement?.style
        .generateTextStyle(),
    onErrorFallback:
    (FlutterMathException e) {
    return Text(e.message);
    },
    );
    }),
    ],
    )),
    ),
    Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
    width: 30,
    height: 45,
    child: showTrueFalse(
    thisCorrectAns:
    widget.data.correctAns.toString(),
    usrAns: "4",
    thisVisibleVar: isShowCheckMark_C),
    ),
    ),
    ],
    ),
    onTap: () {
    if (isFullVer == true || isShowAns == true) {
    updateItemTable(
    fileName: widget.fileName,
    itemId: qNumId,
    createdDate: qNumDate,
    isClicked: 'true',
    isNew: '0');
    setState(() {
    isShowCheckMark_C = true;
    });
    } else {
    showAnsNotAvailable();
    }
    },
    ),
    elevation: 2,
    ),
    Card(
    child: InkWell(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
    width: 30,
    height: 45,
    child: Image.asset('assets/images/choice_4.png'),
    ),
    ),
    Expanded(
    child: Container(
    width: double.infinity,
    child: Html(
    data: widget.data.choice_D,
    extensions: [
    TagExtension(
    tagsToExtend: {"tex"},
    builder: (extensionContext) {
    return Math.tex(
    extensionContext.innerHtml,
    mathStyle: MathStyle.text,
    textStyle: extensionContext
        .styledElement?.style
        .generateTextStyle(),
    onErrorFallback:
    (FlutterMathException e) {
    return Text(e.message);
    },
    );
    }),
    ],
    )),
    ),
    Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
    width: 30,
    height: 45,
    child: showTrueFalse(
    thisCorrectAns:
    widget.data.correctAns.toString(),
    usrAns: "5",
    thisVisibleVar: isShowCheckMark_D),
    ),
    ),
    ],
    ),
    onTap: () {
    if (isFullVer == true || isShowAns == true) {
    updateItemTable(
    fileName: widget.fileName,
    itemId: qNumId,
    createdDate: qNumDate,
    isClicked: 'true',
    isNew: '0');
    setState(() {
    isShowCheckMark_D = true;
    });
    } else {
    showAnsNotAvailable();
    }
    },
    ),
    elevation: 2,
    ),
    Visibility(
    child: Card(
    child: InkWell(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
    width: 30,
    height: 45,
    child: Image.asset('assets/images/choice_5.png'),
    ),
    ),
    Expanded(
    child: Container(
    width: double.infinity,
    child: Html(
    data: widget.data.choice_E,
    extensions: [
    TagExtension(
    tagsToExtend: {"tex"},
    builder: (extensionContext) {
    return Math.tex(
    extensionContext.innerHtml,
    mathStyle: MathStyle.text,
    textStyle: extensionContext
        .styledElement?.style
        .generateTextStyle(),
    onErrorFallback:
    (FlutterMathException e) {
    return Text(e.message);
    },
    );
    }),
    ],
    )),
    ),
    Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
    width: 30,
    height: 45,
    child: showTrueFalse(
    thisCorrectAns:
    widget.data.correctAns.toString(),
    usrAns: "6",
    thisVisibleVar: isShowCheckMark_E),
    ),
    ),
    ],
    ),
    onTap: () {
    if (isFullVer == true || isShowAns == true) {
    updateItemTable(
    fileName: widget.fileName,
    itemId: qNumId,
    createdDate: qNumDate,
    isClicked: 'true',
    isNew: '0');
    setState(() {
    isShowCheckMark_E = true;
    });
    } else {
    showAnsNotAvailable();
    }
    },
    ),
    elevation: 2,
    ),
    visible: !(isChoice_E_Empty),
    ),
    ],
    ),
    ),
    Align(
    alignment: FractionalOffset.bottomCenter,
    child: Container(
    width: double.infinity,
    child: ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.indigoAccent,
    ),
    child: Text(
    'คำอธิบาย',
    style: TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    ),
    ),
    onPressed: () {
    if (isFullVer == true || isShowAns == true) {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => Explanation(
    itmNum: widget.currQNum,
    total: widget.numOfQstns,
    expltn: widget.data.exPlanation.toString(),
    ),
    ),
    );
    } else {
    showAnsNotAvailable();
    }
    },
    ),
    ),
    ),
    ],
    ),
    );
  }

  void addNewAfterItemNum() {
    debugPrint("กำหนดให้ค่า isThisItemNew เป็น true เพื่อให้มีจุดแดงหลังข้อ");
    debugPrint("isThisItemNew: $isThisItemNew");

    if (isThisItemNew == false) {
      debugPrint("isThisItemNew: $isThisItemNew");
      setState(() {
        isThisItemNew = true;
      });
    }
  }

  Widget showTrueFalse(
      {required String thisCorrectAns,
        required String usrAns,
        required bool thisVisibleVar}) {
    return SizedBox(
      width: 25,
      height: 25,
      child: Visibility(
        child: Image.asset(
          thisCorrectAns == usrAns
              ? 'assets/images/tru.png'
              : 'assets/images/flse.png',
        ),
        visible: thisVisibleVar,
      ),
    );
  }

  Widget buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Center(
          child: Text(widget.data.exPlanation.toString()),
        ),
      ),
    );
  }

  void showAnsNotAvailable() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              color: Color(0xFF737373),
              height: 260,
              child: Container(
                child: _buildBottomNavigationMenu(),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Padding _buildBottomNavigationMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          if (Platform.isAndroid) ...[
            SizedBox(height: 35),
            Text(
              'ข้อนี้ มีเฉลยในรุ่นเต็ม นะครับ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'ลงทุนเพื่ออนาคต เพียง 199 บาท เท่านั้น',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'มือถือ Android จ่ายผ่าน',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'พร้อมแพย์(สแกนจ่าย ผ่าน คิวอาร์โค้ด), บัตรเครดิต, TrueMoney, LinePay, และอื่น ๆ ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ซื้อครั้งเดียวใช้ได้ตลอด ฟรีอัพเดท!! คุ้มกว่าเยอะ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else if (Platform.isIOS) ...[
            SizedBox(height: 20),
            Text(
              'ข้อนี้ มีเฉลยเฉพาะรุ่นเต็ม นะครับ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'ลงทุนเพียง 199 บาท\nซื้อครั้งเดียว ใช้ได้ตลอด\nคุ้มกว่าเยอะ\nฟรี อัพเดท!!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void checkItemTable(
      {required String fileName,
        required String qNumId,
        required String qNumDate}) async {
    debugPrint("checkItemTable เลื่อนข้อ $fileName id: $qNumId date: $qNumDate");
    final dbClient = await SqliteDB().db;
    int? count = Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT COUNT (*) FROM itemTable WHERE file_name = ? and item_id=?',
        ["$fileName", "$qNumId"]));
    debugPrint("ไฟล์: $fileName เลขที่: $qNumId จำนวน rows: $count");
    if (count == 0) {
      debugPrint("checkItemTable เป็น 0 แสดงว่า ยังไม่มีในตาราง ItemTable");

      insertItemTable(
          fileName: fileName,
          thisID: qNumId,
          thisDate: qNumDate,
          isNew: "1",
          is_clicked: "false");

      addNewAfterItemNum();
    } else {
      debugPrint(" มีข้อมูลอยู่ในตาราง ItemTable แล้ว พบจำนวน: $count");
      int currdate = ((DateTime.now().millisecondsSinceEpoch) / 1000).floor();
      var itemDate = await retrieveItemDate(fileName: fileName, itemID: qNumId);
      String thisItemDate = itemDate['item_date'];

      var is_item_clicked =
      await retrieveItemIsClicked(fileName: fileName, itemID: qNumId);
      String is_this_item_clicked = is_item_clicked['isClicked'];
      debugPrint("isClicked: $is_this_item_clicked");

      var itemAgeFromQNum = (((currdate - int.parse(qNumDate)) / 86400).ceil());
      debugPrint("qNumID: $qNumId age: $itemAgeFromQNum");
      if (itemAgeFromQNum < 90) {
        debugPrint("itm_id: $qNumId อายุ น้อย กว่า 90 วัน");
      } else {
        debugPrint("itm_id: $qNumId อายุ มาก กว่า 90 วัน");
      }

      if (is_this_item_clicked == "false") {
        debugPrint("itm_id: $qNumId ยังไม่ได้คลิก");
      } else {
        debugPrint("itm_id: $qNumId คลิกแล้ว");
      }
      if ((itemAgeFromQNum < 90) && (is_this_item_clicked == "false")) {
        debugPrint(
            " IF TRUE itm_id: $qNumId Age: $itemAgeFromQNum  isClicked: $is_this_item_clicked");
        debugPrint("itm_id: $qNumId อายุน้อยกว่า 90 วัน และยังไม่ได้คลิก");
      } else {
        debugPrint(
            " ELSE itm_id: $qNumId Age: $itemAgeFromQNum  isClicked: $is_this_item_clicked");
        debugPrint(
            "itm_id: $qNumId ไม่เข้าเกณฑ์ อายุน้อยกว่า 90 วัน และยังไม่ได้คลิก");
      }

      if ((itemAgeFromQNum < 90) && (is_this_item_clicked == "false")) {
        debugPrint(
            " มีข้อมูลอยู่ในตารางแล้ว และ น้อยกว่า 90 วัน หรือ ยังไม่ได้คลิก");
        addNewAfterItemNum();
        debugPrint("isThisItemNew after updateItem: $isThisItemNew");
      } else {
        debugPrint("itm_id: $qNumId ไม่เข้าเกณฑ์");
      }
    }
  }

  Future retrieveItemDate(
      {required String fileName, required String itemID}) async {
    var dbClient = await SqliteDB().db;
    final res = (await dbClient!.rawQuery(
        """ SELECT item_date FROM itemTable WHERE file_name = '$fileName' AND item_id = '$itemID' """));
    return res.first;
  }

  Future retrieveItemIsClicked(
      {required String fileName, required String itemID}) async {
    var dbClient = await SqliteDB().db;
    final res = (await dbClient!.rawQuery(
        """ SELECT isClicked FROM itemTable WHERE file_name = '$fileName' AND item_id = '$itemID' """));
    return res.first;
  }

  void updateItemTable_no_isClick(
      {required String fileName,
        required String itemId,
        required String createdDate,
        required String isNew}) async {
    debugPrint(
        "inside updateItemTable_no_isClick: createdDate: $createdDate,  isNew: $isNew', fileName: $fileName, itemId: $itemId ");
    var dbClient = await SqliteDB().db;
    var res = await dbClient!.rawUpdate('''
    UPDATE itemTable 
    SET item_date = ?, 
    isNew =? 
    WHERE file_name = ? AND item_id = ?
    ''', ['$createdDate', '$isNew', '$fileName', '$itemId']);
    debugPrint("update ItemTable -- res: $res");
  }

  void updateItemTable(
      {required String fileName,
        required String itemId,
        required String createdDate,
        required String isClicked,
        required String isNew}) async {
    debugPrint(
        "inside updateItemTable: createdDate: $createdDate, isClicked: $isClicked, isNew: $isNew', fileName: $fileName, itemId: $itemId ");
    var dbClient = await SqliteDB().db;
    var res = await dbClient!.rawUpdate('''
    UPDATE itemTable 
    SET item_date = ?, 
    isClicked =?,
    isNew =? 
    WHERE file_name = ? AND item_id = ?
    ''', ['$createdDate', '$isClicked', '$isNew', '$fileName', '$itemId']);
    debugPrint("update ItemTable -- res: $res");
  }
}

Future<void> _onOpen(LinkableElement link) async {
  debugPrint("this link: $link");
  Uri thisLink = Uri.parse(link.url);
  debugPrint("this link: $thisLink");
  if (await canLaunchUrl(thisLink)) {
    await launchUrl(thisLink);
  } else {
    throw 'Could not launch $link';
  }
}

Future createItemInfoTable() async {
  var dbClient = await SqliteDB().db;
  var res = await dbClient!.execute("""
      CREATE TABLE ItemInfo_table(
        id TEXT PRIMARY KEY,
        file_name TEXT,
        qstnNum INTEGER,
        isClicked TEXT
      )""");
  return res;
}

Future insertFileData({required String fileName, required int progress}) async {
  dynamic myData = {"file_name": fileName, "progress": progress};
  final dbClient = await SqliteDB().db;
  int res = await dbClient!.insert("OcscTjkTable", myData);
  return res;
}

Future insertFileCreateDateOcscTjkTable(
    {required String fileName, required int thisDate}) async {
  dynamic myData = {"file_name": fileName, "dateCreated": thisDate};
  final dbClient = await SqliteDB().db;
  int res = await dbClient!.insert("OcscTjkTable", myData);
  return res;
}

Future updateFileData({required String fileName, required int progress}) async {
  var dbClient = await SqliteDB().db;
  var res = await dbClient!.rawQuery(
      """ UPDATE OcscTjkTable SET progress = progress WHERE file_name = '$fileName'; """);
  return res;
}

Future updateOcscTjkTable(
    {required String fileName, required int progress}) async {
  var dbClient = await SqliteDB().db;
  var res = await dbClient!.rawQuery('''
    UPDATE OcscTjkTable 
    SET progress = ? 
    WHERE file_name = ?
    ''', [progress, '$fileName']);
  return res;
}

Future updateFileCreateDate(
    {required String fileName,
      required int createdDate,
      required String picName}) async {
  debugPrint("picName inside updateFile: $picName");
  var dbClient = await SqliteDB().db;
  var res = await dbClient!.rawQuery('''
    UPDATE OcscTjkTable 
    SET dateCreated = ? , progress_pic_name = ?
    WHERE file_name = ?
    ''', [createdDate, picName, '$fileName']);
  return res;
}


// import 'dart:async'; // สำหรับให้ตัวหนังสือ มีลิงค์ได้
// import 'dart:io' show Platform;
// // import 'package:flutter_math_fork/flutter_math.dart' as Math;
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
//
// //import 'package:flutter_html_math/flutter_html_math.dart';
// import 'package:flutter_math_fork/flutter_math.dart';
// import 'package:flutter_html_table/flutter_html_table.dart';
// // import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_linkify/flutter_linkify.dart'; // สำหรับให้ตัวหนังสือ มีลิงค์ได้
// //import 'package:katex_flutter/katex_flutter.dart';
// import 'package:ocsc_exam_prep/exam.dart'; //  รูปแบบโครงสร้างข้อสอบ
// import 'package:ocsc_exam_prep/paymentScreen.dart';
// import 'package:ocsc_exam_prep/theme.dart';
// import 'package:ocsc_exam_prep/utils.dart';
//
// // import 'package:package_info/package_info.dart'; // สำหรับ เรียก version และชื่อ
// // import 'package:package_info_plus/package_info_plus.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:xml/xml.dart'; // สำหรับ อ่านข้อมูล xml
//
// // สำหรับตรวจว่า เป็น android หรือ iphone จะได้ส่งลิงค์ไปให้คะแนน ถูกเว็บ
// import 'ProviderModel.dart';
// import 'aboutDialog.dart';
// import 'drawingDialog.dart';
// import 'explanation.dart'; // สำหรับให้ตัวหนังสือ มีลิงค์ได้
// import 'noteAppLauncher.dart';
// import 'sqlite_db.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// class ItemPageView extends StatefulWidget {
//   final String myExams;
//   final String
//       createDate; // สำหรับวันที่ ของไฟล์ที่ส่งเข้า จะเอาไป update ในฐานข้อมูล ถ้า
//   // คลิกข้อใหม่หมดแล้ว ทุกข้อ  -- คือ ต้องคลิกข้อใหม่หมดทุกข้อ จึงเอาจุดแดงออกจากหน้าเมนู
//   final String title;
//   final int currPageNum;
//   final int currQstnNum;
//   final int numOfQstn;
//   final String msg;
//   final bool buyStatus;
//
//
//   ItemPageView(
//       {Key? key,
//       required this.myExams,
//       required this.title,
//       required this.currPageNum,
//       required this.currQstnNum,
//       required this.numOfQstn,
//       required this.createDate,
//       required this.msg,
//       required this.buyStatus})
//       : super(key: key);
//
//   @override
//   _PageViewCustomState createState() => _PageViewCustomState();
// // final PageController _pageController = PageController();
// }
//
// class _PageViewCustomState extends State<ItemPageView> {
//   // ProviderModel _appProvider;
// //  List<String> items = <String>['1', '2', '3', '4', '5'];
//   // PageController _pageController = PageController();
//   //  PageController _pageController = PageController(initialPage: 3);
// // int res = getFileDat("sss");
//
//   // ถ้าไม่มี สร้าง ถ้ามี เอามา ถ้าใหม่ update
//   // ไปเอาข้อมูลเดิม มาเปรียบเทียบวันที่ เพื่อเพิ่มข้อมูลว่า เป็นข้อใหม่ ที่เลขข้อ แต่ละข้อ
//
//   //final NoteAppLauncher noteAppLauncher = NoteAppLauncher(); // Instantiate here เพื่อเรียกใช้ open ใน class NoteAppLauncher
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//
//   late List<Exam> items;
//
//   late String _myExams;
//   late String _title;
//   late int _currPageNum;
//   late int _currQstnNum;
//   late int _numOfQstn;
//   late String _createDate;
//   late String _messageToShow;
//   late bool _buyStatus;
//
//   // สำหรับตรวจสถานะการซื้อ ว่า ซื้อแล้วหรือยัง จะได้เอาเป็นเงื่อนไขการแสดงปุ่มซื้อ
//   late SharedPreferences buyStatus;
//   late bool isBoughtAlready;
//   late bool isBought;
//
//   bool ActiveConnection= false;
//
//   PageController _pageController = PageController();
//   PageController myController = PageController();
//
//   int ocscAppInstallDate = 111111;
//
//   @override
//   initState() {
//     super.initState();
//
//     debugPrint("enter initState of itemPageView");
//
//     CheckUserConnection();
//
//     // ไปเอา เลขหน้าเริ่มต้นของการแสดงข้อสอบ ในตาราง OcscTjkTable ว่าจะเริ่มข้อไหน พร้อมกับ สั่งให้
//     // เปิดหน้าสุดท้ายที่เคยเข้ามา โดยใช้ ส่งเลขหน้าให้ _pageController
//     getWhereToStart(whatFileName: widget.myExams);
//     // debugPrint("whereToStart thisStartNum: $thisStartNum");
//     // _pageController = PageController(initialPage: thisStartNum);
//     _myExams = widget.myExams; // ชื่อไฟล์ ที่ส่งเข้ามาจากหน้า mainMenu
//
//     _title = widget.title; //ชื่อหัวข้อ ที่ส่งเข้ามาจากหน้า mainMenu
//     _createDate = widget.createDate; // วันที่ที่ส่งเข้ามาจากหน้า mainMenu
//     _messageToShow = widget.msg; // ข่าวสาร
//     _buyStatus = widget.buyStatus; // ซื้อหรือยัง
//
//     final provider = Provider.of<ProviderModel>(context, listen: false);
//
//     provider.initPlatformState();
//     debugPrint(
//         "offering from provider -- caling from itemPageView: ${provider.offering}");
//     debugPrint(
//         "removeAds from provider -- caling from itemPageView:  ${provider.removeAds}");
//
//     debugPrint(
//         "ชื่อไฟล์  ใน initState: $_myExams วันที่: $_createDate ซื้อหรือยัง buyStatus in itemPageView: $_buyStatus");
//     // debugPrint(
//     //     "isBought abcdAlready - isBoughtAlready in itemPageView before buyBtn after checkIfBought: $isBoughtAlready");
//     debugPrint("buyStatus from mainMenu - itemPageView (isBought): $_buyStatus");
//
//     if (_buyStatus == false) {
//       // ถ้าไม่มี ให้เชคจาก Provider อาจมีหลายกรณี เช่น
//       // บางทีข้อมูลจากตาราง หรือ sharePref เป็น null หรือ ถอนโปรแกรมออก แล้วติดตั้งใหม่แล้วกดปุ่ม restore purchase
//       // ในหน้า paymentScreen
//
//       setState(() {
//         _buyStatus = provider.removeAds;
//       });
//       debugPrint(
//           "_buyStatus (isBought ส่งมาจาก Provider โดย เอามาจาก removeAds และ sku ในตาราง hashTable และ sharePref $_buyStatus");
//     }  // end of   if (_buyStatus == false) {
//
//
//     // ไปเอาวันที่ติตตั้งแอพ จากใน sharePref
//     // final myInstallDate = Provider.of<ThemeNotifier>(context,
//     //     listen: false);  // วันที่ ที่ติดตั้งแอพ
//     // int dateInstalled = ((myInstallDate.installDate) / 1000).round();
//
//     final myInstallDate = Provider.of<ThemeNotifier>(
//         context,
//         listen: false); // วันที่ ที่ติดตั้งแอพ
//     int? dateInstalled = myInstallDate.installDate;
//
//
//     debugPrint("install at: $dateInstalled");
//     ocscAppInstallDate = dateInstalled!;
//
//
//     // เชค future:
//     debugPrint("before check xml file: $_myExams installed date: $ocscAppInstallDate");
//     insertOrUpdateTableRow(fileName: _myExams, appInstallDate: ocscAppInstallDate); // ปรับตาราง itemTable
//
// // ******************** ถึงตรงนี้ ***********************
// // เอาจุดแดง แสดงที่หลังเลขข้อ ได้แล้ว จะมีอายุ 15 วัน
//   // ต่อไป ต้อง เวลาคลิกตัวเลือก ให้ปรับ isNew ในตาราง table เป็น 0 เพื่อว่า หน้าเมนูมาเชค จะไอ้เอาจุดแดงหลังเมนู ออก
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     bool isMath = false; // สำหรับ เชคว่าเป็นวิชาคณิตหรือไม่ จะได้แสดงปุ่ม กระดาษทด บน appBar
//
//     // ช้า ทำได้ไม่ดี เลยเลิกใช้งาน เลยกำหนดให้เป็น false ทั้งหมด
//     // ถ้า จะลองใหม่ ให้เอา คอมเม้นข้างล่างออก ทุกอย่างยังทำงานได้
//
//     if (widget.myExams.contains("num") || widget.myExams.contains("math") || widget.myExams.contains("cndtng") || widget.myExams.contains("thai_conclusion") || widget.myExams.contains("ocsc_answer")) {
//       isMath = true;
//     } else {
//       isMath = false;
//     }
//
//
//     // return WillPopScope(
//     //   onWillPop: () async {
//     return PopScope(
//       canPop: true,
//      // onPopInvoked: (bool didPop) async {  // deprecated
//         onPopInvokedWithResult: (bool didPop, Object? result) async {
//         //Navigator.pop(context, false);
//         //createExamProgressTable();
//         //saveToDatabase()
//         debugPrint("Back button is pressed.");
//         debugPrint(
//             "หน้าปัจจุบัน $_currQstnNum"); //  ยังเป็น null  --- มาแล้ว .......
//         debugPrint("หน้าทั้งหมด $_numOfQstn");
//         debugPrint("ชื่อไฟล์ ใน Willpopscope   $_myExams");
//         debugPrint("วันที่ : $_createDate");
//         //   int myProgress = (_currQstnNum / _numOfQstn * 100).round();
//
//         double progress = _currQstnNum / _numOfQstn * 100;
//
//         int myProgress; // เพื่อว่า ขาดไปข้อเดียวก็ยังไม่เสร็จ ถ้าปัดธรรมดา round()
//         // มันจะปัดขึ้น ทำให้เป็น 100% ซึ่งไม่ดี ทำนองเดียวกัน ทำข้อเดียว มันปัดลง ก็ไ่ม่ขึ้นวงกลมให้
//         // ก็เลยเอาใหม่เป็น ถ้าข้อเดียวก็แสดงความก้าวหน้า หรือ ทำขาดไปข้อเดียว ก็ไม่ขึ้น เครื่องหมายถูกให้
//         if (progress > 50) {
//           myProgress = progress.floor();
//         } else {
//           myProgress = progress.ceil();
//         }
//
//         String picName;
//         debugPrint("myProgress: $myProgress");
//         if (myProgress >= 100) {
//           picName = "p100.png";
//         } else if (myProgress >= 90) {
//           picName = "p90.png";
//         } else if (myProgress >= 80) {
//           picName = "p80.png";
//         } else if (myProgress >= 70) {
//           picName = "p70.png";
//         } else if (myProgress >= 60) {
//           picName = "p60.png";
//         } else if (myProgress >= 50) {
//           picName = "p50.png";
//         } else if (myProgress >= 40) {
//           picName = "p40.png";
//         } else if (myProgress >= 30) {
//           picName = "p30.png";
//         } else if (myProgress >= 20) {
//           picName = "p20.png";
//         } else if (myProgress >= 1) {
//           picName = "p10.png";
//         } else {
//           picName = "p00.png";
//         }
//         // ดูอีกที  ตรงนี้ เปลี่ยนรูป ความก้าวหน้า
//         //  ******ไม่ปรับจุดสีแดงที่นี่ ปรับตอนไปนับว่า ไฟล์นี้ไม่มีข้อใหม่ จึงเอาปุ่มสีแดงออก *****
//         // ตรวจดูข้อสอบที่ทำเสร็จแล้ว และกำลังจะกลับหน้าเมนู แต่ละข้อ ว่า มี isNew = 1 หรือไม่ ถ้าไม่มี แสดงว่่า เป็นของเก่า ให้ปรับ isNew ในตาราง OcscTjkTable  เป็น 0
//         // คือ ถ้ามีจุดแดงอยู่ก่อน และเข้ามาทำแล้วทุกข้อ จึงลบจุดแดงที่หน้าเมนูออก ถ้ายังเหลืออยู่ ก็จะไม่ลบออก
//         debugPrint("aaxx file name to check for isNew: $_myExams");
//         int fileDate = int.parse(_createDate);  // วันที่ของไฟล์ ใน main.dart ซึ่งเป็นหน้าเมนูหลัก
//         debugPrint("aaxx หน้าปัจจุบัน to check for isNew: $_currQstnNum.toString()");
//         updateOcscTjkTbl_open_last(
//             whatFileName: _myExams, whereToStart: _currQstnNum.toString(), whatPicName: picName);
//
//         // ตรวจดู   isNew โดยการนับ ถ้าเป็น 0 แสดงว่า ดูหมดแล้ว อัพเดท isNew และ วันที่ด้วย หรือไม่งั้น(ยังทำของใหม่ ยังไม่หมด)ก็ ไม่ทำอะไร
//         debugPrint("whatFileName: $_myExams, whatDate: $fileDate");
//         // checkAndActOnIsNewOfOcscTjkTable(
//         //     whatFileName: _myExams, whatDate: fileDate);  // ส่งค่าชื่อไฟล์ในหน้าเมนูหลัก และวันที่ของไฟล์นั้น
//
//         var dbClient = await SqliteDB().db;
//
//         var queryResult = await dbClient!.rawQuery(
//             """ SELECT * FROM OcscTjkTable WHERE file_name = '$_myExams'; """);
//         debugPrint("queryResult: $queryResult");
//         debugPrint("picName: $picName");
//
//         // ถ้ามีข้อมูลอยู่แล้ว ให้ update วันที่เป็นของไฟล์ใหม่ เพื่อเมื่อ // ไม่ใช่
//         // เข้ามาอีกครั้ง จะไดไม่มีจุดแดงหลังชื่อในหน้าเมนู  -- อย่าลืม ต้องเชคก่อนเลย พอเข้าหน้าเมนู เพราะ
//         // จะได้เปรียบเทียบวันที่ ของไฟล์ที่เข้ามา โดยเปรียบเทียบกับวันที่ ที่มีอยู่ในฐานข้อมูล
//
//         if (queryResult.isNotEmpty) {  // ถ้ามีชื่อไฟล์ ในตาราง itemTable ปรับวันที่ในตาราง ให้ตรงกับที่หน้าเมนู พร้อมทั้งภาพวงกลม ทำไปแล้วประมาณเท่าไร
//           updateFileCreateDate(
//               fileName: _myExams, createdDate: fileDate, picName: picName);
//         }
//
//         clearSharedDrawingData();  // เคลียกระดาษทด
//
//         return Future.value(true);
//       },
//       child: SafeArea(
//         minimum: const EdgeInsets.all(1.0),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text(
//               'เตรียมสอบ ก.พ. ภาค ก.',
//               //  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//             ),
//             centerTitle: true,
//             elevation: 0,
//             actions: [
//
//               Tooltip(
//                 message: "กระดาษทด",
//                 child: GestureDetector(  // สำหรับ dialog กระดาษทด
//                   onTap: () => _showDrawingWindow(context),
//                   child: (isMath) // ถ้าเป็นไฟล์คณิต จะให้มี icon คลิกไปเปิดกระดาษทด
//                       ? Icon(
//                     Icons.edit_note,
//                     size: 30.0,
//                   )
//                       : Visibility(
//                     child: Icon(
//                       Icons.help_outline,
//                       size: 26.0,
//                     ),
//                     visible: false,
//                   ),
//                 ),
//               ),
//
//
//               // // เรียกใช้ แอปข้างนอก เพื่อเป็นกระดาษทด -- ยังไม่ทำงาน
//               //GestureDetector(  //
//              //  // onTap: () => NoteAppLauncher(packageName: 'com.thongjoon.ocsc_exam_prep'),
//              //    onTap: () => NoteAppLauncher.launchNoteApp(context),
//              //    child: (isMath) //ถ้าเป็นไฟล์ คณิต
//              //        ? Icon(
//              //      Icons.edit_note,
//              //      size: 30.0,
//              //    )
//              //        : Visibility(
//              //      child: Icon(
//              //        Icons.help_outline,
//              //        size: 26.0,
//              //      ),
//              //      visible: false,
//              //    ),
//              //  ),
//
//
//               PopupMenuButton(
//                   onSelected: (selectedValue) {
//                     //debugPrint(selectedValue);
//                     handleClick(selectedValue.toString());
//                   },
//                   itemBuilder: (BuildContext ctx) => [
//                         // PopupMenuItem(
//                         //     child: Text('ส่งเมลถึงผู้เขียน'),
//                         //     value: 'sendMyMail'),
//                         const PopupMenuItem(
//                             child: Text('ให้คะแนน App นี้'), value: 'vote'),
//                         const PopupMenuItem(
//                             child: Text('แชร์กับเพื่อน'), value: 'share'),
//                         const PopupMenuItem(
//                             child: Text(
//                                 'ส่งอีเมล ติชม เสนอแนะ หรือแจ้งข้อผิดพลาด'),
//                             value: 'sendMyMail'),
//                         const PopupMenuItem(child: Text('เกี่ยวกับ'), value: 'about'),
//                       ])
//             ],
//           ),
//           body: FutureBuilder(
//             future: getExamDataFromXML(context),
//             builder: (context, data) {
//               debugPrint(
//                   "_buyStatus (isBought ส่งมาจาก mainMenu โดย เอามาจาก sku ในตาราง hashTable และ sharePref $_buyStatus");
//               // "แสดงข่าวสาร\nMade askf afja กกา าหก าฟากา ฟาด่ าาby https://www.thongjoon.com\nMail: example@gmail.com";
//               String myMessage = "แสดงข่าวสาร หน้า itemPageView";
//
//               if (data.hasData) {
//                 List<Exam> items = data.data as List<Exam>;
//                 debugPrint("itemssss: $items");
//                 debugPrint("buyStatus - isBought เงื่อนไขแสดงปุ่มซื้อ: $_buyStatus");
//                 final isDarkMode =
//                     Provider.of<ThemeNotifier>(context, listen: false)
//                         .darkTheme; // true = dark, false = light
//                 debugPrint("isShowAns in itemPageView: $isDarkMode");
//                 debugPrint("isBought in itemPageView: $_buyStatus");
//                 final _isFirstRun =
//                     Provider.of<ThemeNotifier>(context, listen: false)
//                         .isFirstRun;
//                 debugPrint("isFirstRun in itemPageView: $_isFirstRun");
//                 return Column(
//                   children: [
//                     Container(
//                       // สำหรับแสดงข้อความจาก pastebin
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         //  color: Colors.blue[700],
//                         color: Theme.of(context).primaryColorDark,
//                         border: const Border(
//                           top: BorderSide(width: 1, color: Colors.white70),
//                         ),
//                         // color: Colors.white,
//                       ),
//                       child: Linkify(
//                         // สำหรับให้คลิกไปที่ลิงค์ได้ ถ้ามี https://
//                         onOpen: _onOpen,
//                         textScaleFactor: 1,
//                         // text: myMessage,
//                         text: _messageToShow,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(fontSize: 14.0, color: Colors.white),
//                         // style: TextStyle(
//                         //     fontSize: 18.0,
//                         //     color: Colors.white54,
//                         //     fontWeight: FontWeight.bold),
//
//                         linkStyle: const TextStyle(
//                             // กำหนดสีของลิงค์
//                             fontSize: 14.0,
//                             color: Colors.yellowAccent),
//                         options: const LinkifyOptions(
//                             humanize:
//                                 false), // ให้แสดงตัวหนังสือ https:// ด้วย ไม่งั้นจะถูกตัดออกไป
//                       ),
//                     ),
//                     Container(
//                       // สำหรับชื่อ ชุดข้อสอบ
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         //  color: Colors.redAccent,
//                         color: Theme.of(context).primaryColorDark,
//                         border: const Border(
//                           top: BorderSide(width: 1, color: Colors.white70),
//                           //   bottom: BorderSide(width: 1, color: Colors.white),
//                         ),
//                       ),
//                       child: Text(
//                         "$_title",
//                         textAlign: TextAlign.center,
//                         // style: TextStyle(
//                         //   color: Colors.white,
//                         //   fontSize: 16.0,
//                         // ),
//                         style: const TextStyle(
//                             fontSize: 18.0,
//                             color: Colors.white54,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Container(
//                       // สำหรับปุ่มซื้อ
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.blue[100],
//                         //color: Theme.of(context).primaryColorDark,
//                         border: const Border(
//                           top: BorderSide(width: 1, color: Colors.white70),
//                           bottom: BorderSide(width: 1, color: Colors.black45),
//                         ),
//                       ),
//                       // child:
//                       // !(isThisItemNew) // ถ้า isThisItemNew = false ไม่แสดง NEW
//                       // ? Text(
//                       // "ข้อ ${widget.currQNum}/${widget.numOfQstns}",
//                       // style: TextStyle(
//                       // fontSize: 14.0, color: Colors.white),
//                       // )
//                       //     : Ric
//                       // debugPrint("isBoughtAlready for buy Btn: $isBoughtAlready");  // cannot debugPrint here
//                       // child: !(isBoughtAlready)  // ไม่เอาแล้ว เอาจากที่ส่งมาจาก MainMenu
//
//                       child:
//                           !(_buyStatus) // สถานะการซื้อ ส่งมาจาก MainMenu  และ จาก provider
//                               // child: !(isBought)
//                               ? SizedBox(
//                                   height: 38,
//                                   width: 120,
//                                   child: TextButton(
//                                     child: Text(
//                                       'วิธีซื้อรุ่นเต็ม',
//                                       style: TextStyle(
//                                         fontFamily: 'Athiti',
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18.0,
//                                         color: Colors.blue[900],
//                                       ),
//                                     ),
//                                      onPressed: () {
//                                       if(ActiveConnection) { // ถ้ามีอินเทอร์เน็ต
//                                         //   //debugPrint('ส่งไปหน้า ให้ซื้อ PaymentScreen');
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 PaymentScreen(
//                                                   // revenueCat
//                                                   key: const ValueKey('uniqueKey'),
//                                                   isDarkMde: isDarkMode,
//                                                   isBuy: _buyStatus,
//                                                 ),
//                                           ), //กำลังแก้ไข -- OK
//                                         );
//                                       }else{  // ถ้าไม่ต่อกับอินเทอร์เน็ต ซื้อไม่ได้
//                                         // show message
//                                         showDialog(
//                                           context: context,
//                                           builder: (BuildContext context) {
//                                             return AlertDialog(
//                                               title: const Text('ไม่มีการเชื่อมต่ออินเทอร์เน็ต', style: TextStyle(color: Colors.red, fontWeight:
//                                               FontWeight.bold),),
//                                               //content: Text('ท่านต้องเชื่อมต่อกับอินเทอร์เน็ตก่อน นะครับ'),
//                                               content: RichText(
//                                                 text: const TextSpan(
//                                                   text: 'ท่านต้องเชื่อมต่อกับอินเทอร์เน็ตก่อน นะครับ',
//                                                   style: TextStyle(fontSize: 20, color: Colors.black87),
//                                                   children: <TextSpan>[
//                                                     TextSpan(text: '\n\n(กดปุ่มลูกศรออกจากหน้านี้ ต่อเชื่อมอินเทอร์เน็ต แล้วจึงกดปุ่มซื้ออีกครั้ง)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                                                   ],
//                                                 ),
//                                               ),
//                                               actions: <Widget>[
//                                                 TextButton(
//                                                   onPressed: () => Navigator.of(context).pop(),
//                                                   child: Text('OK'),
//                                                 ),                                           ],
//                                             );
//                                           },
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 )
//                               : const SizedBox.shrink(),
//                     ),
//                     Expanded(
//                       child: Scaffold(
//                           // สำหรับตัวข้อสอบ ลูกศรเลื่อนข้อ และ เลขข้อ/จำนวนข้อ
//                           body: PageView.custom(
//                         controller: _pageController,
//
//                         childrenDelegate: SliverChildBuilderDelegate(
//                           (context, index) {
//                             // int currQstnNum = index + 1;
//                             _currQstnNum = index + 1;
//                             // กำลังสงสัยอยู่ว่า ตรงนี้น่าจะเกี่ยวกับที่บางข้อไม่แสดง เลขหน้า ?????????
//                             // ข้อปัจจุบัน บวก 1 เพราะ list เริ่มที่ 0
//                             debugPrint("_currQstnNum ข้อ: $_currQstnNum");
//                             _numOfQstn = items.length;
//                             // จำนวนข้อ ในข้อสอบปัจจุบันที่กำลังแสดงในหน้า pageview
//                             var i = 0;
//                             items.forEach((item) {
//                               // วนดูชุดข้อสอบที่ส่งเข้ามา
//                               i++;
//                               debugPrint(
//                                   'ข้อที่: $i || qNum: ${item.qNum} || question: ${item.question} || isExplain: ${item.isExplain}');
//                             });
//                             debugPrint(
//                                 "item ทดลองดู: ${items[3]}"); // instance of Exam
//                             debugPrint(
//                                 "_pageController.hasClients: ${_pageController.hasClients}");
//
//                             return KeepAlive(
//                               data: items[index],
//                               //     key: ValueKey<String>(items[index]),
//                               key: ValueKey<Exam>(items[index]),
//                               // ส่่งไป class KeepAlive extends StatefulWidget
//                               currQNum: _currQstnNum,
//                               // ส่่งไป class KeepAlive extends StatefulWidget
//                               numOfQstns: _numOfQstn,
//                               // ส่่งไป class KeepAlive extends StatefulWidget
//                               fileName: _myExams,
//
//                               controller: _pageController,
//                             );
//                           },
//                           childCount: items.length,
//                           findChildIndexCallback: (Key key) {
//                             final ValueKey valueKey = key as ValueKey<dynamic>;
//                             final Exam data = valueKey.value;
//                             return items.indexOf(data);
//                           },
//                         ),
//                       )),
//                     ),
//                   ],
//                 );
//               }
//               return const Center(
//                 child: CircularProgressIndicator(), // added,
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future CheckUserConnection() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         setState(() {
//           ActiveConnection = true;
//         });
//       }
//     } on SocketException catch (_) {
//       setState(() {
//         ActiveConnection = false;
//       });
//     }
//     debugPrint("ActiveConnection: $ActiveConnection");
//   }
//
//
//   Future<bool> check_if_already_bought_from_hashTable() async {
//     // ตรงนี้ทำให้ไม่แสดงหน้าข้อสอบ มีแต่หมุน ๆ  -- ได้แล้ว ผิดตรงที่เอาค่าจาก result ออกมาไม่ถูก
//     bool isBuy;
//     final dbClient = await SqliteDB().db;
//     var result =
//         await dbClient!.rawQuery('SELECT * FROM hashTable WHERE name = "sku"');
//     if (result.isNotEmpty) {
//       // ค่าของ result อยู่ในรูป list เช่น result: [{id: 312, name: sku, str_value: true}]
//       debugPrint("isBoughtAlready inside function is not empty.");
//       String val = result.first['str_value'] as String;
//       if (val == "true") {
//         isBuy = true;
//       } else {
//         isBuy = false;
//       }
//     } else {
//       isBuy = false;
//     }
//     debugPrint("isBoughtAlready inside function - result: $result");
//     debugPrint("isBoughtAlready inside function: $isBuy");
//     return isBuy;
//   }
//
//   Future<List<Exam>> getExamDataFromXML(BuildContext context) async {
//     String xmlString = await DefaultAssetBundle.of(context)
//         .loadString("assets/data/$_myExams");
//     //  .loadString("assets/data/dummy.xml");
//     // .loadString("assets/data/contact.xml");
//     //   var raw = xml.XmlDocument.parse(xmlString);
//     final document = XmlDocument.parse(xmlString);
//     //debugPrint('document tttttttttttt $document');
//     var elements = document.findAllElements("thisQuestion");
//
//     return elements.map((element) {  // text is deprecated ก็เลยต้องให้ Gemini ปรับให้
//       debugPrint("qNum_text: ${element.findElements("qNum").first.innerText}");
//
//        return Exam(
//           element.findElements("qNum").first.innerText,
//           element.findElements("question").first.innerText,
//           element.findElements("choice_A").first.innerText,
//           element.findElements("choice_B").first.innerText,
//           element.findElements("choice_C").first.innerText,
//           element.findElements("choice_D").first.innerText,
//           element.findElements("choice_E").first.innerText,
//           element.findElements("explanation").first.innerText,
//           element.findElements("isExplain").first.innerText,
//           int.parse(element.findElements("correctAns").first.innerText));
//     }).toList();
//   }
//
//   Future<void> handleClick(String value) async {
//     switch (value) {
//       case 'sendMyMail':
//         final Uri params = Uri(
//           scheme: 'mailto',
//           path: 'thongjoon@gmail.com',
//           query:
//               'subject=หัวข้อเรื่อง (โปรดระบุ)&body=สวัสดีครับ/ค่ะ', //add subject and body here
//         );
//
//         var url = params;
//         if (canLaunchUrl(url) != null) {
//           await launchUrl(url);
//         } else {
//           throw 'Could not launch $url';
//         }
//         break;
//       case 'vote':
//         Utils.openLink(
//             url:
//                 'https://play.google.com/store/apps/details?id=com.thongjoon.ocsc_exam_prep');
//         break;
//       case 'share':
//         Share.share(
//             "แนะนำ แอพเตรียมสอบ กพ ใช้ได้ทั้ง Android และ iPhone ดาวโหลดที่ Play Store และ App Store");
//         break;
//       case 'about':
//         openAboutDialog();
//         break;
//     }
//   }
//
//   void openAboutDialog() {
//     Navigator.of(context).push(new MaterialPageRoute<Null>(
//         builder: (BuildContext context) {
//           return new aboutDialog();
//         },
//         fullscreenDialog: true));
//   }
//
//   _showMaterialDialog(String msg) {
//     // สำหรับเมนู 3 จุด
//     showDialog(
//         context: context,
//         builder: (_) => new AlertDialog(
//               title: new Text("Material Dialog"),
//               content: new Text(msg),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('Close me!'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             ));
//   }
//
//   void insertOrUpdateTableRow({String? fileName, int? appInstallDate}) async {
//     final dbClient = await SqliteDB().db;
//     // ดูว่า มีไฟล์นี้ ข้อนี้ ในตาราง itemTable หรือเปล่า
//     var count = Sqflite.firstIntValue(await dbClient!.rawQuery(
//         'SELECT COUNT (*) FROM itemTable WHERE file_name = ?', ["$fileName"]));
//     debugPrint("fileName x count xx: $fileName");
//     debugPrint("x count xx (จำนวนข้อ เพราะ 1 record คือ 1 ข้อ): $count");
//     if (count == 0) { // ไฟล์ใหม่ซิง ๆ ทั้งหมด
//       // กรณีเป็นไฟล์ที่เพิ่มเข้ามาใหม่ ใน main.dart จะยังไม่มีในตาราง itemTable
//       debugPrint("x count xx: (Not in itemTable) count = $count");
//       getExamDataFromXmlAndWriteToItemTable(context,
//           fileName!); // ไม่ทำงาน ไม่รู้เป็นอะไร ***ทำงานแล้ว ส่งชื่อ itemTable ผิด มีช่องว่างเกินไปอัน เป็น " itemTable" เลยหาไม่เจอ ไม่บอก error อีกต่างหาก
//     } else { // ไฟล์มีอยู่แล้ว
//       // กรณีเป็นไฟล์ที่เก่าที่มีอยู่แล้วใน main.dart
//       //  ถ้าภายใน 15 วัน หรือตามที่กำหนด  isNew ให้เป็น 1 (ใหม่) ภายใน 15 วัน คลิกแล้ว isNew = 0 (เก่า) หรือ เกิน 15 วัน ไม่ว่าจะคลิกแล้วหรือยัง ก็เป็น เก่า isNew=0
//
//       // ถ้ายังอยู่ในเกณฑ์ใหม่
//       //  1. เพิ่มข้อใหม่ เพิ่ม id ใหม่ วันที่ใหม่
//       // 2. ข้อเดิม แต่มีการปรับใหม่ ใช้ id เดิม วันที่ใหม่
//
//
//       // แต่เพิ่มข้อใหม่เข้ามา จะยังไม่มีในตาราง itemTable
//       // // ยัง udate ไม่ได้ เพราะต้องเข้าไปเอาวันที่ จากใน xml
//       // debugPrint("x count xx: update"); //  เดี๋ยวค่อยทำต่อ
//       // var dateFromSqlite = Sqflite.firstIntValue(await dbClient!.rawQuery(
//       //     'SELECT item_date FROM itemTable WHERE file_name = ? AND item_id = ?',
//       //     ["$fileName"]));
//
//       //  ยังไม่ได้ตรวจสอบ ละเอียด  ต้องลองเปลี่ยน วันที่ ในข้อสอบ บางข้อ แล้วดูว่า update ตารางไหม
//       // มีจุดแดงไหม
//       debugPrint("ไฟล์เก่า -- file name: $fileName");
//       debugPrint("count not equal to 0 แสดงว่ามีไฟล์นี้แล้ว หลายข้อ ");
//       debugPrint("date created of $fileName from main.dart (วันที่ในหน้าเมนู): $_createDate");
//
//       getDateAndUpdateItemTable(context, fileName!, appInstallDate!); // กรณีไฟล์ที่มีอยู่แล้ว ต้องเชคว่า มีข้อเพิ่ม หรือ update วันที่หรือไม่
//     }
//   }
//
//   //  คิดว่า น่าจะแถว ๆ นี้ ที่กลับไปแล้ว มีจุดแดง ปุ่มแดง
//
//   // void checkAndActOnIsNewOfOcscTjkTable(
//   //     {String? whatFileName, int? whatDate}) async {
//   //   final dbClient = await SqliteDB().db;
//   //   var count = Sqflite.firstIntValue(await dbClient!.rawQuery(
//   //       'SELECT COUNT (*) FROM itemTable WHERE file_name = ? AND isClicked = "false" AND isNew = "1" ',
//   //       ["$whatFileName"]));
//   //   //
//   //   if(whatFileName!.startsWith("2_th_3_word_order")) {
//   //     debugPrint(
//   //         "file: $whatFileName  count isNew before going back to MainMenu  x count xx: $count ");
//   //   }
//   //
//   //   if (count == 0) {
//   //     // เท่ากับ 0 คือไม่มี ถ้ามี ก็แสดงว่า ยังทำของใหม่ ยังไม่หมด ไม่เอาจุดแดงหน้าเมนูออก
//   //     //    debugPrint("x count xx: isNew ใน itemTable ไม่มี");
//   //  //  updateIsNewOfOcscTjkTable(context, whatFileName,
//   //         whatDate!); // ถ้า isNew ในตาราง OcscTjkTable เท่ากับ 0 จะไม่มีจุดแดง หน้าเมนู
//   //   } else {
//   //     // ถ้ายังมี NEW อยู่ ปรับให้มีจุดแดง ในหน้า mainMenu โดยให้ isNew = 1
//   //  //   updateIsNewOfOcscTjkTableToOne(context, whatFileName, whatDate!);
//   //   }
//   // }
//
//   // void updateIsNewOfOcscTjkTable(
//   //     BuildContext context, String whatFileName, int whatDate) async {
//   //   final dbClient = await SqliteDB().db;
//   //   var res = await dbClient!.rawQuery('''
//   //   UPDATE OcscTjkTable
//   //   SET isNew = ?,
//   //   dateCreated =?
//   //   WHERE file_name = ?
//   //   ''', [0, whatDate, '$whatFileName']);
//   // }
//
//   // void updateIsNewOfOcscTjkTableToOne(
//   //     BuildContext context, String whatFileName, int whatDate) async {
//   //   final dbClient = await SqliteDB().db;
//   //   var res = await dbClient!.rawQuery('''
//   //   UPDATE OcscTjkTable
//   //   SET isNew = ?,
//   //   dateCreated =?
//   //   WHERE file_name = ?
//   //   ''', [1, whatDate, '$whatFileName']);
//   // }
//
//   void updateOcscTjkTbl_open_last(
//       {String? whatFileName, String? whereToStart, String? whatPicName}) async {
//     debugPrint("whereToStart หน้าปัจจุบัน for open last: $whereToStart");
//     final dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawQuery('''
//     UPDATE OcscTjkTable
//     SET open_last = ?, progress_pic_name = ?
//     WHERE file_name = ?
//     ''', ['$whereToStart', '$whatPicName', '$whatFileName']);
//   }
//
//   void getWhereToStart({String? whatFileName}) async {
//     debugPrint("file name for open last: $whatFileName");
//     final dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawQuery('''
//     SELECT open_last FROM OcscTjkTable
//     WHERE file_name = ?
//     ''', ['$whatFileName']);
//     // debugPrint("whereToStart in future2: ${res[0]['open_last']}");
//     // debugPrint("whereToStart in future3: $whatFileName");
//     // debugPrint("whereToStart in future4: ${ExamModel.fromMap(res.first)}");
//     //  _pageController = PageController(initialPage: res[0]['open_last']);
//     if (res != null) {
//       // ถ้าไม่มี จะไม่ส่งค่าไป _pageController จะใช้ค่าเดิม คือเริ่มที่ หน้แรก ของ pageview ซึ่งก็คือ ข้อ 1
//       String thisLabel = res[0]['open_last']
//           as String; // บังเอิญตอนแรก เก็บข้อสุดท้ายไว้ในฐานข้อมูล (ใน main.dart) เป็นชื่อ tbl_q ต่อด้วยเลข ต่อมาเปลียนใหม่ เอาแต่ตวเลข
//       // ก็เลย ต้องจัดการดึงเอาแต่ตัวเลขออกมา ก่อนที่จะนำไป parse จาก ตัวอักษร(ข้อมูลในฐานข้อมูลเก็บเป็นลักษณะ ตัวอักษร) เป็นตัวเลข ไม่งั้น Error
//       String numToStart = "0";
//       if (thisLabel.contains("tbl_q")) {
//         numToStart = thisLabel.substring(5, thisLabel.length);
//       } else {
//         numToStart = thisLabel;
//       }
//       debugPrint("numToStart - string from database: $thisLabel");
//       debugPrint("numToStart - string: $numToStart");
//       int thisNum;
//       if (numToStart == "top") {
//         // ในตารางเก็บคำว่า top คือยังไม่ได้เข้าใช้งาน
//         thisNum = 0;
//       } else {
//         thisNum = int.parse(numToStart) - 1;
//       }
//       // int thisNum = int.parse(res[0]['open_last']) -
//       //     1; // ในฐานข้อมูล เป็น String เลยต้องเปลี่ยนเป็น int
//       // ถ้าไม่ ลบ 1 จะไปเปิดหน้าต่อไป จากหน้าที่แล้ว ก็เลย ลบออก 1 เพื่อว่า ออกจากหน้าไหน เวลาเข้ามาใหม่ ให้กลับไปที่หน้าเดิม
//       _pageController =
//           PageController(initialPage: thisNum); // ให้ไปเปิดหน้าที่ระบุ
//     }
//
//   }
//
//   Future<void> clearSharedDrawingData() async {
//     debugPrint("try to clear sharedDrawing");
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove("savedDrawing");
//   }
//
//
// }
//
// // void _showDrawingDialog(BuildContext context) {
// //   showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return DrawingDialog();
// //     },
// //   );
// // }
//
// void _showDrawingWindow(BuildContext context) {
//   Navigator.of(context).push(
//     PageRouteBuilder(
//       opaque: false,
//       pageBuilder: (_, __, ___) => DrawingDialog(),
//     ),
//   );
// }
//
//
// Widget _buildPopupDialog(BuildContext context) {
//   return new AlertDialog(
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//     title: Container(
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(12.0),
//           topLeft: Radius.circular(12.0),
//         ),
//         color: Colors.deepPurple,
//       ),
//       child: const Text(
//         'วิธีใช้',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//             fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
//       ),
//     ),
//     titlePadding: const EdgeInsets.all(0),
//     content: const Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text("ปัดซ้าย หรือแตะ > เพื่อไปข้อต่อไป "),
//         Text("ปัดขวา หรือแตะ < เพื่อย้อนกลับ "),
//         Text("แตะที่ \"คำอธิบาย\" เพื่อดูการเฉลย"),
//       ],
//     ),
//     actions: <Widget>[
//       new TextButton(
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//         child: Text(
//           'ปิด',
//           style:
//               TextStyle(fontSize: 14.0, color: Theme.of(context).primaryColor),
//         ),
//       ),
//     ],
//   );
// }
// //
//
// void getDateAndUpdateItemTable(BuildContext context, String fileName, int appInstallDate) async {  // กรณีไฟล์เก่า ต้องเชค ทีละข้อว่า  มีข้อเพิ่มหรือไม่ หรือมีการ udate ข้อเก่า หรือไม่
//   List lstQNumID_FromXML = <String>[];  // สำหรับเก็บ id ข้อสอบในไฟล์ xml เพื่อว่า จะได้เอาไปเชคในตาราง
//               // itemTable เพื่อลบ id ที่ไม่มี เพราะบางที แขวนอยู่ และมี isNew=1 ทำให้มีจุดแดง ไม่ได้ปรับ isNew เป็น 0
//                // เพราะ id ไม่ได้ถูกเลือก
//
//
//   String xmlString =
//       await DefaultAssetBundle.of(context).loadString("assets/data/$fileName");
//   final document = XmlDocument.parse(xmlString);
//   var idAndDate = document.findAllElements("qNum");
//   for (var element in idAndDate) {
//     var str = element.innerText;
//     if (str.contains(":date")) {
//       //รูปแบบ <qNum>id1627193:date1627453500</qNum>
//       const start = "id";
//       const end = ":date";
//       final startIndex = str.indexOf(start);
//       final endIndex = str.indexOf(end, startIndex + start.length);
//       final startIndex2 = str.indexOf(end);
//       // debugPrint(
//       //     " x count xx  str: $str startIndex: $startIndex endIndex:$endIndex startIndex2: $startIndex2");
//       String qNumId = str.substring(startIndex + start.length, endIndex);
//       String qNumDate = str.substring(startIndex2 + end.length);
//       debugPrint("inside getDateAndUpdateItemTable -- fileName: $fileName   qNum id: $qNumId qNum date: $qNumDate");
//       // เอาข้อมูลไปใส่ตาราง itemTable
//       // insertItemData(file_name: fileName, item_id: qNumId, item_date: qNumDate);
//
//       // เพิ่ม โดยเชคก่อนว่ามีหรือเปล่า จะได้ไม่ซ้ำ ถ้ากลับมาคลิกใหม่
//       if(!lstQNumID_FromXML.contains(qNumId)){
//         lstQNumID_FromXML.add(qNumId);
//       }
//
//       updateItemData(
//           file_name: fileName, item_id: qNumId, curr_item_date: qNumDate, ocscAppInstallDate: appInstallDate);
//
//       // ลบ record ของข้อสอบ ใน itemTable ที่ไม่มีในไฟล์ ข้อสอบ โดยตรวจจาก id
//
//     }
//   }
//   debugPrint("lstQNumID_FromXML: $lstQNumID_FromXML");
//   // หา id ในตาราง itemTable ที่มีชื่อไฟล์นี้
//
//
//   final dbClient = await SqliteDB().db;
//   final result = (await dbClient!.rawQuery(
//       """ SELECT item_id FROM itemTable WHERE file_name = '$fileName' """));
//   List<String> itemIds_fromItemTble = result.map((row) => row['item_id'] as String).toList();
//   debugPrint("itemIds_fromItemTble: $itemIds_fromItemTble");
//
//   // Identify elements in listA that are not in listB
//   List<String> listC = itemIds_fromItemTble.where((element) => !lstQNumID_FromXML.contains(element)).toList();
//
//   debugPrint("listC: $listC");
//   // Traverse listC and print each element
//   listC.forEach((element) async{
//     final result2 = (await dbClient.rawQuery(
//     """ DELETE FROM itemTable WHERE item_id = '$element' """));
//     print("record $element has been deleted!");
//   });
//
//
//
// }
//
// Future updateItemData(
//     {String? file_name, String? item_id, String? curr_item_date, int? ocscAppInstallDate}) async {
//
//   debugPrint("check_id: $item_id");
//
//
//   // -------------------- ปรับใหม่ -------------------------------
//
//   // ต้องเชคว่า
//   // ถ้าวันที่หลังจากติดตั้งแอพแล้ว ให้กำหนด isNew เป็น 0
//
//   // ถ้ายังอยู่ในกำหนด คือยังใหม่อยู่
//   // 1. เป็นข้อใหม่ที่เพิ่มเข้ามา กรณีนี้ จะไม่มี id ก็เพิ่มเข้าไป insert  -- isNew-1; isClicked-0
//   // 2. เป็นข้อเก่า :: update
//   //        วันที่ข้อนี้ หลังจากติดตั้งแอพ (ocscAppInstallDate) แล้วหรือไม่
//   //      2.1 หลังจากที่ติดตั้งไปแล้ว ภายใน 5 วัน และยังไม่คลิก   ::  isNew-1; isClicked-0
//   //      2.2 ก่อนติดตั้ง เกิน 5 วัน ถือว่าเก่าหมด   ::  isNew-0; isClicked-0
//
//  // int currdate = ((DateTime.now().millisecondsSinceEpoch) / 1000).floor();
// //  debugPrint("curr date: $currdate"); // เวลาปัจจุบัน เป็นวินาที (timestamp)
// //
//   final dbClient = await SqliteDB().db;
//
//   // check if id exists in SQlite
//   var countThisQuestionID = Sqflite.firstIntValue(await dbClient!.rawQuery(
//       '''SELECT COUNT (*) FROM itemTable WHERE file_name = ? AND  item_id = ? ''',
//       ['$file_name','$item_id']));
//
//   // 1. เป็นข้อใหม่ที่เพิ่มเข้ามา กรณีนี้ จะไม่มี id ก็เพิ่มเข้าไป insert  -- isNew-1; isClicked-0
//   if(countThisQuestionID! <= 0){
//     debugPrint("item not found: NEW Question");
//     debugPrint("updateItemData - all New");
//
//     insertItemData(
//         file_name: file_name,
//         item_id: item_id,
//         item_date: curr_item_date,
//         isClicked: "false",
//         isNew: "1");  // ถูกต้องแล้ว เพราะเป็นข้อใหม่ที่เพิ่มเข้ามา
//
//   }else{
//     // 2. เป็นข้อเก่า :: update
//     debugPrint("item found: update it Question");
//
//     // เชคต่อว่า เกิน 90 วันหรือยัง
//
//
// // get item_date from sqlite  // ตรงนี้ผิด cast ไม่ได้ เพราะ เขาออกมาเป็น list จึงต้อง map ก่อน แล้วจึง cast
// //     String dateFromSQlite = (await dbClient.rawQuery('''
// //     SELECT item_date FROM itemTable
// //     WHERE file_name = ?
// //     AND item_id =?
// //     ''', ['$file_name', '$item_id'])) as String;
//
//     //แก้แล้ว chatGPT ช่วยแก้ให้  ต้อง map แล้วจึง cast
//     List<Map<String, dynamic>> result = await dbClient.rawQuery('''
//         SELECT item_date, isNew, isClicked FROM itemTable
//         WHERE file_name = ?
//         AND item_id =?
//         ''', [file_name, item_id]);
//
// // Check if the result is not empty and extract the item_date
//     String dateFromSQlite = '';
//     // String isNew_itemTbl ='';
//     String isClicked_itemTbl='';
//
//     if (result.isNotEmpty) {
//
//       // Check if 'item_date' is null and provide a default value if necessary
//       dateFromSQlite = result.first['item_date'] as String? ?? "111111";
//
//       // Check if 'isNew' is null and provide a default value if necessary
//       // isNew_itemTbl = result.first['isNew'] as String? ?? "0";
//
//       // Check if 'isClicked' is null and provide a default value if necessary
//       isClicked_itemTbl = result.first['isClicked'] as String? ?? "false";
//
//       // if(result.first['item_date'] == null){
//       //   dateFromSQlite = "111111";
//       // }else{
//       //   dateFromSQlite = result.first['item_date'];
//       // }
//       // if(result.first['isNew'] == null){
//       //   isNew_itemTbl = "0";
//       // }else{
//       //   isNew_itemTbl = result.first['isNew'];
//       // }
//       // if(result.first['isClicked'] == null){
//       //   isClicked_itemTbl = "false";
//       // }else{
//       //   isClicked_itemTbl = result.first['isClicked'];
//       // }
//       // dateFromSQlite = result.first['item_date'];
//       // isNew_itemTbl = result.first['isNew'];
//       // isClicked_itemTbl = result.first['isClicked'];
//     }
//
//     debugPrint("ข้อสอบเก่า -- file name: $file_name dateFromSQlite $dateFromSQlite");
//
//     // ไม่ใช่แล้ว ต้องไปเชคกับวันปัจจุบัน คือ ถ้าปรับใหม่ แต่ยงไม่เกิน 15 วัน ถอยหลงจากวันนี้ไป ก็จะยังใหม่
//     // แต่ถ้าไปเทียบกับวันติดตั้งโปรแกรม ถ้าใช้มานานแล้ว เกิน 15 วัน อะไรที่ update ใหม่ ก็จะไม่มีจุดแดง
//     //  int dateDiff = (((int.parse(curr_item_date!)) - ocscAppInstallDate! / 86400).ceil(); //  (วันที่ในไฟล์ xml จากหน้า เมนู) - (วันติดตั้งแอพ)
//     // debugPrint("id: $item_id curr_item_date: $curr_item_date จำนวนวันหลังติดตั้ง dateDiff: $dateDiff");
//
// // Grok ปรับให้
//     // Get current date in epoch seconds
//     int currentDateSeconds = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
// // Parse curr_item_date from string to int (assuming it's in seconds)
//     int itemDateSeconds = int.parse(curr_item_date!);
// // Calculate difference in days
//     int dateDiff = ((currentDateSeconds - itemDateSeconds) / 86400).ceil();
//     debugPrint("id: $item_id curr_item_date: $curr_item_date currentDateSeconds: $currentDateSeconds dateDiff: $dateDiff");
//
// // Case 1: Item is older than 15 days -> mark as not new (old)
//     if (dateDiff > 15) {
//       debugPrint("id: $item_id ไฟล์เก่า: $file_name date: $curr_item_date dateDiff: $dateDiff -- OLD");
//       await dbClient.rawQuery('''
//     UPDATE itemTable
//     SET item_date = ?, isNew = '0'
//     WHERE file_name = ? AND item_id = ?
//     ''', ['$curr_item_date', '$file_name', '$item_id']);
//     }
// // Case 2: Item is within 15 days
//     else {
//       // Sub-case 2a: Not clicked -> mark as new
//       if (isClicked_itemTbl == "false") {
//         debugPrint("id: $item_id ไฟล์ใหม่: $file_name date: $curr_item_date dateDiff: $dateDiff -- NEW within 15 days");
//         await dbClient.rawQuery('''
//       UPDATE itemTable
//       SET item_date = ?, isNew = '1'
//       WHERE file_name = ? AND item_id = ? AND isClicked = 'false'
//       ''', ['$curr_item_date', '$file_name', '$item_id']);
//       }
//       // Sub-case 2b: Clicked -> mark as not new (old)
//       else if (isClicked_itemTbl == "true") {
//         debugPrint("id: $item_id ไฟล์ใหม่แต่คลิกแล้ว: $file_name date: $curr_item_date dateDiff: $dateDiff -- NEW but CLICKED");
//         await dbClient.rawQuery('''
//       UPDATE itemTable
//       SET item_date = ?, isNew = '0'
//       WHERE file_name = ? AND item_id = ? AND isClicked = 'true'
//       ''', ['$curr_item_date', '$file_name', '$item_id']);
//       }
//     }
//   //   if (dateDiff > 15) {
//   //          // ข้อนี้ อายุมากกว่าติดตั้งแอพ เกิน 5 วัน ถือว่าเก่ามาก จะไม่มีจุดแดง
//   //       debugPrint(
//   //       "id: $item_id ไฟล์เก่า: $file_name date: $curr_item_date dateDiff: $dateDiff -- OLD");
//   //       // เก่าเกินกว่า 15 วัน ถือว่า ไม่ใหม่แล้ว update วันที่ และ isNew ให้เป็น 0 (เพราะบางที มี isNew เป็น 1 ค้างอยู่)
//   //       // var res = await dbClient.rawQuery('''
//   //       //   UPDATE itemTable
//   //       //   SET item_date = ?,
//   //       //   isNew = ?
//   //       //    WHERE file_name = ?
//   //       //   AND item_id =?
//   //       //   ''', ['$curr_item_date', '0', '$file_name', '$item_id']);
//   //       if (isNew_itemTbl == "1") {
//   //         await dbClient.rawQuery('''
//   //     UPDATE itemTable
//   //     SET item_date = ?, isNew = ?
//   //     WHERE file_name = ? AND item_id = ?
//   //     ''', ['$curr_item_date', '0', '$file_name', '$item_id']);
//   //       }
//   //   } else {
//   //           // less than 15 days old -- still NEW  น้อยกว่า 15 วัน หลังติดตั้ง ถือว่ายังใหม่อยู่  ถ้ายังไม่คลิก
//   //         debugPrint(
//   //         "id: $item_id ไฟล์ใหม่: $file_name date: $curr_item_date dateDiff: $dateDiff -- NEW within 90 days");
//   //         // ไม่เกินกว่า 5 วัน ถือว่า ยังใหม่อยู่ update วันที่ และ isNew โดยมีเงื่อนไขว่า isClicked ต้องเป็น false คือยังไม่คลิก
//   //     if(isClicked_itemTbl == "false") {
//   //         var res = await dbClient.rawQuery('''
//   //         UPDATE itemTable
//   //         SET item_date = ? ,
//   //         isNew = ?
//   //         WHERE file_name = ?
//   //         AND item_id = ?
//   //         AND isClicked = ?
//   //         ''', ['$curr_item_date', '1', '$file_name', '$item_id', "false"]);
//   //     } // end of  if(isClicked_itemTbl == "false")
//   // }  // end of  if (dateDiff > 15)
//
//   }// end of  if(countThisQuestionID! <= 0)
//
//
// }  // end of Future updateItemData()async{
//
//
// //Future<List<Exam>> getExamDataFromXmlAndWriteToItemTable(
// void getExamDataFromXmlAndWriteToItemTable( // กรณีไฟล์เพิ่มเข้ามาใหม่ทั้งไฟล์
//     BuildContext context, String fileName) async {
//   //  debugPrint("x count xx inside getExamDataFromXmlAndWriteToItemTable");
//   String xmlString =
//       await DefaultAssetBundle.of(context).loadString("assets/data/$fileName");
//   // ต้องไปอ่านจาก xml เพราะที่ส่งมาใน myExams จ่าก main.dart  มีแต่ชื่อ
//   //  .loadString("assets/data/dummy_xml.xml");
// //  debugPrint("x count xx inside xmlString: $xmlString");
//   final document = XmlDocument.parse(xmlString);
// //  debugPrint(' x count xx  document tttttttttttt $document');
//   var idAndDate = document.findAllElements("qNum");
//   // แยกเป็น id และ date  จาก <qNum></qNum>
//   // รูปแบบของ qNum ในไฟล์ xml คือ <qNum>id1627193508:date1627453893</qNum>
//   for (var element in idAndDate) {
//     var str = element.innerText;
//     if (str.contains(":date")) {
//       //รูปแบบ <qNum>id1627193:date1627453500</qNum>
//       // วนทำทีละข้อในไฟล์นี้ จนหมดทุกข้อ
//       const start = "id";
//       const end = ":date";
//       final startIndex = str.indexOf(start);
//       final endIndex = str.indexOf(end, startIndex + start.length);
//       final startIndex2 = str.indexOf(end);
//       // debugPrint(
//       //     " x count xx  str: $str startIndex: $startIndex endIndex:$endIndex startIndex2: $startIndex2");
//
//       String qNumId = str.substring(startIndex + start.length, endIndex);
//       String qNumDate = str.substring(startIndex2 + end.length);
//       //     debugPrint("x count xx   qNum id: $qNumId qNum date: $qNumDate");
//       // เอาข้อมูลไปใส่ตาราง itemTable
//       // insertItemData(file_name: fileName, item_id: qNumId, item_date: qNumDate);
//       //ไฟล์เพิ่มเข้ามาใหม่ทั้งไฟล์ ทุกข้อต้องเป็นข้อใหม่ isNew="1"  -- ต้องเป็น 0 มั๊ง ไม่งั้น เวลาคลิกแล้วกลับมา มีจุดแดง
//       insertItemData(
//           file_name: fileName,
//           item_id: qNumId,
//           item_date: qNumDate,
//           isClicked: "false",
//         //  isNew: "0");  // ต้องเป็น 0 คือ เป็นของเก่า  // แต่เดี๋ยว ลองคิดดูใหม่ กรณีของใหม่จริง ๆ ทำไง -- วันนี้ พอก่อน
//           isNew: "1");  // ถูกต้องแล้ว เพราะเป็นไฟล์ใหม่ทั้งหมด
// //      debugPrint("qNumxx: $fileName ${element.text}");
//       //debugPrint('${element.attributes.first.value}->${element.text}');
//     }
//   }
// }
//
// Future insertItemData(
//     {String? file_name,
//     String? item_id,
//     String? item_date,
//     isClicked,
//     isNew}) async {
//   // debugPrint("x count xx  itemID: $item_id");
//
//   // debugPrint(
//   //     "x count xx insertItemData file_name: $file_name item_id: $item_id item_date: $item_date");
//   int res;
//   // Add to table
//   // bool isAfterFirstRun = await getBooleanValue("after_First_Run"); // ยังไม่ถูก
//   // สงสัยต้องไปเชคที่อื่น ปรับ isNew เป็น 0 เหมือนตอนต้นก่อน
//   // debugPrint(
//   //     "isAfterFirstRun true-เคยใช้แล้ว false-เพิ่งเปิดใช้งานครั้งแรก: $isAfterFirstRun");
//   final dbClient = await SqliteDB().db;
// //  if (isAfterFirstRun == true) {
//   // ไม่ใช่เป็นการใช้งานครั้งแรก เมื่อมีการเพิ่มไฟล์ใหม่ เอาใส่ฐานข้อมูล และให้ถือเป็นไฟล์ใหม่
//   res = await dbClient!.rawInsert(
//       'INSERT INTO "itemTable" (file_name,item_id,item_date,isClicked,isNew) VALUES(?,?,?,?,?)',
//       ['$file_name', '$item_id', '$item_date', '$isClicked', '$isNew']);
//   // } else {
//   //   res = await dbClient.rawInsert(
//   //       // ถ้าเป็นการใช้งานครั้งแรก ไฟล์ที่ยังไม่มีในฐานข้อมูล ก็เอาใส่ในฐานข้อมูล และ ถือเป็นไฟล์เก่า
//   //       'INSERT INTO "itemTable" (file_name,item_id,item_date,isClicked,isNew) VALUES(?,?,?,?,?)',
//   //       ['$file_name', '$item_id', '$item_date', 'false', '0']);
//   // } // isNew เป็น 1 เพราะ เป็นไฟล์ใหม่ที่เพิ่งส่งเข้ามา
//   // แต่ เดี๋ยวก่อน ตอนใช้งานครั้งแรก มันก็จะใหม่หมดทุกไฟล์ ต้องให้ยกเว้นไว้ตรงนี้
// // เอาเป็นว่า เชควันที่ ถ้า น้อยกว่า
//   return res;
// }
//
// class KeepAlive extends StatefulWidget {
//   const KeepAlive({
//     required Key key,
//     required this.data,
//     required this.currQNum,
//     required this.numOfQstns,
//     required this.fileName,
//     required this.controller,
//   }) : super(key: key);
//
//   //final String data;
//   final Exam data;
//   final int currQNum;
//   final int numOfQstns;
//   final String fileName;
//   final PageController controller;
//
//   @override
//   _KeepAliveState createState() => _KeepAliveState();
// }
//
// class _KeepAliveState extends State<KeepAlive>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//
// // เอาไว้นอก Build เพราะจะได้ใช้ SetState เปลี่ยนค่า เพื่อให้แสดงเครื่องหมาย ถูก ผิด แต่ละตัวเลือก
//   bool isShowCheckMark_A = false;
//   bool isShowCheckMark_B = false;
//   bool isShowCheckMark_C = false;
//   bool isShowCheckMark_D = false;
//   bool isShowCheckMark_E = false;
//
//   // ลองเอาไปไว้ที่อื่น
//   bool isThisItemNew =
//       false; // สำหรับดูว่า ข้อนี้ใหม่หรือไม่ ถ้าใหม่ จะได้มีใส่คำว่า NEW ต่อท้ายเลขข้อ
//   // bool isBoughtAlready = false;
//   var isNew_arrayList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     //  widget.controller.jumpTo(5);   ไม่รู้จะเอาไปไว้ตรงไหน
//     // if (widget.controller.hasClients) {
//     //   widget.controller.jumpTo(5);
//     // }
//
//     // debugPrint("_pageController.hasClientsXXX: ${widget.controller.hasClients}");
//     // debugPrint("isThisItemNew after Build: $isThisItemNew");
//     // void addNewAfterItemNum(){
//     //   setState(() {
//     //     // เพื่อให้มีคำว่า NEW หลังข้อสอบ ข้อนี้
//     //     isThisItemNew = true;
//     //   });
//     // }
//     bool isShowAns =
//         true; // สำหรับ ไม่แสดงเฉลย ถูกผิด และ คำอธิบาย ของแต่ละข้อ ขึ้นอยู่กับ ข้อความที่บอกมาจาก xml ไฟล์ ในส่วน <isExplain>
//     // true = ซ่อน ไม่แสดงเฉลย-คำอธิบาย  false = ไม่ใช่รุ่นจำกัด
//     String check_isExplain = widget.data.isExplain.toString();
//     //  if (check_isExplain.contains("yes")) {
//
//     //   check_isExplain = "yes"; // เปิดเต็ม ชั่วคราว
//     if (check_isExplain == "yes") {
//       // ถ้าข้อนี้บอกว่าเป็น yes ก็ให้แสดงคำตอบ  แม้ว่าจะยังไม่ซื้อก็ตาม
//       isShowAns = true;
//     } else {
//       isShowAns =
//           false; // ถ้าไม่ใช่ yes จะไม่แสดงเฉลย ถ้ายังไม่ซื้อ (ไม่ใช่รุ่นเต็ม)
//     }
//     // **********
//     // debugPrint("qNum: ${widget.data.isExplain.toString()}");
//     // debugPrint("qNum: ${widget.data.question.toString()}");
//     // debugPrint("qNum: ${widget.data.choice_A.toString()}");
//     // debugPrint("qNum: ${widget.data.choice_B.toString()}");
//     // debugPrint("qNum: ${widget.data.choice_C.toString()}");
//     // debugPrint("qNum: ${widget.data.choice_D.toString()}");
//     // debugPrint("qNum: ${widget.data.choice_E.toString()}");
//     // debugPrint("qNum: ${widget.data.exPlanation.toString()}");
//     // debugPrint("qNum: ${widget.data.isExplain.toString()}");
//
//     //***********
//
//     // debugPrint(
//     //     "ข้อนี้เฉลยหรือไม่ จาก isExplain ในไฟลฺ์ xml: ${widget.data.isExplain}");
//     // debugPrint("ข้อนี้เฉลยหรือไม่ isShowAns: $isShowAns");
//
//     String choiceE = widget.data.choice_E.toString();
//     bool isChoice_E_Empty = choiceE.trim().isEmpty ??
//         true; // เชคว่า ตัวเลือก ข้อ จ. มีหรือไม่  true= ไม่มีข้อ จ.      false= มีข้อ จ
//
//     // แยก id และ วันที่
//     String id_and_date = widget.data.qNum;
//     const start = "id";
//     const end = ":date";
//     final startIndex = id_and_date.indexOf(start);
//     final endIndex = id_and_date.indexOf(end, startIndex + start.length);
//     final startIndex2 = id_and_date.indexOf(end);
//     // debugPrint(
//     //     "str: $id_and_date startIndex: $startIndex endIndex:$endIndex startIndex2: $startIndex2");
//     String qNumId = id_and_date.substring(startIndex + start.length, endIndex);
//     String qNumDate = id_and_date.substring(startIndex2 + end.length);
//     //   debugPrint("qNum id: $qNumId qNum date: $qNumDate");
//     String thisFile = widget.fileName;
//     bool isDisplay_with_katex = false;
//     if (qNumId.contains("_katex")) {
//       isDisplay_with_katex = true;
//     }
//
//     // เชคในตาราง itemTable ถ้ามีข้อมูล ให้เปรียบเทียบวันที่ ถ้าไม่มี ให้เพิ่มข้อมูล ถ้าวันที่ยังไม่เกิน 90 วัน ถือว่า ยังใหม่
//     //  future:
//
//     // ************************  ลอง ย้าย
//     checkItemTable(fileName: thisFile, qNumId: qNumId, qNumDate: qNumDate);
// // **************************
//
//     // debugPrint("isShowCheckMark_A:::: $isShowCheckMark_A");
//
//     //  bool showBuyBttn = check_if_already_bought;
//     final provider = Provider.of<ProviderModel>(context, listen: false);
//     // bool isFullVer = provider
//     //     .isFullVersion; // สำหรับ แสดงคำตอบ-เฉลย ในแต่ละข้อ  -- true = รุ่นเต็ม-ซื้อแล้ว ตรวจคำตอบ(แสดงเครื่องหมาย ถูก-ผิด) และแสดงคำอธิบาย
//     bool isFullVer = provider.removeAds;
//     debugPrint("isFullver : $isFullVer");
//     debugPrint("removeAds provider.removeAds: ${provider.removeAds}");
//
//     // debugPrint("isShowAns: $isShowAns");
//     final isDarkMode = Provider.of<ThemeNotifier>(context, listen: false)
//         .darkTheme; // true = dark, false = light
//     debugPrint("isShowAns in itemPageView: $isDarkMode");
//     //  debugPrint("isThisItemNew: $isThisItemNew");
//     // final isDarkMode = Porvider.of<Th
//     return Container(
//       // pageView แต่ละหน้า
//
//       //decoration: BoxDecoration(color: Colors.white),  // ไม่กำหนด เพราะ ถ้า mode black แล้ว สีไม่เปลี่ยน
//       // decoration: BoxDecoration(color: Colors.amberAccent),
//
//       child: Column(
//         children: [
//           Container(
//             // ส่วนหัวชุดข้อสอบ เมนูเลื่อนข้อ และ ข้อที่/จำนวนข้อ
//             // decoration: BoxDecoration(
//             //  border: Border.all(color: Colors.redAccent)),
//             padding: const EdgeInsets.all(8),
//             //color: Colors.blue[50],
//             color: Theme.of(context).primaryColorDark,
//             height: 35,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.topLeft,
//                     child: Visibility(
//                       child: Container(
//                         // สำหรับ icon กลับข้อแรก
//                         // decoration: BoxDecoration(
//                         //    border: Border.all(color: Colors.redAccent)),
//                         child: GestureDetector(
//                             onTap: () {
//                               // widget.controller.previousPage(
//                               widget.controller.jumpToPage(0);
//                               debugPrint(
//                                   "widget.currQNum-1:  ${widget.currQNum - 1}");
//                             },
//                             child: new Image.asset(
//                                 'assets/images/previous_first.png',
//                                 //   child: new Image.asset('assets/images/go_start.png',
//                                 width: 30.0,
//                                 height: 110.0)),
//                       ),
//                       visible: !(widget.currQNum - 1 <=
//                           0), // ถ้า อยู่ข้อ 1 ก็ไม่ต้องแสดง ลูกศรชี้ทางซ้าย
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 2),
//                 // ระยะห่าง ระหว่าง
//                 // Expanded(
//                 //   child: Align(
//                 //     alignment: Alignment.topLeft,
//                 //     child: Visibility(
//                 //       child: Container(
//                 //         decoration: BoxDecoration(
//                 //             border: Border.all(color: Colors.blueAccent)),
//                 //         child: GestureDetector(
//                 //             onTap: () {
//                 //               // widget.controller.jumpToPage(widget.currQNum - 1);
//                 //               // widget.controller.previousPage(
//                 //               widget.controller.jumpToPage(0);
//                 //               debugPrint(
//                 //                   "widget.currQNum-1:  ${widget.currQNum - 1}");
//                 //             },
//                 //             child: new Image.asset(
//                 //                 'assets/images/previous_first.png',
//                 //                 //   child: new Image.asset('assets/images/go_start.png',
//                 //                 width: 30.0,
//                 //                 height: 110.0)),
//                 //       ),
//                 //       visible: !(widget.currQNum - 1 <=
//                 //           0), // ถ้า อยู่ข้อ 1 ก็ไม่ต้องแสดง ลูกศรชี้ทางซ้าย
//                 //     ),
//                 //   ),
//                 // ),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.topLeft,
//                     child: Visibility(
//                       child: Container(
//                         child: GestureDetector(
//                             onTap: () {
//                               // widget.controller.jumpToPage(widget.currQNum - 1);
//                               widget.controller.previousPage(
//                                   // เดี๋ยวทำ เดี๋ยวไม่ทำ คือ ช้า ไม่รู้เป็นไร ไม่มี error
//                                   duration: Duration(milliseconds: 250),
//                                   curve: Curves.easeOut);
//                               debugPrint(
//                                   "widget.currQNum-1:  ${widget.currQNum - 1}");
//                               debugPrint("total page:  ${widget.numOfQstns}");
//                               // goPreviousPage(
//                               //     widget.currQNum - 1); // กลับหน้าที่ผ่านมา
//                             },
//                             child: new Image.asset('assets/images/previous.png',
//                                 width: 30.0, height: 110.0)),
//                       ),
//                       visible: !(widget.currQNum - 1 <=
//                           0), // ถ้า อยู่ข้อ 1 ก็ไม่ต้องแสดง ลูกศรชี้ทางซ้าย
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Container(
//                         // condition ? Text("True") : Text("False"),
//
//                         child:
//                             !(isThisItemNew) // ถ้า isThisItemNew = false ไม่แสดง NEW
//                                 ? Container(
//                                     alignment: Alignment.center,
//                                     width: 490,
//                                     decoration: BoxDecoration(
//                                         border:
//                                             Border.all(color: Colors.white)),
//                                     child: Text(
//                                       //   "ข้อ ${widget.currQNum}/${widget.numOfQstns}",
//                                       "${widget.currQNum}/${widget.numOfQstns}",
//                                       style: TextStyle(
//                                           fontSize: 14.0, color: Colors.white),
//                                     ),
//                                   )
//                                 : Container(
//                                     alignment: Alignment.center,
//                                     width: 490,
//                                     decoration: BoxDecoration(
//                                         border:
//                                             Border.all(color: Colors.white)),
//                                     child: RichText(
//                                       text: TextSpan(
//                                         style: TextStyle(fontSize: 14.0),
//                                         children: <TextSpan>[
//                                           TextSpan(
//                                               text:
//                                                   "${widget.currQNum}/${widget.numOfQstns}",
//                                               style: TextStyle(
//                                                   fontSize: 14.0,
//                                                   color: Colors.white
//                                                       // color: Colors.red
//                                                       .withValues(alpha: 0.8))),
//                                           TextSpan(
//                                               //  text: ' [NEW]',  // ยาวเกินไป ทำให้ล้น เป็นบรรทัดที่ 2 ทำให้มองไม่เห็น
//                                               text: '\u2022',
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 14.0,
//                                                   //fontSize: 20.0,
//                                                   //  fontStyle: FontStyle.italic,
//                                                   color: Colors.redAccent))
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                         // : Text(
//                         //     "ข้อ ${widget.currQNum}/${widget.numOfQstns} (ใหม่)",
//                         //     style: TextStyle(fontSize: 14.0),
//                         //   ),
//                         ),
//                   ),
//                 ),
//                 Expanded(
//                   // สำหรับลูกศร ข้อต่อไป
//                   child: Align(
//                     alignment: Alignment.topRight,
//                     child: GestureDetector(
//                       onTap: () {
//                         // widget.controller.jumpToPage(widget.currQNum + 1);
//                         widget.controller.nextPage(
//                             duration: Duration(milliseconds: 250),
//                             curve: Curves.easeOut);
//                         debugPrint(
//                             "_pageController.hasClientsYYY: ${widget.controller.hasClients}");
//                         debugPrint("widget.currQNum+1:  ${widget.currQNum + 1}");
//                       },
//                       child: Visibility(
//                         child: Container(
//                           child: new Image.asset('assets/images/next.png',
//                               width: 30.0, height: 110.0),
//                         ),
//                         // visible: (globals
//                         //     .isInRangeRight), // ถ้า อยู่ข้อ สุดท้าย ก็ไม่ต้องแสดง ลูกศร ชี้ทางขวา
//                         visible: !(widget.currQNum + 1 >
//                             widget
//                                 .numOfQstns), // ถ้า อยู่ข้อ สุดท้าย ก็ไม่ต้องแสดง ลูกศร ชี้ทางขวา
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   // สำหรับ ไปข้อสุดท้าย
//                   child: Align(
//                     alignment: Alignment.topRight,
//                     child: Visibility(
//                       child: Container(
//                         // decoration: BoxDecoration(
//                         //     border: Border.all(color: Colors.blueAccent)),
//                         child: GestureDetector(
//                             onTap: () {
//                               widget.controller.jumpToPage(widget.numOfQstns);
//                               // widget.controller
//                               //     .animateToPage(widget.numOfQstns);
//                               debugPrint(
//                                   "widget.currQNum-1:  ${widget.currQNum - 1} total page:  ${widget.numOfQstns}");
//                             },
//                             child: new Image.asset(
//                                 'assets/images/next_last.png',
//                                 //   child: new Image.asset('assets/images/go_start.png',
//                                 width: 30.0,
//                                 height: 110.0)),
//                       ),
//                       visible: !(widget.currQNum >=
//                           widget
//                               .numOfQstns), // ถ้า อยู่ข้อ 1 ก็ไม่ต้องแสดง ลูกศรชี้ทางซ้าย
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           //    Text("qNum: ${.qNumwidget.data}"),
//           // Text("isChoice_E_Empty: ${isChoice_E_Empty}"),
//           // Text("ข้อ ${widget.currQNum}"),
//           // Text("ข้อสอบทั้งหมด  ${widget.numOfQstns} ข้อ"),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//               // crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // เงื่อนไขมาใส่ตรงนี้ ถ้ามี _katex ให้ใช้ katex_flutter
//                 //  !isDisplay_with_katex
//                 //   ? // if NOT isDisplay_with_katex แสดง ปกติ ใช้ Html
//                 Html(
//                   data: "${widget.data.question}",
//
//                   // onLinkTap: (url, _, __) async {   // for a tag, not working
//                   //   final uri = Uri.parse(url!);
//                   //   if (await canLaunchUrl(uri)) {
//                   //     await launchUrl(uri);
//                   //   }
//                   // },
//
//                   shrinkWrap: true,
//                   // https://pub.dev/packages/flutter_html/versions/3.0.0-beta.1#flutter_html_math
//                   extensions: [
//                     // ทำให้ใช้ สัญลักษณ์คณิตศาสตร์ เช่น เศษส่วน รูท เป็นต้น
//                     // แต่ยังมีปัญหา overflow ต้องอย่าให้ <tex>... </tex> ในไฟล์ xml ยาว ไม่งั้น overfolw
//                     TagExtension(
//                         tagsToExtend: {"tex"},
//                         builder: (extensionContext) {
//                           return Math.tex(
//                             extensionContext.innerHtml,
//                             //mathStyle: MathStyle.display,  // อยู่กลางบรรทัด ขีดเศษส่วน อยู่สูงกว่าธรรมดา
//                             mathStyle: MathStyle.text,
//                             // แทรกในข้อความ ขีดเศษส่วน อยู่ระดับเดียวกับข้อความ
//                             // ใน xml ไฟล์ ให้ระบุเป็น /dfrac{}{} จะได้ตัวใหญ่ แต่จะลอยสูงกว่าเพื่อน ถ้าใช้ /frac จะตัวเล็ก แต่อยู่ระดับตัวหนังสือ
//                             textStyle: extensionContext.styledElement?.style
//                                 .generateTextStyle(),
//                             onErrorFallback: (FlutterMathException e) {
//                               //optionally try and correct the Tex string here
//                               return Text(e.message);
//                             },
//                           );
//                         }),
//                     // สำหรับตาราง ในส่วน โจทย์คำถาม
//                     TableHtmlExtension(), // Add this line to include the table extension
//                   ],
//                 ),
//                 // : KaTeX(
//                 //     laTeXCode: Text(widget.data.question,
//                 //         style: Theme.of(context).textTheme.bodyText2
//                 //         //  .copyWith(color: Colors.black),
//                 //         )),
//                 // ตัวเลือกแต่ละตัว จะมีเฉลยไว้ที่ trailing ของ ListTile แต่จะทำให้มองไม่เห็น โดยใช้ Visibility
//                 // เมื่อคลิกตัวเลือก จะทำให้มองเห็น โดยไปกำหนดให้ตัวแปรที่ทำให้มองไม่เห็น เป็น true
//                 // โดยการ SetState()
//                 Card(
//                   child: InkWell(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: SizedBox(
//                             width: 30,
//                             height: 45,
//                             child: Image.asset('assets/images/choice_1.png'),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             padding: EdgeInsets.only(left: 5),
//                             width: double.infinity,
//                             // color: Colors.blue,
//                             // height: MediaQuery.of(context).size.height,
//                             child:
//                                 //   !isDisplay_with_katex // ถ้าไม่มีเครื่องหมายทางคณิตศาสตร์
//                                 // ?
//                                 Html(
//                               data: widget.data.choice_A,
//                               extensions: [
//                                 // ทำให้ใช้ สัญลักษณ์คณิตศาสตร์ เช่น เศษส่วน รูท เป็นต้น
//                                 // แต่ยังมีปัญหา overflow ต้องอย่าให้ <tex>... </tex> ในไฟล์ xml ยาว ไม่งั้น overfolw
//                                 TagExtension(
//                                     tagsToExtend: {"tex"},
//                                     builder: (extensionContext) {
//                                       return Math.tex(
//                                         extensionContext.innerHtml,
//                                         // mathStyle: MathStyle.display,
//                                         mathStyle: MathStyle.text,
//                                         textStyle: extensionContext
//                                             .styledElement?.style
//                                             .generateTextStyle(),
//                                         onErrorFallback:
//                                             (FlutterMathException e) {
//                                           //optionally try and correct the Tex string here
//                                           return Text(e.message);
//                                         },
//                                       );
//                                     }),
//                       //          TableHtmlExtension(), // Add this line to include the table extension
//                               ],
//                             ),
//                             // : Padding(
//                             //     padding: EdgeInsets.symmetric(
//                             //         vertical: 10.0, horizontal: 5.0),
//                             //     child: KaTeX(
//                             //         // ถ้ามีเครื่องหมายคณิต
//                             //         laTeXCode: Text(
//                             //       " ${widget.data.choice_A}",
//                             //     )),
//                             //       ),
//                             // style: Theme.of(context)
//                             //     .textTheme
//                             //     .bodyMedium
//                             //    .copyWith(color: Colors.black),
//                             //      )),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: SizedBox(
//                             width: 30,
//                             height: 45,
//                             //color: Colors.purple,
//                             child: showTrueFalse(
//                                 thisCorrectAns:
//                                     widget.data.correctAns.toString(),
//                                 usrAns: "2",
//                                 thisVisibleVar:
//                                     isShowCheckMark_A), // "2" คือตำแหน่งใน ListTile ของตัวเลือกนี้
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       //   if(isBoughtAlready==true) {
//                       if (isFullVer == true || isShowAns == true) {
//                         // ถ้าเป็นรุ่นเต็ม หรือ ข้อนี้ ให้แสดงคำอธิบายซึี่งส่งมาจาก xml จะตรวจคำตอบ และแสดงเฉลย
//                         // ปรับข้อมูลในตาราง itemTable เอาวันที่ข้อนี้ไปใส่
//                         updateItemTable(
//                             fileName: widget.fileName,
//                             itemId: qNumId,
//                             createdDate: qNumDate,
//                             isClicked: 'true',
//                             isNew: '0');
//                         setState(() {
//                           isShowCheckMark_A = true;
//                         });
//                         // debugPrint("isShowCheckMark_A after SetState: $isShowCheckMark_A");
//                       } else {
//                         // แสดงข้อความเลื่อนขึ้นจากด้านล่างว่า มีเฉลยในรุ่นเต็ม
//                         showAnsNotAvailable();
//                       } // end of if (isFullVer == true
//                     },
//                   ),
//                   elevation: 2,
//                 ),
//
//                 // ===============bbbbb
//                 Card(
//                   child: InkWell(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: SizedBox(
//                             width: 30,
//                             height: 45,
//                             child: Image.asset('assets/images/choice_2.png'),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                               width: double.infinity,
//                               //color: Colors.blue,
//                               child: //!isDisplay_with_katex
//                                   // ?
//                                   Html(
//                                 data: widget.data.choice_B,
//                                 extensions: [
//                                   // ทำให้ใช้ สัญลักษณ์คณิตศาสตร์ เช่น เศษส่วน รูท เป็นต้น
//                                   // แต่ยังมีปัญหา overflow ต้องอย่าให้ <tex>... </tex> ในไฟล์ xml ยาว ไม่งั้น overfolw
//                                   TagExtension(
//                                       tagsToExtend: {"tex"},
//                                       builder: (extensionContext) {
//                                         return Math.tex(
//                                           extensionContext.innerHtml,
//                                           mathStyle: MathStyle.text,
//                                           textStyle: extensionContext
//                                               .styledElement?.style
//                                               .generateTextStyle(),
//                                           onErrorFallback:
//                                               (FlutterMathException e) {
//                                             //optionally try and correct the Tex string here
//                                             return Text(e.message);
//                                           },
//                                         );
//                                       }),
//                                 ],
//                               )
//                               // ถ้ามีเครื่องหมายคณิต
//                               // : Padding(
//                               //     padding: EdgeInsets.symmetric(
//                               //         vertical: 10.0, horizontal: 5.0),
//                               //     child: KaTeX(
//                               //         laTeXCode: Text(
//                               //       " ${widget.data.choice_B}",
//                               //     )),
//                               //   ),
//                               ),
//                         ),
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: SizedBox(
//                             width: 30,
//                             height: 45,
//                             //color: Colors.purple,
//                             child: showTrueFalse(
//                                 thisCorrectAns:
//                                     widget.data.correctAns.toString(),
//                                 usrAns: "3",
//                                 thisVisibleVar:
//                                     isShowCheckMark_B), // "3" คือตำแหน่งใน ListTile ของตัวเลือกนี้
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       if (isFullVer == true || isShowAns == true) {
//                         updateItemTable(
//                             fileName: widget.fileName,
//                             itemId: qNumId,
//                             createdDate: qNumDate,
//                             isClicked: 'true',
//                             isNew: '0');
//                         setState(() {
//                           isShowCheckMark_B = true;
//                         });
//                         // debugPrint("isShowCheckMark_A after SetState: $isShowCheckMark_A");
//                       } else {
//                         // แสดงข้อความเลื่อนขึ้นจากด้านล่างว่า มีเฉลยในรุ่นเต็ม
//                         showAnsNotAvailable();
//                       } // end of if (isFullVer == true
//                     },
//                   ),
//                   elevation: 2,
//                 ),
//
//                 // ============== cccc
//                 Card(
//                   child: InkWell(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: SizedBox(
//                             width: 30,
//                             height: 45,
//                             child: Image.asset('assets/images/choice_3.png'),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                               width: double.infinity,
//                               //color: Colors.blue,
//                               child: //!isDisplay_with_katex
//                                   //   ?
//                                   Html(
//                                 data: widget.data.choice_C,
//                                 extensions: [
//                                   // ทำให้ใช้ สัญลักษณ์คณิตศาสตร์ เช่น เศษส่วน รูท เป็นต้น
//                                   // แต่ยังมีปัญหา overflow ต้องอย่าให้ <tex>... </tex> ในไฟล์ xml ยาว ไม่งั้น overfolw
//                                   TagExtension(
//                                       tagsToExtend: {"tex"},
//                                       builder: (extensionContext) {
//                                         return Math.tex(
//                                           extensionContext.innerHtml,
//                                           mathStyle: MathStyle.text,
//                                           textStyle: extensionContext
//                                               .styledElement?.style
//                                               .generateTextStyle(),
//                                           onErrorFallback:
//                                               (FlutterMathException e) {
//                                             //optionally try and correct the Tex string here
//                                             return Text(e.message);
//                                           },
//                                         );
//                                       }),
//                                   // สำหรับตาราง ในส่วนคำอธิบาย
//                             //      TableHtmlExtension(), // Add this line to include the table extension
//                                 ],
//                               )
//                               // ถ้ามีเครื่องหมายคณิต
//                               // : Padding(
//                               //     padding: EdgeInsets.symmetric(
//                               //         vertical: 10.0, horizontal: 5.0),
//                               //     child: KaTeX(
//                               //         laTeXCode: Text(
//                               //       " ${widget.data.choice_C}",
//                               //     )),
//                               //   ),
//                               ),
//                         ),
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: SizedBox(
//                             width: 30,
//                             height: 45,
//                             //color: Colors.purple,
//                             child: showTrueFalse(
//                                 thisCorrectAns:
//                                     widget.data.correctAns.toString(),
//                                 usrAns: "4",
//                                 thisVisibleVar:
//                                     isShowCheckMark_C), // "4" คือตำแหน่งใน ListTile ของตัวเลือกนี้
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       if (isFullVer == true || isShowAns == true) {
//                         updateItemTable(
//                             fileName: widget.fileName,
//                             itemId: qNumId,
//                             createdDate: qNumDate,
//                             isClicked: 'true',
//                             isNew: '0');
//                         setState(() {
//                           isShowCheckMark_C = true;
//                         });
//                         // debugPrint("isShowCheckMark_A after SetState: $isShowCheckMark_A");
//                       } else {
//                         // แสดงข้อความเลื่อนขึ้นจากด้านล่างว่า มีเฉลยในรุ่นเต็ม
//                         showAnsNotAvailable();
//                       } // end of if (isFullVer == true
//                     },
//                   ),
//                   elevation: 2,
//                 ),
//
//                 //  dddddddddd
//                 Card(
//                   child: InkWell(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: SizedBox(
//                             width: 30,
//                             height: 45,
//                             child: Image.asset('assets/images/choice_4.png'),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                               width: double.infinity,
//                               //color: Colors.blue,
//                               child: // !isDisplay_with_katex
//                                   //   ?
//                                   Html(
//                                 data: widget.data.choice_D,
//                                 extensions: [
//                                   // ทำให้ใช้ สัญลักษณ์คณิตศาสตร์ เช่น เศษส่วน รูท เป็นต้น
//                                   // แต่ยังมีปัญหา overflow ต้องอย่าให้ <tex>... </tex> ในไฟล์ xml ยาว ไม่งั้น overfolw
//                                   TagExtension(
//                                       tagsToExtend: {"tex"},
//                                       builder: (extensionContext) {
//                                         return Math.tex(
//                                           extensionContext.innerHtml,
//                                           mathStyle: MathStyle.text,
//                                           textStyle: extensionContext
//                                               .styledElement?.style
//                                               .generateTextStyle(),
//                                           onErrorFallback:
//                                               (FlutterMathException e) {
//                                             //optionally try and correct the Tex string here
//                                             return Text(e.message);
//                                           },
//                                         );
//                                       }),
//                                 ],
//                               )
//                               // ถ้ามีเครื่องหมายคณิต
//                               // : Padding(
//                               //     padding: EdgeInsets.symmetric(
//                               //         vertical: 10.0, horizontal: 5.0),
//                               //     child: KaTeX(
//                               //         laTeXCode: Text(
//                               //       " ${widget.data.choice_D}",
//                               //     )),
//                               //   ),
//                               ),
//                         ),
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: SizedBox(
//                             width: 30,
//                             height: 45,
//                             //color: Colors.purple,
//                             child: showTrueFalse(
//                                 thisCorrectAns:
//                                     widget.data.correctAns.toString(),
//                                 usrAns: "5",
//                                 thisVisibleVar:
//                                     isShowCheckMark_D), // "2" คือตำแหน่งใน ListTile ของตัวเลือกนี้
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       if (isFullVer == true || isShowAns == true) {
//                         updateItemTable(
//                             fileName: widget.fileName,
//                             itemId: qNumId,
//                             createdDate: qNumDate,
//                             isClicked: 'true',
//                             isNew: '0');
//                         setState(() {
//                           isShowCheckMark_D = true;
//                         });
//                         // debugPrint("isShowCheckMark_A after SetState: $isShowCheckMark_A");
//                       } else {
//                         // แสดงข้อความเลื่อนขึ้นจากด้านล่างว่า มีเฉลยในรุ่นเต็ม
//                         showAnsNotAvailable();
//                       } // end of if (isFullVer == true
//                     },
//                   ),
//                   elevation: 2,
//                 ),
//
//                 /// eeeeeeee
//                 Visibility(
//                   child: Card(
//                     child: InkWell(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Align(
//                             alignment: Alignment.bottomCenter,
//                             child: SizedBox(
//                               width: 30,
//                               height: 45,
//                               child: Image.asset('assets/images/choice_5.png'),
//                             ),
//                           ),
//                           Expanded(
//                             child: Container(
//                                 width: double.infinity,
//                                 //color: Colors.blue,
//                                 child: //!isDisplay_with_katex
//                                     // ?
//                                     Html(
//                                   data: widget.data.choice_E,
//                                   extensions: [
//                                     // ทำให้ใช้ สัญลักษณ์คณิตศาสตร์ เช่น เศษส่วน รูท เป็นต้น
//                                     // แต่ยังมีปัญหา overflow ต้องอย่าให้ <tex>... </tex> ในไฟล์ xml ยาว ไม่งั้น overfolw
//                                     TagExtension(
//                                         tagsToExtend: {"tex"},
//                                         builder: (extensionContext) {
//                                           return Math.tex(
//                                             extensionContext.innerHtml,
//                                             mathStyle: MathStyle.text,
//                                             textStyle: extensionContext
//                                                 .styledElement?.style
//                                                 .generateTextStyle(),
//                                             onErrorFallback:
//                                                 (FlutterMathException e) {
//                                               //optionally try and correct the Tex string here
//                                               return Text(e.message);
//                                             },
//                                           );
//                                         }),
//                                   ],
//                                 )),
//                           ),
//                           Align(
//                             alignment: Alignment.bottomCenter,
//                             child: SizedBox(
//                               width: 30,
//                               height: 45,
//                               //color: Colors.purple,
//                               child: showTrueFalse(
//                                   thisCorrectAns:
//                                       widget.data.correctAns.toString(),
//                                   usrAns: "6",
//                                   thisVisibleVar:
//                                       isShowCheckMark_E), // "2" คือตำแหน่งใน ListTile ของตัวเลือกนี้
//                             ),
//                           ),
//                         ],
//                       ),
//                       onTap: () {
//                         if (isFullVer == true || isShowAns == true) {
//                           updateItemTable(
//                               fileName: widget.fileName,
//                               itemId: qNumId,
//                               createdDate: qNumDate,
//                               isClicked: 'true',
//                               isNew: '0');
//                           setState(() {
//                             isShowCheckMark_E = true;
//                           });
//                           // debugPrint("isShowCheckMark_A after SetState: $isShowCheckMark_A");
//                         } else {
//                           // แสดงข้อความเลื่อนขึ้นจากด้านล่างว่า มีเฉลยในรุ่นเต็ม
//                           showAnsNotAvailable();
//                         } // end of if (isFullVer == true
//                       },
//                     ),
//                     elevation: 2,
//                   ),
//                   visible:
//                       !(isChoice_E_Empty), // ถ้ามี ตัวเลือกที่ 5 ให้แสดง ถ้าไม่มี ก็ไม่ต้องแสดงอะไร ไม่กินพื้นที่ด้วย
//                 ),
//               ],
//             ),
//           ),
//           Align(
//             alignment: FractionalOffset.bottomCenter,
//             child: Container(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.indigoAccent, // Background color
//                 ),
//                 child: Text(
//                   'คำอธิบาย',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20.0,
//                   ),
//                 ),
//                 onPressed: () {
//                   if (isFullVer == true || isShowAns == true) {
//                     // ถ้าเป็นรุ่นเต็ม หรือ ให้แสดงคำอธิบาย
//                     // if (isDisplay_with_katex == true) {  // ยกเลิก ไม่ใช้ เพราะ flutter_html ใช้เศษส่วนได้แล้ว
//                     // อีกอย่าง flutter_katex ไม่ปรับรุ่น จะทำให้ upgrade ไม่ได้ เพราะจะไปขัดแย้งกับ package อื่น ๆ
//                     //   // ถ้าข้อไหน ให้แสดงคำอธิบายใน webview
//                     //   Navigator.push(
//                     //     // ไปเปิดหน้า คำอธิบาย  isDisplay_with_katex
//                     //     context,
//                     //     MaterialPageRoute(
//                     //       builder: (context) => ExplanationWebView(
//                     //         // ต้องใช้ webview เพราะต้องแสดงรูป
//                     //         itmNum: widget.currQNum,
//                     //         total: widget.numOfQstns,
//                     //         expltn: widget.data.exPlanation.toString(),
//                     //         isDarkMode: isDarkMode,
//                     //       ),
//                     //     ),
//                     //   );
//                     // } else {
//                     Navigator.push(
//                       // ไปเปิดหน้า คำอธิบายปกติ
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Explanation(
//                           itmNum: widget.currQNum,
//                           total: widget.numOfQstns,
//                           expltn: widget.data.exPlanation.toString(),
//                         ),
//                       ),
//                     );
//                     //        }  // end of if (isDisplay_with_katex == true) {
//                   } else {
//                     //  if (isFullVer == false || isShowAns == false)
//                     // แสดงข้อความเลื่อนขึ้นจากด้านล่างว่า มีเฉลยในรุ่นเต็ม
//                     showAnsNotAvailable();
//                   } // end of if (isFullVer == true
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void addNewAfterItemNum() {
//     debugPrint("กำหนดให้ค่า isThisItemNew เป็น true เพื่อให้มีจุดแดงหลังข้อ");
//     debugPrint("isThisItemNew: $isThisItemNew");
//
//     //  void addNewAfterItemNum(bool isThisItemNew) {
//     if (isThisItemNew == false) {
//       debugPrint("isThisItemNew: $isThisItemNew");
//       // ต้องเชค isThisItemNew ไม่งั้น setState ตลอดเลย ถ้าเจอข้อใหม่
//       setState(() {
//         // เพื่อให้มีคำว่า NEW หลังข้อสอบ ข้อนี้
//         isThisItemNew = true;
//       });
//     }
//   }
//
//   // สำหรับตรวจคำตอบ จะแสดงว่า ตัวเลือกที่เลือก ถูกหรือผิด
//   Widget showTrueFalse(
//       {required String thisCorrectAns,
//       required String usrAns,
//       required bool thisVisibleVar}) {
//     return SizedBox(
//       width: 25,
//       height: 25,
//       child: Visibility(
//         child: Image.asset(
//           thisCorrectAns == usrAns //condition ? Text("True") : Text("False"),
//               ? 'assets/images/tru.png'
//               : 'assets/images/flse.png',
//         ),
//         visible: thisVisibleVar,
//       ),
//     );
//   }
//
//   Widget buildBottomSheet(BuildContext context) {
//     // สำหรับคำอธิบาย
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Container(
//         height: MediaQuery.of(context).size.height * 0.75,
//         decoration: new BoxDecoration(
//           color: Colors.white,
//           borderRadius: new BorderRadius.only(
//             topLeft: const Radius.circular(25.0),
//             topRight: const Radius.circular(25.0),
//           ),
//         ),
//         child: Center(
//           child: Text(widget.data.exPlanation.toString()),
//         ),
//       ),
//     );
//   }
//
//   // void showNavHelp(){
//   //   showModalBottomSheet(
//   //       context: context,
//   //       builder: (context) {
//   //        // if (Platform.isAndroid) {
//   //           return SingleChildScrollView(
//   //             child: Container(
//   //               color: Color(0xFF737373),
//   //               height: 260,
//   //               child: Container(
//   //                 child: _buildBottomHelp(),
//   //                 decoration: BoxDecoration(
//   //                   color: Theme
//   //                       .of(context)
//   //                       .canvasColor,
//   //                   borderRadius: BorderRadius.only(
//   //                     topLeft: const Radius.circular(10),
//   //                     topRight: const Radius.circular(10),
//   //                   ),
//   //                 ),
//   //               ),
//   //             ),
//   //           );
//   //  //       }
//   //       });
//   // }
//   //
//   void showAnsNotAvailable() {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return SingleChildScrollView(
//             child: Container(
//               color: Color(0xFF737373),
//               height: 260,
//               child: Container(
//                 child: _buildBottomNavigationMenu(),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).canvasColor,
//                   borderRadius: BorderRadius.only(
//                     topLeft: const Radius.circular(10),
//                     topRight: const Radius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//     //     if (Platform.isAndroid) {
//     //       return SingleChildScrollView(
//     //         child: Container(
//     //           color: Color(0xFF737373),
//     //           height: 260,
//     //           child: Container(
//     //             child: _buildBottomNavigationMenu(),
//     //             decoration: BoxDecoration(
//     //               color: Theme.of(context).canvasColor,
//     //               borderRadius: BorderRadius.only(
//     //                 topLeft: const Radius.circular(10),
//     //                 topRight: const Radius.circular(10),
//     //               ),
//     //             ),
//     //           ),
//     //         ),
//     //       );
//     //     } else if (Platform.isIOS) {
//     //       return Container(
//     //         color: Color(0xFF737373),
//     //         height: 175,
//     //         child: Container(
//     //           child: _buildBottomNavigationMenu(),
//     //           decoration: BoxDecoration(
//     //             color: Theme.of(context).canvasColor,
//     //             borderRadius: BorderRadius.only(
//     //               topLeft: const Radius.circular(10),
//     //               topRight: const Radius.circular(10),
//     //             ),
//     //           ),
//     //         ),
//     //       );
//     //     }
//     //   },
//     // );
//   }
//
//   Column _buildBottomNavigationMenu() {
//     return Column(children: <Widget>[
//       if (Platform.isAndroid) ...[
//         SizedBox(
//           width: 5,
//           height: 35,
//         ),
//         Text(
//           'ข้อนี้ มีเฉลยในรุ่นเต็ม นะครับ',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.redAccent,
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(
//           width: 25,
//           height: 20,
//         ),
//         Text(
//           'ลงทุนเพื่ออนาคต เพียง 199 บาท เท่านั้น',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.blueGrey,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(
//           width: 15,
//           height: 20,
//         ),
//         Text(
//           'มือถือ Android จ่ายผ่าน',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.blueGrey,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           'พร้อมแพย์(สแกนจ่าย ผ่าน คิวอาร์โค้ด), บัตรเครดิต, TrueMoney, LinePay, และอื่น ๆ ',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.blueGrey,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           'ซื้อครั้งเดียวใช้ได้ตลอด ฟรีอัพเดท!! คุ้มกว่าเยอะ',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.blueGrey,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ] else if (Platform.isIOS) ...[
//         SizedBox(
//           width: 5,
//           height: 20,
//         ),
//         Text(
//           'ข้อนี้ มีเฉลยเฉพาะรุ่นเต็ม นะครับ',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.redAccent,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(
//           width: 25,
//           height: 15,
//         ),
//         Text(
//           'ลงทุนเพียง 219 บาท\nซื้อครั้งเดียว ใช้ได้ตลอด\nคุ้มกว่าเยอะ\nฟรี อัพเดท!!!',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.blueGrey,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ]
//     ]);
//   }
//
//   // ทำทุกครั้ง ที่เลื่อนไปแต่ละข้อ
//   //    // ยังไม่ได้ทดสอบ
//   void checkItemTable(
//       {required String fileName,
//       required String qNumId,
//       required String qNumDate}) async {
//     debugPrint("checkItemTable เลื่อนข้อ $fileName id: $qNumId date: $qNumDate");
//     final dbClient = await SqliteDB().db;
//     // ดูว่า มีไฟล์นี้ ข้อนี้ ในตาราง itemTable หรือเปล่า ถ้าไม่มีให้เพิ่ม คือ ในกรณีที่เพิ่มข้อสอบให้มากขึ้น
//     // ข้อใหม่ที่เพิ่ม จะไม่มีในฐานข้อมูล จึงต้องเอาไปใส่ด้วย
//     int? count = Sqflite.firstIntValue(await dbClient!.rawQuery(
//         'SELECT COUNT (*) FROM itemTable WHERE file_name = ? and item_id=?',
//         ["$fileName", "$qNumId"]));
//     //   debugPrint("fileName x count xx ไฟล์: $fileName");
// //    debugPrint("qNumID x count xx เลขที่: $qNumId");
//     debugPrint("ไฟล์: $fileName เลขที่: $qNumId จำนวน rows: $count");
//     if (count == 0) {
// //      debugPrint("x count xx inside if: $count");
//       // เพิ่ม
//       debugPrint("checkItemTable เป็น 0 แสดงว่า ยังไม่มีในตาราง ItemTable");
//
//       // ข้อใหม่ ใส่ข้อมูลลงตาราง พร้อมทั้ง ให้มีคำว่า NEW หลังเลขข้อ
//       insertItemTable(
//           fileName: fileName,
//           thisID: qNumId,
//           thisDate: qNumDate,
//           isNew: "1",
//           is_clicked: "false");
//
//       addNewAfterItemNum();
//
//       // setState(() {  // เรียกตรงนี้ไม่ได้ เพราะ unload ไปแล้ว เลยต้องเรียก addNewAfterItemNum
//       //   // เพื่อให้มีคำว่า NEW หลังข้อสอบ ข้อนี้
//       //   isThisItemNew = true;
//       // });
//     } else {
//       // ถ้ามีอยู่แล้วในฐานข้อมูล
//       debugPrint(" มีข้อมูลอยู่ในตาราง ItemTable แล้ว พบจำนวน: $count");
//       // เชคว่า ใหม่หรือไม่ โดยเชคกับวันปัจจุบันว่า อายุเกิน 90 วัน และยังไม่ได้คลิก ก็จะถือว่า เป็นไฟล์ใหม่
//       int currdate = ((DateTime.now().millisecondsSinceEpoch) / 1000).floor();
//       //วัน ในตาราง itemTable
//       var itemDate = await retrieveItemDate(fileName: fileName, itemID: qNumId);
//       // itemDate ที่ได้ออกมา เป็น Map อยู่ในรูป item_date: 1627453500}
//       // ถามว่า จะเอา ปีกกา ออกยังไง
//       // ตอบ: มันเป็น Map เก็บในรูป key:value เวลาจะเอา value ออกมา ก็ระบุ key เช่น itemDate['item_date'] ก็จะได้ตัวเลข 1627453500
//       // รายละเอียด ดูที่ https://www.tutorialspoint.com/dart_programming/dart_programming_map.htm
//       // สาเหตุที่มันมีวงเล็บปีกกา เพราะ ไม่ได้ใช้ fromMap ถ้าจะใช้ ต้องสร้าง method ใน itemModel class
//       String thisItemDate = itemDate['item_date'];
//       // ดึงเอาเฉพาะตัวเลข ออกจาก Map (ตอนนั้น ยังไม่ใช้ map)
//
//       var is_item_clicked =
//           await retrieveItemIsClicked(fileName: fileName, itemID: qNumId);
//       String is_this_item_clicked = is_item_clicked['isClicked'];
// //      debugPrint("qNumID: $qNumId isClicked: $is_this_item_clicked");
//       // debugPrint("thisDate x count xx thisItemDate: $thisItemDate");
//       // debugPrint("thisDate x count xx itemDate: $itemDate");
//       debugPrint("isClicked: $is_this_item_clicked");
//       // อายุของข้อนี้ คิดเป็นวัน (1 วันมี 86400 วินาที)
//       var itemAgeFromQNum =
//           (((currdate - int.parse(qNumDate)) / 86400).ceil()); //
//       debugPrint("qNumID: $qNumId age: $itemAgeFromQNum");
//       if (itemAgeFromQNum < 90) {
//         debugPrint("itm_id: $qNumId อายุ น้อย กว่า 90 วัน");
//       } else {
//         debugPrint("itm_id: $qNumId อายุ มาก กว่า 90 วัน");
//       }
//
//       if (is_this_item_clicked == "false") {
//         debugPrint("itm_id: $qNumId ยังไม่ได้คลิก");
//       } else {
//         debugPrint("itm_id: $qNumId คลิกแล้ว");
//       }
//       if ((itemAgeFromQNum < 90) && (is_this_item_clicked == "false")) {
//         // อัพเดท isNew ใน itemTable
//         debugPrint(
//             " IF TRUE itm_id: $qNumId Age: $itemAgeFromQNum  isClicked: $is_this_item_clicked");
//         debugPrint("itm_id: $qNumId อายุน้อยกว่า 90 วัน และยังไม่ได้คลิก");
//       } else {
//         debugPrint(
//             " ELSE itm_id: $qNumId Age: $itemAgeFromQNum  isClicked: $is_this_item_clicked");
//         debugPrint(
//             "itm_id: $qNumId ไม่เข้าเกณฑ์ อายุน้อยกว่า 90 วัน และยังไม่ได้คลิก");
//       }
//
//       // debugPrint(
//       //     "x count xx itemAge: $itemAgeFromQNum fileName: $fileName itemId: $qNumId, itemDate: $qNumDate");
//       int item_date_from_file = int.parse(qNumDate);
//       int item_date_from_sqlite = int.parse(thisItemDate);
//       // int item_date_from_sqlite = itemDate as int;
//       // debugPrint(
//       //     "item_date_from_file: $item_date_from_file :: item_date_from_sqlite: $item_date_from_sqlite");
//       // ถ้าข้อนี้ ระบุวันที่ มากกว่า(หลัง)  วันที่ของข้อนี้ ที่อยู่ในฐานข้อมูล
//
//       //   if (item_date_from_file > item_date_from_sqlite) {
//       //   ใหม่   -- ต้องภายใน 90 วัน  จึงจะเป็นของใหม่ ถ้า ส่งขึ้นมานานแล้ว (เกิน 90 วัน)และไม่ได้เปิด ก็ถือเป็นของเก่า คือ ไฟล์ใหม่ ให้อยู่ได้ 90 วัน โดยไม่ต้องไปปรับ isNew ในตาราง ปุ่มแดงจะไม่มี
//       if ((itemAgeFromQNum < 90) && (is_this_item_clicked == "false")) {
//         // อัพเดท isNew ใน itemTable
//         debugPrint(
//             " มีข้อมูลอยู่ในตารางแล้ว และ น้อยกว่า 90 วัน หรือ ยังไม่ได้คลิก");
//         // (fileName: fileName, thisID: qNumId, thisDate: qNumDate);
//
//         // updateItemTable(
//         //     fileName: fileName,
//         //     itemId: qNumId,
//         //     createdDate: thisItemDate,
//         //     //           isClicked: "true",
//         //     isNew: "1");
//         // debugPrint("x count xx itemAgeFromQNum น้อยกว่า 90 วัน");
//         // debugPrint(
//         //     "x count xx fileName: $fileName, qNumId: $qNumId, qNumDate: $qNumDate");
//         // bool isThisItemNew;
//         // isThisItemNew = true;
//         // addNewAfterItemNum(isThisItemNew);
//         addNewAfterItemNum();
//         // setState(() {
//         //   // เพื่อให้มีคำว่า NEW หลังข้อสอบ ข้อนี้
//         //   isThisItemNew = true;
//         // });
//
//         debugPrint("isThisItemNew after updateItem: $isThisItemNew");
//       } else {
//         debugPrint("itm_id: $qNumId ไม่เข้าเกณฑ์");
//       }
//     }
//   }
//
//   // }
//
// //  retrieveItemDate({String fileName, String itemID}) {}
//
//   Future retrieveItemDate(
//       {required String fileName, required String itemID}) async {
//     var dbClient = await SqliteDB().db;
//     final res = (await dbClient!.rawQuery(
//         """ SELECT item_date FROM itemTable WHERE file_name = '$fileName' AND item_id = '$itemID' """));
//     return res.first;
//     //  return res.isNotEmpty ? ItemModel.fromMap(res.first) : Null;
//   }
//
//   Future retrieveItemIsClicked(
//       {required String fileName, required String itemID}) async {
//     var dbClient = await SqliteDB().db;
//     final res = (await dbClient!.rawQuery(
//         """ SELECT isClicked FROM itemTable WHERE file_name = '$fileName' AND item_id = '$itemID' """));
//     return res.first;
//     //  return res.isNotEmpty ? ItemModel.fromMap(res.first) : Null;
//   }
//
//   void updateItemTable_no_isClick(
//       {required String fileName,
//       required String itemId,
//       required String createdDate,
//       required String isNew}) async {
//     debugPrint(
//         "inside updateItemTable_no_isClick: createdDate: $createdDate,  isNew: $isNew', fileName: $fileName, itemId: $itemId ");
//     var dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawUpdate('''
//     UPDATE itemTable
//     SET item_date = ?,
//     isNew =?
//     WHERE file_name = ? AND item_id = ?
//     ''', ['$createdDate', '$isNew', '$fileName', '$itemId']);
//     debugPrint("update ItemTable -- res: $res");
//     //return res;
//   }
//
//   void updateItemTable(
//       {required String fileName,
//       required String itemId,
//       required String createdDate,
//       required String isClicked,
//       required String isNew}) async {
//     debugPrint(
//         "inside updateItemTable: createdDate: $createdDate, isClicked: $isClicked, isNew: $isNew', fileName: $fileName, itemId: $itemId ");
//     var dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawUpdate('''
//     UPDATE itemTable
//     SET item_date = ?,
//     isClicked =?,
//     isNew =?
//     WHERE file_name = ? AND item_id = ?
//     ''', ['$createdDate', '$isClicked', '$isNew', '$fileName', '$itemId']);
//     debugPrint("update ItemTable -- res: $res");
//     //return res;
//   }
// }
//
// Future<void> _onOpen(LinkableElement link) async {
//   debugPrint("this link: $link");
//   // สำหรับ link ในข้อความ
//   Uri thisLink = Uri.parse(link.url); // แปลง LinkableElement เป็น Uri
//   debugPrint("this link: $thisLink");
//   if (await canLaunchUrl(thisLink)) {
//     await launchUrl(thisLink);
//   } else {
//     throw 'Could not launch $link';
//   }
// }
//
// // saveToDatabase({String fileName, int currQstnNum, int totalQstnNumber})
//
// Future createItemInfoTable() async {
//   // เอาไว้เก็บค่าว่า คลิกเข้ามาหรือยัง ถ้าคลิกแล้ว จะได้ลบจุดแดงออก
//   var dbClient = await SqliteDB().db;
//   var res = await dbClient!.execute("""
//       CREATE TABLE ItemInfo_table(
//         id TEXT PRIMARY KEY,
//         file_name TEXT,
//         qstnNum INTEGER,
//         isClicked TEXT
//       )""");
//   return res;
// }
//
// /// Add user to the table
// Future insertFileData({required String fileName, required int progress}) async {
//   dynamic myData = {"file_name": fileName, "progress": progress};
//
//   /// Adds user to table
//   final dbClient = await SqliteDB().db;
//   int res = await dbClient!.insert("OcscTjkTable", myData);
//   return res;
// }
//
// Future insertFileCreateDateOcscTjkTable(
//     {required String fileName, required int thisDate}) async {
//   dynamic myData = {"file_name": fileName, "dateCreated": thisDate};
//
//   /// Adds user to table
//   final dbClient = await SqliteDB().db;
//   int res = await dbClient!.insert("OcscTjkTable", myData);
//   return res;
// }
//
// Future updateFileData({required String fileName, required int progress}) async {
//   var dbClient = await SqliteDB().db;
//   var res = await dbClient!.rawQuery(""" UPDATE OcscTjkTable
//         SET progress = progress WHERE file_name = '$fileName'; """);
//   return res;
// }
//
// Future updateOcscTjkTable(
//     {required String fileName, required int progress}) async {
//   var dbClient = await SqliteDB().db;
//   // debugPrint("progress: $progress  file name:  $fileName");
// // https://stackoverflow.com/questions/54102043/how-to-do-a-database-update-with-sqflite-in-flutter
//   var res = await dbClient!.rawQuery('''
//     UPDATE OcscTjkTable
//     SET progress = ?
//     WHERE file_name = ?
//     ''', [progress, '$fileName']);
//
//   // debugPrint("res: $res");
//   return res;
// }
//
// Future updateFileCreateDate(
//     {required String fileName,
//     required int createdDate,
//     required String picName}) async {
//   debugPrint("picName inside updateFile: $picName");
//   var dbClient = await SqliteDB().db;
//   var res = await dbClient!.rawQuery('''
//     UPDATE OcscTjkTable
//     SET dateCreated = ? , progress_pic_name = ?
//     WHERE file_name = ?
//     ''', [createdDate, picName, '$fileName']);
//
//   // debugPrint("res: $res");
//   return res;
// }
//
// //
// // Future<bool> getBooleanValue(String key) async {
// //   // สำหรับเชคว่าเป็นการใช้งานครั้งแรกหรือเปล่า จะได้ไม่ใส่จุดแดง หน้าข้อ
// //   SharedPreferences myPrefs = await SharedPreferences.getInstance();
// //   bool afterFirstRun = myPrefs.getBool(key) ?? false;
// //   if (afterFirstRun) {
// //     return true;
// //   } else {
// //     await myPrefs.setBool('after_First_Run', true);
// //     return false;
// //   }
// // }
//
// // Future createExamProgressTable() async {
// //   var dbClient = await SqliteDB().db;
// //   var res = await dbClient.execute("""
// //       CREATE TABLE IF NOT EXISTS ExamProgress(
// //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// //         file_name TEXT,
// //         progress INTEGER,
// //         dateCreated INTEGER,
// //         exam_type INTEGER,
// //         field_2 INTEGER,
// //         position TEXT,
// //         open_last TEXT,
// //         field_5 TEXT
// //       )""");
// //   return res;
// // }
// //
