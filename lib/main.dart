import 'package:ocsc_exam_prep/database_manager.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ocsc_exam_prep/sharePreferencesManager.dart';
import 'package:ocsc_exam_prep/src/constant.dart';
import 'package:ocsc_exam_prep/store_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/src/widgets/visibility.dart' as flutterVisibility; // สำหรับซ่อน ชวนให้โหวต 5 ดาว

import 'package:ocsc_exam_prep/theme.dart';
import 'package:ocsc_exam_prep/menu_data.dart'; // Added import

import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/store.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProviderModel.dart';
import 'curriculum.dart';

import 'mainMenu.dart';
import 'sqlite_db.dart';
import 'dart:math'; // สำหรับหา random number เพื่อแสดง ขอกำลังใจ 5 ดาว
import 'package:ocsc_exam_prep/googleSheetsAPI.dart';

import'package:ocsc_exam_prep/app_utils.dart';

import 'package:connectivity_plus/connectivity_plus.dart'; // สำหรับเชคว่าต่ออินเทอร์เน็ตหรือเปล่า

const countDown_global = "สอบ ก.พ. e-Exam รอบที่ 6 _X_ วันที่ 26 เม.ย. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-26 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 7 _X_ วันที่ 27 เม.ย. 67 เวลา 09.00 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-27 09:00:00xyzสอบ ก.พ. e-Exam รอบที่ 8 _X_ วันที่ 27 เม.ย. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-27 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 9 _X_ วันที่ 28 เม.ย. 67 เวลา 09.00 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-28 09:00:00xyzสอบ ก.พ. e-Exam รอบที่ 10 _X_ วันที่ 28 เม.ย. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-28 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 11 _X_ วันที่ 24 พ.ค. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-24 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 12 _X_ วันที่ 25 พ.ค. 67 เวลา 09.00 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-25 09:00:00xyzสอบ ก.พ. e-Exam รอบที่ 13 _X_ วันที่ 25 พ.ค. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-25 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 14 _X_ วันที่ 26 พ.ค. 67 เวลา 09.00 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-26 09:00:00xyzสอบ ก.พ. e-Exam รอบที่ 15 _X_ วันที่ 26 พ.ค. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-26 14:30:00";

// Gives the option to override in tests.
class IAPConnection {
  static InAppPurchase? _instance;

  static set instance(InAppPurchase value) {
    _instance = value;
  }

  static InAppPurchase get instance {
    _instance ??= InAppPurchase.instance;
    debugPrint("_instance in main.dart: $_instance");
    return _instance!;
  }

}



Future main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Save the install date if not already saved
  await AppUtils.saveFirstRunDate();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);  // for Edge-to-edge SDK 35

  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }


  // Initialize SharedPreferencesManager once in your app, preferably at the beginning เพื่อให้ใช้ sharePref ตัวเดียวกัน
  await SharedPreferencesManager().initialize();

  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    // Run the app passing --dart-define=AMAZON=true
    const useAmazon = bool.fromEnvironment("amazon");
    StoreConfig(
      store: useAmazon ? Store.amazon : Store.playStore,
      apiKey: useAmazon ? amazonApiKey : googleApiKey,
    );
    debugPrint("googleApiKey: $googleApiKey");
  }

  WidgetsFlutterBinding.ensureInitialized();

  // เชคว่า configure แล้วหรือยัง
  // Check if purchase has already been configured
  bool purchasesConfigured = await Purchases.isConfigured;
  debugPrint("purchasesConfigured already: $purchasesConfigured");
  // If purchase has not been configured, then call _configureSDK
  if (!purchasesConfigured) {
    await _configureSDK();
  }

  runApp(
    const MyApp(),
  );
} // end of void main()


Future<void> _configureSDK() async {
  // Enable debug logs before calling `configure`.
  await Purchases.setLogLevel(LogLevel.debug);

  /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
  PurchasesConfiguration configuration;
  if (StoreConfig.isForAmazonAppstore()) { // update เป็น รุ่น 8 ของ Revenuecat
    configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
  } else {
    configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
  }
  await Purchases.configure(configuration);
} // end of _configureSDK()  -- revenueCat


// บางที มีเมนูซ้ำกัน 3 ครั้ง รูปหน้า ก็ไม่มา *** อย่าลืมแก้  ******* แก้แล้ว เพิ่ม unique ตอนสร้างตาราง
class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {  // WidgetsBindingObserver เพื่อว่า จะได้ลบข้อมูลในกระดาษทด ตอน exit โปรแกรม

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  var _prefs;
  late Image beachImage;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late Data _data;

  // สำหรับ แสดง dialog ตอนเปิดใช้งาน ตรงนี้เป็นส่วนให้ผู้ใช้ปิดไม่ให้แสดงอีก 5 วัน
  //ถ้าต้องการเปลี่ยนจำนวนวัน ให้ค้นหาว่า Check if 5 days have passed since the last open
  bool isDialogHidingExpired = false;  // กำหนดให้เป็น false เลย ไม่งั้น มีปัญหา
  //เกี่ยวกับ lateInitializationError เพราะมัวไปเอาจาก sharePref ยังไม่ทันเสร็จ
  bool? isAlertboxOpened;
  late Future<String?> _countDownMsg;  // สำหรับ นับถอยหลังวันสอบ หน้าเมนูหลัก

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    isAlertboxOpened = false; // preventing welcome dialog to show multiple times
    _prefs = SharedPreferences.getInstance();

    getLastDialogOpenTime();

    beachImage = Image.asset(
        "assets/images/beach04.png"); // เพื่อจะ preload รูปเข้ามาก่อน


    listPdfFiles();  // to check only
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(beachImage.image, context);
  }

  @override
  void dispose() {
    clearDrawingOnExit(); // ลบข้อมูลในกระดาษทด Clear drawing on app exit
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void clearDrawingOnExit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('savedDrawing');
  }


  @override
  Widget build(BuildContext context) {
    createHashTableIfNotExist();
    createOcscTjkTableIfNotExist();
    createItemTableIfNotExist();
    deleteOrphantRecords();
    setDefaultValueForWelcomDialog();
    return ChangeNotifierProvider<Data>(

      // สำหรับรับค่ามาจาก Javascript และส่ง Willpopscope
      create: (_) => Data(),
      child: ChangeNotifierProvider(
        // สำหรับ theme
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
          builder: (context, notifier, child) {
            debugPrint("notifier.darkTheme: ${notifier.darkTheme}");
            debugPrint("notifier.isFirstRun: ${notifier.isFirstRun}");
            return MultiProvider(
              providers: [
                // สำหรับ in_app purchases
                ChangeNotifierProvider(create: (_) => ProviderModel()),
                // สำหรับ bottom bar notification for Update
                ChangeNotifierProvider(create: (_) => BadgeNotifier()),
              ],
              child: MaterialApp(
                title: 'OCSC Exam Prep Application',
                theme: notifier.darkTheme ? dark : light, //theme: dark,
                home: MyHomePage(
                  title: 'เตรียมสอบ ก.พ. (ภาค ก.)',
                  beachImage: beachImage,
                  isDialogHidingExpired: isDialogHidingExpired, //ส่งมาจาก myApp()
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void deleteOrphantRecords() async {
    var dbClient = await SqliteDB().db;
    await dbClient!.rawDelete(
      'delete from itemTable where file_name not in (select file_name from OcscTjkTable)',
    );
  }

  void getLastDialogOpenTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime lastOpenTime =
    DateTime.fromMillisecondsSinceEpoch(prefs.getInt('dialogLastOpenTime') ?? 0);

    // Calculate the difference in days
    int daysDifference = DateTime.now().difference(lastOpenTime).inDays;

    // คิดเป็นนาที
    int minutesDifference = DateTime.now().difference(lastOpenTime).inMinutes;
    bool isDialogHidingDaysPassed = minutesDifference >= 2;

    // จำไว้ว่า เวลาไปเอาข้อมูลที่ต้องรอด้วย async/await หรือ Future ถ้าจะเอามาปรับตัวแปร ก็ใช้การ setState
    setState(() {
      isDialogHidingExpired = isDialogHidingDaysPassed;
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void listPdfFiles() async {
    Directory dir = Directory('/data/user/0/com.thongjoon.ocsc_exam_prep/app_flutter');
    List<FileSystemEntity> files = dir.listSync();

    for (var file in files) {
      if (file is File && file.path.endsWith('.pdf')) {
        print('PDF File: ${file.path}');
      }
    }
  }
}

class BadgeNotifier extends ChangeNotifier {
  bool _showBadge = false;

  bool get showBadge => _showBadge;

  void updateBadgeStatus(bool value) {
    _showBadge = value;
    notifyListeners();
  }
}

Future _launchUrl() async {
  final Uri _url = Uri.parse('https://play.google.com/store/apps/details?id=com.thongjoon.ocsc_exam_prep');
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
        required this.title,
        required this.beachImage,
        this.appName,
        this.packageName,
        this.version,
        this.buildNumber,
        required this.isDialogHidingExpired,
      });

  final String title;
  final Image beachImage;
  final bool isDialogHidingExpired;
  final String? appName;
  final String? packageName;
  final String? version;
  final String? buildNumber;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showUpdateBanner = false;  // for Update is available
  String _localVersion = ''; // for Update is available
  String _remoteVersion = ''; // for Update is available for Android
  String _remoteVersion_iOS = ''; // for Update is available for IOS
  String _whatsNew_Android = '';
  String _whatsNew_iOS = '';

  int _selectedIndex = 0;// for Update is available

  late Future<void> _packageInfoFuture;
  bool _isThereCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent ?? false;

  // สำหรับแสดง dialog ตอนเปิดแอพ
  bool _isDialogShown = false;
  bool isDialogHidingExpired = true;
  bool isShowRequestFiveStarBox = true;


  DateTime? firstOpenApp;  // สำหรับเก็บวันเดือนปีที่เปิดใช้ครั้งแรก เพื่อแสดง dialog ชวนโหวด 5 ดาว
  bool shouldShowVoteFiveStar = false;
  bool isVoteFiveStarsAlready = false; // สำหรับว่า ถ้าโหวตแล้ว จะมีตัวเลือก ให้ไม่แสดง dialog อีกตลอดไป
  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;
  final GoogleSheetsAPI _sheetsAPI = GoogleSheetsAPI();
  List<Map<String, dynamic>> myGSheetData = [];


  @override
  void initState() {
    super.initState();
    _packageInfoFuture = _loadPackageInfo();
    _checkLastOpenTime();
    _doRandomNumber();

    fetchData();  // ไปเอาข้อมูลจาก Google Sheets
  }

  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<void> fetchData() async {
    if (await isConnected()) {
      try {
        final GSheetsData = await _sheetsAPI.fetchData();

        setState(() {
          myGSheetData = GSheetsData;
        });

        debugPrint("data from sheets: $myGSheetData");

        await checkVersion();
      } catch (e) {
        debugPrint('Exception while fetching data: $e');
        ScaffoldMessenger.of(context).showSnackBar(  // snackbar not working
          const SnackBar(content: Text('Error fetching data. Please try again.')),
        );
      }
    } else {
      debugPrint('Device offline.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar( // snackbar not working
            content: Text('ไม่มีการเชื่อมต่ออินเทอร์เน็ต ไม่สามารถตรวจสอบการ UPDATE ได้ นะครับ')),
      );
    }
  }


  Future<int?> getCount() async {
    // ถูกเรียกโดยใช้ snapshot
    var dbClient = await SqliteDB().db;
    var x = await dbClient!.rawQuery('SELECT COUNT (*) from OcscTjkTable');
    int? countX = Sqflite.firstIntValue(x);
    return countX;
  }




  @override
  Widget build(BuildContext context) {
    debugPrint("isDialogHidingExpired before showFirstMessage: $isDialogHidingExpired");

    showFirstMessage(context, isDialogHidingExpired, isVoteFiveStarsAlready, isShowRequestFiveStarBox); // แสดง dialog แสดงข่าวสาร ตอนเปิดโปรแกรม

    final providerModel = Provider.of<ProviderModel>(context,
        listen: false); // สำหรับการซื้อในแอพ

    providerModel.initPlatformState();
    bool isBuyFromProvider = providerModel.removeAds;
    debugPrint("isBuyFromProvider from main.dart: $isBuyFromProvider");

// สำหรับข้อมูล ให้กำลังใจ และ นับถอยหลัง จาก Google Sheets
    List msgFromGSheets = myGSheetData;
    debugPrint("record length: ${msgFromGSheets.length}");

    if(msgFromGSheets.isEmpty){
      // ถ้าไม่มีอินเทอร์เน็ต คือ offline อยู่ ให้ใช้ข้อความนี้  ---------------
      msgFromGSheets = [
        {'name': 'exam_schedule', 'description': 'วันขึ้นปีใหม่_X_ 1 มกราคม_X_2024-01-01 00:00:01xyzวันสงกรานต์_X_ 13 เมษายน_X_2024-01-01 00:00:01'},
        {'name': 'message_android_bought', 'description': '**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี**xyz**ความพยายามอยู่ที่ไหน ความสำเร็จอยู่ที่นั่น**'},
        {'name': 'message_android_not_buy_yet', 'description': '**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี**xyz**ความพยายามอยู่ที่ไหน ความสำเร็จอยู่ที่นั่น**'},
        {'name': 'message_ios_bought', 'description': '**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี**xyz**ความพยายามอยู่ที่ไหน ความสำเร็จอยู่ที่นั่น**'},
        {'name': 'message_ios_not_buy_yet', 'description': '**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี**xyz**ความพยายามอยู่ที่ไหน ความสำเร็จอยู่ที่นั่น**'},
        {'name': 'ocsc_curr_version_android', 'description':'3.0.0+25680101'},
      ];

    }

    debugPrint("msgFromGSheets XX: $msgFromGSheets");
    debugPrint("record length XX: ${msgFromGSheets.length}");
    debugPrint("record[5] XX: ${msgFromGSheets[5]}");
    debugPrint("version from package: $version");

    const List newBigList = [
      ...general,
      ...english,
      ...law,
      ...practice
    ];
    debugPrint("newBigList จำนวน สมาชิก: ${newBigList.length} รายการ");
    final isDarkMde =
        Provider.of<ThemeNotifier>(context, listen: false).darkTheme;
    debugPrint("isDarkMde checked: $isDarkMde");

    // สำหรับ ไอคอน สว่าง-มืด
    const IconData nightlight_outlined = IconData(0xf214, fontFamily: 'MaterialIcons');
    const IconData wb_sunny_outlined = IconData(0xf4bc, fontFamily: 'MaterialIcons');
    const IconData mode_night = IconData(0xe3f4, fontFamily: 'MaterialIcons');
    const IconData sunny = IconData(0xf0575, fontFamily: 'MaterialIcons');

    final theme = Provider.of<ThemeNotifier>(context,
        listen: false); // ใช้สำหรับ update ตัวแปร index ด้วย
    int countDwnIndx = theme.thisExamIndexFromPref;

    List<String> messageList = countDown_global.split("xyz"); // แปลงเป็น list จะได้นับจำนวนได้ แต่ละอัน คั่นด้วย xyz
    debugPrint("thisIndex from sharePref countDwnIndx: $countDwnIndx");
    debugPrint("msg length: ${messageList.length}");
    if (countDwnIndx >= messageList.length){
      countDwnIndx = 0;
    }
    prepareOcscTjkTableData(newList: newBigList);

    return SafeArea(
      minimum: const EdgeInsets.all(1.0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(this.widget.title),
          actions: [
            Tooltip(
              message: "ปรับโหมด มืด-สว่าง",
              child: Row(
                children: [
                  Transform.rotate(
                    angle: 3.14159 / 4, // Rotating 45 degrees (change angle as needed)
                    child: Icon(
                      isDarkMde == true ? wb_sunny_outlined : mode_night, // Change icon based on isDarkMde
                      color: isDarkMde == true ? Colors.pink[100] : Colors.yellow,
                      size: isDarkMde == true ? 30 : 18.0,
                    ),
                  ),

                  Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) => Switch(
                      activeColor: Colors.lime,
                      onChanged: (val) {
                        notifier.toggleTheme();
                      },
                      value: notifier.darkTheme,
                    ),
                  )
                ],
              ), 
            )
          ],
        ),

        body: FutureBuilder(
          future: Future.wait([getCount(), getCountDwnMsg()]),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occured',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              } else if (snapshot.hasData) {
                debugPrint("general listXXX: ${general}"); // Updated reference
                getCount().then((numOfRecordsInOcscTjkTable) {
                  if (numOfRecordsInOcscTjkTable! <= 0) {
                    debugPrint("ตาราง OcscTjkTable ไม่มีข้อมูล ");
                    var newList = [
                      ...general, // Updated reference
                      ...english, // Updated reference
                      ...law,     // Updated reference
                      ...practice // Updated reference
                    ]; 
                  }
                });
                var countDownMessage = snapshot.data![1].toString(); 
                debugPrint("countDownMessage in Main: $countDownMessage");
                debugPrint("msgFromGSheets before mainMenu: $msgFromGSheets");
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.beachImage.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                          width: 200,
                        ),
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  const Text(
                                    'เลือกหัวข้อประเภทข้อสอบ',
                                    style: TextStyle(
                                      fontFamily: 'Athiti',
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white60,
                                    ),
                                  ),
                                  const SizedBox(
                                      width: double.infinity, height: 12.0),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 40.0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.blue[300]!)),
                                      clipBehavior: Clip.none,
                                      child: const Text(
                                        'หลักสูตรและโครงสร้างข้อสอบ ก.พ. (ภาค ก.)',
                                        style: TextStyle(
                                          fontFamily: 'Athiti',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffFFFF00),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const Curriculum(
                                                key: null,
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 40.0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.blue[300]!)),
                                      child: const Text(
                                        'ความสามารถทั่วไป',
                                        style: TextStyle(
                                            fontFamily: 'Athiti',
                                            color: Color(0xff003366),
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        debugPrint(
                                            "ปุ่ม Go to ความสามารถทั่วไป ถูกกด aaa aa");
                                        if (msgFromGSheets.isNotEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MainMenu(
                                                  myType: "1",
                                                  title: "ความสามารถทั่วไป",
                                                  fileList: general, // Updated reference
                                                  examScheduleIndex:
                                                  countDwnIndx,
                                                  countDownMessage:
                                                  countDownMessage,
                                                  msgFromGSheets: msgFromGSheets,
                                                )),
                                          );}else{
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        };
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 40.0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.blue[300]!)),
                                      child: const Text(
                                        'ภาษาอังกฤษ',
                                        style: TextStyle(
                                            fontFamily: 'Athiti',
                                            color: Color(0xff003366),
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        debugPrint("cccc cc");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MainMenu(
                                                myType: "2",
                                                title: "ภาษาอังกฤษ",
                                                fileList: english, // Updated reference
                                                examScheduleIndex:
                                                countDwnIndx,
                                                countDownMessage:
                                                countDownMessage,
                                                msgFromGSheets: msgFromGSheets,
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 40.0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.blue[300]!)),
                                      child: const Text(
                                        'การเป็นข้าราชการที่ดี',
                                        style: TextStyle(
                                            fontFamily: 'Athiti',
                                            color: Color(0xff003366),
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MainMenu(
                                                myType: "3",
                                                title:
                                                "การเป็นข้าราชการที่ดี",
                                                fileList: law, // Updated reference
                                                examScheduleIndex:
                                                countDwnIndx,
                                                countDownMessage:
                                                countDownMessage,
                                                msgFromGSheets: msgFromGSheets,
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 40.0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.blue[300]!)),
                                      child: const Text(
                                        'ฝึกทำข้อสอบ จับเวลา',
                                        style: TextStyle(
                                            fontFamily: 'Athiti',
                                            color: Color(0xff003366),
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MainMenu(
                                                myType: "4",
                                                title: "ฝึกทำข้อสอบ จับเวลา ",
                                                fileList: practice, // Updated reference
                                                examScheduleIndex:
                                                countDwnIndx,
                                                countDownMessage:
                                                countDownMessage,
                                                msgFromGSheets: msgFromGSheets,
                                              )),
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Version: $version", 
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  Text(
                                    "Build: $buildNumber",
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                );
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),

        bottomNavigationBar: _showUpdateBanner
            ? GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _showUpdateBanner = false;
            });
          },
          child: Container(
            color: Colors.amber[800],
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? 'มีข้อสอบใหม!!! ฟรี UPDATE ที่ App Store\n รุ่นของท่าน: $_localVersion รุ่นใหม่: $_remoteVersion_iOS \n $_whatsNew_iOS'
                      : 'มีข้อสอบใหม!!! ฟรี UPDATE ที่ Play Store\n รุ่นของท่าน: $_localVersion รุ่นใหม่: $_remoteVersion \n $_whatsNew_Android',
                  style: const TextStyle(
                      fontFamily: 'Athiti',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                  ),

                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    final String url = Platform.isIOS
                        ? 'https://apps.apple.com/app/id1622156979'
                        : 'https://play.google.com/store/apps/details?id=com.thongjoon.ocsc_exam_prep';

                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    } else {
                      debugPrint("Could not launch store URL");
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2), 
                      borderRadius: BorderRadius.circular(12), 
                    ),
                    child: Text(
                      Platform.isIOS
                          ? '👉 กดที่นี่ เพื่อ UPDATE'
                          : '👉 กดที่นี่ เพื่อ UPDATE',
                      style: const TextStyle(
                          fontFamily: 'Athiti',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            : null,
      ),
    );
  }

  void prepareOcscTjkTableData ({required List newList}) async {

    int? dateInstalled = await AppUtils.getInstallDateEpochSeconds();

    debugPrint("install at: $dateInstalled");

    var dbClient = await SqliteDB().db;
    var x = await dbClient!.rawQuery('SELECT COUNT (*) from OcscTjkTable');
    int? countX = Sqflite.firstIntValue(x);
    debugPrint("เข้ามาครั้งแรก ข้อมูลใน OcscTjkTable : $countX");
    if (countX == 0) {  
      addToOcscTjkTable(wholeList: newList); 
    } else {  

      debugPrint("mapYYY: before check");
      List<String> menuNameListFromMain = [];

      debugPrint("จำนวนข้อมูลใน newList: ${newList.length}");

      for (var i = 0; i < newList.length; i++) {
        final menuName = newList[i][0];
        final fileName = newList[i][1];
        final createDateStr = newList[i][2];
        final whatType = int.parse(newList[i][3]);
        final position = newList[i][4];
        final dateFromFile = int.parse(createDateStr);

        menuNameListFromMain.add(menuName);
        fileNameListFromMain.add(fileName);

        await addNewDataIfAny(
          position: position,
          menuName: menuName,
          fileName: fileName,
          createDate: createDateStr,
          whatType: whatType,
        );

        if (fileName.contains("label")) continue;

        final positionAndDate = await retrieveDateFromSQflite(fileName: fileName);
        final posAndDateArr = positionAndDate.split("aa");
        final dbPosition = posAndDateArr[0];
        final dateFromDB = int.parse(posAndDateArr[1]);
        final isMenuClicked = int.parse(posAndDateArr[2]);

        if (position != dbPosition) {
          await updatePositionInOcscTjkTable(fileName: fileName, position: position);
        }

        final isNewlyUploaded = dateFromFile > dateFromDB;
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final sixtyDaysAgo = now - (60 * 24 * 60 * 60);
        final isWithin60Days = dateFromFile > sixtyDaysAgo;

        final showRedDot = isNewlyUploaded && isWithin60Days && isMenuClicked == 0;

        debugPrint("✅ $fileName → red dot: $showRedDot");

        await dbClient.transaction((txn) async {
          if (showRedDot) {
            debugPrint("Criteria met--Add redDot $fileName");
            await txn.rawUpdate('''
        UPDATE OcscTjkTable
        SET isNew = 1, field_2 = 0
        WHERE file_name = ?
      ''', [fileName]);
          } else {
            debugPrint("Criteria NOT met -- No redDot $fileName");
            await txn.rawUpdate('''
        UPDATE OcscTjkTable
        SET isNew = 0, dateCreated = ?, field_2 = 0
        WHERE file_name = ?
      ''', [dateFromFile, fileName]);
          }
        });
      }

      await deleteMenuItemFromTableIfNotExist(menuListInMain: menuNameListFromMain);

    }
  }


  initInApp(provider) async {
    debugPrint("check going to initInApp from Main -- before going");
    await provider.initInApp();
    debugPrint("check going to initInApp from Main -- after going");
  }

  initPlatformState(provider) async {
    debugPrint(
        "check going to initPlatformState (revenueCat) from Main -- before going");
    await provider.initPlatformState();
    debugPrint("provider.removeAds: ${provider.remov}");
  }

  void updateOcscTjkTblOnceAndForAll() {
    // Not in use
  }

  Future <String?> getCountDwnMsg() async {
    String? thisCountDwnMsg = countDown_global;
    return thisCountDwnMsg;
  }

  void showFirstMessage(BuildContext context, bool isDialogHidingExpired, bool isVoteFiveStarsAlready, bool isShowRequestFiveStarBox) async {
    bool isDialogHidingDayExpired = isDialogHidingExpired;
    bool isClickVoteAlready = isVoteFiveStarsAlready;
    bool showWelcomeDialogNoMore = SharedPreferencesManager().getBool(
        'noMoreShowWelcomeDialog');

    debugPrint("widget.isDialogHidingExpired: ${widget.isDialogHidingExpired}");
    debugPrint("shouldShowVoteFiveStar: $shouldShowVoteFiveStar");
    debugPrint("isDialogHidingDayExpired: $isDialogHidingDayExpired");
    debugPrint("!_isDialogShown inside showFirstMessage: ${!(_isDialogShown)}");
    debugPrint(
        "_isThereCurrentDialogShowing(context): ${_isThereCurrentDialogShowing(
            context)}");
    debugPrint("showWelcomeDialogNoMore: $showWelcomeDialogNoMore");
    if(!showWelcomeDialogNoMore){ 
      debugPrint("outside  if ((!_isDialogShown &&");
      if ((!_isDialogShown && _isThereCurrentDialogShowing(context) &&
          isDialogHidingDayExpired)) {
        _isDialogShown = true; 
        debugPrint("inside  if ((!_isDialogShown &&");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 540),
                  child: Theme(
                    data: themeForGreetingDialog,
                    child: AlertDialog(
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/exam_prep_logo.png',
                              height: 60,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'ยินดีต้อนรับ',
                              style: TextStyle(
                                fontFamily: 'Athiti',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: themeForGreetingDialog.primaryColor,
                              ),
                              textAlign: TextAlign
                                  .center, 
                            ),
                            SizedBox(height: 6),
                            const Text(
                              'ติ-ชม-สอบถาม ใช้เมนู 3 จุดในแอพ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.indigo,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            flutterVisibility.Visibility(
                              visible: (shouldShowVoteFiveStar &&
                                  !isVoteFiveStarsAlready && isShowRequestFiveStarBox),
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 15.0, right: 15.0, bottom: 5,),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red, 
                                    width: 2.0, 
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10.0), 
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 5),
                                    const Text(
                                      'ขอกำลังใจ 5 ดาว',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _setOptionNotShowDialog();
                                        Navigator.of(context).pop();

                                        if (Platform.isIOS || Platform.isMacOS) {
                                          _launchURL('https://apps.apple.com/th/app/%E0%B9%80%E0%B8%95%E0%B8%A3-%E0%B8%A2%E0%B8%A1%E0%B8%AA%E0%B8%AD%E0%B8%9A-%E0%B8%81%E0%B8%9E-%E0%B8%A0%E0%B8%B2%E0%B8%84-%E0%B8%81/id1622156979?l=th');
                                        } else if (Platform.isAndroid) {
                                          _launchURL(
                                              'https://play.google.com/store/apps/details?id=$packageName');
                                        }

                                      },
                                      child: RichText(
                                        text: const TextSpan(
                                          text: 'ให้คะแนน 5 ดาว ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                            decoration: TextDecoration.underline,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'คลิกที่นี่',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 16,
                                                decoration: TextDecoration
                                                    .underline,
                                              ),
                                            ),
                                            TextSpan(text: ' \nขอบคุณมาก'),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),


                                  ],

                                ),
                              ),
                            ),

                            SizedBox(height: 15),
                            Container(
                              color: Colors.yellow,
                              child: Center(
                                child: Text(
                                  'มีอะไรใหม่',
                                  style: TextStyle(
                                    fontFamily: 'Athiti',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: themeForGreetingDialog.primaryColor,
                                  ),
                                  textAlign: TextAlign
                                      .center, 
                                ),
                              ),
                            ),
                            const Text(
                              '\u2764️ UPDATE!! ข้อสอบเสมือนจริง เม.ย. 2568 เรื่อง อนุกรม\n ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.indigo,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],

                        ),
                      ),

                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pop(); 

                                if (isVoteFiveStarsAlready) {
                                  _dont_show_welcome_dialog_anymore();
                                } else {
                                  _saveCurrentTime(); 
                                }
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: isVoteFiveStarsAlready
                                      ? "ไม่ต้องแสดงอีกตลอดไป"
                                      : "ไม่ต้องแสดงอีก 5 วัน",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.indigo,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('รับทราบ'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
          _isDialogShown = true;
        });
      } 

    }  

  }

  void showDialog_work_in_progress(BuildContext context) {
    if (!_isDialogShown && _isThereCurrentDialogShowing(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/data/images/work_in_progress.png',
                      height: 150, 
                    ),
                    SizedBox(height: 16),
                    const Text('ช่วงนี้ ผมปิดชั่วคราวเพื่อปรับปรุง \n'
                        'แต่ยังมีการอัพเดทข้อมูลอยู่\n\n'
                        'ถ้าท่านได้ซื้อแล้ว ยังใช้รุ่นเต็มได้เหมือนเดิม\n\n'
                        'ผู้ใช้รายใหม่จะไม่เห็นแอพนี้ บน Play Store\n\n '
                        'ถ้าท่านลบแอพนี้ และต้องการติดตั้งใหม่ ต้องเข้าทางบัญชี Play Store ของท่าน '
                        'และดูแอพที่ไม่ได้ติดตั้ง\n\n'
                        'ถ้าต้องการซื้อรุ่นเต็ม ก็ยังทำได้เหมือนเดิม\n\n'
                        'ถ้ายังไม่ซื้อแต่ต้องการใช้รุ่นเต็ม ให้ส่งเมลถึงผมทางเมนู 3 จุด '
                        'เพื่อสมัครเข้าร่วมทดสอบแอพนี้'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('รับทราบ'),
                ),
              ],
            );
          },
        );
        _isDialogShown = true;
      });
    }
  }

  Future<void> _loadPackageInfo() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appName = packageInfo.appName;
        packageName = packageInfo.packageName;
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
        debugPrint("appName: $appName");
        debugPrint("packageName: $packageName");
        debugPrint("version: $version");
        debugPrint("buildNumber: $buildNumber");
      });
    } catch (e) {
      debugPrint('Error loading package info: $e');
    }
  }

  void _doRandomNumber(){
    Random random = Random();
    int randomNumber = random.nextInt(4) + 1;

    if(randomNumber == 1 || randomNumber == 2 || randomNumber == 4){
      isShowRequestFiveStarBox = true;
    }else{
      isShowRequestFiveStarBox = false;
    }
    debugPrint('Random Number: $randomNumber');
    debugPrint("isShowRequestFiveStarBox: $isShowRequestFiveStarBox");
    setState(() {
      isShowRequestFiveStarBox;
    });
  }
  void _checkLastOpenTime() async {

    int minutesDifferenceFirstUse = 0;
    int daysDifferenceFirstUse = 0;

    int storedTime =  SharedPreferencesManager().getInt('timeOfFirstRun') ?? 0;

    bool isVoteClicked =  SharedPreferencesManager().getBool('isVote_5_stars_Clicked') ?? false;

    DateTime firstTimeUse = DateTime.fromMillisecondsSinceEpoch(storedTime, isUtc: true);

    minutesDifferenceFirstUse = DateTime.now().toUtc().difference(firstTimeUse).inMinutes;

    daysDifferenceFirstUse = DateTime.now().toUtc().difference(firstTimeUse).inDays;
    bool shouldVoteFiveStar = daysDifferenceFirstUse >= 7;

    DateTime lastOpenTime =
    DateTime.fromMillisecondsSinceEpoch(SharedPreferencesManager().getInt('dialogLastOpenTime') ?? 0);

    int minutesDifference = DateTime.now().difference(lastOpenTime).inMinutes;

    int daysDifference = DateTime.now().difference(lastOpenTime).inDays;
    bool isHidingDaysPassed = daysDifference >= 5;

    firstOpenApp = firstTimeUse;
    shouldShowVoteFiveStar = shouldVoteFiveStar;
    isVoteFiveStarsAlready = isVoteClicked;
    isDialogHidingExpired = isHidingDaysPassed;

    debugPrint("สำหรับแสดง dialog");
    debugPrint("isHidingDaysPassed in _checkLastOpenTime: $isHidingDaysPassed");

    debugPrint("สำหรับแสดง ให้กดโหวต 5 ดาว");
    debugPrint("storedTime: $storedTime");
    debugPrint("DateTime.now (UTC): ${DateTime.now().toUtc()}");
    debugPrint("firstTimeUse (UTC): $firstTimeUse");
    debugPrint("for testing -- minutesDifferenceFirstUse: $minutesDifferenceFirstUse");
    debugPrint("for testing -- daysDifferenceFirstUse: $daysDifferenceFirstUse");
    debugPrint("shouldVoteFiveStar: $shouldVoteFiveStar");

    debugPrint("isDialogHidingExpired before setState: $isDialogHidingExpired");
    debugPrint("isVoteClicked: $isVoteClicked");
    debugPrint("isVoteFiveStarsAlready: $isVoteFiveStarsAlready");

    setState(() {
      isDialogHidingExpired;
      firstOpenApp;
      shouldShowVoteFiveStar;
      isVoteFiveStarsAlready;
    });
  }


  void _dont_show_welcome_dialog_anymore() async {
    await SharedPreferencesManager().setBool('noMoreShowWelcomeDialog', true);
  }

  void _saveCurrentTime() async {
    await SharedPreferencesManager().setInt('dialogLastOpenTime', DateTime.now().millisecondsSinceEpoch);
  }

  void _setOptionNotShowDialog() async {
    await SharedPreferencesManager().setBool('isVote_5_stars_Clicked', true);
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    bool launched = await launchUrl(uri);

    if (!launched) {
      throw 'Could not launch $url';
    }
  }

  Future<void> populateOcscTjkTable({required List wholeList}) async {
    final dbClient = await SqliteDB().db; 

    final countResult = await dbClient!.rawQuery('SELECT COUNT(*) as count FROM OcscTjkTable');
    final int rowCount = Sqflite.firstIntValue(countResult) ?? 0;
    debugPrint("Table OcscTjkTable row count: $rowCount");

    if (rowCount > 0) {
      await dbClient.rawDelete('DELETE FROM OcscTjkTable');
      debugPrint("Deleted all existing rows from OcscTjkTable");
    }

    debugPrint("Entering populateOcscTjkTable: wholeList.length = ${wholeList.length}");
    for (var i = 0; i < wholeList.length; i++) {
      await dbClient.rawInsert(
        'INSERT INTO "OcscTjkTable"(menu_name, file_name, progress_pic_name, dateCreated, isNew, exam_type, field_2, position, open_last, field_5) VALUES(?,?,?,?,?,?,?,?,?,?)',
        [
          wholeList[i][0], 
          wholeList[i][1], 
          "p00.png",       
          wholeList[i][2], 
          0,               
          wholeList[i][3], 
          0,               
          wholeList[i][4], 
          "top",           
          "reserved"       
        ],
      );
    }
    debugPrint("Finished populating OcscTjkTable with ${wholeList.length} rows");
  }

  Future<void> checkAndShowUpdateBadge(List<Map<String, dynamic>> gsheetData) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    debugPrint("version from package: $localVersion");

    String? remoteVersion;
    for (var item in gsheetData) {
      if (item['name'] == 'ocsc_curr_version_android') {
        remoteVersion = item['description'];
        break;
      }
    }

    if (remoteVersion == null) {
      debugPrint("No remote version found.");
      return;
    }

    String cleanRemoteVersion = remoteVersion.split('+').first;
    debugPrint("Remote version: $cleanRemoteVersion");
  }

  Future<void> checkVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final String local = packageInfo.version;

    String? remote;
    String? version_ios_gsheets;
    String? whats_new_android_gsheets;
    String? whats_new_ios_gsheets;

    for (var record in myGSheetData) {
      switch (record['name']) {
        case 'ocsc_curr_version_android':
          remote = record['description'];
          break;
        case 'ocsc_curr_version_ios':
          version_ios_gsheets = record['description'];
          break;
        case 'whats_new_android':
          whats_new_android_gsheets = record['description'];
          break;
        case 'whats_new_ios':
          whats_new_ios_gsheets = record['description'];
          break;
      }
    }

    if (remote == null) {
      debugPrint('No version found from Google Sheets.');
      return;
    }

    String latest = remote.split('+').first;

    debugPrint("current version from GSheets: $latest");
    if (_isNewerVersion(latest, local)) {
      setState(() {
        _localVersion = local;  

        _remoteVersion = latest.contains('+') ? latest.split('+')[0] : latest;  
        _remoteVersion_iOS = version_ios_gsheets!.contains('+') ? version_ios_gsheets.split('+')[0] : version_ios_gsheets;

        _whatsNew_Android = whats_new_android_gsheets!;
        _whatsNew_iOS = whats_new_ios_gsheets!;
        _showUpdateBanner = true;

      });
    }
  }


  bool _isNewerVersion(String latest, String current) {
    List<int> latestParts = latest.split('.').map(int.parse).toList();
    List<int> currentParts = current.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length || latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        context.read<BadgeNotifier>().updateBadgeStatus(false);
      }
    });
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, bool showDot) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Icon(icon),
          if (showDot)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      label: label,
    );
  }


} // end of class _MyHomePageState

Future<void> updatePositionInOcscTjkTable({required String fileName, required String position}) async {
  final dbClient = await SqliteDB().db;
  if (dbClient != null) {
    try {
      await dbClient.transaction((txn) async {
        var res = await txn.rawQuery(''' 
          UPDATE OcscTjkTable 
          SET position = ? 
          WHERE file_name = ? 
        ''', ['$position', '$fileName']);
      });
    } catch (e) {
      print("Error during transaction: $e");
    }
  }
}





Future retrieveDateFromSQflite({required String fileName}) async {
  var dbClient = await SqliteDB().db; 
  final res = (await dbClient!.rawQuery(
      """ SELECT position, dateCreated, field_2 FROM OcscTjkTable WHERE file_name = '$fileName' """));

  var thisDate;
  int dateFromSQL;
  String pos;
  int is_clicked_main;
  String posAndDate;
  if (res.length > 0) {
    debugPrint("mapxxx rest/first: ${res.first}");
    thisDate = res.first;
    dateFromSQL = thisDate["dateCreated"];
    pos = thisDate["position"];
    is_clicked_main = thisDate["field_2"];  
    debugPrint("isClicked_main in DB -- retrieveDateFromSQflite: $is_clicked_main");
    posAndDate = pos + "aa" + dateFromSQL.toString() + "aa" + is_clicked_main.toString();
  } else {
     debugPrint("mapxxx - length <= 0: ${res.first}");
    thisDate = 111111;
    dateFromSQL = 111111;
    pos = "00";
    is_clicked_main = 0;
    posAndDate = pos + "aa" + dateFromSQL.toString() + "aa" + is_clicked_main.toString();
  }
  return posAndDate;
}

Future<void> deleteMenuItemFromTableIfNotExist({required List<String> menuListInMain}) async {
  getDataFromOcscTjkTable().then((List<String> menuNameListFromTable) {
    var notFoundList = [];
    for (var i = 0; i < menuNameListFromTable.length; i++) {
      if (!(menuListInMain.contains(menuNameListFromTable[i]))) {
        notFoundList.add(menuNameListFromTable[i]);
      }
    }
    debugPrint("mapYYY: notfound: $notFoundList");

    if (notFoundList.isNotEmpty) {
      deleteNonExistMenuFile(fileList: notFoundList);
    }

  }, onError: (error) {
    debugPrint("deleteNonExistMenuFile error:  $error");
  });
}


void deleteNonExistMenuFile({required List fileList}) async {
  debugPrint(" === deleteNonExistMenuFile === ");
  debugPrint("num of record to be deleted - fileList: ${fileList.length}");
  var dbClient = await SqliteDB().db;

  try {
    await dbClient!.transaction((txn) async {
      for (var i = 0; i < fileList.length; i++) {
        debugPrint("not found to be deleted: ${fileList[i]}");

        var y = await txn.rawDelete(
            'DELETE FROM OcscTjkTable WHERE menu_name = ?',
            [fileList[i]]
        );
        debugPrint("Deleted $y records where menu_name = ${fileList[i]}");
      }
    });
  } catch (e) {
    debugPrint("Error deleting records: $e");
  }
}

void testHowMuchTimeAMethodUsed() async {  
  const Duration threshold = Duration(seconds: 2);
  await measureExecutionTime(
    method: getDataFromOcscTjkTable, 
    threshold: threshold,  
  );
}


Future<T> measureExecutionTime<T>({
  required Future<T> Function() method, 
  required Duration threshold,          
}) async {
  final DateTime startTime = DateTime.now();

  final T result = await method();

  final DateTime endTime = DateTime.now();

  final Duration executionTime = endTime.difference(startTime);

  if (executionTime > threshold) {
    debugPrint(
      'Warning: Method took too much time: ${executionTime.inMilliseconds} ms',
    );
  } else {
    debugPrint(
      'Method executed within time: ${executionTime.inMilliseconds} ms',
    );
  }

  return result; 
}



Future<List<String>> getDataFromOcscTjkTable() async {
  final dbClient = await SqliteDB().db;
  List<Map> results = await dbClient!.rawQuery('SELECT * FROM OcscTjkTable');
  List<String> menuNameFromOcscTjkTable = [];
  results.forEach((result) {
    menuNameFromOcscTjkTable.add(result['menu_name']);
  });
  return menuNameFromOcscTjkTable;
}

Future<void> addNewDataIfAny(
    {required String menuName,
      required String fileName,
      required String createDate,
      required int whatType,
      required String position}) async {
  if (menuName.contains("ทดสอบ")) {
    debugPrint("menu ก่อนเอาเข้าฐานข้อมูล: $menuName file: $fileName");
  }

  int thisDate = int.parse(createDate); 

  final dbClient = await SqliteDB().db;
  var x = await dbClient!.rawQuery(
      'SELECT COUNT (*) from OcscTjkTable WHERE menu_name = ?',
      ["$menuName"]); 
  int? countX = Sqflite.firstIntValue(x);
  if (countX == 0) {
    debugPrint(
        "xx all files If data countx == 0 ไฟล์ใหม่  '$menuName' '$fileName' $thisDate  ");

    await dbClient.transaction((txn) async {
      var result = await txn.rawInsert(
          'INSERT INTO "OcscTjkTable"(menu_name, file_name, progress_pic_name, dateCreated, isNew, exam_type, field_2, position, open_last, field_5) '
              'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            menuName,
            fileName,
            'p00.png',
            thisDate,
            1,          
            whatType,
            0,          
            position,
            '0',        
            'reserved'  
          ]
      );
      debugPrint("Insert result: $result");
    });
  } else {
    // If the file already exists, check if the position needs to be updated.
  }
}


void addToOcscTjkTable({required List wholeList}) async {
  final dbClient = await SqliteDB().db;

  await dbClient!.transaction((txn) async {
    int res;
    debugPrint("enter addToOcscTjkTable: wholeList.length =  ${wholeList.length}");

    for (var i = 0; i < wholeList.length; i++) {
      res = await txn.rawInsert(
          'INSERT INTO "OcscTjkTable"(menu_name, file_name, progress_pic_name, dateCreated, isNew, exam_type, field_2, position, open_last, field_5) '
              'VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            wholeList[i][0], 
            wholeList[i][1], 
            "p00.png", 
            wholeList[i][2], 
            0, 
            wholeList[i][3], 
            0, 
            wholeList[i][4], 
            "top", 
            "reserved" 
          ]
      );
    }
  });
}


Future checkAndUpdateOcscTjkTable(
    {required String menuName,
      required String fileName,
      required String createDate,
      required int whatType,
      required String position}) async {
  int thisDate = int.parse(
      createDate); 
  final dbClient = await SqliteDB().db;
  var x = await dbClient!.rawQuery(
      'SELECT COUNT (*) from OcscTjkTable WHERE file_name = ?', ["$fileName"]);
  int? countX = Sqflite.firstIntValue(x);

  if (countX == 0) {
    var result = await dbClient!.rawInsert(
        'INSERT INTO "OcscTjkTable"(menu_name,file_name,progress_pic_name,dateCreated,isNew,exam_type,field_2,position,open_last,field_5) VALUES(?,?,?,?,?,?,?,?,?,?)',
        [
          menuName,
          fileName,
          'p00.png',
          thisDate,
          0,
          whatType,
          0,
          'reserved',
          '0',
          'reserved'
        ]);
    return result;
  }
}

class _PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หลักสูตรการสอบ ก.พ. ภาค ก.'),
      ),
      body: Center(
        child: Text(
          'หน้า 1',
        ),
      ),
    );
  }
}

Future navigateToP1(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => _PageOne()));
}

void createHashTableIfNotExist() async {
  var dbClient = await SqliteDB().db;
  await dbClient!.execute("""
      CREATE TABLE IF NOT EXISTS hashTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        str_value TEXT,
        UNIQUE (name) ON CONFLICT REPLACE
      )""");
  await dbClient!.rawInsert(
      'INSERT INTO hashTable (name, str_value) VALUES("appMode", "light")'); 
}

Future createOcscTjkTableIfNotExist() async {
  var dbClient = await SqliteDB().db;
  var res = await dbClient!.execute("""
      CREATE TABLE IF NOT EXISTS OcscTjkTable(
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
        UNIQUE (menu_name, file_name)  ON CONFLICT REPLACE
      )""");
}

Future<bool> getBooleanValue(String key) async {
  bool _isFirstRun = false;
  bool firstRun = SharedPreferencesManager().getBool(key);
  if(firstRun==false){  
    _isFirstRun = true;
  }else{
    _isFirstRun = false;
  }

  debugPrint(
      "the value of _isFirstRun from getBooleanValue function in Main.dart : $_isFirstRun");

  return _isFirstRun;
}


Future setDefaultValueForWelcomDialog() async {

  debugPrint("inside setDefaultValueForWelcomDialog");

  await SharedPreferencesManager().setIntIfNotExists('timeOfFirstRun', DateTime.now().toUtc().millisecondsSinceEpoch);
  int storedTime = SharedPreferencesManager().getInt('timeOfFirstRun');
  debugPrint("storedTime from main>sharePrefManager: $storedTime");

  await SharedPreferencesManager().setBoolIfNotExists('isVote_5_stars_Clicked', false);
  await SharedPreferencesManager().setBoolIfNotExists('noMoreShowWelcomeDialog', false);

  bool isVote_5_stars_Clicked = SharedPreferencesManager().getBool('isVote_5_stars_Clicked');
  debugPrint("isVote_5_stars_Clicked from main>sharePrefManager: $isVote_5_stars_Clicked");

} 


Future createItemTableIfNotExist() async {
  var dbClient = await SqliteDB().db;
  var res = await dbClient!.execute("""
      CREATE TABLE IF NOT EXISTS itemTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        file_name TEXT,
        item_id TEXT,
        item_date TEXT,
        isClicked TEXT DEFAULT "false",
        isNew TEXT,
        UNIQUE (item_id) ON CONFLICT REPLACE
      )""");
  return res;
}

Future<dynamic> checkWebsiteAvailability({required String url}) async {
  String isWebsiteAvailable;
  try {
    final response = await HttpClient().getUrl(Uri.parse(url)).then((request) => request.close());
    if (response.statusCode == 200) {
      isWebsiteAvailable = "yes";
      debugPrint('statusCode: 200 -- Website is available.');
    } else {
      isWebsiteAvailable = "no";
      debugPrint('statusCode is not equal to 200 -- Website is down.');
    }
  } on SocketException {
    isWebsiteAvailable = "no";
    debugPrint('SocketException: Website is down.');
  } on HttpException {
    isWebsiteAvailable = "no";
    debugPrint('HttpException: Website is down.');
  }
  return isWebsiteAvailable;
}


Future insertExamFileData({required List listName}) async {
  int? res;
  for (var i = 0; i < listName.length; i++) {
    final dbClient = await SqliteDB().db;

    res = await dbClient!.rawInsert(
        'INSERT INTO "OcscTjkTable"(menu_name,file_name,progress_pic_name,dateCreated,isNew,exam_type,field_2,position,open_last,field_5) VALUES(?,?,?,?,?,?,?,?,?,?)',
        [
          listName[i][0],
          listName[i][1],
          "p00.png",
          listName[i][2],
          0,
          listName[i][3],
          0,
          "reserved",
          "tbl_q1",
          "reserved"
        ]);
  }
  return res;
}

class ConstantUtil {  
  static const String UNAUTHORIZED = "Unauthorized";
  static const String SOMETHING_WRONG = "Something went wrong";
  static const String NO_INTERNET = "No internet connection";
  static const String BAD_RESPONSE = "Bad response";
}

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get username => _sharedPrefs.getString(keyUsername) ?? "";

  set username(String value) {
    _sharedPrefs.setString(keyUsername, value);
  }
}

const String keyUsername = "key_username";

void debugPrintWrapped(String text) {
  final pattern = new RegExp('.{1,800}'); 
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}


Future<int> getInstallDate() async {  
  final dir = await getApplicationSupportDirectory();
  final stat = await dir.stat();
  return (stat.changed.millisecondsSinceEpoch ~/ 1000); 
}

class Data extends ChangeNotifier {
  String data = "112233";

  void changeString(String newString) {
    data = newString;
    debugPrint("newString from JS in Data class to notifyListeners: $newString");
    notifyListeners();
  }
}
