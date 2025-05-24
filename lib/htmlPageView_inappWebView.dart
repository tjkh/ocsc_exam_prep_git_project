import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:ocsc_exam_prep/paymentScreen.dart';
import 'package:ocsc_exam_prep/sqlite_db.dart';
import 'package:ocsc_exam_prep/theme.dart';
import 'package:ocsc_exam_prep/utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import 'ProviderModel.dart';
import 'aboutDialog.dart';
import 'drawingDialog.dart';
import 'item_model.dart';
import 'main.dart';

class HtmlPageView_inappWebView extends StatefulWidget {
  final String myExams;
  final String createDate;
  final String title;
  final int currPageNum;
  final int currQstnNum;
  final int numOfQstn;
  final String msg;
  final bool buyStatus;

  const HtmlPageView_inappWebView({
    super.key,
    required this.myExams,
    required this.createDate,
    required this.title,
    required this.currPageNum,
    required this.currQstnNum,
    required this.numOfQstn,
    required this.msg,
    required this.buyStatus,
  });

  @override
  State<HtmlPageView_inappWebView> createState() =>
      _HtmlPageViewState_inappWebView();
}

class _HtmlPageViewState_inappWebView extends State<HtmlPageView_inappWebView> {
  String? previousQNum; // Flag to determine if we should save the question number

  late String myHtmlFile;
  double _progress = 0;
  InAppWebViewController? inAppWebViewController;
  bool ActiveConnection = false; // Check internet connection after buy button
  var exerciseData; // Store exercise data: topic, current question, total questions

  late List<String> myMenuNames; // Store menu names from HTML

  @override
  void initState() {
    super.initState();

    String filePath = 'assets/data/';
    String _myExams = widget.myExams;
    String _title = widget.title;
    myHtmlFile = filePath + _myExams;

    CheckUserConnection();

    bool _buyStatus = false;

    final providerModel = Provider.of<ProviderModel>(context, listen: false);
    final provider = Provider.of<ProviderModel>(context, listen: false);

    provider.initPlatformState();
    print(
        "offering from provider -- calling from htmlPageView: ${provider.offering}");
    print(
        "removeAds from provider -- calling from htmlPageView: ${provider.removeAds}");

    _buyStatus = providerModel.removeAds;

    print(
        "_buyStatus (isBought from Provider, sourced from removeAds and sku in hashTable and sharePref: $_buyStatus");

    if (_buyStatus == false) {
      _buyStatus = widget.buyStatus;
    }

    bool isBoughtAlready = _buyStatus;

    String currMode2 = "";
    bool mode = Provider.of<ThemeNotifier>(context, listen: false).darkTheme;
    print("213 mode from Provider for all JS files: $mode");
    if (mode == true) {
      currMode2 = "dark";
    } else {
      currMode2 = "light";
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMath = false; // Check if it's a math file to show drawing pad button
    if (widget.myExams.contains("graph") ||
        widget.myExams.contains("full_exam_all") ||
        widget.myExams.contains("math_exercise") ||
        widget.myExams.contains("math") ||
        widget.myExams.contains("exponent") ||
        widget.myExams.contains("cndtng") ||
        widget.myExams.contains("sequential_num_exercise") ||
        widget.myExams.contains("symbol_cndtng_exercise") ||
        widget.myExams.contains("operate_exercise") ||
        widget.myExams.contains("table_exercise") ||
        widget.myExams.contains("percent_shortcut") ||
        widget.myExams.contains("ocsc_answer")) {
      isMath = true;
    }

    bool isExercise = widget.myExams.contains("exercise");
    String myMessage = widget.msg;
    String _title = widget.title;

    final theme = Provider.of<ThemeNotifier>(context, listen: false);
    final provider = Provider.of<ProviderModel>(context, listen: false);
    bool _buyStatus = provider.removeAds;
    print("_buyStatus from mainMenu -- htmlPageView: $_buyStatus");
    print("FileName in Build context: ${widget.myExams}");

    String stringResult = "";
    bool mode = Provider.of<ThemeNotifier>(context, listen: false).darkTheme;

    final providerModel = Provider.of<ProviderModel>(context, listen: false);
    provider.initPlatformState();
    print(
        "offering from provider -- calling from htmlPageView: ${provider.offering}");
    print(
        "removeAds from provider -- calling from htmlPageView: ${provider.removeAds}");

    _buyStatus = providerModel.removeAds;

    print(
        "_buyStatus (isBought from Provider, sourced from removeAds and sku in hashTable and sharePref: $_buyStatus");

    if (_buyStatus == false) {
      _buyStatus = widget.buyStatus;
    }

    bool isBoughtAlready = _buyStatus;
    String currMode2 = "";
    print("213 mode from Provider for all JS files: $mode");
    if (mode == true) {
      currMode2 = "dark";
    } else {
      currMode2 = "light";
    }

    return SafeArea(
      minimum: const EdgeInsets.all(1.0),
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {
            print("entering onPopInvokedWithResult");
            clearSharedDrawingData();

            String myData = Provider.of<Data>(context, listen: false).data;
            print('Data from Data class in htmlPageView_inappWebView: $myData');
            print("messageXX: File: ${widget.myExams} Last Q: $myData");

            String currNum;
            String picName = "p00.png";

            if (myData.contains("xzc")) {
              List msgArr = myData.split("xzc");
              print("msgArr from data class: $msgArr");
              currNum = msgArr[1];
              print("messageXX: currNum = $currNum");

              String clickedItems = msgArr[2].substring(3);
              List<String> lstClickedItems = clickedItems.split("ccx");
              print("messageXX: Clicked items: $lstClickedItems");

              for (int i = 0; i < lstClickedItems.length; i++) {
                updateClick_in_ItemTable(context, widget.myExams, lstClickedItems[i]);
              }

              String totalNum = msgArr[0];
              int _currQstnNum = int.parse(RegExp(r'\d+$').firstMatch(currNum)?.group(0) ?? '1');
              int _numOfQstn = int.parse(totalNum);

              double progress = _currQstnNum / _numOfQstn * 100;
              print("_currQstnNum: $_currQstnNum _numOfQstn: $_numOfQstn calculated progress: $progress");

              int myProgress = progress > 50 ? progress.floor() : progress.ceil();
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
              }
            } else {
              currNum = "top";
            }

            print("messageXX: file: ${widget.myExams} image: $picName last: $currNum");

            String? previousQNum = await getStartId(whatHtmlFile: widget.myExams);
            print("messageXX previousQNum from sharePref: $previousQNum");

            if (previousQNum != currNum || currNum == 'tbl_q10') {
              await savePreviousQNum(currNum, widget.myExams);
              await saveProgressImage(picName, widget.myExams);
              print("messageXX: previousQNum AFTER updated: $currNum");
              print("messageXX: picName to save: $picName");
            }

            inAppWebViewController?.goBack();
            return Future.value(false);
          }
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
                child: GestureDetector(
                  onTap: () => _showDrawingWindow(context),
                  child: isMath
                      ? Icon(Icons.edit_note, size: 30.0)
                      : Visibility(child: Icon(Icons.help_outline, size: 26.0), visible: false),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => _buildPopupDialog(context),
                  );
                },
                child: isExercise
                    ? Icon(Icons.help_outline, size: 26.0)
                    : Visibility(child: Icon(Icons.help_outline, size: 26.0), visible: false),
              ),
              PopupMenuButton(
                onSelected: (selectedValue) {
                  handleClick(selectedValue, context);
                },
                itemBuilder: (BuildContext ctx) => [
                  PopupMenuItem(child: Text('ให้คะแนน App นี้'), value: 'vote'),
                  PopupMenuItem(child: Text('แชร์กับเพื่อน'), value: 'share'),
                  PopupMenuItem(
                      child: Text('ส่งอีเมล ติชม เสนอแนะ หรือแจ้งข้อผิดพลาด'), value: 'sendMyMail'),
                  PopupMenuItem(child: Text('เกี่ยวกับ'), value: 'about'),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  border: Border(top: BorderSide(width: 1, color: Colors.white70)),
                ),
                child: Linkify(
                  onOpen: _onOpen,
                  textScaleFactor: 1,
                  text: myMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                  linkStyle: TextStyle(fontSize: 14.0, color: Colors.yellowAccent),
                  options: LinkifyOptions(humanize: false),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  border: Border(top: BorderSide(width: 1, color: Colors.white70)),
                ),
                child: Text(
                  "$_title",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
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
                child: _buyStatus
                    ? SizedBox.shrink()
                    : SizedBox(
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
                              key: ValueKey('uniqueKey'),
                              isDarkMde: mode,
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
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                              content: RichText(
                                text: const TextSpan(
                                  text: 'ท่านต้องเชื่อมต่อกับอินเทอร์เน็ตก่อน นะครับ',
                                  style: TextStyle(fontSize: 20, color: Colors.black87),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                        '\n\n(กดปุ่มลูกศรออกจากหน้านี้ ต่อเชื่อมอินเทอร์เน็ต แล้วจึงกดปุ่มซื้ออีกครั้ง)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 14)),
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
                  children: [
                    InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: WebUri(
                          Platform.isAndroid
                              ? "file:///android_asset/flutter_assets/$myHtmlFile"
                              : Uri.file(myHtmlFile).toString(),
                        ),
                      ),
                      initialSettings: InAppWebViewSettings(),
                      onWebViewCreated: (InAppWebViewController controller) {
                        inAppWebViewController = controller;

                        // Add handler to navigate to last question when page is ready
                        inAppWebViewController?.addJavaScriptHandler(
                          handlerName: "ready",
                          callback: (args) async {
                            String startId = await getStartId(whatHtmlFile: widget.myExams);
                            print("Navigating to question: $startId for file: ${widget.myExams}");
                            inAppWebViewController?.evaluateJavascript(
                                source: 'navigateToQuestion("$startId");'
                            );
                            return {'status': 'navigated'};
                          },
                        );

                        inAppWebViewController?.addJavaScriptHandler(
                          handlerName: "Toaster",
                          callback: (args) {
                            print("345 Received args from JS: $args");
                            try {
                              if (args.isNotEmpty) {
                                String message = args[0];
                                print("345 Message received: $message");
                                return {'bar': 'bar_value', 'baz': 'baz_value'};
                              } else {
                                print("345 args is empty!");
                                return {'error': 'No arguments provided'};
                              }
                            } catch (e) {
                              print("345 Error in callback: $e");
                              return {'error': 'Exception occurred'};
                            }
                          },
                        );

                        inAppWebViewController?.addJavaScriptHandler(
                          handlerName: "is_IsNewClicked",
                          callback: (args) async {
                            print("345 Received args from JS - is_IsNewClicked: $args");
                            try {
                              if (args.isNotEmpty) {
                                String message = args[0];
                                print("345 Message received - is_IsNewClicked: $message");

                                String contentOfIsNewFromJs = message;
                                String contentOfIsNew = contentOfIsNewFromJs.length < 1
                                    ? "id111111:date1637726921"
                                    : contentOfIsNewFromJs.substring(
                                    0, contentOfIsNewFromJs.length - 3);

                                print(
                                    "checkTwice รับมาจาก JS: contentOfIsNew: $contentOfIsNew");

                                await saveOrUpdateItemTable(
                                    whatString: contentOfIsNew,
                                    whatHtmlFile: widget.myExams,
                                    context: context);

                                String thisDateFromSQL = await getIsNewFromItemTbl(
                                    whatFile: widget.myExams,
                                    isNewString: contentOfIsNew);

                                stringResult = thisDateFromSQL.substring(
                                    0, thisDateFromSQL.length - 3);

                                String startID = await getStartId(whatHtmlFile: widget.myExams);
                                String newString = stringResult + "tjk" + startID;
                                print(
                                    "213 ชื่อไฟล์: ${widget.myExams} ข้อมูล stringResult+startID: $newString");
                                print(
                                    "213 currMode2 before adding to newString for sending to JS: $currMode2");
                                newString = newString + "tjk" + currMode2;

                                String alreadyBought = _buyStatus ? "true" : "false";
                                print(
                                    "213 is_Bought_Already before sending to JScript: $alreadyBought");
                                newString = newString + "tjk" + alreadyBought;
                                print(
                                    "213 Flutter ส่งไป Js - is_IsNewClicked() สำหรับไฟล์: ${widget.myExams} ข้อมูลทั้งหมดสำหรับ is_IsNewClcked(): $newString");

                                return {'newString': newString, 'baz': 'baz_value'};
                              } else {
                                print("345 args is empty!");
                                return {'error': 'No arguments provided'};
                              }
                            } catch (e) {
                              print("345 Error in callback: $e");
                              return {'error': 'Exception occurred'};
                            }
                          },
                        );

                        inAppWebViewController?.addJavaScriptHandler(
                          handlerName: "messageHandler",
                          callback: (args) {
                            print(
                                "213 Js > Flutter - for messageHandler(): ชื่อไฟล์: ${widget.myExams} ค่าที่ส่งมาจาก JS -> Flutter: ${args[0]} ");

                            String msgStr;
                            if (args.length >= 1) {
                              print("kxk from seq_num: $args");
                              String exerciseDat = args.join('');
                              msgStr = exerciseDat;
                              print("kxk msgStr from seq_num: $msgStr");
                            } else {
                              print("kxk from con_full_version: $args");
                              msgStr = args[0];
                              print("kxk msgStr from con_full_version: $msgStr");
                            }

                            Provider.of<Data>(context, listen: false).changeString(msgStr);

                            String msgToSend = "$isBoughtAlready" + "xyz" + "$mode";
                            print(
                                "213 Flutter ส่งไป Js - isBuyAndMode() ไฟล์: ${widget.myExams} buy: $isBoughtAlready, mode: $mode, msgToSend: $msgToSend");

                            print("message to send to JS: $msgToSend");
                            return {'Message': '$msgToSend', 'baz': 'baz_value'};
                          },
                        );

                        inAppWebViewController?.addJavaScriptHandler(
                          handlerName: "exerciseData",
                          callback: (args) {
                            print(
                                "213 Js > Flutter - for exerciseData ชื่อไฟล์: xxx ค่าที่ส่ง: $args");

                            String exerciseDat = args.join('');
                            print("args ข้อมูลจาก Javascript มายัง exerciseData: $exerciseDat");

                            List<String> forDataClass = exerciseDat.split("xzc");
                            print("forDataClass: $forDataClass");

                            String nameOfMenu = forDataClass[0];
                            String curValueOfMenu = forDataClass[1];

                            getExerciseDoneFromPref(nameOfMenu, curValueOfMenu)
                                .then((completedTotal) {
                              List<String> completedTotal_data = completedTotal.split(":");
                              String thisMenuName = completedTotal_data[0];
                              String thisCompletedTotal = completedTotal_data[1];

                              forDataClass[1] = thisCompletedTotal;
                              print("menuName - forDataClass[0]: ${forDataClass[0]}");
                              print(
                                  "completed sofar - forDataClass[1]: ${forDataClass[1]}");
                              print("Total - forDataClass[2]: ${forDataClass[2]}");

                              String msgForWillpopFromExerciseDat = forDataClass[2] +
                                  "xzctbl_q" +
                                  forDataClass[1] +
                                  "xzcccx11111";

                              print(
                                  "exerciseData sent to Data class for progress: $msgForWillpopFromExerciseDat");

                              Provider.of<Data>(context, listen: false)
                                  .changeString(msgForWillpopFromExerciseDat);
                            });

                            saveExerciseData(exerciseDat);
                          },
                        );

                        inAppWebViewController?.addJavaScriptHandler(
                          handlerName: "menuNameToFlutter",
                          callback: (args) async {
                            print(
                                "213 Js > ค่าที่ส่ง via menuNameToFlutter : ${args[0]}");
                            String exerciseMenu = args[0].trim();
                            myMenuNames = exerciseMenu.split(",");
                            print("myMenuNames.length: ${myMenuNames.length}");

                            List lastQstn_from_pref = await checkingTheSavedData(myMenuNames, "0");
                            print("lastQstn_from_pref: $lastQstn_from_pref");

                            // Fetch progress images for each menu
                            List<String> menuData = [];
                            for (var menuName in myMenuNames) {
                              String? lastQstn = await getLastQuestion(menuName);
                              String? progressImage = await getProgressImage(menuName);
                              menuData.add("$menuName:xyz:$lastQstn:xyz:$progressImage");
                            }

                            String dataToJs = menuData.join(" ");
                            print("dataToJs for menuNames: $dataToJs");

                            inAppWebViewController?.evaluateJavascript(
                                source: 'getLastQstnNum("$dataToJs")');

                            return {'menuName': "$dataToJs", 'baz': 'baz_value'};
                          },
                        );

                        inAppWebViewController?.addJavaScriptHandler(
                          handlerName: "get_isNewClicked",
                          callback: (args) {
                            print("3456 Received args from JS: $args");
                            try {
                              if (args.isNotEmpty) {
                                String message = args[0];
                                print("3456 Message received: $message");

                                String contentOfIsNewFromJs = message;
                                String contentOfIsNew = contentOfIsNewFromJs.length < 1
                                    ? "id111111:date1637726921"
                                    : contentOfIsNewFromJs.substring(
                                    0, contentOfIsNewFromJs.length - 3);

                                print(
                                    "checkTwice รับมาจาก JS: contentOfIsNew: $contentOfIsNew");

                                saveOrUpdateItemTable(
                                    whatString: contentOfIsNew,
                                    whatHtmlFile: widget.myExams,
                                    context: context);

                                getIsNewFromItemTbl(
                                    whatFile: widget.myExams, isNewString: contentOfIsNew)
                                    .then((thisDateFromSQL) {
                                  stringResult = thisDateFromSQL.substring(
                                      0, thisDateFromSQL.length - 3);

                                  getStartId(whatHtmlFile: widget.myExams).then((startID) {
                                    String newString = stringResult + "tjk" + startID;
                                    print(
                                        "213 ชื่อไฟล์: ${widget.myExams} ข้อมูล stringResult+startID: $newString");
                                    print(
                                        "213 currMode2 before adding to newString for sending to JS: $currMode2");
                                    newString = newString + "tjk" + currMode2;

                                    String alreadyBought = _buyStatus ? "true" : "false";
                                    print(
                                        "213 is_Bought_Already before sending to JScript: $alreadyBought");
                                    newString = newString + "tjk" + alreadyBought;
                                    print(
                                        "213 Flutter ส่งไป Js - is_IsNewClicked() สำหรับไฟล์: ${widget.myExams} ข้อมูลทั้งหมดสำหรับ is_IsNewClcked(): $newString");

                                    return {'newString': '$newString', 'baz': 'baz_value'};
                                  });
                                });
                              } else {
                                print("345 args is empty!");
                                return {'error': 'No arguments provided'};
                              }
                            } catch (e) {
                              print("345 Error in callback: $e");
                              return {'error': 'Exception occurred'};
                            }
                          },
                        );
                      },
                      onProgressChanged: (InAppWebViewController controller, int progress) {
                        if (_progress >= 1.0) {
                          print("345 inappWebView finished loading...");
                        }
                        setState(() {
                          _progress = progress / 100;
                        });
                      },
                    ),
                    if (_progress < 1.0) LinearProgressIndicator(value: _progress),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateClick_in_ItemTable(BuildContext context, String whatFile, String whatID) async {
    print("before updateClick_in_ItemTable File Name: $whatFile, ID: $whatID");
    final dbClient = await SqliteDB().db;
    var res = await dbClient?.rawQuery('''
    UPDATE itemTable
    SET isClicked = ?,
    isNew = ?
    WHERE file_name = ? AND item_id = ?
    ''', ['true', '0', '$whatFile', '$whatID']);
  }

  Future<void> clearSharedDrawingData() async {
    debugPrint("try to clear sharedDrawing");
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("savedDrawing");
  }

  Future<void> _onOpen(LinkableElement link) async {
    Uri thisLink = Uri.parse(link.url);
    if (await canLaunchUrl(thisLink)) {
      await launchUrl(thisLink);
    } else {
      throw 'Could not launch $link';
    }
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

  Future<String> getExerciseDoneFromPref(String menuName, String menuValue) async {
    print("in getExerciseDoneFromPref");
    int math2567 = 0;
    int mat_8_yrs = 0;
    int law = 0;
    int others = 0;

    int completedSofar = 0;
    int completedSofar_2567 = 0;
    int completedSofar_8yrs = 0;
    int completedSofar_law = 0;
    int completedSofar_others = 0;

    List mNames_2567 = [];
    List mNames_8yrs = [];
    List mNames_law = [];

    String thisMenuName = menuName;
    String thisMenuCurrValue = menuValue;

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (var key in keys) {
      if (key.contains('_exer')) {
        final value = prefs.getString(key);
        if (value != null) {
          if (key.contains('_2')) {
            math2567 += 1;
            mNames_2567.add(key + ":" + value + " ");
            if (key == thisMenuName) {
              completedSofar_2567 += int.parse(thisMenuCurrValue);
            } else {
              completedSofar_2567 += int.parse(value);
            }
          } else if (key.contains('math_exer')) {
            mat_8_yrs += 1;
            mNames_8yrs.add(key + ":" + value + " ");
            if (key == thisMenuName) {
              completedSofar_8yrs += int.parse(thisMenuCurrValue);
            } else {
              completedSofar_8yrs += int.parse(value);
            }
          } else if (key.contains('law_exer')) {
            law += 1;
            mNames_law.add(key + ":" + value + " ");
            if (key == thisMenuName) {
              completedSofar_law += int.parse(thisMenuCurrValue);
            } else {
              completedSofar_law += int.parse(value);
            }
          } else {
            completedSofar_others += int.parse(thisMenuCurrValue);
            others += 1;
          }
        }
      }
    }

    if (thisMenuName.contains("_2")) {
      completedSofar = completedSofar_2567;
    } else if (thisMenuName.contains("math_exer")) {
      completedSofar = completedSofar_8yrs;
    } else if (thisMenuName.contains("law_exer")) {
      completedSofar = completedSofar_law;
    } else {
      completedSofar = completedSofar_others;
    }

    String result = thisMenuName + ":" + completedSofar.toString();
    print("result from sharePref: $result");
    print("completedSofar: $completedSofar");

    print(
        "math2567: $completedSofar_2567\n mat_8_yrs: $completedSofar_8yrs\n law: $completedSofar_law\n others: $completedSofar_others");
    print("menuNames: $mNames_2567\n$mNames_8yrs\n$mNames_law");
    return result;
  }

  Future saveExerciseData(exDat) async {
    var exDatList = exDat.split('xzc');
    String thisName = exDatList[0];
    String thisValue = exDatList[1];
    exerciseData = await SharedPreferences.getInstance();
    exerciseData.setString(thisName, thisValue);
  }

  Future<List> checkingTheSavedData(List key_to_check, String initial_value) async {
    List thisDat = [];
    print("thisDat: $thisDat");

    List myMenuNames = key_to_check;

    for (var i = 0; i < myMenuNames.length; i++) {
      await isExerciseKeyExist(myMenuNames[i]).then((isExist) async {
        if (!isExist) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString(myMenuNames[i], initial_value);
          pref.setString('progress_image_${myMenuNames[i]}', 'p00.png');
          thisDat.add(myMenuNames[i] + ":xyz:" + initial_value + ":xyz:p00.png");
          print("thisDat inside for loop (not exist): ${thisDat.toString()}");
        } else {
          SharedPreferences pref = await SharedPreferences.getInstance();
          String? thisValue = pref.getString(myMenuNames[i]);
          String? progressImage = pref.getString('progress_image_${myMenuNames[i]}') ?? 'p00.png';
          thisDat.add(myMenuNames[i] + ":xyz:" + thisValue + ":xyz:" + progressImage);
          print("thisDat inside for loop (do exist): ${thisDat.toString()}");
        }
      });
    }
    print("thisDat before return: ${thisDat.toString()}");
    return thisDat;
  }

  Future<bool> isExerciseKeyExist(String keyToCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(keyToCheck)) {
      print("$keyToCheck found in sharePref");
      return true;
    } else {
      print("$keyToCheck NOT found in sharePref");
      return false;
    }
  }

  bool saveOrUpdateItemTable(
      {String? whatString, String? whatHtmlFile, context}) {
    String? contentOfIsNew = whatString;
    String? _myExams = whatHtmlFile;

    List<String>? jsMassage = contentOfIsNew?.split("abc");

    for (int i = 0; i < (jsMassage!.length); i++) {
      String thisIdAndDate = jsMassage[i];
      const start = "id";
      const end = ":date";
      final startIndex = thisIdAndDate.indexOf(start);
      final endIndex = thisIdAndDate.indexOf(end, startIndex + start.length);
      final startIndex2 = thisIdAndDate.indexOf(end);
      String qNumId = thisIdAndDate.substring(startIndex + start.length, endIndex);
      String qNumDate = thisIdAndDate.substring(startIndex2 + end.length);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        addOrUpdate(
            whatFile: _myExams!,
            whatID: qNumId,
            whatDate: qNumDate,
            context as BuildContext);
      });
    }
    return true;
  }

  void addOrUpdate(BuildContext context,
      {required String whatFile, required String whatID, required String whatDate}) async {
    print(
        "345 ----- enter addOrUpdate ------ Fn: $whatFile whatID: $whatID whatDate $whatDate");
    final dbClient = await SqliteDB().db;
    List<Map> list = await dbClient!.rawQuery(
        'SELECT * FROM itemTable WHERE file_name = ? AND item_id = ?',
        ["$whatFile", "$whatID"]);

    int count = list.length;
    print(
        "345 ----- inside addOrUpdate ------ check Fn: $whatFile whatID: $whatID in itemTable count: $count");
    if (count >= 1) {
      String dateFromSQL = list.first["item_date"];
      int dateFromSQLite = int.parse(dateFromSQL);
      int fileDate = int.parse(whatDate);

      if (fileDate > dateFromSQLite) {
        updateItemTable(context, whatFile, whatID, whatDate);
        print(
            "345 ----- inside addOrUpdate ------ FOUND AND NEWER: Fn: $whatFile whatID: $whatID count: $count");
      }
    } else {
      print(
          "345 ----- inside addOrUpdate ------ NOT FOUND Fn: $whatFile whatID: $whatID in itemTable count: $count");
      addNewRecordToItemTable(context, whatFile, whatID, whatDate);
      print(
          "345 ----- inside addOrUpdate ------ finish ADD NEW Fn: $whatFile whatID: $whatID in itemTable");
    }
    print("345 ----- leaving addOrUpdate --------------- ");
  }

  updateItemTable(
      BuildContext context, String whatFile, String whatID, String whatDate) async {
    print("before updateItemTable: File $whatFile, ID $whatID, Date $whatDate");
    final dbClient = await SqliteDB().db;
    var res = await dbClient!.rawQuery('''
    UPDATE itemTable
    SET item_date = ?, isClicked = ?, isNew = ?
    WHERE file_name = ? AND item_id = ?
    ''', ['$whatDate', 'false', '1', '$whatFile', '$whatID']);
  }

  void addNewRecordToItemTable(
      BuildContext context, String whatFile, String whatID, String whatDate) async {
    final dbClient = await SqliteDB().db;
    var res = await dbClient!.rawInsert(
        'INSERT INTO "itemTable" (file_name,item_id,item_date,isClicked,isNew) VALUES(?,?,?,?,?)',
        ['$whatFile', '$whatID', '$whatDate', 'false', '0']);
  }

  Future<String> getIsNewFromItemTbl(
      {required String whatFile, required String isNewString}) async {
    List<String> jsMassage = isNewString.split("abc");
    String trueOrFalse = "";
    for (int i = 0; i < (jsMassage.length); i++) {
      String thisIdAndDate = jsMassage[i];
      const start = "id";
      const end = ":date";
      final startIndex = thisIdAndDate.indexOf(start);
      final endIndex = thisIdAndDate.indexOf(end, startIndex + start.length);
      final startIndex2 = thisIdAndDate.indexOf(end);
      String qNumId = thisIdAndDate.substring(startIndex + start.length, endIndex);
      String qNumDate = thisIdAndDate.substring(startIndex2 + end.length);
      print("ส่งไปหา ในTable i: $i id: $qNumId date: $qNumDate fn: $whatFile");

      final dbClient = await SqliteDB().db;
      var result = await dbClient?.rawQuery(
          'SELECT * FROM itemTable WHERE file_name = ? AND item_id = ?',
          ["$whatFile", "$qNumId"]);

      if (result!.isNotEmpty) {
        print("ส่งไปหา ในTable เจอ TF: $trueOrFalse จ$qNumId $whatFile");
        trueOrFalse = trueOrFalse +
            qNumId +
            "sss" +
            (result.first["isNew"].toString()) +
            "sss" +
            (result.first["isClicked"].toString()) +
            "abc";
      } else {
        trueOrFalse += qNumId + "sss" + qNumDate + "ssstrueabc";
        print("ส่งไปหา ในTable ไม่เจอ TF: $trueOrFalse $qNumId $whatFile");
      }
    }
    return trueOrFalse;
  }

  Future<String> getStartId({String? whatHtmlFile}) async {
    String itemID = "top";
    final prefs = await SharedPreferences.getInstance();
    String? lastQuestion = prefs.getString('last_question_${whatHtmlFile}');
    if (lastQuestion != null && lastQuestion.isNotEmpty) {
      itemID = lastQuestion;
    }
    print("startAtID inside getStartId: $itemID FILE: $whatHtmlFile");
    return itemID;
  }

  Future<String?> getPreviousQNum() async {
    print('aaabc Deprecated: getPreviousQNum is deprecated, use getStartId instead');
    final thisPref = await SharedPreferences.getInstance();
    print('aaabc Retrieving previousQNum: ${thisPref.getString('previousQNum')}');
    return thisPref.getString('previousQNum');
  }

  Future<void> savePreviousQNum(String qNum, String fileName) async {
    print('aaabc Saving currNum as previousQNum: $qNum for file: $fileName');
    final thisPref = await SharedPreferences.getInstance();
    await thisPref.setString('last_question_$fileName', qNum);
  }

  Future<void> saveProgressImage(String picName, String fileName) async {
    print('aaabc Saving progress image: $picName for file: $fileName');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('progress_image_$fileName', picName);
  }

  Future<String?> getLastQuestion(String menuName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(menuName) ?? "0";
  }

  Future<String?> getProgressImage(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('progress_image_$fileName') ?? "p00.png";
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

Future<void> handleClick(String value, BuildContext context) async {
  switch (value) {
    case 'sendMyMail':
      final Uri params = Uri(
        scheme: 'mailto',
        path: 'thongjoon@gmail.com',
        query: 'subject=หัวข้อเรื่อง (โปรดระบุ)&body=สวัสดีครับ/ค่ะ',
      );
      var url = params;
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
      break;
    case 'vote':
      if (Platform.isAndroid) {
        Utils.openLink(
            url: 'https://play.google.com/store/apps/details?id=com.thongjoon.ocsc_exam_prep');
      } else if (Platform.isIOS) {
        Utils.openLink(
            url: 'https://apps.apple.com/app/เตรียมสอบ-กพ-ภาค-ก/id1622156979');
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
  Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return aboutDialog();
      },
      fullscreenDialog: true));
}

Widget _buildPopupDialog(BuildContext context) {
  return AlertDialog(
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
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text("ปัดซ้าย เพื่อไปข้อต่อไป")],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text("ปัดขวา เพื่อย้อนกลับ")],
        ),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'ปิด',
          style: TextStyle(fontSize: 14.0, color: Theme.of(context).primaryColor),
        ),
      ),
    ],
  );
}

// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:ocsc_exam_prep/paymentScreen.dart';
// import 'package:ocsc_exam_prep/sqlite_db.dart';
// import 'package:ocsc_exam_prep/theme.dart';
// import 'package:ocsc_exam_prep/utils.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// //import 'package:sqflite/sqflite.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:io';
//
// import 'ProviderModel.dart';
// import 'aboutDialog.dart';
// import 'drawingDialog.dart';
// import 'item_model.dart';
// import 'main.dart';
//
// class HtmlPageView_inappWebView extends StatefulWidget {
//   final String myExams;
//   final String createDate;
//   final String title;
//   final int currPageNum;
//   final int currQstnNum;
//   final int numOfQstn;
//   final String msg;
//   final bool buyStatus;
//
//   const HtmlPageView_inappWebView({
//     super.key,
//     required this.myExams,
//     required this.createDate,
//     required this.title,
//     required this.currPageNum,
//     required this.currQstnNum,
//     required this.numOfQstn,
//     required this.msg,
//     required this.buyStatus,
//   });
//
//   @override
//   State<HtmlPageView_inappWebView> createState() =>
//       _HtmlPageViewState_inappWebView();
// }
//
// class _HtmlPageViewState_inappWebView extends State<HtmlPageView_inappWebView> {
//
//   String? previousQNum;  // สำหรับเป็น Flag ว่าจะ update ตาราง OcscTjkTable หรือไม่
//
//   late String myHtmlFile;
//   double _progress = 0;
//   // late InAppWebViewController inAppWebViewController;
//   InAppWebViewController? inAppWebViewController;
//   bool ActiveConnection =
//   false; // สำหรับตรวจสอบว่าต่ออินเทอร์เน็ตหรือเปล่า หลังจากกดปุ่มซื้อ
//   var exerciseData; // สำหรับเก็บข้อมูลการทำแบบฝึกหัด ได้แก่ เรื่องอะไร ทำข้อปัจจุบันข้ออะไร เรื่องนี้มีทั้งหมดกี่ข้อ
//
//   late List<String> myMenuNames; // สำหรับเก็บชื่อเมนูที่เอามาจากไฟล์ html
//
//   @override
//   void initState() {
//     super.initState();
//
//     String filePath = 'assets/data/';
//     String _myExams = widget.myExams;
//     String _title = widget.title;
//     myHtmlFile = filePath + _myExams;
//     String picName;
//
//     CheckUserConnection();
//
//     bool _buyStatus = false;
//     String stringResult = "";
//
//     final providerModel = Provider.of<ProviderModel>(context, listen: false);
//
//     final provider = Provider.of<ProviderModel>(context, listen: false);
//
//     provider.initPlatformState();
//     print(
//         "offering from provider -- caling from htmlPageView: ${provider.offering}");
//     print(
//         "removeAds from provider -- caling from htmlPageView:  ${provider.removeAds}");
//
//     _buyStatus = providerModel.removeAds;
//
//     print(
//         "_buyStatus (isBought ส่งมาจาก Provider โดย เอามาจาก removeAds และ sku ในตาราง hashTable และ sharePref: $_buyStatus");
//
//     if (_buyStatus == false) {
//       // เชคที่ส่งมาจาก mainMenu
//       _buyStatus = widget.buyStatus;
//     }
//
//     bool isBoughtAlready = _buyStatus;
//
//     String currMode2 = "";
//
//     bool mode; // สำหรับส่งไป JS ว่าโหมดมืด หรือ สว่าง
//
//     mode = Provider.of<ThemeNotifier>(context, listen: false).darkTheme;
//     print("213 mode from Provider for all JS files: $mode");
//     if (mode == true) {
//       currMode2 = "dark";
//     } else {
//       currMode2 = "light";
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     bool isMath =
//     false; // สำหรับเชคว่า เป็น คณิต หรือไม่ จะได้แสดงปุ่มกระดาษทด บน appBar
//
//     // ช้า ทำได้ไม่ดี เลยเลิกใช้งาน เลยกำหนดให้เป็น false ทั้งหมด
//     // ถ้า จะลองใหม่ ให้เอา คอมเม้นข้างล่างออก ทุกอย่างยังทำงานได้
//
//     if (widget.myExams.contains("graph") ||
//         widget.myExams.contains("full_exam_all") ||
//         widget.myExams.contains("math_exercise") ||
//         widget.myExams.contains("math") ||
//         widget.myExams.contains("exponent") ||
//         widget.myExams.contains("cndtng") ||
//         widget.myExams.contains("sequential_num_exercise") ||
//         widget.myExams.contains("symbol_cndtng_exercise") ||
//         widget.myExams.contains("operate_exercise") ||
//         widget.myExams.contains("table_exercise") ||
//         widget.myExams.contains("percent_shortcut") ||
//         widget.myExams.contains("ocsc_answer")) {
//       isMath = true;
//     } else {
//       isMath = false;
//     }
//
//     bool isExercise; // ชื่อไฟล์ที่มีคำว่า exercise ต่อท้าย
//     // คือไฟล์ที่มีรูปแบบ ถาม-ตอบ ใช้ข้อมูลลักษณะ json
//     if (widget.myExams.contains("exercise")) {
//       isExercise = true;
//     } else {
//       isExercise = false;
//     }
//     String myMessage = widget.msg; // ข่าวสาร
//     String _title = widget.title;
//
//     final theme = Provider.of<ThemeNotifier>(context,
//         listen: false); // สำหรับเรียกใช้ฟังก์ชันต่าง ๆ ใน theme provider
//     final provider = Provider.of<ProviderModel>(context, listen: false);
//     bool _buyStatus = provider.removeAds;
//     print("_buyStatus from mainMenu -- htmlPageView: $_buyStatus");
//     print("FileName in Build context: ${widget.myExams}");
//
//     List<ItemModel> itemData;
//     String stringResult =
//         ""; // สำหรับส่งข้อมูล isNew ไป javaScript เชคแต่ละข้อว่า ใหม่หรือเปล่า
//
//     bool mode; // สำหรับส่งไป JS ว่าโหมดมืด หรือ สว่าง
//     mode = Provider.of<ThemeNotifier>(context, listen: false).darkTheme;
//
//     final providerModel = Provider.of<ProviderModel>(context, listen: false);
//
//     provider.initPlatformState();
//     print(
//         "offering from provider -- caling from htmlPageView: ${provider.offering}");
//     print(
//         "removeAds from provider -- caling from htmlPageView:  ${provider.removeAds}");
//
//     _buyStatus = providerModel.removeAds;
//
//     print(
//         "_buyStatus (isBought ส่งมาจาก Provider โดย เอามาจาก removeAds และ sku ในตาราง hashTable และ sharePref: $_buyStatus");
//
//     if (_buyStatus == false) {
//       // เชคที่ส่งมาจาก mainMenu
//       _buyStatus = widget.buyStatus;
//     }
//
//     bool isBoughtAlready = _buyStatus;
//     String currMode2 = "";
//     // bool mode; // สำหรับส่งไป JS ว่าโหมดมืด หรือ สว่าง
//     //
//     // mode = Provider.of<ThemeNotifier>(context, listen: false).darkTheme;
//     print("213 mode from Provider for all JS files: $mode");
//     if (mode == true) {
//       currMode2 = "dark";
//     } else {
//       currMode2 = "light";
//     }
//
//     return SafeArea(
//       minimum: const EdgeInsets.all(1.0),
//
//       child: PopScope(
//
//         canPop: true,
//        //  canPop: false,
//         // onPopInvoked: (bool didPop) async { // deprecated
//         onPopInvokedWithResult: (bool didPop, Object? result) async {
//            final _controller = inAppWebViewController;
//
//
//           if (didPop) {
//             print("entering onPopInvokedWithResult");
//
//             // Clear shared data or perform any other cleanup tasks
//             clearSharedDrawingData(); // Clear the drawing data
//
//
//             String myData = Provider
//                 .of<Data>(context, listen: false)
//                 .data; // สำหรับส่งข้อมูล ไปแสดง ไอคอน รูปวงกลม แสดงความก้าวหน้า
//
//             print('Data from Data class in htmlPageView_inappWebView: $myData');
//             print(
//                 " messageXX: ชื่อไฟล์: ${widget
//                     .myExams} เลขข้อสุดท้าย: $myData");
//             String picName;
//             String currNum;
//             String lastNum;
//             String myNum;
//
//             if ((widget.myExams).contains("math_exercise")) {}
//
//             final regexp = RegExp(
//                 r'\d+$'); // เอาเฉพาะ ข้อความที่ลงท้ายด้วยตัวเลข
//             if (myData.contains("xzc")) {
//               // ถ้ามี xzc แสดงว่า ส่งมาจาก javaScript OK
//               List msgArr = myData.split(
//                   "xzc"); // แยกข้อมูลที่ส่งมาจาก javaScript เป็น ข้อที่ทำปัจจุบัน กับข้อทั้งหมด
//
//               print("msgArr ทำ myData จาก data class เป็น array: $msgArr");
//               currNum = msgArr[1];
//               print(" messageXX: currNum = $currNum");
//               final lastQNum = regexp
//                   .allMatches(currNum)
//                   .map((m) => m[0])
//                   .first;
//
//               String clickedItems =
//               msgArr[2].substring(3); // เอาตัวหน้า 3 ตัว ccx ออกไป
//
//               List<String> lstClickedItems = clickedItems.split("ccx");
//               print(
//                   " messageXX: ข้อที่คลิก lstClickedItems:  $lstClickedItems");
//
//               for (int i = 0; i < (lstClickedItems.length); i++) {
//                 updateClick_in_ItemTable(
//                     context, widget.myExams, lstClickedItems[i]);
//               }
//
//               myNum = lastQNum.toString();
//               print(" messageXX: ข้อสุดท้าย myNum:  $myNum");
//               String totalNum = msgArr[0];
//               int _currQstnNum = int.parse(myNum);
//               int _numOfQstn = int.parse(totalNum);
//               //   _controller = WebViewController();
//
// // ยกเลิกการเชค เพราะตัดขาด หน้าเมนู เอาจุดแดงออก ไม่ขึ้นกับ ข้อสอบแต่ละข้อ ในหน้า itemPageView
//          //     checkIsNew(whatFile: widget.myExams, allQstnItem: _numOfQstn);
//
//               // int myProgress = (_currQstnNum / _numOfQstn * 100).round();
//               //print("myProgress to show: $myProgress");
//
//               double progress = _currQstnNum / _numOfQstn * 100;
//
//               print("_currQstnNum: $_currQstnNum _numOfQstn: $_numOfQstn calculated progress: $progress");
//
//               int myProgress; // เพื่อว่า ขาดไปข้อเดียวก็ยังไม่เสร็จ ถ้าปัดธรรมดา round()
//               // มันจะปัดขึ้น ทำให้เป็น 100% ซึ่งไม่ดี ทำนองเดียวกัน ทำข้อเดียว มันปัดลง ก็ไ่ม่ขึ้นวงกลมให้
//               // ก็เลยเอาใหม่เป็น ถ้าข้อเดียวก็แสดงความก้าวหน้า หรือ ทำขาดไปข้อเดียว ก็ไม่ขึ้น เครื่องหมายถูกให้
//               if (progress > 50) {
//                 myProgress = progress.floor();
//               } else {
//                 myProgress = progress.ceil();
//               }
//
//               if (myProgress >= 100) {
//                 picName = "p100.png";
//               } else if (myProgress >= 90) {
//                 picName = "p90.png";
//               } else if (myProgress >= 80) {
//                 picName = "p80.png";
//               } else if (myProgress >= 70) {
//                 picName = "p70.png";
//               } else if (myProgress >= 60) {
//                 picName = "p60.png";
//               } else if (myProgress >= 50) {
//                 picName = "p50.png";
//               } else if (myProgress >= 40) {
//                 picName = "p40.png";
//               } else if (myProgress >= 30) {
//                 picName = "p30.png";
//               } else if (myProgress >= 20) {
//                 picName = "p20.png";
//               } else if (myProgress >= 1) {
//                 picName = "p10.png";
//               } else {
//                 picName = "p00.png";
//               }
//             } else {
//               currNum = "top"; // ถ้าไม่มี ให้ไปที่บนสุด
//               picName = "p00.png";
//             }
//
//             //   print("messageXX: ข้อสุดท้าย myNum:  $myNum");
//             print(" messageXX: file: ${widget.myExams} ชื่อภาพ:  $picName ข้อสุดท้าย:  $currNum");
//          //   print(" messageXX: previousQNum BEFORE updated: $previousQNum");
//
//
//             getPreviousQNum().then((value) { //ไปเอาข้อมูล ข้อสุดท้ายเมื่อครั้งก่อน ที่เก็บใน Sharepref
//               // เพื่อเอามาเปรียบเทียบว่า ถ้าคลิกเข้ามาหน้าข้อสอบชุดนี้ แล้วไม่ทำอะไร คลิกลูกศรออกเลย จะได้
//               // ไม่ต้องปรับข้อมูล เพราะถ้าปรับข้อมูล จะผิด เพราะส่วนใหญ่ม คลิกครั้งงก่อนันจะคนละไฟล์กับที่คลิกเข้ามาครั้งนี้
//               // ถ้าไม่ใช้ รูปแบบ .then ก็ให้้ใช้ asnyc-await แทน เช่น เรียก getPreviousQNum() ตรงนี้
//               // แล้ว สร้าง getPreviousQNum async(){await...} เป็นต้น
//
//               String previousQNum = value.toString();
//               print("messageXX previousQNum from sharePref: $previousQNum");
//
//               print("messageXX BEFORE COMPARE currNum: $currNum previousQNum: $previousQNum");
//
//             if((previousQNum!=currNum) || (currNum == 'tbl_q10')) { // ป้องกัน ถ้าเข้ามาแล้วไม่ทำข้อสอบ แต่กดออกเลย จะได้ไม่ต้องเอาข้อมูลข้อเก่ามา update ตาราง
//                                           // หน้าอธิบายเฉย ๆ เมื่อออก ก็จะมีเครื่องหมายถูก เพราะมีเงื่อนไขว่า เป็น 'tbl_q10' เพราะ กำหนดใน javascript ไว้อย่างนั้น
//
//                 savePreviousQNum(currNum); // ✅ Save persistently
//                 print("messageXX: previousQNum AFTER updated: $previousQNum");
//                 print("messageXX: picName to save in ocscTjkTbl: $picName");
//               // update ข้อมูลในตาราง OcscTjkTable เพื่อว่า เวลาทำหน้าเมนู จะได้มีไอคอนความก้าวหน้า และ เวลาเปิดใหม่ จะได้ไปที่ข้อที่ทำค้างไว้ (ถ้ามี)
//                 updateOcscTjkTbl_html(
//                 fileName: widget.myExams,
//                 whereToStart: currNum,
//                 iconName: picName);
//               }
//             });
//
//            _controller?.goBack();
//            return Future.value(false);
//
//         }
//
//           return Future.value(true);
// //           //   end of comment out 203 to 317
//
//
//
//
//         },
//
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text(
//               'เตรียมสอบ ก.พ. ภาค ก.',
//               style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//             ),
//             centerTitle: true,
//             elevation: 0,
//             actions: [
//               Tooltip(
//                 message: "กระดาษทด",
//                 child: GestureDetector(
//                   // สำหรับ dialog กระดาษทด
//                   onTap: () => _showDrawingWindow(context),
//                   child:
//                   (isMath) //ถ้าเป็นไฟล์คณิต จะให้มี icon คลิกไปเปิดกระดาษทด
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
//               GestureDetector(
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) =>
//                         _buildPopupDialog(context),
//                   );
//                 },
//                 child:
//                 (isExercise) //ถ้าเป็นไฟล์แบบฝึกหัด ให้มีเครื่องหมายคำถามที่ AppBar เหมือนเป็น Help menu
//                     ? Icon(
//                   Icons.help_outline,
//                   size: 26.0,
//                 )
//                     : Visibility(
//                   child: Icon(
//                     Icons.help_outline,
//                     size: 26.0,
//                   ),
//                   visible: false,
//                 ),
//               ),
//               PopupMenuButton(
//                 // เมนู สาม จุด
//                   onSelected: (selectedValue) {
//                     //print(selectedValue);
//                     handleClick(selectedValue, context);
//                   },
//                   itemBuilder: (BuildContext ctx) => [
//                     // PopupMenuItem(
//                     //     child: Text('ส่งเมลถึงผู้เขียน'),
//                     //     value: 'sendMyMail'),
//                     PopupMenuItem(
//                         child: Text('ให้คะแนน App นี้'), value: 'vote'),
//                     PopupMenuItem(
//                         child: Text('แชร์กับเพื่อน'), value: 'share'),
//                     PopupMenuItem(
//                         child: Text(
//                             'ส่งอีเมล ติชม เสนอแนะ หรือแจ้งข้อผิดพลาด'),
//                         value: 'sendMyMail'),
//                     PopupMenuItem(child: Text('เกี่ยวกับ'), value: 'about'),
//                   ])
//             ],
//           ),
//           body: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   //color: Colors.blue[700],
//                   color: Theme.of(context).primaryColorDark,
//                   border: Border(
//                     top: BorderSide(width: 1, color: Colors.white70),
//                   ),
//                   // color: Colors.white,
//                 ),
//                 child: Linkify(
//                   onOpen: _onOpen,
//                   textScaleFactor: 1,
//                   text: myMessage,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14.0, color: Colors.white),
//                   linkStyle:
//                   TextStyle(fontSize: 14.0, color: Colors.yellowAccent),
//                   options: LinkifyOptions(
//                       humanize:
//                       false), // ให้แสดงตัวหนังสือ https:// ด้วย ไม่งั้นจะถูกตัดออกไป
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColorDark,
//                   // color: Colors.blue[400],
//                   border: Border(
//                     top: BorderSide(width: 1, color: Colors.white70),
//                     //  bottom: BorderSide(width: 1, color: Colors.white),
//                   ),
//                 ),
//                 child: Text(
//                   "$_title",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.blue[100],
//                   border: Border(
//                     top: BorderSide(width: 1, color: Colors.white70),
//                     bottom: BorderSide(width: 1, color: Colors.black45),
//                   ),
//                 ),
//                 child: _buyStatus ==
//                     true // buyStatus เอาจาก mainMenu จาก provider ตาราง hashTable และ sharePref -- ถ้าอันใดอันหนึ่งเป็นจริง _buyStatus จะเป็นจริง
//                     ? SizedBox.shrink()
//                     : SizedBox(
//                   height: 38,
//                   width: 120,
//                   child: TextButton(
//                     child: Text(
//                       'วิธีซื้อรุ่นเต็ม',
//                       style: TextStyle(
//                         fontFamily: 'Athiti',
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.0,
//                         color: Colors.blue[900],
//                       ),
//                     ),
//                     onPressed: () {
//                       if (ActiveConnection) {
//                         // ถ้ามีอินเทอร์เน็ต
//                         //   //print('ส่งไปหน้า ให้ซื้อ PaymentScreen');
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PaymentScreen(
//                               // revenueCat
//                               key: ValueKey('uniqueKey'),
//                               isDarkMde: mode,
//                               isBuy: _buyStatus,
//                             ),
//                           ), //กำลังแก้ไข -- OK
//                         );
//                       } else {
//                         // ถ้าไม่ต่อกับอินเทอร์เน็ต ซื้อไม่ได้
//                         // show message
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text(
//                                 'ไม่มีการเชื่อมต่ออินเทอร์เน็ต',
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               //content: Text('ท่านต้องเชื่อมต่อกับอินเทอร์เน็ตก่อน นะครับ'),
//                               content: RichText(
//                                 text: const TextSpan(
//                                   text:
//                                   'ท่านต้องเชื่อมต่อกับอินเทอร์เน็ตก่อน นะครับ',
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       color: Colors.black87),
//                                   children: <TextSpan>[
//                                     TextSpan(
//                                         text:
//                                         '\n\n(กดปุ่มลูกศรออกจากหน้านี้ ต่อเชื่อมอินเทอร์เน็ต แล้วจึงกดปุ่มซื้ออีกครั้ง)',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 14)),
//                                   ],
//                                 ),
//                               ),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.of(context).pop(),
//                                   child: Text('OK'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Stack(
//                   children: [
//                     InAppWebView(
//                      // initialData: InAppWebViewInitialData(data: Uri.file(myHtmlFile).toString()
//
//                        initialUrlRequest: URLRequest(
//                       //   url: WebUri("https://www.thongjoon.com"),
//                         url: WebUri(
//                           Platform.isAndroid
//                               ? "file:///android_asset/flutter_assets/$myHtmlFile"
//                               : Uri.file(myHtmlFile).toString(),
//                         ),
//                       ),
//                       initialSettings: InAppWebViewSettings(),
//
//                       onWebViewCreated: (InAppWebViewController controller) {
//                         inAppWebViewController = controller;
//
//
//
//
//                         //   // comment out from 533 to 1113
//
//
//                         // //  javascriptChannels {
//                         //
//                         // // Register JavaScript Handlers
//
//                         inAppWebViewController?.addJavaScriptHandler(
//                           handlerName: "Toaster",
//                           // handlerName: "Toaster",
//
//                           callback: (args) {
//                             print("345 Received args from JS: $args");
//
//                             try {
//                               // Check if args is non-empty
//                               if (args.isNotEmpty) {
//                                 String message = args[0];
//                                 print("345 Message received: $message");
//
//                                 // // Display the message in a Snackbar
//                                 // ScaffoldMessenger.of(context).showSnackBar(
//                                 //   SnackBar(content: Text("Toaster says: $message")),
//                                 // );
//
//                                 // Return a valid object back to JS
//                                 return {'bar': 'bar_value', 'baz': 'baz_value'};
//                               } else {
//                                 print("345 args is empty!");
//                                 return {'error': 'No arguments provided'};
//                               }
//                             } catch (e) {
//                               print("345 Error in callback: $e");
//                               return {'error': 'Exception occurred'};
//                             }
//                           },
//                         );
//
//
//                         inAppWebViewController?.addJavaScriptHandler(
//                           handlerName: "is_IsNewClicked",
//                           // handlerName: "Toaster",
//
//                           callback: (args) async {
//                             print("345 Received args from JS - is_IsNewClicked: $args");
//
//                             try {
//                               // Check if args is non-empty
//                               if (args.isNotEmpty) {
//                                 String message = args[0];
//                                 print("345 Message received - is_IsNewClicked: $message");
//
//                                 //    String contentOfIsNewFromJs = message.trim();
//
//                                 String contentOfIsNewFromJs = message;
//
//                                 print(
//                                     "3456 checkTwice qNum id: ContentFromJs:  $contentOfIsNewFromJs ");
//                                 String contentOfIsNew;
//                                 if (contentOfIsNewFromJs.length < 1) {
//                                   // ในกรณีที่ไฟล์ html นั้น ไม่มี <div class="isNew"></div> จะเกิด error จึงต้องใส่เป็น dummy เอาไว้
//                                   //  โดยกำหนดวันที่เป็น วันพุธที่ 24 พ.ย. 2564 (1637726921) เพื่อให้เลย 90 วัน จะได้ไม่แสดงข้อความ NEW
//                                   contentOfIsNew = "id111111:date1637726921";
//                                 } else {
//                                   contentOfIsNew = contentOfIsNewFromJs.substring(
//                                       0, contentOfIsNewFromJs.length - 3);
//                                 }
//
//                                 //===============================
//                                 // ต้องเอาตัวท้าย abc ออกไปตัวนึง เพราะเกินมา
//                                 print(
//                                     "checkTwice รับมาจาก JS: contentOfIsNew: $contentOfIsNew");
//
//                                 await saveOrUpdateItemTable(
//                                     whatString: contentOfIsNew,
//                                     whatHtmlFile: widget.myExams,
//                                     context: context);
//                                 print(
//                                     "after saveOrUpdateItemTable FILE: ${widget.myExams}");
//                                 //    Future tutorial: https://www.youtube.com/watch?v=DAS0EQuM-oU&t=26s
//
//                                 String thisDateFromSQL = await getIsNewFromItemTbl(
//                                     whatFile: widget.myExams,
//                                     isNewString: contentOfIsNew);
//
//                                 //   .then((thisDateFromSQL) {
//                                 stringResult = thisDateFromSQL.substring(
//                                     0,
//                                     thisDateFromSQL.length -
//                                         3); // เอา abc ตัวสุดท้ายออกไป
//                                 // print("abcfg stringResult whatFile: $_myExams");
//                                 // print(
//                                 //     "abcfg stringResult contentOfIsNew: $contentOfIsNew");
//                                 // print("abcfg stringResult: $stringResult");
//                                 // print(
//                                 //     "abcfg stringResult date from SQL: $thisDateFromSQL");
//
//
//                                 String startID = await getStartId(
//                                     whatHtmlFile: widget
//                                         .myExams); //  ข้อที่จะให้แสดงเป็นข้อแรก
//                                 //  .then((startID) {
//                                 String newString =
//                                     stringResult + "tjk" + startID;
//                                 print(
//                                     "213 ชื่อไฟล์: ${widget.myExams} ข้อมูล stringResult+startID: $newString");
//                                 print(
//                                     "213 currMode2 before adding to newString for sending to JS: $currMode2");
//                                 newString = newString + "tjk" + currMode2;
//                                 // print("abcfg currMode inside: $currMode");
//                                 print(
//                                     "213 Flutter ส่งไป Js - is_IsNewClicked() ในตัวแปร newString ชื่อไฟล์: ${widget.myExams} ข้อมูล:  $newString");
//
//                                 String alreadyBought;
//                                 if (_buyStatus == true) {
//                                   alreadyBought = "true";
//                                 } else {
//                                   alreadyBought = "false";
//                                 }
//                                 print(
//                                     "213 is_Bought_Already before sending to JScript: $alreadyBought");
//                                 newString = newString + "tjk" + alreadyBought;
//                                 print(
//                                     "213 Flutter ส่งไป Js - is_IsNewClicked() สำหรับไฟล์: ${widget.myExams} ข้อมูลทั้งหมดสำหรับ is_IsNewClcked(): $newString");
//                                 // ส่งไป Javascript
//                                 // controller.evaluateJavascript(
//                                 //     source:
//                                 //         'is_IsNewClicked("$newString")'); // ชื่อ JS ฟังก์ชั่น("ข้อมูลที่ส่ง ในรูปตัวอักษร-string"
//                                 //  return{newString};
//
//                                 //   return {'newString': newString, 'baz': 'baz_value'};
//
//                                 // } // .then
//                                 //    );
//                                 //  }
//
//                                 //  );
//
//
//                                 //     // Display the message in a Snackbar
//                                 // ScaffoldMessenger.of(context).showSnackBar(
//                                 //   SnackBar(content: Text("Toaster says: $message")),
//                                 // );
//
//                                 // ส่งไป Javascript
//                                 return {'newString': newString, 'baz': 'baz_value'};
//                               } else {
//                                 print("345 args is empty!");
//                                 return {'error': 'No arguments provided'};
//                               }
//                             } catch (e) {
//                               print("345 Error in callback: $e");
//                               return {'error': 'Exception occurred'};
//                             }
//                           },
//                         );
//
//                         //
//                         inAppWebViewController?.addJavaScriptHandler(
//                           handlerName: "messageHandler",
//                           callback: (args) {
//                             // Handle "messageHandler" messages
//                             // รับข้อมูลมาจาก Javascript ซึ่งส่งมาโดย window.flutter_inappwebview.
//                             // callHandler('messageHandler', ...args)
//                             // อยู่ในรูปของ list
//                             // ข้อมูลที่ส่งมา คือ ข้อที่คลิกเลือกคำตอบ ส่งมาทุกข้อที่คลิก
//                             // จะใช้เอาไปแสดงผลความก้าวหน้า
//
//                             print(
//                                 "213 Js > Flutter - for messageHandler(): ชื่อไฟล์: ${widget.myExams} ค่าที่ส่งมาจาก JS -> Flutter: ${args[0]} ");
//
//                             String msgStr;
//
//                             print("arg length: ${args.length}");
//
//                            if(args.length >= 1) {
//                              print(" kxk from seq_num: $args");
//                              // ถ้าส่งมาจากไฟล์แบบฝึกหัด จะเป็น เช่น [4, 2, 0, x, z, c, t, b, l, _, q, 3, 8, x, z, c, c, c, x, 1, 1, 1, 1, 1]
//                              // จึงต้องเอามารวมกันเสียก่อน
//                              String exerciseDat = args.join('');
//                              msgStr = exerciseDat;
//                              print(" kxk msgStr from seq_num: $msgStr");
//                            }else{
//                              print(" kxk from con_full_version: $args");
//
//                              // ค่าที่รับมาจาก javaScript คือ ข้อปัจจุบัน&&จำนวนข้อทั้งหมด เช่น 11&&36 (ข้อ 11 ในจำนวนทั้งหมด  36 ข้อ)
//                              msgStr = args[0];  // ค่าที่รับมาจาก JavaScript อยู่ในรูป ตัวแปร list []
//                              print(" kxk msgStr from con_full_version: $msgStr");
//                            }
//
//                          //   msgStr = args[
//                           //  0]; // ค่าที่รับมาจาก javaScript คือ ข้อปัจจุบัน&&จำนวนข้อทั้งหมด เช่น 11&&36 (ข้อ 11 ในจำนวนทั้งหมด  36 ข้อ)
//
//                             // ส่งไป Willpopscope
//                             Provider.of<Data>(context, listen: false)
//                                 .changeString(msgStr);
// // =============== สิ้นสุดการจัดการข้อมูลที่ส่งมาจาก Javascript =====================
//
// // =============== Retrieve Data to send to Javascript via messageHandler =====================
//                             // ไปเอาข้อมูล mode
//                             String msgToSend = "$isBoughtAlready" +
//                                 "xyz" +
//                                 "$mode"; // isBoughtAlready คือ _buyStatus
//                             print(
//                                 "213 Flutter ส่งไป Js - isBuyAndMode()  ไฟล์: ${widget.myExams}  buy: $isBoughtAlready, mode: $mode, msgToSend: $msgToSend"); //
//                             //controller // ส่งไป JS
//                             // .runJavaScriptReturningResult(
//                             // 'isBuyAndMode("$msgToSend")'); // ชื่อ JS ฟังก์ชั่น("ข้อมูลที่ส่ง ในรูปตัวอักษร-string")
//
//                             // ส่งไป JS  -- inAppWebview
//                             // controller.evaluateJavascript(
//                             //     source: "isBuyAndMode('$msgToSend');");
//                             //   return {'newString': newString, 'baz': 'baz_value'};
//
//                             // return "Message : $msgToSend}";
//                             // send data to Javascript via messageHandler
//                             print("message to send to JS: $msgToSend");
//                             return {'Message': '$msgToSend', 'baz': 'baz_value'};
//
//                           },
//                         );
//
//                         inAppWebViewController?.addJavaScriptHandler(
//                           handlerName: "exerciseData",
//                           callback: (args) {
//                             // javascriptChannels  ชื่อ exerciseData
//                             // เพื่อเอาข้อมูลการทำแบบฝึกหัดไว้ในฐานข้อมูล และเอาไปบอกว่า
//                             // ครั้งที่แล้ว ทำไปถึงข้ออะไร
//                             // เมื่อกลับมาใหม่ จะได้ไปยังข้อที่ทำครั้งสุดท้าย (ถ้าทำยังไม่เสร็จ ถ้าเสร็จแล้ว จะไปเริ่มข้อ 1)
//                             print(
//                                 "213 Js > Flutter - for exerciseData ชื่อไฟล์: xxx ค่าที่ส่ง: $args ");
//                                 //"213 Js > Flutter - for exerciseData ชื่อไฟล์: xxx ค่าที่ส่ง: ${args[0]} ");
//
//                            // ค่าที่รับมาจาก javaScript คือ ชื่อหัวข้อเรื่อง ข้อปัจจุบัน และจำนวนข้อทั้งหมด คั่นด้วย xzc
//                             // เช่น normal_cndtngxzc4xzc7  คือ เรื่อง normal_cndtng ข้อปัจจุบัน คือข้อ 4 เรื่องนี้มีทั้งหมดจำนวน 7 ข้อ
//                             //ค่าที่ส่งเข้ามา เป็น list เช่น ['n', 'o', 'r', 'm', 'a', 'l', '_', 'c', 'n', 'd', 't', 'n', 'g', 'x', 'z', 'c', 3, 'x', 'z', 'c', 3, 8];
//                             // จึงต้องเอามารวมกัน เป็น String จะได้ไปทำต่อได้
//                             String exerciseDat = args.join('');
//                             print("args ข้อมูลจาก Javascript มายัง exerciseData: $exerciseDat");
//
//                             // แยกข้อมูล
//                             List<String> forDataClass =
//                                 exerciseDat.split("xzc");
//                             print("forDataClass: $forDataClass");
//
//                             int math_8_yrs_done_sofar = 0;
//                             int math_2567_done_sofar = 0;
//
//                             String nameOfMenu = forDataClass[0];
//                             String curValueOfMenu = forDataClass[1];
//                             // น่าจะต้องส่งค่า เมนูปัจจุบัน เพื่อเอาไปรวมด้วยเลย ไม่งั้นไม่เป็นปัจจุบัน
//                             getExerciseDoneFromPref(nameOfMenu, curValueOfMenu)
//                                 .then((completedTotal) {
//                               //completedTotal เป็นข้อความ ในรูป
//                               // ชื่อเมนู:ข้อที่ทำเสร็จแล้ว(คั่นด้วย colon) เช่น math_exer:15
//                               List<String> completedTotal_data =
//                                   completedTotal.split(":"); // แยกเป็น Array
//                               String thisMenuName = completedTotal_data[0];
//                               String thisCompletedTotal =
//                                   completedTotal_data[1];
//
//                               forDataClass[1] = thisCompletedTotal;
//                               print(
//                                   "menuName - forDataClass[0]: ${forDataClass[0]}");
//                               print(
//                                   "completed sofar - forDataClass[1]: ${forDataClass[1]}");
//                               print(
//                                   "Total - forDataClass[2]: ${forDataClass[2]}");
//
//                               // ปรับรูปแบบ เพื่อส่งไป willpopscpe รูปแบบให้เหมือน ที่ส่งจากไฟล์ 1_graph_chart_table...
//                               // ถ้าไม่ปรับ จะมี error เพราะมีการสั่งไปเอาข้อมูลที่คลิก แต่อันนี้ ไม่มี จึงต้องเพิ่มไป OK  แล้ว
//                               String msgForWillpopFromExerciseDat =
//                                   forDataClass[2] +
//                                       "xzctbl_q" +
//                                       forDataClass[1] +
//                                       "xzcccx11111";
//
//                               print(
//                                   "exerciseData sent to Data class for progress: $msgForWillpopFromExerciseDat");
//
//                               // ส่งไป Willpopscope
//                               Provider.of<Data>(context, listen: false)
//                                   .changeString(msgForWillpopFromExerciseDat);
//                             });
//
//                             // เก็บไว้ใน SharePreferences
//                             saveExerciseData(exerciseDat);
//
//                             // Process exercise data
//                             // String exercise = args[0]; // Example data from JS
//                             // print("Exercise data: $exercise");
//                             // return "Data processed!";
//                           },
//                         );
//
//                           inAppWebViewController?.addJavaScriptHandler(
//                           handlerName: "menuNameToFlutter",
//                           // callback: (args) {
//                           //   // Handle menu name data
//                           //   String menuName = args[0];
//
//                           //   print("Menu name received: $menuName");
//                           // },
//                           callback: (args) async{
//                             // รับข้อมูลมาจาก Javascript ซึ่งส่งมาทาง postMessage() ของ
//                             // javascriptChannels  ชื่อ menuNameToFlutter
//                             // เพื่อเอาชื่อตัวแปรของเมนูแบบฝึกหัด  และเอาไปบอกว่า
//                             // ครั้งที่แล้ว ทำไปถึงข้ออะไร
//                             // เมื่อกลับมาใหม่ จะได้ไปยังข้อที่ทำครั้งสุดท้าย (ถ้าทำยังไม่เสร็จ ถ้าเสร็จแล้ว จะไปเริ่มข้อ 1)
//                             // normal_menu fraction_menu plus_minus_menu min_max_menu multi_connection_menu
//
//                             print(
//                                 "213 Js >   ค่าที่ส่ง via menuNameToFlutter  : ${args[0]} ");
//                             String exerciseMenu_ = args[
//                                 0]; // ค่าเมนู ที่รับมาจาก javaScript คือ ชื่อหัวข้อเรื่อง
//                             // normal_menu fraction_menu plus_minus_menu min_max_menu multi_connection_menu
//                             // เปลี่ยนเป็น array เพื่อเชค
//                             // List<String> myMenuNames  = exerciseMenu.split(" ");
//                             String exerciseMenu = exerciseMenu_.trim();
//                             myMenuNames = exerciseMenu.split(",");
//                             // เอาไปตรวจดูใน sharePref ถ้าไม่มี ให้ใส่เป็น 1 คือ ยังไม่ได้ทำ
//                             print("myMenuNames.length: ${myMenuNames.length}");
//
//                             //myMenuNames = ["aaa","bbb","ccc"]; // เพิ่มเพือทดสอบ เดี๊ยวต้องเอาออก
//                             checkingTheSavedData(myMenuNames, "0")
//                                 .then((thisLastQstn) {
//                               List lastQstn_from_pref = thisLastQstn;
//                               print("lastQstn_from_pref: $lastQstn_from_pref");
//
//                               String dataToJs = lastQstn_from_pref.join(
//                                   " "); // convert list to string sperated by space
//                               print("dataToJs for menuNames:  $dataToJs");
//
//
//
//                               // Send `dataToJs` back to JavaScript
//                               inAppWebViewController?.evaluateJavascript(
//                                   source: 'getLastQstnNum("$dataToJs")'
//                               );
//
//                               return {'menuName': "$dataToJs", 'baz': 'baz_value'};
//
//
//                                 }
//
//                             );
//
//                             // ส่งไป JS
//                            // return await {'menuName': '$dataToJs', 'baz': 'baz_value'};
//                           },
//                         );
//
//
//
//
//                         inAppWebViewController?.addJavaScriptHandler(
//                           handlerName: "get_isNewClicked",
//                           callback: (args) {
//                             print("3456 Received args from JS: $args");
//
//
//                             try {
//                               // Check if args is non-empty
//                               if (args.isNotEmpty) {
//                                 String message = args[0];
//                                 print("3456 Message received: $message");
//
//                                 //    String contentOfIsNewFromJs = message.trim();
//
//                                 String contentOfIsNewFromJs = message;
//
//                                 print(
//                                     "3456 checkTwice qNum id: ContentFromJs:  $contentOfIsNewFromJs ");
//                                 String contentOfIsNew;
//                                 if (contentOfIsNewFromJs.length < 1) {
//                                   // ในกรณีที่ไฟล์ html นั้น ไม่มี <div class="isNew"></div> จะเกิด error จึงต้องใส่เป็น dummy เอาไว้
//                                   //  โดยกำหนดวันที่เป็น วันพุธที่ 24 พ.ย. 2564 (1637726921) เพื่อให้เลย 90 วัน จะได้ไม่แสดงข้อความ NEW
//                                   contentOfIsNew = "id111111:date1637726921";
//                                 } else {
//                                   contentOfIsNew = contentOfIsNewFromJs.substring(
//                                       0, contentOfIsNewFromJs.length - 3);
//                                 }
//
//                                 // ต้องเอาตัวท้าย abc ออกไปตัวนึง เพราะเกินมา
//                                 print(
//                                     "checkTwice รับมาจาก JS: contentOfIsNew: $contentOfIsNew");
//
//                                 saveOrUpdateItemTable(
//                                     whatString: contentOfIsNew,
//                                     whatHtmlFile: widget.myExams,
//                                     context: context);
//                                 print(
//                                     "after saveOrUpdateItemTable FILE: ${widget.myExams}");
//                                 //    Future tutorial: https://www.youtube.com/watch?v=DAS0EQuM-oU&t=26s
//
//                                 getIsNewFromItemTbl(
//                                     whatFile: widget.myExams,
//                                     isNewString: contentOfIsNew)
//                                     .then((thisDateFromSQL) {
//                                   stringResult = thisDateFromSQL.substring(
//                                       0,
//                                       thisDateFromSQL.length -
//                                           3); // เอา abc ตัวสุดท้ายออกไป
//                                   // print("abcfg stringResult whatFile: $_myExams");
//                                   // print(
//                                   //     "abcfg stringResult contentOfIsNew: $contentOfIsNew");
//                                   // print("abcfg stringResult: $stringResult");
//                                   // print(
//                                   //     "abcfg stringResult date from SQL: $thisDateFromSQL");
//
//
//                                   getStartId(
//                                       whatHtmlFile: widget
//                                           .myExams) //  ข้อที่จะให้แสดงเป็นข้อแรก
//                                       .then((startID) {
//                                     String newString =
//                                         stringResult + "tjk" + startID;
//                                     print(
//                                         "213 ชื่อไฟล์: ${widget.myExams} ข้อมูล stringResult+startID: $newString");
//                                     print(
//                                         "213 currMode2 before adding to newString for sending to JS: $currMode2");
//                                     newString = newString + "tjk" + currMode2;
//                                     // print("abcfg currMode inside: $currMode");
//                                     print(
//                                         "213 Flutter ส่งไป Js - is_IsNewClicked() ในตัวแปร newString ชื่อไฟล์: ${widget.myExams} ข้อมูล:  $newString");
//
//                                     String alreadyBought;
//                                     if (_buyStatus == true) {
//                                       alreadyBought = "true";
//                                     } else {
//                                       alreadyBought = "false";
//                                     }
//                                     print(
//                                         "213 is_Bought_Already before sending to JScript: $alreadyBought");
//                                     newString = newString + "tjk" + alreadyBought;
//                                     print(
//                                         "213 Flutter ส่งไป Js - is_IsNewClicked() สำหรับไฟล์: ${widget.myExams} ข้อมูลทั้งหมดสำหรับ is_IsNewClcked(): $newString");
//                                     // ส่งไป Javascript
//                                     // controller.evaluateJavascript(
//                                     //     source:
//                                     //         'is_IsNewClicked("$newString")'); // ชื่อ JS ฟังก์ชั่น("ข้อมูลที่ส่ง ในรูปตัวอักษร-string"
//                                     //  return{newString};
//                                     return {'newString': '$newString', 'baz': 'baz_value'};
//
//                                   });
//                                 });
//
//
//
//
//
//
//                                 //
//                                 // // Display the message in a Snackbar
//                                 // ScaffoldMessenger.of(context).showSnackBar(
//                                 //   SnackBar(content: Text("Toaster says: $message")),
//                                 // );
//
//                                 // Return a valid object back to JS
//                                 //   return {'bar': 'bar_value', 'baz': 'baz_value'};
//                                 //  return{newString};
//                               } else {
//                                 print("345 args is empty!");
//                                 return {'error': 'No arguments provided'};
//                               }
//                             } catch (e) {
//                               print("345 Error in callback: $e");
//                               return {'error': 'Exception occurred'};
//                             }
//                           },
//                         );
//
//
//                       },   // end of comment out from 451 to 1121
//
//
//                       onProgressChanged:
//                           (InAppWebViewController controller, int progress) {
//                         if (_progress >= 1.0) {
//                           print("345 inappWebView finished loading...");
//                         }
//                         setState(() {
//                           _progress = progress / 100;
//                         });
//                       },
//                     ),
//                     if (_progress < 1.0)
//                       LinearProgressIndicator(
//                         value: _progress,
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//
//     // Ensure WebView controller is cleaned up
//     // if (inAppWebViewController != null) {
//     //   debugPrint("Disposing inAppWebViewController in htmlPageView_inappWebView...");
//     //   InAppWebViewController.clearAllCache();
//     //   inAppWebViewController = null;
//     // }
//     super.dispose();
//
//   }
//
//   void updateClick_in_ItemTable(
//       BuildContext context, String whatFile, String whatID) async {
//     print("before updateClick_in_ItemTable File Name: $whatFile, ID: $whatID");
// //  BuildContext context, String whatFileName, int whatDate) async {
//     final dbClient = await SqliteDB().db;
//     var res = await dbClient?.rawQuery('''
//     UPDATE itemTable
//     SET isClicked = ?,
//     isNew = ?
//     WHERE file_name = ? AND item_id = ?
//     ''', ['true', '0', '$whatFile', '$whatID']);
//   }
//
// //   void checkIsNew({String? whatFile, int? allQstnItem}) async {
// //     final dbClient = await SqliteDB().db;
// //     int? count = Sqflite.firstIntValue(await dbClient!.rawQuery(
// //         'SELECT COUNT (*) FROM itemTable WHERE file_name = ? AND isNew = ?',
// //         ["$whatFile", "1"]));
// //     print("count html: $count  fileName: $whatFile");
// //     if (count! > 0) {
// //       if (count < allQstnItem!) {
// // //   set isNew = 1
// //         var res = await dbClient.rawQuery('''
// //     UPDATE OcscTjkTable
// //     SET isNew = ?
// //     WHERE file_name = ?
// //     ''', ['1', '$whatFile']);
// //       } else {
// // //   set isNew = 2
// //         var res = await dbClient.rawQuery('''
// //     UPDATE OcscTjkTable
// //     SET isNew = ?
// //     WHERE file_name = ?
// //     ''', ['2', '$whatFile']);
// //       }
// //     } else {
// // // ถ้า count น้อยกว่าหรือเท่ากับ 0 ปรับให้หน้าเมนู ไม่่มีจุดแดง isNew = 0  -- OK ใช้ได้แล้ว ลบจุดแดงหน้าเมนู
// //       var res = await dbClient.rawQuery('''
// //     UPDATE OcscTjkTable
// //     SET isNew = ?
// //     WHERE file_name = ?
// //     ''', ['0', '$whatFile']);
// //     }
// //   }
//
//   Future<void> clearSharedDrawingData() async {
//     debugPrint("try to clear sharedDrawing");
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove("savedDrawing");
//   }
//
//   Future<void> _onOpen(LinkableElement link) async {
// // สำหรับ link ในข้อความ
//     Uri thisLink = Uri.parse(link.url); // แปลง LinkableElement เป็น Uri
//     if (await canLaunchUrl(thisLink)) {
//       await launchUrl(thisLink);
//     } else {
//       throw 'Could not launch $link';
//     }
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
//     print("ActiveConnection: $ActiveConnection");
//   }
//
//   void _showDrawingWindow(BuildContext context) {
//     Navigator.of(context).push(
//       PageRouteBuilder(
//         opaque: false,
//         pageBuilder: (_, __, ___) => DrawingDialog(),
//       ),
//     );
//   }
//
//   Future<String> getExerciseDoneFromPref(
//       String menuName, String menuValue) async {
//     print(" in getExerciseDoneFromPref");
//     int math2567 = 0;
//     int mat_8_yrs = 0;
//     int law = 0;
//     int others = 0;
//
//     int completedSofar = 0;
//     int completedSofar_2567 = 0;
//     int completedSofar_8yrs = 0;
//     int completedSofar_law = 0;
//     int completedSofar_others = 0;
//
//     List mNames_2567 = [];
//     List mNames_8yrs = [];
//     List mNames_law = [];
//
//     String thisMenuName = menuName;
//     String thisMenuCurrValue = menuValue;
//
//     final prefs = await SharedPreferences.getInstance();
//     final keys = prefs.getKeys();
//
//     for (var key in keys) {
//       if (key.contains('_exer')) {
//         final value = prefs.getString(key);
//         if (value != null) {
// // =================
//           if (key.contains('_2')) {
//             // เมนู คณิต 2567 จับเวลา
//             math2567 += 1;
//             mNames_2567.add(key + ":" + value + " ");
//
//             if (key == thisMenuName) {
// // completedSofar = completedSofar - int.parse(value); // หักของเก่าออก เพื่อเอาของใหม่เติม
// // // ไม่งั้นจะเพิ่มมากเกินจริง เพราะทำแต่ละข้อ จะมาเพิ่มที่นี่
// // if(completedSofar < 0){completedSofar=0;}
//               completedSofar_2567 += int.parse(thisMenuCurrValue);
//             } else {
//               completedSofar_2567 += int.parse(value);
//             }
// // Add other lines of code here for this case if needed
//           } else if (key.contains('math_exer')) {
//             // เมนู คณิต 8 ปี จับเวลา
//             mat_8_yrs += 1;
//             mNames_8yrs.add(key + ":" + value + " ");
//             if (key == thisMenuName) {
//               completedSofar_8yrs += int.parse(thisMenuCurrValue);
//             } else {
//               completedSofar_8yrs += int.parse(value);
//             }
// // Add other lines of code here for this case if needed
//           } else if (key.contains('law_exer')) {
//             // เมนู กฎหมายจับเวลา
//             law += 1;
//             mNames_law.add(key + ":" + value + " ");
//             if (key == thisMenuName) {
//               completedSofar_law += int.parse(thisMenuCurrValue);
//             } else {
//               completedSofar_law += int.parse(value);
//             }
// // Add other lines of code here for this case if needed
//           } else {
//             // สำหรับเมนูเดียว ส่งเข้ามาเท่าไร คืนออกไป
//             completedSofar_others += int.parse(thisMenuCurrValue);
//             others += 1;
//           }
//         } // end of  if (value != null)
//       } // end of    if (key.contains('_exer'))
//     }
//
//     if (thisMenuName.contains("_2")) {
//       // สำหรับเมนู ข้อสอบเสมือนจริง คณิต 2567
//       completedSofar = completedSofar_2567;
//     } else if (thisMenuName.contains("math_exer")) {
//       // สำหรับ ข้อสอบเสมือนจริงคณิต 8 ปี
//       completedSofar = completedSofar_8yrs;
//     } else if (thisMenuName.contains("law_exer")) {
//       // สำหรับ ข้อสอบเสมือนจริง กฎหมาย
//       completedSofar = completedSofar_law;
//     } else {
//       // สำหรับที่ไม่มีเมนูย่อย
//       completedSofar = completedSofar_others;
//     }
//
// //   String result = "exer:"+sumWithout2.toString()+"-xyz-"+"exer_2:"+sumWith2.toString();
//     String result = thisMenuName + ":" + completedSofar.toString();
//     print("result from sharePref: $result");
//     print("completedSofar: $completedSofar");
//
//     print(
//         "math2567: $completedSofar_2567\n mat_8_yrs: $completedSofar_8yrs\n law: $completedSofar_law\n others: $completedSofar_others");
//     print("menuNames: $mNames_2567\n$mNames_8yrs\n$mNames_law");
//     return result;
//
// //  setState(() {});
//   }
//
// //เก็บข้อมูล ซึ่งส่งมาจาก Javascript
//   Future saveExerciseData(exDat) async {
// //ค่าที่ส่ง เช่น : normal_cndtngxzc3xzc7
//     var exDatList = exDat.split(
//         'xzc'); // แยกที่ส่งมา เป็น list ตัวแรก-ชื่อ ตัวสอง-ข้อปัจจุบัน ตัวที่สาม-จำนวนข้อทั้งหมด
//     String thisName = exDatList[0];
//     String thisValue =
//     exDatList[1]; // เอาเฉพาะเลขข้อไปเก็บ ใน sharePref จำนวนข้อ ไม่ใช้
//     exerciseData = await SharedPreferences.getInstance();
//     exerciseData.setString(thisName, thisValue);
//   }
//
//   Future<List> checkingTheSavedData(
//       List key_to_check, String initial_value) async {
//     // ตรงนี้ ต้องใส่ async ด้วย ไม่งั้น ตรงวน for loop ไม่มีข้อมูลออกมานอก loop -- เสียเวลาอยู่หลายวัน
//
//     List thisDat = [];
//     print("thisDat: $thisDat");
//
//     List myMenuNames = key_to_check;
//
//     for (var i = 0; i < myMenuNames.length; i++) {
//       await isExerciseKeyExist(myMenuNames[i]).then((isExist) async {
//         if (!isExist) {
//           // ถ้าไม่มี กำหนดให้เป็น ข้อ 1
//           SharedPreferences pref = await SharedPreferences.getInstance();
//           pref.setString(myMenuNames[i], initial_value);
//           thisDat.add(myMenuNames[i] + "xyz" + initial_value);
//           // thisDat += myMenuNames[i] + "xyz" + initial_value;
//           print("thisDat inside for loop (not exist): ${thisDat.toString()}");
//         } else {
//           SharedPreferences pref = await SharedPreferences.getInstance();
//           String? thisValue = pref.getString(myMenuNames[i]);
//           thisDat.add(myMenuNames[i] + "xyz" + thisValue);
//           //   thisDat += myMenuNames[i] + "xyz" + thisValue;
//           print("thisDat inside for loop (do exist): ${thisDat.toString()}");
//         }
//       });
//     }
//     print("thisDat before return: ${thisDat.toString()}");
//     return thisDat;
//   }
//
//   Future<bool> isExerciseKeyExist(String keyToCheck) async {
//     // เชคว่า มีข้อมูลการทำแบบฝึกหัดหรือยัง ถ้ายัง ใส่เป็นเริ่มที่ 1
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.containsKey(keyToCheck)) {
//       // if key exists
//       print("$keyToCheck found in sharePref");
//       return true;
//     } else {
//       print("$keyToCheck NOT found in sharePref");
//       return false;
//     }
//   }
//
//   bool saveOrUpdateItemTable(
//       {String? whatString, String? whatHtmlFile, context}) {
//     String? contentOfIsNew = whatString;
//     String? _myExams = whatHtmlFile;
//
//     // สำหรับเก็บค่า true false ของ id ทุกตัว ที่ส่งไปหาข้อมูลในตาราง itemTable จะส่งกลับไปเป็นชุด
//     List<String>? jsMassage = contentOfIsNew?.split("abc"); // แปลงเป็น List
//
//     for (int i = 0; i < (jsMassage!.length); i++) {
//       String thisIdAndDate =
//       jsMassage[i]; // ได้ id และ วันที่ ของ isNew แต่ละตัว
//       const start = "id";
//       const end = ":date";
//       final startIndex = thisIdAndDate.indexOf(start);
//       final endIndex = thisIdAndDate.indexOf(end, startIndex + start.length);
//       final startIndex2 = thisIdAndDate.indexOf(end);
//       // print(
//       //     "qNum id: str: $thisIdAndDate, startIndex: $startIndex, endIndex:$endIndex, startIndex2: $startIndex2");
//       String qNumId =
//       thisIdAndDate.substring(startIndex + start.length, endIndex);
//       String qNumDate = thisIdAndDate.substring(startIndex2 + end.length);
//
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         // เพิ่มเข้ามา เพื่อส่ง contex ไปยังฟังก์ชัน addOrUpdate -- ยังไม่ได้เชค พอแค่นี้ก่อน
//
//         // if (_key.currentContext != null) {
//         //   myFunction(_key.currentContext!); // Pass the context to your function
//         // }
//
//         addOrUpdate(
//             whatFile: _myExams!,
//             whatID: qNumId,
//             whatDate: qNumDate,
//             context as BuildContext); // Pass the context to your function
//       });
//     } // end of for
//     return true;
//   }
//
//   void addOrUpdate(BuildContext context,
//       {required String whatFile,
//         required String whatID,
//         required String whatDate}) async {
//     print(
//         " 345  ----- enter addOrUpdate ------ Fn: $whatFile whatID: $whatID whatDate $whatDate");
//     final dbClient = await SqliteDB().db;
//     List<Map> list = await dbClient!.rawQuery(
//         'SELECT * FROM itemTable WHERE file_name = ? AND item_id = ?',
//         ["$whatFile", "$whatID"]);
//
//     int count = list.length; // นับจำนวนสมาชิกของ List ถ้าไม่มี จะเป็น 0
//     print(
//         " 345  ----- inside addOrUpdate ------ check Fn: $whatFile whatID: $whatID in itemTable  count: $count");
//     if (await count >= 1) {
//       String dateFromSQL = list.first["item_date"];
//       int dateFromSQLite = int.parse(dateFromSQL);
//       int fileDate = int.parse(whatDate);
//
//       if (fileDate > dateFromSQLite) {
//             () => updateItemTable(context, whatFile, whatID,
//             whatDate); // ถ้า isNew ในตาราง OcscTjkTable เท่ากับ 0 จะไม่มีจุดแดง หน้าเมนู  whatDate คือวันที่จากไฟล์
//
//         print(
//             " 345  ----- inside addOrUpdate ------ FOUND AND NEWER: Fn: $whatFile whatID: $whatID count: $count");
//         //
//       }
//     } else {
//       print(
//           " 345  ----- inside addOrUpdate ------ NOT FOUND Fn: $whatFile whatID: $whatID in itemTable  count: $count");
//           () => addNewRecordToItemTable(context, whatFile, whatID, whatDate);
//       print(
//           " 345  ----- inside addOrUpdate ------ finish ADD NEW Fn: $whatFile whatID: $whatID in itemTable");
//     } //  end of if (count >= 1)
//     print(" 345  ----- leaving addOrUpdate --------------- ");
//   }
//
//   updateItemTable(BuildContext context, String whatFile, String whatID,
//       String whatDate) async {
//     print("before updateItemTable: File $whatFile, ID $whatID, Date $whatDate");
//     //  BuildContext context, String whatFileName, int whatDate) async {
//     final dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawQuery('''
//     UPDATE itemTable
//     SET item_date = ?, isClicked = ?, isNew = ?
//     WHERE file_name = ? AND item_id = ?
//     ''', ['$whatDate', 'false', '1', '$whatFile', '$whatID']); // ดูอีกที
//   }
//
//   void addNewRecordToItemTable(BuildContext context, String whatFile,
//       String whatID, String whatDate) async {
//     final dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawInsert(
//         'INSERT INTO "itemTable" (file_name,item_id,item_date,isClicked,isNew) VALUES(?,?,?,?,?)', [
//       '$whatFile',
//       '$whatID',
//       '$whatDate',
//       'false',
//       '0'
//     ]); // item_id กับ item_date ใน html  คือ อย่างเดียวกัน เพราะมันคือ เนื้อหาของ isNew เช่น <div class="isNew">1608958161</div>
//   }
//
// // for exercise
//
//   String? getDataFromPref(List<String> myMenuNames) {
//     for (var i = 0; i < myMenuNames.length; i++) {
//       String thisQstnValue = "";
//       gettingTheSavedData(myMenuNames[i]).then((thisQstnNum) {
//         print("thisQstnNum: $thisQstnNum");
//         String thisNum = thisQstnNum;
//
//         thisQstnValue += thisNum + " ";
//         //  thisQstnValue.add(thisNum);
//
//         print("thisQstnValue inside for loop: $thisQstnValue");
//         //  print("thisQstnValue: ${thisQstnValue.toString()}");
//       });
//
//       print("thisQstnValue outside for loop: $thisQstnValue");
//       //print("thisQstnValue outside for:  ${thisQstnValue.toString()}");
//
//       return thisQstnValue;
//     }
//     return null;
//   }
//
//   Future<String> gettingTheSavedData(String key_to_check) async {
//     print("key to check in gettingTheSavedData: $key_to_check");
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String? thisVal = pref.getString(key_to_check);
//     String lastQstnDat = key_to_check + "xyz" + thisVal!;
//     print("thisVal: $lastQstnDat");
//     return lastQstnDat;
//   }
//
//   Future<String> getIsNewFromItemTbl(
//       // Future<ItemModel> getIsNewFromItemTbl(
//           {required String whatFile,
//         required String isNewString}) async {
//     // print(
//     //     " 345 ----- enter getIsNewFromItemTbl --------- whatFile: $whatFile isNewString: $isNewString ");
//     List<String> jsMassage = isNewString.split("abc");
//     String trueOrFalse = "";
//     //  print("messageXX isNewString.length: ${isNewString.length}");
//     // print("messageXX result.first: $whatFile $whatID");
//     for (int i = 0; i < (jsMassage.length); i++) {
//       // print(
//       //     " 345 ----- enter loop in getIsNewFromItemTbl --------- loop: $i of ${jsMassage.length}");
//       String thisIdAndDate = jsMassage[i];
//       //   print("isNewFromTbl thisIdAndDate: $thisIdAndDate");
//       const start = "id";
//       const end = ":date";
//       final startIndex = thisIdAndDate.indexOf(start);
//       final endIndex = thisIdAndDate.indexOf(end, startIndex + start.length);
//       final startIndex2 = thisIdAndDate.indexOf(end);
//       // print(
//       //     "qNum id: str: $thisIdAndDate, startIndex: $startIndex, endIndex:$endIndex, startIndex2: $startIndex2");
//       String qNumId =
//       thisIdAndDate.substring(startIndex + start.length, endIndex);
//       String qNumDate = thisIdAndDate.substring(startIndex2 + end.length);
//       print("ส่งไปหา ในTable i: $i id: $qNumId date: $qNumDate fn: $whatFile");
//       // print(
//       //     " 345 ----- find id and date in getIsNewFromItemTbl --------- i: $i id: $qNumId date: $qNumDate fn: $whatFile");
//
//       final dbClient = await SqliteDB().db;
//       var result = await dbClient?.rawQuery(
//           'SELECT * FROM itemTable WHERE file_name = ? AND item_id = ?',
//           ["$whatFile", "$qNumId"]);
//       // print(
//       //     "messageXX result.firstxx: ${result.first}"); // ผลที่ได้ เช่น {isClicked: false}
//       //    print("messageXX result.firstxx: ${result.first["isClicked"]}");
//       // return result.isNotEmpty ? ItemModel.fromMap(result.first) : null;
//       if (result!.isNotEmpty) {
//         print("ส่งไปหา ในTable เจอ TF: $trueOrFalse จ$qNumId $whatFile");
//         // print(
//         //     " 345 ----- FOUND isClicked in getIsNewFromItemTbl --------- i: $i id: $qNumId date: $qNumDate  isNew: ${result.first["isNew"]} fn: $whatFile");
//         trueOrFalse = trueOrFalse +
//             qNumId +
//             // "sss" +  // ตรงนี้ เปลี่ยน ไม่ส่งวันที่ แต่ส่ง isNew ถ้า 1 = ใหม่ 0=เหมือนเดิม
//             // (result.first["item_date"]) +
//             "sss" +
//             (result.first["isNew"].toString()) +
//             "sss" +
//             (result.first["isClicked"].toString()) +
//             "abc"; // ใช้ sss คั่นระหว่าง id และ วันที่ และใช้ abc คั่นแต่ละตัว ส่วน ["isClicked"] คือ ชื่อคอลัมน์ ใน ตาราง itemTable
//         // print(
//         //     " 345 ----- find id and date in getIsNewFromItemTbl --------- i: trueOrFalse: $trueOrFalse");
//       } else {
//         // print(
//         //     " 345 ----- NOT FOUND isClicked in getIsNewFromItemTbl --------- i: $i id: $qNumId date: $qNumDate fn: $whatFile");
//         trueOrFalse += qNumId +
//             "sss" +
//             qNumDate +
//             "ssstrueabc"; // ถ้าไม่เจอ ให้เป็น คลิกแล้ว จะได้ไม่ต้องแสดงคำว่า "ใหม่" หลังเลขข้อ
//         print("ส่งไปหา ในTable ไม่เจอ TF: $trueOrFalse $qNumId $whatFile");
//         // print(
//         //     " 345 ----- find id and date in getIsNewFromItemTbl --------- i: ไม่เจอ  trueOrFalse: $trueOrFalse");
//       }
//       // print(
//       //     " 345 ----- RESULT in getIsNewFromItemTbl --------- id: $qNumId ผลลัพธ์: $trueOrFalse");
//     }
//     // print(
//     //     " 345 ----- FINAL RESULT in getIsNewFromItemTbl --------ผลลัพธ์ทั้งหมด: $trueOrFalse");
//     // print(" 345 ----- exit getIsNewFromItemTbl ----");
// // จบการหา isNew แต่ละข้อที่ส่งมา ต่อไป หา โหมด มืด-สว่าง, ซื้อหรือยัง, ข้อแรกที่จะเริ่มใหม่ โดยหาจากใน ฐานข้อมูล
//     //   getStartId(whatHtmlFile: whatFile);
//
//     return trueOrFalse;
//   }
//
//   Future<String> getStartId({String? whatHtmlFile}) async {
//     String itemID = "top";
//     //   void getWhereToStart({String whatFileName}) async {
//     final dbClient = await SqliteDB().db;
//     var res = await dbClient!.rawQuery('''
//     SELECT open_last FROM OcscTjkTable
//     WHERE file_name = ?
//     ''', ['$whatHtmlFile']);
//     // print("whereToStart in future2: ${res[0]['open_last']}");
//     // print("whereToStart in future3: $whatFileName");
//     // print("whereToStart in future4: ${ExamModel.fromMap(res.first)}");
//     //  _pageController = PageController(initialPage: res[0]['open_last']);
//     if (res != null) {
//       itemID = res.first["open_last"] as String;
//     }
//     print("startAtID inside getStartId: $itemID FILE: $whatHtmlFile");
//     return itemID;
//   }
//
//   Future<String?> getPreviousQNum() async {
//     final thisPref = await SharedPreferences.getInstance();
//     print('aaabc Retrieving previousQNum: ${thisPref.getString('previousQNum')}');
//     return thisPref.getString('previousQNum');
//   }
//
//   Future<void> savePreviousQNum(String qNum) async {
//     print('aaabc Saving currNum as previousQNum: $qNum');
//     final thisPref = await SharedPreferences.getInstance();
//     await thisPref.setString('previousQNum', qNum);
//   }
//
//
// }
//
//
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
//
//
// Future<void> handleClick(String value, BuildContext context) async {
//   switch (value) {
//     case 'sendMyMail':
//       final Uri params = Uri(
//         scheme: 'mailto',
//         path: 'thongjoon@gmail.com',
//         query:
//         'subject=หัวข้อเรื่อง (โปรดระบุ)&body=สวัสดีครับ/ค่ะ', //add subject and body here
//       );
//
//       var url = params;
//       if (canLaunchUrl(url) != null) {
//         await launchUrl(url);
//       } else {
//         throw 'Could not launch $url';
//       }
//       break;
//     case 'vote':
//       if (Platform.isAndroid) {
//         Utils.openLink(
//             url:
//             'https://play.google.com/store/apps/details?id=com.thongjoon.ocsc_exam_prep');
//       } else if (Platform.isIOS) {
// // iOS-specific code
//         Utils.openLink(
//             url: 'https://apps.apple.com/app/เตร-ยมสอบ-กพ-ภาค-ก/id1622156979');
//       }
//
//       break;
//     case 'share':
//       Share.share(
//           "แนะนำ แอพเตรียมสอบ กพ ใช้ได้ทั้ง Android และ iPhone ดาวโหลดที่ Play Store และ App Store");
//       break;
//     case 'about':
//       openAboutDialog(context);
//       break;
//   }
// }
//
// void openAboutDialog(BuildContext context) {
//   Navigator.of(context).push(new MaterialPageRoute<Null>(
//       builder: (BuildContext context) {
//         return new aboutDialog();
//       },
//       fullscreenDialog: true));
// }
//
// Widget _buildPopupDialog(BuildContext context) {
//   return new AlertDialog(
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//     title: Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(12.0),
//           topLeft: Radius.circular(12.0),
//         ),
//         color: Colors.teal,
//       ),
//       child: Text(
//         'วิธีใช้',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//             fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
//       ),
//     ),
//     titlePadding: const EdgeInsets.all(0),
// //title: const Text('วิธีใช้'),
//     content: new Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text("ปัดซ้าย  เพื่อไปข้อต่อไป"),
//           ],
//         ),
//         SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text("ปัดขวา  เพื่อย้อนกลับ "),
//           ],
//         ),
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
//           TextStyle(fontSize: 14.0, color: Theme.of(context).primaryColor),
//         ),
//       ),
//     ],
//   );
// } //
//
// void updateOcscTjkTbl_html(
//     {required String fileName,
//       required String whereToStart,
//       required String iconName}) async {
// // ปรับ isNew ให้เป็น 0 ด้วย คือเอาจุดแดงในหน้าเมนูออกไป เพราะเข้ามาแล้ว จึงไม่ใหม่
// // isNew ยังปรับไม่ได้ เพราะต้องไปนับว่า ข้อนี้ที่เป็นข้อใหม่ ถูกคลิกหมดหรือยัง
//
//   final dbClient = await SqliteDB().db;
//   var res = await dbClient?.rawQuery('''
//     UPDATE OcscTjkTable
//     SET progress_pic_name = ?, open_last = ?
//     WHERE file_name = ?
//     ''', ['$iconName', '$whereToStart', '$fileName']);
// }
//
