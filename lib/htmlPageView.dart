
import 'dart:async';
import 'dart:io';
// import 'dart:js';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ocsc_exam_prep/paymentScreen.dart';
import 'package:ocsc_exam_prep/sqlite_db.dart';
import 'package:ocsc_exam_prep/theme.dart';
import 'package:ocsc_exam_prep/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'ProviderModel.dart';
import 'aboutDialog.dart';
import 'drawingDialog.dart';
import 'main.dart';

// สำหรับตรวจว่า เป็น android หรือ iphone จะได้ส่งลิงค์ไปให้คะแนน ถูกเว็บ
import 'dart:io' show Platform;
import 'item_model.dart';
import 'noteAppLauncher.dart';


class HtmlPageView extends StatefulWidget {

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



//  late Data data = Data();
//   late final WebViewController controller;
//   var loadingPercentage = 0;


  const HtmlPageView({
    super.key,
    required this.myExams,
    required this.createDate,
    required this.title,
    required this.currPageNum,
    required this.currQstnNum,
    required this.numOfQstn,
    required this.msg,
    required this.buyStatus});

  @override
  _HtmlPageViewState createState() => _HtmlPageViewState();
}

class _HtmlPageViewState extends State<HtmlPageView> {
  late final WebViewController _controller;
 // late Orientation _currentOrientation;
  Key _webViewKey = UniqueKey(); // เพื่อบังคับให้ reload webview
  var loadingPercentage = 0;
  var _isLoading = true;
  final GlobalKey _key = GlobalKey();
  late SharedPreferences
  exerciseData; // สำหรับเก็บข้อมูลการทำแบบฝึกหัด ได้แก่ เรื่องอะไร ทำข้อปัจจุบันข้ออะไร เรื่องนี้มีทั้งหมดกี่ข้อ
  bool _isResized = false; // แก้ปัญหา Samsung หน้าจอดำ ไม่แสดงหน้าเว็บ

  @override
  void initState() {
    super.initState();

   // WidgetsBinding.instance.addObserver(this);
    //_currentOrientation = MediaQueryData.fromView(WidgetsBinding.instance.window).orientation;

    // // Lock orientation for testing  แก้ปัญหา Samsung ไม่แสดงหน้าเว็บ หน้าจอมืด ต้องแตะจึงมา
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

    String filePath = 'assets/data/';
    String _myExams = widget.myExams;
    String _title = widget.title;
    String myHtmlFile = filePath + _myExams;
    String picName;

    CheckUserConnection();

    bool _buyStatus = false;
    String stringResult = "";


    final providerModel = Provider.of<ProviderModel>(context, listen: false);

    final provider = Provider.of<ProviderModel>(context, listen: false);

    provider.initPlatformState();
    print("offering from provider -- caling from htmlPageView: ${provider.offering}");
    print("removeAds from provider -- caling from htmlPageView:  ${provider.removeAds}");

    _buyStatus = providerModel.removeAds;

    print(
        "_buyStatus (isBought ส่งมาจาก Provider โดย เอามาจาก removeAds และ sku ในตาราง hashTable และ sharePref: $_buyStatus");

    if (_buyStatus == false){  // เชคที่ส่งมาจาก mainMenu
      _buyStatus = widget.buyStatus;
    }

    bool isBoughtAlready = _buyStatus;

    String currMode2 = "";

    bool mode; // สำหรับส่งไป JS ว่าโหมดมืด หรือ สว่าง



    mode = Provider.of<ThemeNotifier>(context, listen: false).darkTheme;
    print("213 mode from Provider for all JS files: $mode");
    if (mode == true) {
      currMode2 = "dark";
    } else {
      currMode2 = "light";
    }

    List<String> myMenuNames; // สำหรับเก็บชื่อเมนูที่เอามาจากไฟล์ html

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features


    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //    ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });

            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) async{
           // await _controller.clearCache(); // Clear WebView cache
            _isLoading = true;
            setState(() {
              loadingPercentage = 0;
              _isLoading;
            });
            debugPrint('Page started loading: $url');
            debugPrint('loadingPercentage: $loadingPercentage');
            debugPrint('_isLoading: $_isLoading');
          },
          onPageFinished: (String url) {
            _isLoading = false;
            setState(() {
              loadingPercentage = 100;
              _isLoading;
            });
            debugPrint('Page finished loading: $url');
            debugPrint('loadingPercentage: $loadingPercentage');
            debugPrint('_isLoading: $_isLoading');

            _controller.runJavaScript("document.body.offsetHeight;");  //
       //     _controller.runJavaScript("document.body.offsetHeight;");
       //     _controller.reload(); // Force a full refresh of the WebView

          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )

      ..addJavaScriptChannel(
          'messageHandler',
          // onMessageReceived: (message) => _handleThisMessage(message, _myExams, context as BuildContext, controller, provider) //
          onMessageReceived: (JavaScriptMessage message) {
            // รับข้อมูลมาจาก Javascript ซึ่งส่งมาทาง postMessage() ของ
            // javascriptChannels  ชื่อmessageHandler
            // ข้อมูลที่ส่งมา คือ ข้อที่คลิกเลือกคำตอบ ส่งมาทุกข้อที่คลิก
            // แต่จะใช้เฉพาะ ข้อสุดท้ายที่คลิก ก่อนคลิกปุ่มกลับ เพื่อเอาไปไว้ในฐานข้อมูล สำหรับ
            // เมื่อกลับมาใหม่ จะได้ไปยังข้อที่ทำครั้งสุดท้าย (ถ้าทำยังไม่เสร็จ ถ้าเสร็จแล้ว จะไปเริ่มข้อ 1)
            print(
                "213 Js > Flutter - for messageHandler(): ชื่อไฟล์: $_myExams ค่าที่ส่งมาจาก JS -> Flutter: ${message.message} ");
            String msgStr = message
                .message; // ค่าที่รับมาจาก javaScript คือ ข้อปัจจุบัน&&จำนวนข้อทั้งหมด เช่น 11&&36 (ข้อ 11 ในจำนวนทั้งหมด  36 ข้อ)

            // ส่งไป Willpopscope
            Provider.of<Data>(context, listen: false)
                .changeString(msgStr);


            // ไปเอาข้อมูล mode
            String msgToSend = "$isBoughtAlready" +
                "xyz" +
                "$mode"; // isBoughtAlready คือ _buyStatus
            print(
                "213 Flutter ส่งไป Js - isBuyAndMode()  ไฟล์: $_myExams  buy: $isBoughtAlready, mode: $mode, msgToSend: $msgToSend"); //
            controller // ส่งไป JS
                .runJavaScriptReturningResult(
                'isBuyAndMode("$msgToSend")'); // ชื่อ JS ฟังก์ชั่น("ข้อมูลที่ส่ง ในรูปตัวอักษร-string")
          })


    // ****************************************************
    //  ยังมีปัญหาที่การแสดงวงกลมความก้าวหน้า
    // คือแสดงช้า คลิกหมดทุกข้อ แต่บอกว่ายังไม่หมด
    // ต้องเข้ามาใหม่ และออกไป จึงจะบอกว่าหมดแล้ว
    // ปัญหา คือ ไม่อ่านข้อมูลใน sharePref ล่าสุดมาแสดง

      ..addJavaScriptChannel(
          'exerciseData',
          onMessageReceived: (JavaScriptMessage message) {   // รับข้อมูลมาจาก Javascript ซึ่งส่งมาทาง postMessage() ของ
            // javascriptChannels  ชื่อ exerciseData
            // เพื่อเอาข้อมูลการทำแบบฝึกหัดไว้ในฐานข้อมูล และเอาไปบอกว่า
            // ครั้งที่แล้ว ทำไปถึงข้ออะไร
            // เมื่อกลับมาใหม่ จะได้ไปยังข้อที่ทำครั้งสุดท้าย (ถ้าทำยังไม่เสร็จ ถ้าเสร็จแล้ว จะไปเริ่มข้อ 1)
            print(
                "213 Js > Flutter - for exerciseData ชื่อไฟล์: xxx ค่าที่ส่ง: ${message.message} ");
            String exerciseDat = message
                .message; // ค่าที่รับมาจาก javaScript คือ ชื่อหัวข้อเรื่อง ข้อปัจจุบัน และจำนวนข้อทั้งหมด คั่นด้วย xzc
            // เช่น normal_cndtngxzc4xzc7  คือ เรื่อง normal_cndtng ข้อปัจจุบัน คือข้อ 4 เรื่องนี้มีทั้งหมดจำนวน 7 ข้อ

            List<String> forDataClass  = exerciseDat.split("xzc");
            print("forDataClass: $forDataClass");

            int math_8_yrs_done_sofar=0;
            int math_2567_done_sofar=0;

            String nameOfMenu = forDataClass[0];
            String curValueOfMenu = forDataClass[1];
            // น่าจะต้องส่งค่า เมนูปัจจุบัน เพื่อเอาไปรวมด้วยเลย ไม่งั้นไม่เป็นปัจจุบัน
            getExerciseDoneFromPref(nameOfMenu, curValueOfMenu).then((completedTotal){
//completedTotal เป็นข้อความ ในรูป ชื่อเมนู:ข้อที่ทำเสร็จแล้ว(คั่นด้วย colon) เช่น math_exer:15
              List<String> completedTotal_data = completedTotal.split(":"); // แยกเป็น Array
              String thisMenuName = completedTotal_data[0];
              String thisCompletedTotal = completedTotal_data[1];

              forDataClass[1] = thisCompletedTotal;
              print("menuName - forDataClass[0]: ${forDataClass[0]}");
              print("completed sofar - forDataClass[1]: ${forDataClass[1]}");
              print("Total - forDataClass[2]: ${forDataClass[2]}");

              // ปรับรูปแบบ เพื่อส่งไป willpopscpe รูปแบบให้เหมือน ที่ส่งจากไฟล์ 1_graph_chart_table...
              // ถ้าไม่ปรับ จะมี error เพราะมีการสั่งไปเอาข้อมูลที่คลิก แต่อันนี้ ไม่มี จึงต้องเพิ่มไป OK  แล้ว
              String msgForWillpopFromExerciseDat = forDataClass[2]+"xzctbl_q" + forDataClass[1] + "xzcccx11111";

              print("exerciseData sent to Data class for progress: $msgForWillpopFromExerciseDat");

              // ส่งไป Willpopscope
              Provider.of<Data>(context, listen: false)
                  .changeString(msgForWillpopFromExerciseDat);

            });

            // เก็บไว้ใน SharePreferences
            saveExerciseData(exerciseDat);
          })

// *********************************
      ..addJavaScriptChannel(
        'menuNameToFlutter',

        onMessageReceived: (JavaScriptMessage message) {
          // รับข้อมูลมาจาก Javascript ซึ่งส่งมาทาง postMessage() ของ
          // javascriptChannels  ชื่อ menuNameToFlutter
          // เพื่อเอาชื่อตัวแปรของเมนูแบบฝึกหัด  และเอาไปบอกว่า
          // ครั้งที่แล้ว ทำไปถึงข้ออะไร
          // เมื่อกลับมาใหม่ จะได้ไปยังข้อที่ทำครั้งสุดท้าย (ถ้าทำยังไม่เสร็จ ถ้าเสร็จแล้ว จะไปเริ่มข้อ 1)
          // normal_menu fraction_menu plus_minus_menu min_max_menu multi_connection_menu

          print(
              "213 Js >   ค่าที่ส่ง via menuNameToFlutter  : ${message.message} ");
          String exerciseMenu_ = message
              .message; // ค่าเมนู ที่รับมาจาก javaScript คือ ชื่อหัวข้อเรื่อง
          // normal_menu fraction_menu plus_minus_menu min_max_menu multi_connection_menu
          // เปลี่ยนเป็น array เพื่อเชค
          // List<String> myMenuNames  = exerciseMenu.split(" ");
          String exerciseMenu = exerciseMenu_.trim();
          myMenuNames = exerciseMenu.split(",");
          // เอาไปตรวจดูใน sharePref ถ้าไม่มี ให้ใส่เป็น 1 คือ ยังไม่ได้ทำ
          print(
              "myMenuNames.length: ${myMenuNames.length}");

          checkingTheSavedData(myMenuNames, "0")
              .then((thisLastQstn) {
            List lastQstn_from_pref = thisLastQstn;
            print(
                "lastQstn_from_pref: $lastQstn_from_pref");
            String dataToJs = lastQstn_from_pref.join(
                " "); // convert list to string sperated by space
            print("  $dataToJs");

            controller // ส่งไป JS
                .runJavaScriptReturningResult(
                'getLastQstnNum("$dataToJs")'); // ชื่อ JS ฟังก์ชั่น("ข้อมูลที่ส่ง ในรูปตัวอักษร-string")

          });
        },
      )

      ..addJavaScriptChannel('get_isNewClicked',
          //onMessageReceived: (message) => _handleGet_isNewClicked(message, _myExams, context as BuildContext, controller, provider, currMode2, _buyStatus),),)
          onMessageReceived:
              (JavaScriptMessage message) async {
            // ส่งมายาว id และ วันที่ เช่น id50147:date1630050147abcid501478:date1630050148abcid501479:date1630050149abc
            // เอา id  ไปหาว่า ข้อนี้ คลิกแล้วหรือยัง
            // print(
            //     "213 Js > Flutter get_isNewClicked - length: ${(message.message).length} ");
            print(
                "213 Js > Flutter: get_isNewClicked ชื่อไฟล์: $_myExams ข้อมูล: ${message.message} ");
            // รูปแบบที่ส่งเข้ามา เช่น id1608958161:date1630050149abcid1608958162:date1630050150abc
            String contentOfIsNewFromJs =
            (message.message).trim();
            print(
                "checkTwice qNum id: ContentFromJs:  $contentOfIsNewFromJs ");
            String contentOfIsNew;
            if (contentOfIsNewFromJs.length < 1) {
              // ในกรณีที่ไฟล์ html นั้น ไม่มี <div class="isNew"></div> จะเกิด error จึงต้องใส่เป็น dummy เอาไว้
              //  โดยกำหนดวันที่เป็น วันพุธที่ 24 พ.ย. 2564 (1637726921) เพื่อให้เลย 90 วัน จะได้ไม่แสดงข้อความ NEW
              contentOfIsNew = "id111111:date1637726921";
            } else {
              contentOfIsNew =
                  contentOfIsNewFromJs.substring(
                      0, contentOfIsNewFromJs.length - 3);
            }
            // ต้องเอาตัวท้าย abc ออกไปตัวนึง เพราะเกินมา
            print(
                "checkTwice รับมาจาก JS: contentOfIsNew: $contentOfIsNew");

            saveOrUpdateItemTable(
                whatString: contentOfIsNew,
                whatHtmlFile: _myExams,
                context: context);
            print(
                "after saveOrUpdateItemTable FILE: $_myExams");
            //    Future tutorial: https://www.youtube.com/watch?v=DAS0EQuM-oU&t=26s
            getIsNewFromItemTbl(
                whatFile: _myExams,
                isNewString: contentOfIsNew)
                .then((thisDateFromSQL) {
              stringResult = thisDateFromSQL.substring(
                  0,
                  thisDateFromSQL.length -
                      3); // เอา abc ตัวสุดท้ายออกไป
              // print("abcfg stringResult whatFile: $_myExams");
              // print(
              //     "abcfg stringResult contentOfIsNew: $contentOfIsNew");
              // print("abcfg stringResult: $stringResult");
              // print(
              //     "abcfg stringResult date from SQL: $thisDateFromSQL");
              getStartId(
                  whatHtmlFile:
                  _myExams) //  ข้อที่จะให้แสดงเป็นข้อแรก
                  .then((startID) {
                String newString =
                    stringResult + "tjk" + startID;
                print(
                    "213 ชื่อไฟล์: _myExams ข้อมูล stringResult+startID: $newString");
                print(
                    "213 currMode2 before adding to newString for sending to JS: $currMode2");
                newString = newString + "tjk" + currMode2;
                // print("abcfg currMode inside: $currMode");
                print(
                    "213 Flutter ส่งไป Js - is_IsNewClicked() ในตัวแปร newString ชื่อไฟล์: _myExams ข้อมูล:  $newString");

                String alreadyBought;
                if (_buyStatus == true) {
                  alreadyBought = "true";
                } else {
                  alreadyBought = "false";
                }
                print(
                    "213 is_Bought_Already before sending to JScript: $alreadyBought");
                newString =
                    newString + "tjk" + alreadyBought;
                print(
                    "213 Flutter ส่งไป Js - is_IsNewClicked() สำหรับไฟล์: $_myExams ข้อมูลทั้งหมดสำหรับ is_IsNewClcked(): $newString");
                // ส่งไป Javascript
                _controller // ส่งไป JS
                    .runJavaScriptReturningResult(
                    'is_IsNewClicked("$newString")'); // ไม่ใส่เครื่องหมาย "  " ทำให้เสียเวลา หลายวัน
              }); // end of getIsBought().then((is_bought)
              //  }); // end of getDataFromHashTbl(whatName: "appMode").then
            }); //   getStartId(whatHtmlFile:_myExams).then
            //      }); // getIsNewFromItemTbl  //
          })

 //loadHtml(myHtmlFile);

       ..loadFlutterAsset(myHtmlFile);

      //
      // controller.runJavaScript("document.body.offsetHeight;"); // force page reload


    //  ..loadFlutterAsset('assets/data/symbol_cndtng_exercise.html');

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;

  }

  bool ActiveConnection = false;  // สำหรับตรวจสอบว่าต่ออินเทอร์เน็ตหรือเปล่า หลังจากกดปุ่มซื้อ

  late TapDownDetails _doubleTapDetails;
  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
    print("DoubleTapDown details: $details");
  }

  void _handleDoubleTap() {
    print('DoubleTap on position ${_doubleTapDetails.localPosition}');
  }

  @override
  void dispose() {
   // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //
  //     // Resize container on resume
  //     setState(() {
  //       _isResized = true; // Temporarily resize
  //       _webViewKey = UniqueKey(); // Force rebuild the WebView
  //     });
  //
  //     // Restore original size in an after frame callback
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       setState(() {
  //         _isResized = false; // Restore size
  //       });
  //     });
  //   }
  // }



  @override
  Widget build(BuildContext context) {

    final newOrientation = MediaQuery.of(context).orientation; // แก้ปัญหา Samsung

    bool isMath = false; // สำหรับเชคว่า เป็น คณิต หรือไม่ จะได้แสดงปุ่มกระดาษทด บน appBar

    // ช้า ทำได้ไม่ดี เลยเลิกใช้งาน เลยกำหนดให้เป็น false ทั้งหมด
    // ถ้า จะลองใหม่ ให้เอา คอมเม้นข้างล่างออก ทุกอย่างยังทำงานได้

    if (widget.myExams.contains("chart") || widget.myExams.contains("full_exam_all") || widget.myExams.contains("math_exercise") || widget.myExams.contains("math") || widget.myExams.contains("exponent") || widget.myExams.contains("cndtng") || widget.myExams.contains("ocsc_answer")) {
      isMath = true;
    } else {
      isMath = false;
    }

    //  _context = context;

    bool isExercise; // ชื่อไฟล์ที่มีคำว่า exercise ต่อท้าย
    // คือไฟล์ที่มีรูปแบบ ถาม-ตอบ ใช้ข้อมูลลักษณะ json
    if (widget.myExams.contains("exercise")) {
      isExercise = true;
    } else {
      isExercise = false;
    }
    String myMessage = widget.msg; // ข่าวสาร
    String _title = widget.title;

    final theme = Provider.of<ThemeNotifier>(context, listen: false);  // สำหรับเรียกใช้ฟังก์ชันต่าง ๆ ใน theme provider
    final provider = Provider.of<ProviderModel>(context, listen: false);
    bool _buyStatus = provider.removeAds;
    print("_buyStatus from mainMenu -- htmlPageView: $_buyStatus");
    print("FileName in Build context: ${widget.myExams}");

    List<ItemModel> itemData;
    String stringResult =
        ""; // สำหรับส่งข้อมูล isNew ไป javaScript เชคแต่ละข้อว่า ใหม่หรือเปล่า

    bool mode; // สำหรับส่งไป JS ว่าโหมดมืด หรือ สว่าง
    mode = Provider.of<ThemeNotifier>(context, listen: false).darkTheme;

    // Trigger rebuild if orientation has changed
    // if (newOrientation != _currentOrientation) {
    //   _currentOrientation = newOrientation;
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     setState(() {});
    //   });
    // }

    return SafeArea(
      minimum: const EdgeInsets.all(1.0),
      // child: WillPopScope(
      //   onWillPop: () async { // deprecated
      child: PopScope(
        canPop: true,
        // onPopInvoked: (bool didPop) async { // deprecated
        onPopInvokedWithResult: (bool didPop, Object? result) async {

          // child: WillPopScope(// deprecated
          //   onWillPop: () async {
          // Get the Data instance using Provider
          //  Data data = Provider.of<Data>(context, listen: false);

          // Do something with the data
          //  print('Data from Data class: ${data.data}');

          String myData = Provider.of<Data>(context, listen: false)
              .data; // สำหรับส่งข้อมูล ไปแสดง ไอคอน รูปวงกลม แสดงความก้าวหน้า

          print('Data from Data class: $myData');
          print(" messageXX: ชื่อไฟล์: เลขข้อสุดท้าย = ${widget.myExams}: $myData");
          String picName;
          String currNum;
          String lastNum;
          String myNum;




          if((widget.myExams).contains("math_exercise")){


          }

          final regexp = RegExp(r'\d+$'); // เอาเฉพาะ ข้อความที่ลงท้ายด้วยตัวเลข
          if (myData.contains("xzc")) {
            // ถ้ามี xzc แสดงว่า ส่งมาจาก javaScript OK
            List msgArr = myData.split(
                "xzc"); // แยกข้อมูลที่ส่งมาจาก javaScript เป็น ข้อที่ทำปัจจุบัน กับข้อทั้งหมด

            print("msgArr ทำ myData จาก data class เป็น array: $msgArr");
            currNum = msgArr[1];
            print(" messageXX: currNum = $currNum");
            final lastQNum = regexp.allMatches(currNum).map((m) => m[0]).first;

            String clickedItems =
            msgArr[2].substring(3); // เอาตัวหน้า 3 ตัว ccx ออกไป

            List<String> lstClickedItems = clickedItems.split("ccx");
            print(" messageXX: ข้อที่คลิก lstClickedItems:  $lstClickedItems");

            for (int i = 0; i < (lstClickedItems.length); i++) {
              updateClick_in_ItemTable(context, widget.myExams, lstClickedItems[i]);
            }

            myNum = lastQNum.toString();
            print(" messageXX: ข้อสุดท้าย myNum:  $myNum");
            String totalNum = msgArr[0];
            int _currQstnNum = int.parse(myNum);
            int _numOfQstn = int.parse(totalNum);
            //   _controller = WebViewController();

            // ยกเลิก ไม่ไปนุ้งกับ OcscTjkTable เพราะตัดขาดกันแล้ว
          //  checkIsNew(whatFile: widget.myExams, allQstnItem: _numOfQstn);

            // int myProgress = (_currQstnNum / _numOfQstn * 100).round();
            // print("myProgress to show: $myProgress");

            double progress = _currQstnNum / _numOfQstn * 100;

            int myProgress; // เพื่อว่า ขาดไปข้อเดียวก็ยังไม่เสร็จ ถ้าปัดธรรมดา round()
            // มันจะปัดขึ้น ทำให้เป็น 100% ซึ่งไม่ดี ทำนองเดียวกัน ทำข้อเดียว มันปัดลง ก็ไ่ม่ขึ้นวงกลมให้
            // ก็เลยเอาใหม่เป็น ถ้าข้อเดียวก็แสดงความก้าวหน้า หรือ ทำขาดไปข้อเดียว ก็ไม่ขึ้น เครื่องหมายถูกให้
            if (progress > 50) {
              myProgress = progress.floor();
            } else {
              myProgress = progress.ceil();
            }

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
          } else {
            currNum = "top"; // ถ้าไม่มี ให้ไปที่บนสุด
            picName = "p00.png";
          }

          //   print("messageXX: ข้อสุดท้าย myNum:  $myNum");
          print(" messageXX: ชื่อภาพ:  $picName");
          print(" messageXX: ข้อสุดท้าย:  $currNum");

          // update ข้อมูลในตาราง OcscTjkTable เพื่อว่า เวลาทำหน้าเมนู จะได้มีไอคอนความก้าวหน้า และ เวลาเปิดใหม่ จะได้ไปที่ข้อที่ทำค้างไว้ (ถ้ามี)
          updateOcscTjkTbl_html(
              fileName: widget.myExams, whereToStart: currNum, iconName: picName);

          // Other code logic
          // return true;

          clearSharedDrawingData();  // เคลียกระดาษทด

          return Future.value(true);
        },


        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'เตรียมสอบ ก.พ. ภาค ก.',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 0,
            actions: [
              Tooltip(
                message: "กระดาษทด",
                child: GestureDetector(  // สำหรับ dialog กระดาษทด
                  onTap: () => _showDrawingWindow(context),
                  child: (isMath) //ถ้าเป็นไฟล์คณิต จะให้มี icon คลิกไปเปิดกระดาษทด
                      ? Icon(
                    Icons.edit_note,
                    size: 30.0,
                  )
                      : Visibility(
                    child: Icon(
                      Icons.help_outline,
                      size: 26.0,
                    ),
                    visible: false,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context),
                  );
                },

                child: (isExercise) //ถ้าเป็นไฟล์แบบฝึกหัด ให้มีเครื่องหมายคำถามที่ AppBar เหมือนเป็น Help menu
                    ? Icon(
                  Icons.help_outline,
                  size: 26.0,
                )
                    : Visibility(
                  child: Icon(
                    Icons.help_outline,
                    size: 26.0,
                  ),
                  visible: false,
                ),
              ),
              PopupMenuButton(
                // เมนู สาม จุด
                  onSelected: (selectedValue) {
                    //print(selectedValue);
                    handleClick(selectedValue, context);
                  },
                  itemBuilder: (BuildContext ctx) => [
                    // PopupMenuItem(
                    //     child: Text('ส่งเมลถึงผู้เขียน'),
                    //     value: 'sendMyMail'),
                    PopupMenuItem(
                        child: Text('ให้คะแนน App นี้'), value: 'vote'),
                    PopupMenuItem(
                        child: Text('แชร์กับเพื่อน'), value: 'share'),
                    PopupMenuItem(
                        child: Text(
                            'ส่งอีเมล ติชม เสนอแนะ หรือแจ้งข้อผิดพลาด'),
                        value: 'sendMyMail'),
                    PopupMenuItem(
                        child: Text('เกี่ยวกับ'), value: 'about'),
                  ])
            ],
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  //color: Colors.blue[700],
                  color: Theme.of(context).primaryColorDark,
                  border: Border(
                    top: BorderSide(width: 1, color: Colors.white70),
                  ),
                  // color: Colors.white,
                ),
                child: Linkify(
                  onOpen: _onOpen,
                  textScaleFactor: 1,
                  text: myMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                  linkStyle:
                  TextStyle(fontSize: 14.0, color: Colors.yellowAccent),
                  options: LinkifyOptions(
                      humanize:
                      false), // ให้แสดงตัวหนังสือ https:// ด้วย ไม่งั้นจะถูกตัดออกไป
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  // color: Colors.blue[400],
                  border: Border(
                    top: BorderSide(width: 1, color: Colors.white70),
                    //  bottom: BorderSide(width: 1, color: Colors.white),
                  ),
                ),
                child: Text(
                  "$_title",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  border: Border(
                    top: BorderSide(width: 1, color: Colors.white70),
                    bottom: BorderSide(width: 1, color: Colors.black45),
                  ),
                ),
                child: _buyStatus == true // buyStatus เอาจาก mainMenu จาก provider ตาราง hashTable และ sharePref -- ถ้าอันใดอันหนึ่งเป็นจริง _buyStatus จะเป็นจริง
                    ? SizedBox.shrink()
                    : SizedBox(
                  height: 38,
                  width: 120,
                  child: TextButton(
                    child:  Text('กดซื้อรุ่นเต็ม',
                      style: TextStyle(
                        fontFamily: 'Athiti',
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.blue[900],
                      ),),
                    onPressed: () {
                      if(ActiveConnection) { // ถ้ามีอินเทอร์เน็ต
                        //   //print('ส่งไปหน้า ให้ซื้อ PaymentScreen');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaymentScreen(
                                  // revenueCat
                                  key: ValueKey('uniqueKey'),
                                  isDarkMde: mode,
                                  isBuy: _buyStatus,
                                ),
                          ), //กำลังแก้ไข -- OK
                        );
                      }else{  // ถ้าไม่ต่อกับอินเทอร์เน็ต ซื้อไม่ได้
                        // show message
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('ไม่มีการเชื่อมต่ออินเทอร์เน็ต', style: TextStyle(color: Colors.red, fontWeight:
                              FontWeight.bold),),
                              //content: Text('ท่านต้องเชื่อมต่อกับอินเทอร์เน็ตก่อน นะครับ'),
                              content: RichText(
                                text: TextSpan(
                                  text: 'ท่านต้องเชื่อมต่อกับอินเทอร์เน็ตก่อน นะครับ',
                                  style: TextStyle(fontSize: 20, color: Colors.black87),
                                  children: const <TextSpan>[
                                    TextSpan(text: '\n\n(กดปุ่มลูกศรออกจากหน้านี้ ต่อเชื่อมอินเทอร์เน็ต แล้วจึงกดปุ่มซื้ออีกครั้ง)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Stack(

                  children:[

                    WebViewWidget(
                    controller: _controller,
                  ),
                    if (_isLoading)
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                  value: loadingPercentage / 100.0,
                ),
            ],
          ),

          //  floatingActionButton: favoriteButton(),
        ),
      ),
    );
  }

  Widget favoriteButton() {
    return FloatingActionButton(
      onPressed: () async {},
      child: const Icon(Icons.favorite),
    );
  }

  Future<List> checkingTheSavedData(
      List key_to_check, String initial_value) async {
    // ตรงนี้ ต้องใส่ async ด้วย ไม่งั้น ตรงวน for loop ไม่มีข้อมูลออกมานอก loop -- เสียเวลาอยู่หลายวัน

    List thisDat = [];
    print("thisDat: $thisDat");

    List myMenuNames = key_to_check;

    for (var i = 0; i < myMenuNames.length; i++) {
      await isExerciseKeyExist(myMenuNames[i]).then((isExist) async {
        if (!isExist) {
          // ถ้าไม่มี กำหนดให้เป็น ข้อ 1
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString(myMenuNames[i], initial_value);
          thisDat.add(myMenuNames[i] + "xyz" + initial_value);
          // thisDat += myMenuNames[i] + "xyz" + initial_value;
          print("thisDat inside for loop (not exist): ${thisDat.toString()}");
        } else {
          SharedPreferences pref = await SharedPreferences.getInstance();
          String? thisValue = pref.getString(myMenuNames[i]);
          thisDat.add(myMenuNames[i] + "xyz" + thisValue);
          //   thisDat += myMenuNames[i] + "xyz" + thisValue;
          print("thisDat inside for loop (do exist): ${thisDat.toString()}");
        }
      });
    }
    print("thisDat before return: ${thisDat.toString()}");
    return thisDat;
  }


// Separated shared preferences method is a good call
  Future<bool> isExerciseKeyExist(String keyToCheck) async {
    // เชคว่า มีข้อมูลการทำแบบฝึกหัดหรือยัง ถ้ายัง ใส่เป็นเริ่มที่ 1
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(keyToCheck)) {
      // if key exists
      print("$keyToCheck found in sharePref");
      return true;
    } else {
      print("$keyToCheck NOT found in sharePref");
      return false;
    }
  }


  //เก็บข้อมูล ซึ่งส่งมาจาก Javascript
  Future saveExerciseData(exDat) async {
    //ค่าที่ส่ง เช่น : normal_cndtngxzc3xzc7
    var exDatList = exDat.split(
        'xzc'); // แยกที่ส่งมา เป็น list ตัวแรก-ชื่อ ตัวสอง-ข้อปัจจุบัน ตัวที่สาม-จำนวนข้อทั้งหมด
    String thisName = exDatList[0];
    String thisValue =
    exDatList[1]; // เอาเฉพาะเลขข้อไปเก็บ ใน sharePref จำนวนข้อ ไม่ใช้
    exerciseData = await SharedPreferences.getInstance();
    exerciseData.setString(thisName, thisValue);
  }


  Future<void> _onOpen(LinkableElement link) async {
    // สำหรับ link ในข้อความ
    Uri thisLink = Uri.parse(link.url); // แปลง LinkableElement เป็น Uri
    if (await canLaunchUrl(thisLink)) {
      await launchUrl(thisLink);
    } else {
      throw 'Could not launch $link';
    }
  }

  void updateClick_in_ItemTable(
      BuildContext context, String whatFile, String whatID) async {
    print("before updateClick_in_ItemTable: File $whatFile, ID $whatID");
    //  BuildContext context, String whatFileName, int whatDate) async {
    final dbClient = await SqliteDB().db;
    var res = await dbClient?.rawQuery('''
    UPDATE itemTable
    SET isClicked = ?,
    isNew = ?
    WHERE file_name = ? AND item_id = ?
    ''', ['true', '0', '$whatFile', '$whatID']);
  }

  // void checkIsNew({String? whatFile, int? allQstnItem}) async {
  //   final dbClient = await SqliteDB().db;
  //   int? count = Sqflite.firstIntValue(await dbClient!.rawQuery(
  //       'SELECT COUNT (*) FROM itemTable WHERE file_name = ? AND isNew = ?',
  //       ["$whatFile", "1"]));
  //   print("count html: $count  fileName: $whatFile");
  //   if (count! > 0) {
  //     if (count < allQstnItem!) {
  //       //   set isNew = 1
  //       var res = await dbClient.rawQuery('''
  //   UPDATE OcscTjkTable
  //   SET isNew = ?
  //   WHERE file_name = ?
  //   ''', ['1', '$whatFile']);
  //     } else {
  //       //   set isNew = 2
  //       var res = await dbClient.rawQuery('''
  //   UPDATE OcscTjkTable
  //   SET isNew = ?
  //   WHERE file_name = ?
  //   ''', ['2', '$whatFile']);
  //     }
  //   } else {
  //     // ถ้า count น้อยกว่าหรือเท่ากับ 0 ปรับให้หน้าเมนู ไม่่มีจุดแดง isNew = 0  -- OK ใช้ได้แล้ว ลบจุดแดงหน้าเมนู
  //     var res = await dbClient.rawQuery('''
  //   UPDATE OcscTjkTable
  //   SET isNew = ?
  //   WHERE file_name = ?
  //   ''', ['0', '$whatFile']);
  //   }
  // }

  void updateOcscTjkTbl_html(
      {required String fileName,
        required String whereToStart,
        required String iconName}) async {
    // ปรับ isNew ให้เป็น 0 ด้วย คือเอาจุดแดงในหน้าเมนูออกไป เพราะเข้ามาแล้ว จึงไม่ใหม่
    // isNew ยังปรับไม่ได้ เพราะต้องไปนับว่า ข้อนี้ที่เป็นข้อใหม่ ถูกคลิกหมดหรือยัง

    final dbClient = await SqliteDB().db;
    var res = await dbClient?.rawQuery('''
    UPDATE OcscTjkTable
    SET progress_pic_name = ?, open_last = ?
    WHERE file_name = ?
    ''', ['$iconName', '$whereToStart', '$fileName']);
  }


  Future<String> getExerciseDoneFromPref(String menuName, String menuValue) async {
    print(" in getExerciseDoneFromPref");
    int math2567=0;
    int mat_8_yrs=0;
    int law=0;
    int others=0;

    int completedSofar=0;
    int completedSofar_2567=0;
    int completedSofar_8yrs=0;
    int completedSofar_law=0;
    int completedSofar_others=0;


    List mNames_2567=[];
    List mNames_8yrs=[];
    List mNames_law=[];

    String thisMenuName = menuName;
    String thisMenuCurrValue = menuValue;

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (var key in keys) {
      if (key.contains('_exer')) {
        final value = prefs.getString(key);
        if (value != null) {

          // =================
          if (key.contains('_2')) { // เมนู คณิต 2567 จับเวลา
            math2567 += 1;
            mNames_2567.add(key+":"+value+" ");

            if(key==thisMenuName) {
              // completedSofar = completedSofar - int.parse(value); // หักของเก่าออก เพื่อเอาของใหม่เติม
              // // ไม่งั้นจะเพิ่มมากเกินจริง เพราะทำแต่ละข้อ จะมาเพิ่มที่นี่
              // if(completedSofar < 0){completedSofar=0;}
              completedSofar_2567 += int.parse(thisMenuCurrValue);
            }else{
              completedSofar_2567 += int.parse(value);
            }
            // Add other lines of code here for this case if needed
          } else if (key.contains('math_exer')) { // เมนู คณิต 8 ปี จับเวลา
            mat_8_yrs += 1;
            mNames_8yrs.add(key+":"+value+" ");
            if(key==thisMenuName) {
              completedSofar_8yrs += int.parse(thisMenuCurrValue);
            }else{
              completedSofar_8yrs += int.parse(value);
            }
            // Add other lines of code here for this case if needed
          } else if (key.contains('law_exer')) { // เมนู กฎหมายจับเวลา
            law += 1;
            mNames_law.add(key+":"+value+" ");
            if(key==thisMenuName) {
              completedSofar_law += int.parse(thisMenuCurrValue);
            }else{
              completedSofar_law += int.parse(value);
            }
            // Add other lines of code here for this case if needed
          } else{ // สำหรับเมนูเดียว ส่งเข้ามาเท่าไร คืนออกไป
            completedSofar_others += int.parse(thisMenuCurrValue);
            others += 1;

          }
        } // end of  if (value != null)
      }// end of    if (key.contains('_exer'))
    }

    if (thisMenuName.contains("_2")) { // สำหรับเมนู ข้อสอบเสมือนจริง คณิต 2567
      completedSofar = completedSofar_2567;
    } else if (thisMenuName.contains("math_exer")) {  // สำหรับ ข้อสอบเสมือนจริงคณิต 8 ปี
      completedSofar = completedSofar_8yrs;
    } else if (thisMenuName.contains("law_exer")) { // สำหรับ ข้อสอบเสมือนจริง กฎหมาย
      completedSofar = completedSofar_law;
    } else { // สำหรับที่ไม่มีเมนูย่อย
      completedSofar = completedSofar_others;
    }

    //   String result = "exer:"+sumWithout2.toString()+"-xyz-"+"exer_2:"+sumWith2.toString();
    String result = thisMenuName + ":" + completedSofar.toString();
    print("result from sharePref: $result");
    print("completedSofar: $completedSofar");

    print("math2567: $completedSofar_2567\n mat_8_yrs: $completedSofar_8yrs\n law: $completedSofar_law\n others: $completedSofar_others");
    print("menuNames: $mNames_2567\n$mNames_8yrs\n$mNames_law");
    return result;

    //  setState(() {});
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
    print("ActiveConnection: $ActiveConnection");
  }

  void _showDrawingWindow(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => DrawingDialog(),
      ),
    );
  }

  Future<void> clearSharedDrawingData() async {
    debugPrint("try to clear sharedDrawing");
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("savedDrawing");
  }

  void loadHtml(myHtmlFile) async {

    await Future.delayed(Duration(milliseconds: 100));
    _controller.loadFlutterAsset(myHtmlFile);
    _controller.runJavaScript("document.body.offsetHeight;"); // force page reload
    _controller.reload(); // Force a full refresh of the WebView
  }



} // end of class _HtmlPageViewState extends State<HtmlPageView>


Future<void> handleClick(String value, BuildContext context) async {
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
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
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
      openAboutDialog(context);
      break;
  }
}

void openAboutDialog(BuildContext context) {
  Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new aboutDialog();
      },
      fullscreenDialog: true));
}

// _showMaterialDialog(String msg) {
//   // สำหรับเมนู 3 จุด
//   showDialog(
//       context: context,
//       builder: (_) => new AlertDialog(
//         title: new Text("Material Dialog"),
//         content: new Text(msg),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Close me!'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           )
//         ],
//       ));
// }



Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    title: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.0),
          topLeft: Radius.circular(12.0),
        ),
        color: Colors.teal,
      ),
      child: Text(
        'วิธีใช้',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    titlePadding: const EdgeInsets.all(0),
    //title: const Text('วิธีใช้'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("ปัดซ้าย  เพื่อไปข้อต่อไป"),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("ปัดขวา  เพื่อย้อนกลับ "),
          ],
        ),
        // SizedBox(height: 10),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     Text(" แตะ 2  ครั้ง เพื่อไปยังข้อแรก"),
        //   ],
        // ),
        // SizedBox(height: 10),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     Text(" แตะ 3  ครั้ง เพื่อไปยังข้อสุดท้าย"),
        //   ],
        // ),
        // SizedBox(height: 10),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     Flexible(
        //       child: Text(
        //           "แตะที่แถบ \"แสดงตัวเลือกการใช้งาน\" เพื่อสลับข้อ หรือ ให้แสดงเฉลยพร้อมกับคำถาม"),
        //     ),
        //   ],
        // ),
        // Text("ปัดซ้าย  เพื่อไปข้อต่อไป "),
        // Text("ปัดขวา  เพื่อย้อนกลับ "),
        //Text("ปัดขึ้น เพื่อไปยังข้อสุดท้าย"),
        //Text("ปัดลง เพื่อไปยังข้อแรก"),
        // Text(
        //     "แตะที่แถบ \"แสดงตัวเลือกการใช้งาน\" เพื่อสลับข้อ หรือ ให้แสดงเฉลยพร้อมกับคำถาม")
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




}  // end of class _HtmlPageViewState extends State<HtmlPageView>


Future<String> getStartId({String? whatHtmlFile}) async {
  String itemID = "top";
  //   void getWhereToStart({String whatFileName}) async {
  final dbClient = await SqliteDB().db;
  var res = await dbClient!.rawQuery('''
    SELECT open_last FROM OcscTjkTable
    WHERE file_name = ?
    ''', ['$whatHtmlFile']);
  // print("whereToStart in future2: ${res[0]['open_last']}");
  // print("whereToStart in future3: $whatFileName");
  // print("whereToStart in future4: ${ExamModel.fromMap(res.first)}");
  //  _pageController = PageController(initialPage: res[0]['open_last']);
  if (res != null) {
    itemID = res.first["open_last"] as String;
  }
  //print("startAtID inside getStartId: $itemID FILE: $whatHtmlFile");
  return itemID;
}







enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
  doPostRequest,
  loadLocalFile,
  loadFlutterAsset,
  loadHtmlString,
  transparentBackground,
  setCookie,
}

class SampleMenu extends StatelessWidget {
  SampleMenu({
    super.key,
    required this.webViewController,
  });

  final WebViewController webViewController;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
      key: const ValueKey<String>('ShowPopupMenu'),
      onSelected: (MenuOptions value) {
        switch (value) {
          case MenuOptions.showUserAgent:
            _onShowUserAgent();
            break;
          case MenuOptions.listCookies:
            _onListCookies(context);
            break;
          case MenuOptions.clearCookies:
            _onClearCookies(context);
            break;
          case MenuOptions.addToCache:
            _onAddToCache(context);
            break;
          case MenuOptions.listCache:
            _onListCache();
            break;
          case MenuOptions.clearCache:
            _onClearCache(context);
            break;

          case MenuOptions.doPostRequest:
            _onDoPostRequest();
            break;
          case MenuOptions.loadFlutterAsset:
            _onLoadFlutterAssetExample();
            break;
          case MenuOptions.setCookie:
            _onSetCookie();
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.showUserAgent,
          child: Text('Show user agent'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.listCookies,
          child: Text('List cookies'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.clearCookies,
          child: Text('Clear cookies'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.addToCache,
          child: Text('Add to cache'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.listCache,
          child: Text('List cache'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.clearCache,
          child: Text('Clear cache'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.doPostRequest,
          child: Text('Post Request'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.loadFlutterAsset,
          child: Text('Load Flutter Asset'),
        ),
        const PopupMenuItem<MenuOptions>(
          key: ValueKey<String>('ShowTransparentBackgroundExample'),
          value: MenuOptions.transparentBackground,
          child: Text('Transparent background example'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.setCookie,
          child: Text('Set cookie'),
        ),
      ],
    );
  }

  Future<void> _onShowUserAgent() {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    return webViewController.runJavaScript(
      'Toaster.postMessage("User Agent: " + navigator.userAgent);',
    );
  }

  Future<void> _onListCookies(BuildContext context) async {
    final String cookies = await webViewController
        .runJavaScriptReturningResult('document.cookie') as String;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Cookies:'),
            _getCookieList(cookies),
          ],
        ),
      ));
    }
  }

  Future<void> _onAddToCache(BuildContext context) async {
    await webViewController.runJavaScript(
      'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";',
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added a test entry to cache.'),
      ));
    }
  }

  Future<void> _onListCache() {
    return webViewController.runJavaScript('caches.keys()'
    // ignore: missing_whitespace_between_adjacent_strings
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  Future<void> _onClearCache(BuildContext context) async {
    await webViewController.clearCache();
    await webViewController.clearLocalStorage();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cache cleared.'),
      ));
    }
  }

  Future<void> _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }


  Future<void> _onSetCookie() async {
    await cookieManager.setCookie(
      const WebViewCookie(
        name: 'foo',
        value: 'bar',
        domain: 'httpbin.org',
        path: '/anything',
      ),
    );
    await webViewController.loadRequest(Uri.parse(
      'https://httpbin.org/anything',
    ));
  }

  Future<void> _onDoPostRequest() {
    return webViewController.loadRequest(
      Uri.parse('https://httpbin.org/post'),
      method: LoadRequestMethod.post,
      headers: <String, String>{'foo': 'bar', 'Content-Type': 'text/plain'},
      body: Uint8List.fromList('Test Body'.codeUnits),
    );
  }

  Future<void> _onLoadFlutterAssetExample() {
    return webViewController.loadFlutterAsset('assets/data/1_columns_01.html');
  }

  Widget _getCookieList(String cookies) {
    if (cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
    cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }

}

class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key, required this.webViewController});

  final WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No back history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No forward history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => webViewController.reload(),
        ),
      ],
    );
  }
}

void saveOrUpdateItemTable({String? whatString, String? whatHtmlFile, context}) {

  String? contentOfIsNew = whatString;
  String? _myExams = whatHtmlFile;

  // สำหรับเก็บค่า true false ของ id ทุกตัว ที่ส่งไปหาข้อมูลในตาราง itemTable จะส่งกลับไปเป็นชุด
  List<String>? jsMassage = contentOfIsNew?.split("abc"); // แปลงเป็น List

  for (int i = 0; i < (jsMassage!.length); i++) {
    String thisIdAndDate =
    jsMassage[i]; // ได้ id และ วันที่ ของ isNew แต่ละตัว
    const start = "id";
    const end = ":date";
    final startIndex = thisIdAndDate.indexOf(start);
    final endIndex = thisIdAndDate.indexOf(end, startIndex + start.length);
    final startIndex2 = thisIdAndDate.indexOf(end);
    // print(
    //     "qNum id: str: $thisIdAndDate, startIndex: $startIndex, endIndex:$endIndex, startIndex2: $startIndex2");
    String qNumId =
    thisIdAndDate.substring(startIndex + start.length, endIndex);
    String qNumDate = thisIdAndDate.substring(startIndex2 + end.length);

    WidgetsBinding.instance.addPostFrameCallback((_) {  // เพิ่มเข้ามา เพื่อส่ง contex ไปยังฟังก์ชัน addOrUpdate -- ยังไม่ได้เชค พอแค่นี้ก่อน

      // if (_key.currentContext != null) {
      //   myFunction(_key.currentContext!); // Pass the context to your function
      // }

      addOrUpdate(whatFile: _myExams!, whatID: qNumId, whatDate: qNumDate, context as BuildContext); // Pass the context to your function
    });

  } // end of for

}
// getIsNewFromItemTbl({required String whatFile, required String isNewString}) {
// };
void addOrUpdate(BuildContext context,
    {required String whatFile,
      required String whatID,
      required String whatDate}) async {
  print(
      " 345  ----- enter addOrUpdate ------ Fn: $whatFile whatID: $whatID whatDate $whatDate");
  final dbClient = await SqliteDB().db;
  List<Map> list = await dbClient!.rawQuery(
      'SELECT * FROM itemTable WHERE file_name = ? AND item_id = ?',
      ["$whatFile", "$whatID"]);

  int count = list.length; // นับจำนวนสมาชิกของ List ถ้าไม่มี จะเป็น 0
  print(
      " 345  ----- inside addOrUpdate ------ check Fn: $whatFile whatID: $whatID in itemTable  count: $count");
  if (await count >= 1) {
    String dateFromSQL = list.first["item_date"];
    int dateFromSQLite = int.parse(dateFromSQL);
    int fileDate = int.parse(whatDate);


    if (fileDate > dateFromSQLite) {
          () => updateItemTable(context, whatFile, whatID,
          whatDate); // ถ้า isNew ในตาราง OcscTjkTable เท่ากับ 0 จะไม่มีจุดแดง หน้าเมนู  whatDate คือวันที่จากไฟล์

      print(
          " 345  ----- inside addOrUpdate ------ FOUND AND NEWER: Fn: $whatFile whatID: $whatID count: $count");
      //
    }
  } else {
    print(
        " 345  ----- inside addOrUpdate ------ NOT FOUND Fn: $whatFile whatID: $whatID in itemTable  count: $count");
        () => addNewRecordToItemTable(context, whatFile, whatID, whatDate);
    print(
        " 345  ----- inside addOrUpdate ------ finish ADD NEW Fn: $whatFile whatID: $whatID in itemTable");
  } //  end of if (count >= 1)
  print(" 345  ----- leaving addOrUpdate --------------- ");
}

Future<String> getIsNewFromItemTbl(
    // Future<ItemModel> getIsNewFromItemTbl(
        {required String whatFile,
      required String isNewString}) async {
  // print(
  //     " 345 ----- enter getIsNewFromItemTbl --------- whatFile: $whatFile isNewString: $isNewString ");
  List<String> jsMassage = isNewString.split("abc");
  String trueOrFalse = "";
  //  print("messageXX isNewString.length: ${isNewString.length}");
  // print("messageXX result.first: $whatFile $whatID");
  for (int i = 0; i < (jsMassage.length); i++) {
    // print(
    //     " 345 ----- enter loop in getIsNewFromItemTbl --------- loop: $i of ${jsMassage.length}");
    String thisIdAndDate = jsMassage[i];
    //   print("isNewFromTbl thisIdAndDate: $thisIdAndDate");
    const start = "id";
    const end = ":date";
    final startIndex = thisIdAndDate.indexOf(start);
    final endIndex = thisIdAndDate.indexOf(end, startIndex + start.length);
    final startIndex2 = thisIdAndDate.indexOf(end);
    // print(
    //     "qNum id: str: $thisIdAndDate, startIndex: $startIndex, endIndex:$endIndex, startIndex2: $startIndex2");
    String qNumId =
    thisIdAndDate.substring(startIndex + start.length, endIndex);
    String qNumDate = thisIdAndDate.substring(startIndex2 + end.length);
    print("ส่งไปหา ในTable i: $i id: $qNumId date: $qNumDate fn: $whatFile");
    // print(
    //     " 345 ----- find id and date in getIsNewFromItemTbl --------- i: $i id: $qNumId date: $qNumDate fn: $whatFile");

    final dbClient = await SqliteDB().db;
    var result = await dbClient?.rawQuery(
        'SELECT * FROM itemTable WHERE file_name = ? AND item_id = ?',
        ["$whatFile", "$qNumId"]);
    // print(
    //     "messageXX result.firstxx: ${result.first}"); // ผลที่ได้ เช่น {isClicked: false}
    //    print("messageXX result.firstxx: ${result.first["isClicked"]}");
    // return result.isNotEmpty ? ItemModel.fromMap(result.first) : null;
    if (result!.isNotEmpty) {
      print("ส่งไปหา ในTable เจอ TF: $trueOrFalse จ$qNumId $whatFile");
      // print(
      //     " 345 ----- FOUND isClicked in getIsNewFromItemTbl --------- i: $i id: $qNumId date: $qNumDate  isNew: ${result.first["isNew"]} fn: $whatFile");
      trueOrFalse = trueOrFalse +
          qNumId +
          // "sss" +  // ตรงนี้ เปลี่ยน ไม่ส่งวันที่ แต่ส่ง isNew ถ้า 1 = ใหม่ 0=เหมือนเดิม
          // (result.first["item_date"]) +
          "sss" +
          (result.first["isNew"].toString()) +
          "sss" +
          (result.first["isClicked"].toString()) +
          "abc"; // ใช้ sss คั่นระหว่าง id และ วันที่ และใช้ abc คั่นแต่ละตัว ส่วน ["isClicked"] คือ ชื่อคอลัมน์ ใน ตาราง itemTable
      // print(
      //     " 345 ----- find id and date in getIsNewFromItemTbl --------- i: trueOrFalse: $trueOrFalse");
    } else {
      // print(
      //     " 345 ----- NOT FOUND isClicked in getIsNewFromItemTbl --------- i: $i id: $qNumId date: $qNumDate fn: $whatFile");
      trueOrFalse += qNumId +
          "sss" +
          qNumDate +
          "ssstrueabc"; // ถ้าไม่เจอ ให้เป็น คลิกแล้ว จะได้ไม่ต้องแสดงคำว่า "ใหม่" หลังเลขข้อ
      print("ส่งไปหา ในTable ไม่เจอ TF: $trueOrFalse $qNumId $whatFile");
      // print(
      //     " 345 ----- find id and date in getIsNewFromItemTbl --------- i: ไม่เจอ  trueOrFalse: $trueOrFalse");
    }
    // print(
    //     " 345 ----- RESULT in getIsNewFromItemTbl --------- id: $qNumId ผลลัพธ์: $trueOrFalse");
  }
  // print(
  //     " 345 ----- FINAL RESULT in getIsNewFromItemTbl --------ผลลัพธ์ทั้งหมด: $trueOrFalse");
  // print(" 345 ----- exit getIsNewFromItemTbl ----");
// จบการหา isNew แต่ละข้อที่ส่งมา ต่อไป หา โหมด มืด-สว่าง, ซื้อหรือยัง, ข้อแรกที่จะเริ่มใหม่ โดยหาจากใน ฐานข้อมูล
  //   getStartId(whatHtmlFile: whatFile);

  return trueOrFalse;
}


Future updateItemTable(BuildContext context, String whatFile, String whatID,
    String whatDate) async {
  print("before updateItemTable: File $whatFile, ID $whatID, Date $whatDate");
  //  BuildContext context, String whatFileName, int whatDate) async {
  final dbClient = await SqliteDB().db;
  var res = await dbClient!.rawQuery('''
    UPDATE itemTable
    SET item_date = ?, isClicked = ?, isNew = ?
    WHERE file_name = ? AND item_id = ?
    ''', ['$whatDate', 'false', '1', '$whatFile', '$whatID']); // ดูอีกที
}


void addNewRecordToItemTable(BuildContext context, String whatFile,
    String whatID, String whatDate) async {
  final dbClient = await SqliteDB().db;
  var res = await dbClient!.rawInsert(
      'INSERT INTO "itemTable" (file_name,item_id,item_date,isClicked,isNew) VALUES(?,?,?,?,?)', [
    '$whatFile',
    '$whatID',
    '$whatDate',
    'false',
    '0'
  ]); // item_id กับ item_date ใน html  คือ อย่างเดียวกัน เพราะมันคือ เนื้อหาของ isNew เช่น <div class="isNew">1608958161</div>
}


// for exercise

String? getDataFromPref(List<String> myMenuNames) {
  for (var i = 0; i < myMenuNames.length; i++) {
    String thisQstnValue = "";
    gettingTheSavedData(myMenuNames[i]).then((thisQstnNum) {
      print("thisQstnNum: $thisQstnNum");
      String thisNum = thisQstnNum;

      thisQstnValue += thisNum + " ";
      //  thisQstnValue.add(thisNum);

      print("thisQstnValue inside for loop: $thisQstnValue");
      //  print("thisQstnValue: ${thisQstnValue.toString()}");
    });

    print("thisQstnValue outside for loop: $thisQstnValue");
    //print("thisQstnValue outside for:  ${thisQstnValue.toString()}");

    return thisQstnValue;
  }
  return null;
}

Future<String> gettingTheSavedData(String key_to_check) async {
  print("key to check in gettingTheSavedData: $key_to_check");
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? thisVal = pref.getString(key_to_check);
  String lastQstnDat = key_to_check + "xyz" + thisVal!;
  print("thisVal: $lastQstnDat");
  return lastQstnDat;
}

