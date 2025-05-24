import 'package:ocsc_exam_prep/database_manager.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
//import 'dart:js_interop';
// import 'package:flutter_app_badger/flutter_app_badger.dart';  // discontinued
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
// import 'package:in_app_update/in_app_update.dart';
// import 'package:upgrader/upgrader.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ocsc_exam_prep/sharePreferencesManager.dart';
import 'package:ocsc_exam_prep/src/constant.dart';
import 'package:ocsc_exam_prep/store_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:rating_dialog/rating_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/src/widgets/visibility.dart' as flutterVisibility; // สำหรับซ่อน ชวนให้โหวต 5 ดาว

import 'package:ocsc_exam_prep/theme.dart';
// import 'package:pastebin/pastebin.dart';

import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/store.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProviderModel.dart';
import 'curriculum.dart';

// import 'logic/dash_counter.dart';
// import 'logic/dash_purchases.dart';
// import 'logic/dash_upgrades.dart';
// import 'logic/firebase_notifier.dart';
import 'mainMenu.dart';
import 'sqlite_db.dart';
import 'dart:math'; // สำหรับหา random number เพื่อแสดง ขอกำลังใจ 5 ดาว
//import 'package:pastebin/pastebin.dart' as pbn;
import 'package:ocsc_exam_prep/googleSheetsAPI.dart';

import'package:ocsc_exam_prep/app_utils.dart';

import 'package:connectivity_plus/connectivity_plus.dart'; // สำหรับเชคว่าต่ออินเทอร์เน็ตหรือเปล่า

//const countDown_global = "วันมาฆะบูชา _X_ ๒๖ กุมภาพันธ์ ๒๕๖๗  _X_ 2024-02-26 00:00:01xyzวันจักรี _X_ ๘ เมษายน ๒๕๖๗  _X_ 2024-04-08 00:00:01xyzวันสงกรานต์ _X_ ๑๓ เมษายน ๒๕๖๗  _X_ 2024-04-13 00:00:01xyzวันฉัตรมงคล  _X_ ๖ พฤษภาคม ๒๕๖๗  _X_ 2024-05-06 00:00:01xyzวันวิสาบูชา _X_ ๒๒ พฤษภาคม  ๒๕๖๗  _X_ 2024-05-22 00:00:01xyzวันเฉลิมพระชนมพรรษาสมเด็จพระนางเจ้าฯ พระบรมราชินี _X_ ๓ มิถุนายน  ๒๕๖๗  _X_ 2024-06-03 00:00:01xyzวันอาสาฬหบูชา _X_ ๒๐ กรกฎาคม  ๒๕๖๗  _X_ 2024-07-20 00:00:01xyzวันเข้าพรรษา _X_ ๒๑ กรกฎาคม    ๒๕๖๗  _X_ 2024-07-21 00:00:01xyzวันเฉลิมพระชนมพรรษาพระบาทสมเด็จพระวชิรเกล้าเจ้าอยู่หัว รัชกาลที่ 10 _X_ ๒๘ กรกฎาคม  ๒๕๖๗  _X_ 2024-07-28 00:00:01xyzวันแม่แห่งชาติ &&&วันเฉลิมพระชนมพรรษา &&&สมเด็จพระนางเจ้าสิริกิติ์ พระบรมราชินีนาถ พระบรมราชชนนีพันปีหลวง _X_ ๑๒ สิงหาคม  ๒๕๖๗  _X_ 2024-08-12 00:00:01xyzวันนวมินทรมหาราช (วันคล้ายวันสวรรคต)&&& พระบาทสมเด็จพระบรมชนกาธิเบศร มหาภูมิพลอดุลยเดชมหาราช บรมนาถบพิตร _X_ ๑๓ ตุลาคม  ๒๕๖๗  _X_ 2024-10-13 00:00:01xyzวันปิยมหาราช _X_ ๒๓ ตุลาคม  ๒๕๖๗  _X_ 2024-10-23 00:00:01xyzวันพ่อแห่งชาติ  _X_ ๕ ธันวาคม  ๒๕๖๗  _X_ 2024-12-05 00:00:01xyzวันรัฐธรรมนูญ _X_ ๑๐ ธันวาคม  ๒๕๖๗  _X_ 2024-12-10 00:00:01xyzวันสิ้นปี _X_ ๓๑ ธันวาคม  ๒๕๖๗  _X_ 2024-12-31 00:00:01xyzวันขึ้นปีใหม่  _X_ ๑ มกราคม ๒๕๖๘  _X_ 2025-01-01 00:00:01";
const countDown_global = "สอบ ก.พ. e-Exam รอบที่ 6 _X_ วันที่ 26 เม.ย. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-26 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 7 _X_ วันที่ 27 เม.ย. 67 เวลา 09.00 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-27 09:00:00xyzสอบ ก.พ. e-Exam รอบที่ 8 _X_ วันที่ 27 เม.ย. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-27 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 9 _X_ วันที่ 28 เม.ย. 67 เวลา 09.00 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-28 09:00:00xyzสอบ ก.พ. e-Exam รอบที่ 10 _X_ วันที่ 28 เม.ย. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-28 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 11 _X_ วันที่ 24 พ.ค. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-24 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 12 _X_ วันที่ 25 พ.ค. 67 เวลา 09.00 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-25 09:00:00xyzสอบ ก.พ. e-Exam รอบที่ 13 _X_ วันที่ 25 พ.ค. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-25 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 14 _X_ วันที่ 26 พ.ค. 67 เวลา 09.00 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-26 09:00:00xyzสอบ ก.พ. e-Exam รอบที่ 15 _X_ วันที่ 26 พ.ค. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-26 14:30:00";
// ต้องเชคว่า สถานะการซื้อ ถ้ายังไม่ซื้อ จะมีปุ่มซื้อหรือไม่
// ใน ProviderModel ใส่ข้อมูลในตาราง hashTable เป็น true ตอนซื้อแล้ว แต่ยังไม่แน่ ว่า ถ้าไม่กดปุ่ม อันนี้จะทำงานหรือไม่
// ต้องทดสอบ ตอนส่งขึ้นจริง แล้วดูว่า ถ้ายังไม่ซื้อ จะมีปุ่มซื้อปรากฏหรือไม่
// เพราะไม่แน่ใจว่า เส้นทางไปไงมาไง เชคใน Google Play ก่อน หรือเปล่า
// คือ ถ้าดาวน์โหลดมาติดตั้งจาก play store ในตาราง hashTable และ
// ใน sharePref จะไม่มีข้อมูลเกี่ยวกับการซื้อ (sku)  จะมีปุ่มซื้อปรากฏ แต่ถ้าซื้อแล้ว
// จะเขียนข้อมูลลงตาราง hastTable แม้ว่าจะลบถอนติดตั้ง และติดตั้งใหม่ inapp purchase ก็จะ
// เขียนลงตาราง hashTable ว่าซื้อแล้ว (sku, true) เพราะตอนทดสอบ ปรากฏว่า
// ใน ProviderModel ไปที่ซื้อแล้ว แสดงว่า สันนิษฐานว่า มีการเชคจากเครื่อง -- อันนี้ จึงต้องทดสอบอีกที ตอนเอาขึ้นจริง

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

// static Future<bool> get isConfigured async =>
//     await _channel.invokeMethod('isConfigured') as bool;

}



Future main() async {

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // ),

  WidgetsFlutterBinding.ensureInitialized();

  // Save the install date if not already saved
  await AppUtils.saveFirstRunDate();

  // if (Platform.isAndroid) {
  //   await InAppWebViewController.setWebContentsDebuggingEnabled(true); // Enable WebView debugging
  // }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);  // for Edge-to-edge SDK 35

  //WidgetsFlutterBinding.ensureInitialized();
  //PlatformDispatcher.instance.onReportTimings = (_) {};

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

  // int? installDate = await getInstallDate();
  // print("App Installed Date: $installDate");

  runApp(
    const MyApp(),
  );
} // end of void main()


//
// static Future<bool> get isConfigured async =>
//     await _channel.invokeMethod('isConfigured') as bool;
//



Future<void> _configureSDK() async {
  // Enable debug logs before calling `configure`.
  await Purchases.setLogLevel(LogLevel.debug);

  /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
  PurchasesConfiguration configuration;
  if (StoreConfig.isForAmazonAppstore()) { // update เป็น รุ่น 8 ของ Revenuecat
    // เอามาจาก ตัวอย่าง ที่ https://github.com/RevenueCat/purchases-flutter/blob/main/revenuecat_examples/MagicWeather/lib/main.dart
    configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
  } else {
    configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
  }
  // if (StoreConfig.isForAmazonAppstore()) {  // รุ่น 6 ของเก่า ของ Revenuecat
  //   configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
  //     ..appUserID = null
  //    ..observerMode = false;
  //
  // } else {
  //   configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
  //     ..appUserID = null
  //  ..observerMode = false;
  // }

  await Purchases.configure(configuration);
} // end of _configureSDK()  -- revenueCat




//สำหรับ in_app_purchases  -- ถึงตงนี้  กำลังแก้ใน paymentscreen.dart ด้วย
// Auto-consume must be true on iOS.
// // To try without auto-consume on another platform, change `true` to `false` here.

//เอาออก จะใช้ของ codelabs
// final bool _kAutoConsume = Platform.isIOS || true;
//
// const String _kConsumableId = 'consumable';
// const String _kUpgradeId = 'upgrade';
// const String _kSilverSubscriptionId = 'subscription_silver';
// const String _kGoldSubscriptionId = 'subscription_gold';
// const List<String> _kProductIds = <String>[
//   _kConsumableId,
//   _kUpgradeId,
//   _kSilverSubscriptionId,
//   _kGoldSubscriptionId,
// ];

// บางที มีเมนูซ้ำกัน 3 ครั้ง รูปหน้า ก็ไม่มา *** อย่าลืมแก้  ******* แก้แล้ว เพิ่ม unique ตอนสร้างตาราง
class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {  // WidgetsBindingObserver เพื่อว่า จะได้ลบข้อมูลในกระดาษทด ตอน exit โปรแกรม

  // AppUpdateInfo? _updateInfo;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _flexibleUpdateAvailable = false;

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

  // late Future<String?> _curr_version;  // สำหรับทำ badge notification จุดแดงที่ icon แสดงว่ามี Update

  // for google sheets
  // final GoogleSheetsAPI _sheetsAPI = GoogleSheetsAPI();
  // List<Map<String, dynamic>> myGSheetData = [];


  // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
  //   android: AndroidInAppWebViewOptions(
  //     useHybridComposition: true,
  //   ),);

  // InAppWebViewSettings(
  // mediaPlaybackRequiresUserGesture: false,
  // useHybridComposition: true,
  // allowsInlineMediaPlayback: true,
  // );

  @override
  void initState() {
    super.initState();
    // checkForUpdate();
    // flexibleUpdate();

    WidgetsBinding.instance.addObserver(this);

    isAlertboxOpened = false; // preventing welcome dialog to show multiple times
    _prefs = SharedPreferences.getInstance();

    getLastDialogOpenTime();

    beachImage = Image.asset(
        "assets/images/beach04.png"); // เพื่อจะ preload รูปเข้ามาก่อน


    listPdfFiles();  // to check only
    //   aboutPageBkg = Image.asset("assets/images/page_about.png");
    // _countDownMsg = getCountDwnMsg();
    //  fetchData();
    //  flexibleUpdate();
  }

  //
  // Future<void> checkForUpdate() async {
  //   InAppUpdate.checkForUpdate().then((info) {
  //     setState(() {
  //       _updateInfo = info;
  //     });
  //  //   flexibleUpdate();
  //
  //   }).catchError((e) {
  //     showSnack(e.toString());
  //   });
  // }

  // Future<void> fetchData() async {
  //   final GSheetsData = await _sheetsAPI.fetchData();
  //   setState(() {
  //     myGSheetData = GSheetsData;
  //   });
  //  //    debugPrint("data from sheets: ${_myGSheetData[2]}");
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(beachImage.image, context);
//    precacheImage(aboutPageBkg.image, context);
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
//    getBooleanValue("is_First_Run"); // ตรวจดูเฉย ๆ ไม่ได้ทำอะไรต่อ ที่ทำจริง อยู่ใน mainMenu.dart ใช้แสดงจุดแดง isNew
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
              //    return ChangeNotifierProvider(
              //     // สำหรับ in_app purchases
              //     create: (_) => ProviderModel(),
              // child: ChangeNotifierProvider<FirebaseNotifier>(
              //     create: (_) => FirebaseNotifier(),
              //     child: ChangeNotifierProvider<DashUpgrades>(
              //       create: (context) => DashUpgrades(
              //         context.read<DashCounter>(),
              //         context.read<FirebaseNotifier>(),
              //         ),
              //       lazy: false,
              //       child: ChangeNotifierProvider<DashPurchases>(
              //         create: (context) => DashPurchases(
              //           context.read<DashCounter>(),
              //           context.read<FirebaseNotifier>(),
              //           context.read<IAPRepo>(),
              //         ),
              //         lazy: false,
              child: MaterialApp(
                title: 'OCSC Exam Prep Application',
                theme: notifier.darkTheme ? dark : light, //theme: dark,
                //home: UpgradeAlert(upgrader: Upgrader(messages: MyThaiMsgForUpgraderDialog()),

                home: MyHomePage(
                  title: 'เตรียมสอบ ก.พ. (ภาค ก.)',
                  beachImage: beachImage,
                  isDialogHidingExpired: isDialogHidingExpired, //ส่งมาจาก myApp()
                ),
              ),
            );

            //      ))));  // สลับกับบรรทัดบน ถ้า เอา คอมเม้น พวก ChangeNotifierProvider ออก
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

    // Check if 5 days have passed since the last open
    // bool isDialogHidingDaysPassed = daysDifference >= 5;

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
//
// void flexibleUpdate() {
//   _updateInfo?.updateAvailability ==
//       UpdateAvailability.updateAvailable
//       ? () {
//     InAppUpdate.startFlexibleUpdate().then((_) {
//       setState(() {
//         _flexibleUpdateAvailable = true;
//       });
//     }).catchError((e) {
//       showSnack(e.toString());
//     });
//   }
//       : null;
// }


//Future<String> getCountDwnMsg() {}
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


  // *******************************************************************************************
//  เมนูของเต็ม รวมของเก่าด้วย backup เอาไว้ที่  "C:\_flutter\bckup\main_bckup_หน้าเมนูเต็ม.txt"
// เวลาจะแก้เมนูที่มีอยู่แล้ว ต้องลบออกก่อน แล้ว run โปรแกรมใหม่ เพื่อให้ลบข้อมูลในฐานข้อมูลออกก่อน
// เสร็จแล้ว จึง paste เข้ามาใหม่ แล้วจึงแก้ ไม่งั้น ก็จะยังเป็นของเดิม เพราะไปเอาข้อมูลจากในฐานข้อมูล
// ถ้าเปลี่ยนชื่อไฟล์เฉย ๆ โดยไม่ลบของเดิมออกก่อน ก็จะไปเอาไฟล์เก่ามาแสดงเหมือนเดิม
  static const general = [
    ["ตัวอย่างข้อสอบ ของ กพ.", "label_main_ocscSample", "10012", "1", "a1.0"],
    //
    // ชื่อในเมนู - ชื่อไฟล์ - วันที่ - ประเภท - ตำแหน่งที่ปรากฎ
    [
      "ข้อสอบ จากเว็บของ กพ",
      // ชื่อที่จะปรากฏบนเมนู
      "1_ocsc_answer.xml",
      // ชื่อไฟล์ที่ใช้งาน ของเรื่องนี้
      // "1633248995",
      "1745575210",
      // เลขวันที่ epoch date สร้างด้วยไฟล์ util/find_seconds.html
      "1",
      // หน้าที่ 1 หน้า 2=อังกฤษ   3=กฎหมาย
      "a1.00"
      // ใช้เรียงลำดับ a1 คือ หน้า 1 หลังจุด ใช้เรียงแบบอักษร ไม่ใช่ตัวเลข คือ 1 > 11 > 111 > 2 > 22 > 3 ...
    ],
    // ชื่อในเมนู, ชื่อไฟล์, วันที่, ประเภท 1=ทั่วไป 2=อังกฤษ 3=กฎหมาย 4=ทำข้อสอบ, ลำดับ
    // ลำดับ ใช้้เป็น String เพราะจะได้เรียงง่าย ๆ เมื่อมีการเพิ่มหัวข้อ เช่น a1.21 -> a1.211 ->a1.22 เมื่อจะแทรก ก็กำหนดเลขให้ต่อกันไปได้ ไม่ต้องเรียงใหม่

    // เวลาเอาหัวข้อใหม่
    // 1.  ให้ ใส่ลำดับ ต่อจากลำดับที่ต้องการ โดยแทรก เช่น
    // ของเดิม เรียง a1.12 -> a1.13 -> a1.14
    // ถ้าต้องการแทรก ระหว่าง a1.12 กับ a1.13 ให้เพิ่มลำดับ เป็น a1.121
    // จะเรียงเป็น a1.12 -> a1.121 -> a1.13 -> a1.14 คือเรียงแบบตัวอักษร ไม่ใช่ตัวเลข
// 2. อย่าลืม แต่ละไฟล์ ต้องใช้ชื่อที่ไม่ซ้ำกัน เพราะใช้ชื่อ ไปค้นหาข้อมูล หาวันที่ หา isNew เป็นต้น

//ทดสอบ การส่งข้อมูล flutter-javascript
//
    //   ["ทดสอบ click", "clickTest.html", "1619737501", "1", "a1.01"],
//
//     ["เพิ่มเข้ามา dummy ทดสอบเศษส่วน", "dummy.xml", "1670311159", "1", "a1.011"], //   OK
//

//     [
//       "ทดสอบ เงื่อนไขสัญลักษณ์ katex_flutter",
//       "test_symbol_condition.xml",
//       "1654053737",
//       "1",
//       "a1.014"
//     ],

    //   ["ทดสอบ ก่อนส่ง", "new383may_to be added.xml", "1653455084", "1", "a1.011"],
    ["การคิดวิเคราะห์เชิงภาษา", "label_main_langAnlysis", "1002", "1", "a1.03"],
    ["ภาษาไทย", "label_thai", "100", "1", "a1.1"],

    //   ["ทดสอบ xml", "xml_add_new.xml", "1622276201", "1", "a1.10"],

    ["การเรียงประโยค (5 ข้อ)", "label_ordering_phrases", "1000", "1", "a1.12"],
    [
      "เทคนิคการทำข้อสอบเรียงประโยค",
      "sentence_order.html",
      "1622276201",
      "1",
      "a1.14"
    ],
    [
      "เรียงประโยค ชุดที่ 1",
      "2_th_3_word_order_1.xml",
      // "1718269548",
      "1747390641",
      "1",
      "a1.15"
    ],
    [
      "เรียงประโยค  ชุดที่ 2",
      "2_th_3_word_order_2.xml",
      "1718100908",
      "1",
      "a1.16"
    ],
    [
      "เรียงประโยค  ชุดที่ 3",
      "2_th_3_word_order_3.xml",
      "1622276204",
      "1",
      "a1.17"
    ],
    [
      "การวิเคราะห์เหตุผลเชิงภาษา\n(เงื่อนไขภาษา)  (5 ข้อ)",
      "label_thai_rationale",
      "105",
      "1",
      "a1.18"
    ],

    [
      "การตัดสินข้อสรุป เงื่อนไขภาษา",
      "true_false_cannot_say.html",
      "1704707099",
      "1",
      "a1.181"
    ],

    [
      "เงื่อนไขภาษา ชุดที่ 1",
      "1_thai_conclusion_from_text_01.xml",
      "1670839961",
      "1",
      "a1.19"
    ],
    [
      "เงื่อนไขภาษา ชุดที่ 2",
      "1_thai_conclusion_from_text_02.xml",
      "1720236920",
      "1",
      "a1.20"
    ],
    [
      "เงื่อนไขภาษา ชุดที่ 3",
      "1_thai_conclusion_from_text_03.xml",
      "1622276212",
      "1",
      "a1.21"
    ],

    [
      "บทความสั้น\n(บทความสั้น-ยาว รวมกัน ประมาณ 10 ข้อ)",
      "label_short_passages",
      "100",
      "1",
      "a1.22"
    ],
    [
      "เทคนิคการทำข้อสอบ บทความสั้น",
      "how_to_shrt_pssge.html",
      "1622276214",
      "1",
      "a1.23"
    ],
    [
      "บทความสั้น ชุดที่ 1",
      "2_th_4_short_passage_04.xml",
      "1622276215",
      "1",
      "a1.24"
    ],
    [
      "บทความสั้น ชุดที่ 2",
      "2_th_4_short_passage_02.xml",
      "1622276216",
      "1",
      "a1.25"
    ],

    [
      "บทความสั้น ชุดที่ 3",
      "2_th_4_short_passage_01.xml",
      "1622276216",
      "1",
      "a1.251"
    ],
    [
      "บทความสั้น ชุดที่ 4",
      "2_th_4_short_passage_03.xml",
      "1622276216",
      "1",
      "a1.252"
    ],

    ["บทความยาว", "label_long_passages", "100", "1", "a1.259"],

    [
      "เทคนิคการทำข้อสอบ บทความยาว",
      "2_th_5_long_passage_00_tips.html",
      "1622276218",
      "1",
      "a1.26"
    ],
    [
      "บทความยาว ชุดที่ 1",
      "2_th_5_long_passage_01.html",
      "1653524970",
      "1",
      "a1.27"
    ],
    [
      "บทความยาว ชุดที่ 2",
      "2_th_5_long_passage_02.html",
      "1622276221",
      "1",
      "a1.28"
    ],
    [
      "บทความยาว ชุดที่ 3",
      "2_th_5_long_passage_03.html",
      "1622276222",
      "1",
      "a1.29"
    ],
    [
      "บทความยาว ชุดที่ 4",
      "2_th_5_long_passage_04.html",
      "1622276223",
      "1",
      "a1.30"
    ],
    [
      "บทความยาว ชุดที่ 5",
      "2_th_5_long_passage_05.html",
      "1622276234",
      "1",
      "a1.31"
    ],
    [
      "บทความยาว ชุดที่ 6 ",
      "2_th_5_long_passage_06.html",
      "1622276225",
      "1",
      "a1.32"
    ],

    ["บทความยาว", "label_long_passages", "100", "1", "a1.27"],
    [
      "เทคนิคการทำข้อสอบ บทความยาว",
      "2_th_5_long_passage_00_tips.html",
      "1622276218",
      "1",
      "a1.33"
    ],
    [
      "บทความยาว ชุดที่ 1",
      "2_th_5_long_passage_01.html",
      "1653524970",
      "1",
      "a1.34"
    ],
    [
      "บทความยาว ชุดที่ 2",
      "2_th_5_long_passage_02.html",
      "1622276221",
      "1",
      "a1.35"
    ],
    [
      "บทความยาว ชุดที่ 3",
      "2_th_5_long_passage_03.html",
      "1622276222",
      "1",
      "a1.36"
    ],
    [
      "บทความยาว ชุดที่ 4",
      "2_th_5_long_passage_04.html",
      "1622276223",
      "1",
      "a1.37"
    ],
    [
      "บทความยาว ชุดที่ 5",
      "2_th_5_long_passage_05.html",
      "1622276234",
      "1",
      "a1.38"
    ],
    [
      "บทความยาว ชุดที่ 6 ",
      "2_th_5_long_passage_06.html",
      "1622276225",
      "1",
      "a1.39"
    ],

    ["การคิดวิเคราะห์เชิงนามธรรม", "label_main_abstract", "100", "1", "a1.390"],
    [
      "การหาความสัมพันธ์ ของคำ\nข้อความ อุปมาอุปไมย  (5 ข้อ)",
      "label_metaphore",
      "10011",
      "1",
      "a1.40"
    ],
    [
      "หลักการทำข้อสอบ อุปมาอุปไมย",
      "1_metaphor_lang_00.html",
      "1622276232",
      "1",
      "a1.41"
    ],
    [
      "คำลักษณนาม ที่ควรรู้ ",
      "character_of_nouns.html",
      "1746747678",
      "1",
      "a1.42"
    ],
    [
      "คำอุปมาอุปไมย ที่ควรรู้ ",
      "1_metaphor_lang_01_with_search.html",
      "1622276233",
      "1",
      "a1.421"
    ],

    [
      "อุปมาอุปไมย ชุดที่ 1 ",
      "1_metaphor_lang_04.xml",
      "1746773195",
      "1",
      "a1.43"
    ],
    [
      "อุปมาอุปไมย ชุดที่ 2 ",
      "1_metaphor_lang_01.xml",
      "1622276235",
      "1",
      "a1.44"
    ],
    [
      "อุปมาอุปไมย ชุดที่ 3",
      "1_metaphor_lang_02.xml",
      "1622276236",
      "1",
      "a1.45"
    ],
    [
      "อุปมาอุปไมย ชุดที่ 4 ",
      "1_metaphor_lang_03.xml",
      "1622276237",
      "1",
      "a1.46"
    ],
    // [
    //   "สำนวน-คำเปรียบเทียบ",
    //   "1_metaphor_lang_01_with_search.html",
    //   "1684709817",
    //   "1",
    //   "a1.461"
    // ],
    // [
    //   "สำนวนสุภาษิต ชุดที่ 1",
    //   "1_thai_reasoning_01.xml",
    //   "1622276240",
    //   "1",
    //   "a1.47"
    // ],
    // [
    //   "สำนวนสุภาษิต ชุดที่ 2",
    //   "1_thai_reasoning_02.xml",
    //   "1622276241",
    //   "1",
    //   "a1.48"
    // ],

    [
      "การคิดวิเคราะห์เชิงปริมาณ",
      "label_main_quantitative_analysis",
      "100",
      "1",
      "a1.49"
    ],
    //

    ["อนุกรม (5 ข้อ)", "label_num_reasoning", "100", "1", "a1.492"],
    [
      "หลักการทำข้อสอบ อนุกรม",
      "1_num_reasng_00_tips.html",
      "1622276244",
      "1",
      "a1.50"
    ],
    [
      "แบบฝึกข้อสอบอนุกรม",
      "sequential_num_exercise.html",
      "1661142042",
      "1",
      "a1.501"
    ],

    ["อนุกรม ชุดที่ 1", "1_num_reasng_01.xml", "1747262051", "1", "a1.51"],
    ["อนุกรม ชุดที่ 2", "1_num_reasng_02.xml", "1654404665", "1", "a1.52"],
    ["อนุกรม ชุดที่ 3", "1_num_reasng_03.xml", "1622276247", "1", "a1.53"],
    ["อนุกรม ชุดที่ 4", "1_num_reasng_04.xml", "1622276248", "1", "a1.54"],
    ["อนุกรม ชุดที่ 5", "1_num_reasng_05.xml", "1622276249", "1", "a1.55"],
    ["อนุกรม ชุดที่ 6", "1_num_reasng_06.xml", "1622276250", "1", "a1.56"],
    ["อนุกรม ชุดที่ 7", "1_num_reasng_07.xml", "1654404665", "1", "a1.57"],
    //
    ["เงื่อนไขสัญลักษณ์ (10 ข้อ)", "label_symbol", "100", "1", "a1.58"],
    [
      "หลักการทำข้อสอบ เงื่อนไขสัญลักษณ์ ",
      "1_symbol_cndtng_00.html",
      "1622276253",
      "1",
      "a1.59"
    ],

    [
      "แบบฝึกหัด เงื่อนไขสัญลักษณ์ ",
      "symbol_cndtng_exercise.html",
      "1681204126",
      "1",
      "a1.591"
    ],

    [
      "เงื่อนไขสัญลักษณ์  ชุดที่ 1 ",
      "1_symbol_cndtng_01.xml",
      "1747713165",
      "1",
      "a1.60"
    ],
    [
      "เงื่อนไขสัญลักษณ์  ชุดที่ 2 ",
      "1_symbol_cndtng_02.xml",
      "1654404665",
      "1",
      "a1.61"
    ],
    [
      "เงื่อนไขสัญลักษณ์  ชุดที่ 3  ",
      "1_symbol_cndtng_03.xml",
      "1622276255",
      "1",
      "a1.62"
    ],

    ["คณิตศาสตร์ทั่วไป  (5 ข้อ) ", "label_basic_math", "100", "1", "a1.621"],
    [
      "ร้อยละ-อัตราส่วน",
      "1_gen_math_04_percent_ratio.xml",
      "1622276276",
      "1",
      "a1.63"
    ],

    ["คิดลัด ร้อยละ", "1_percent_shortcut.html", "1641015648", "1", "a1.631"],

    [
      "ความเร็ว-เวลา-ระยะทาง",
      "1_gen_math_06_speed_time_distance.xml",
      "1622276277",
      "1",
      "a1.64"
    ],
    // ["กระแสน้ำ", "1_gen_math_07_current.xml", "1622276278", "1", "a1.65"],
    ["แบบฝึกเลขยกกำลัง", "exponent_exercise.html", "1666167001", "1", "a1.651"],

    ["แบบฝึกโอเปอเรชั่น", "operate_exercise.html", "1655796937", "1", "a1.652"],
    ["โอเปอเรชั่น", "1_gen_math_operate_01.xml", "1712817896", "1", "a1.66"],
    [
      "ตัวอย่างโจทย์และวิธีคิด กำไร ร้อยละ",
      "1_sales_problem_sample.html",
      "1653653059",
      "1",
      "a1.67"
    ],
    ["โจทย์สมการ", "1_gen_math_05_equation.xml", "1681252051", "1", "a1.671"],
    ["ค.ร.น./ห.ร.ม", "1_gen_math_01_lcm_gcd.xml", "1622276272", "1", "a1.672"],
    [
      "บัญญัติไตรยางค์",
      "1_gen_math_03_rule_of_three.xml",
      "1646718720",
      "1",
      "a1.673"
    ],

    [
      "โจทย์คละคณิตศาสตร์",
      "1_gen_math_02_misc_01.xml",
      "1747540860",
      "1",
      "a1.68"
    ],

    ["ตารางข้อมูล  (5 ข้อ)", "label_data_chart", "100", "1", "a1.69"],
    [
      "เทคนิคการทำข้อสอบ ตาราง",
      "solving_table_problems.html",
      "1660192837",
      "1",
      "a1.70"
    ],
    ["แบบฝึกตารางข้อมูล", "table_exercise.html", "1632538220", "1", "a1.701"],
    [
      "วิเคราะห์ข้อมูล-ตาราง ชุดที่ 1",
      "1_graph_chart_table_02.html",
      "1632538219",
      "1",
      "a1.702"
    ],
    [
      "วิเคราะห์ข้อมูล-ตาราง ชุดที่ 2",
      "1_graph_chart_table_03.html",
      "1683532682",
      "1",
      "a1.703"
    ],

    [
      "ฝึกข้อสอบเสมือนจริง จับเวลา",
      "label_main_mathAuthenticTestExercise",
      "100",
      "1",
      "a1.80"
    ],
    [
      "คณิตศาสตร์ \n8 ปี (2559-2566)",
      "realTest_math_exercise.html",
      "1712114055",
      "1",
      "a1.801"
    ],
    [
      "คณิตศาสตร์ ปี 2567-2568",
      "realTest_math_exercise_2.html",
      "1717667201",
      "1",
      "a1.8011"
    ],

    [
      "อุปมา-อุปไมย",
      "realTest_thai_metaphor_exercise.html",
      "1712114054",
      "1",
      "a1.802"
    ],

    // [
    //   "วิดีโอจาก YouTube",
    //   "label_main_video_youtube_math",
    //   "100",
    //   "1",
    //   "a1.803"
    // ],
    // //  ทดลองเรียก วิดีโอจาก youTube -- มี error แต่ก็ยังเอาใช้งาน  =====OK====
    //   [
    //     "วิดีโอ YouTube คณิตศาสตร์",
    //     "youtube_math",
    //     "1731016756",
    //     "1",
    //     "a1.8031"
    //   ],

//    เสริมพื้นฐาน  อาจจะออก -------------------  ++++++++  ------------------  อาจจะออก -----------
//    เสริมพื้นฐาน  อาจจะออก -------------------  ++++++++  ------------------  อาจจะออก -----------
//    เสริมพื้นฐาน  อาจจะออก -------------------  ++++++++  ------------------  อาจจะออก -----------
//
//     [
//       "เนื้อหาเพิ่มเติม เสริมพื้นฐาน ประสบการณ์",
//       "label_main_extra_contents",
//       "100",
//       "1",
//       "a1.71"
//     ],
//
//     [
//       "เทคนิคการทำข้อสอบ ภาษาไทย",
//       "tips_for_thai_test.html",
//       "1622276191",
//       "1",
//       "a1.72"
//     ],
//
//     [
//       "คำภาษาไทย ยุคใหม่ ที่มักเขียนผิด",
//       "modern_thai_words_often_misspelled.html",
//       "1622276194",
//       "1",
//       "a1.73"
//     ],
//
//     [
//       "การใช้คำให้ถูกต้องตามหลักภาษา",
//       "label_fill_in_blanks",
//       "1001",
//       "1",
//       "a1.74"
//     ],
//     [
//       "เติมคำในช่องว่าง ชุดที่ 1",
//       "2_th_1_word2.xml",
//       "1622276206",
//       "1",
//       "a1.75"
//     ], // ไม่มี
//     [
//       "เติมคำในช่องว่าง ชุดที่ 2",
//       "2_th_1_word3.xml",
//       "162237620",
//       "1",
//       "a1.76"
//     ],
//     [
//       "เติมคำในช่องว่าง ชุดที่ 3 ",
//       "2_th_1_word4.xml",
//       "1622276199",
//       "1",
//       "a1.77"
//     ],
//
//     ["ข้อบกพร่องทางภาษา", "label_thai_grammar", "100", "1", "a1.7701"],
//     [
//       "ข้อบกพร่องทางภาษา ชุดที่ 1",
//       "2_th_2_sentence1.xml",
//       "1622276206",
//       "1",
//       "a1.78"
//     ],
//     [
//       "ข้อบกพร่องทางภาษา ชุดที่ 2",
//       "2_th_2_sentence2.xml",
//       "1622276207",
//       "1",
//       "a1.79"
//     ],
//
//     [
//       "ฝึกคิดคณิตศาสตร์ (สดมภ์) ชุดที่ 2",
//       "1_columns_02.html",
//       "1653259542",
//       "1",
//       "a1.80"
//     ],
//     [
//       "หลักคิดลัด โจทย์สมการ",
//       "linear_equations_tricks.html",
//       "1622276269",
//       "1",
//       "a1.81"
//     ],
//     [
//       "แบบฝึกคิดลัดแก้สมการ",
//       "1_gen_math_06_equation.xml",
//       "1622276270",
//       "1",
//       "a1.82"
//     ],
//
//     ["คิดลัด ร้อยละ", "1_percent_shortcut.html", "1641015648", "1", "a1.86"],
//
//     ["กราฟ แผนภูมิ", "1_graph_chart_table_01.html", "1641015648", "1", "a1.87"],
    //
    // [
    //   "พี่นุช ติวสอบ ก.พ. ภาคพิเศษ ปี 63 (YouTube)",
    //   "https://www.youtube.com/watch?v=mzjmUsZxmWQ",
    //   "1718415320",
    //   "1",
    //   "a1.933"
    // ],
  ];
  static const english = [
    //   ["เทคนิคทำข้อสอบ กพ", "label_main_tips_and_tricks", "100", "2", "a2.00"],
    // [
    //   "The Master แนะเทคนิคทำ อังกฤษ ง่าย ๆ สำหรับคนที่ไม่มีพื้นฐานอังกฤษ พร้อมสอน grammar vocab reading และ conversation(YouTube)",
    //   "https://www.youtube.com/watch?v=5-I1AQMN60E&t=1820",
    //   "100",
    //   "2",
    //   "a2.01"
    // ],
    // [
    //   "ดร.หญิง ธิติญา แนะเทคนิคสุดปัง! ทำข้อสอบ ก.พ. ภาษาอังกฤษ (YouTube)",
    //   "https://www.youtube.com/watch?v=kZsgvzHJOv8",
    //   "100",
    //   "2",
    //   "a2.02"
    // ],
    ["แนวข้อสอบ บทสนทนา", "label_main_conversation", "100", "2", "a2.10"],
    ["บทสนทนา ชุดที่ 1", "3_en_convr_easy_01.xml", "1622276250", "2", "a2.11"],
    ["บทสนทนา ชุดที่ 2", "3_en_convr_easy_02.xml", "1622276246", "2", "a2.12"],
    ["บทสนทนา ชุดที่ 3", "3_en_convr_easy_001.xml", "1622276245", "2", "a2.13"],
    ["บทสนทนา ชุดที่ 4", "3_en_convr_easy_04.xml", "1622276246", "2", "a2.14"],
    [
      "บทสนทนา ชุดที่ 5",
      "3_en_convr_normal_01.xml",
      "1622276247",
      "2",
      "a2.15"
    ],
    ["บทสนทนา ชุดที่ 6", "3_en_long_cnvr_01.html", "1622276248", "2", "a2.16"],
    ["บทสนทนา ชุดที่ 7", "3_en_long_cnvr_02.html", "1622276249", "2", "a2.17"],
    ["บทสนทนา ชุดที่ 8", "3_en_long_cnvr_03.html", "1622276250", "2", "a2.18"],
    ["บทสนทนา ชุดที่ 9", "3_en_long_cnvr_04.html", "1622276251", "2", "a2.19"],
    ["บทสนทนา ชุดที่ 10", "3_en_long_cnvr_05.html", "1622276252", "2", "a2.20"],
    ["บทสนทนา ชุดที่ 11", "3_en_long_cnvr_06.html", "1622276253", "2", "a2.21"],
    [
      "บทสนทนา ชุดที่ 12 ",
      "3_en_long_cnvr_07.html",
      "1622276254",
      "2",
      "a2.22"
    ],
    [
      "บทสนทนา ชุดที่ 14 (ข้อสอบเสมือนจริง)",
      "3_en_long_cnvr_09.html",
      "1669530226",
      "2",
      "a2.221"
    ],
    ["บทสนทนา แนวข้อสอบจริง 2568 ชุดที่ 1", "3_en_long_cnvr_realTest_like_1.html", "1745114937", "2", "a2.222"],
    ["บทสนทนา แนวข้อสอบจริง 2568 ชุดที่ 2", "3_en_long_cnvr_realTest_like_2.html", "1745114937", "2", "a2.223"],

    ["คำศัพท์", "label_main_eng_vocab", "100", "2", "a2.23"],
    [
      "คำศัพท์ภาษาอังกฤษที่ควรรู้จัก",
      "vocab_study.html",
      "1619737502",
      "2",
      "a2.231"
    ],
    [
      "คำภาษาอังกฤษที่มักใช้ผิด",
      "commonly_confused_words_with_search.html",
      "1668749358",
      "2",
      "a2.232"
    ],

    [
      "กริยาวลี (Phrasal Verbs)",
      "3_en_phrasal_verbs.html",
      "1622276256",
      "2",
      "a2.24"
    ],
    ["คำศัพท์ ชุดที่ 1", "3_en_vocab_01.xml", "1746490140", "2", "a2.25"],
    ["คำศัพท์ ชุดที่ 2", "3_en_vocab_02.xml", "1622276258", "2", "a2.26"],
    ["คำศัพท์ ชุดที่ 3", "3_en_vocab_03.xml", "1622276259", "2", "a2.27"],
    [
      "คำศัพท์ ชุดที่ 4: Odd One Out",
      "3_en_vocab_04.xml",
      "1622276260",
      "2",
      "a2.28"
    ],
    [
      "คำศัพท์ ชุดที่ 5: Phrasal Verbs",
      "3_en_phrasal_verbs_01.xml",
      "1622276261",
      "2",
      "a2.29"
    ],
    // [
    //   "พี่แมง ป. ศัพท์อังกฤษ ก.พ. 600 คำ ที่ออกสอบบ่อย (มีเอกสารแจกฟรี)  ep1/6 (YouTube)",
    //   "https://www.youtube.com/watch?v=f55XcXO9yww&t=2399s",
    //   "1622276261",
    //   "2",
    //   "a2.291"
    // ],
    // [
    //   "พี่แมง ป. ศัพท์อังกฤษที่ออกสอบบ่อย ep2/6 (YouTube)",
    //   "https://www.youtube.com/watch?v=lVWa1_rL0P4&t=77s",
    //   "1622276261",
    //   "2",
    //   "a2.292"
    // ],
    // [
    //   "พี่แมง ป. ศัพท์อังกฤษที่ออกสอบบ่อย ep3/6 (YouTube)",
    //   "https://www.youtube.com/watch?v=PI7hqH8yWNw&t=45s",
    //   "1622276261",
    //   "2",
    //   "a2.293"
    // ],
    // [
    //   "พี่แมง ป. ศัพท์อังกฤษที่ออกสอบบ่อย ep4/6 (YouTube)",
    //   "https://www.youtube.com/watch?v=_lBFC8qs7vM",
    //   "1622276261",
    //   "2",
    //   "a2.294"
    // ],
    // [
    //   "พี่แมง ป. ศัพท์อังกฤษที่ออกสอบบ่อย ep5/6 (YouTube)",
    //   "https://www.youtube.com/watch?v=ZaDMGuzwdkI",
    //   "1622276261",
    //   "2",
    //   "a2.295"
    // ],
    // [
    //   "พี่แมง ป. ศัพท์อังกฤษที่ออกสอบบ่อย ep6/6 (YouTube)",
    //   "https://www.youtube.com/watch?v=wszNjiS32Xc",
    //   "1622276261",
    //   "2",
    //   "a2.296"
    // ],
    // [
    //   "พี่รวิ ติวศัพท์อังกฤษ ก.พ. ข้อสอบเสมือนจริง (YouTube)",
    //   "https://www.youtube.com/watch?v=9oZvyGzi3qo",
    //   "1622276261",
    //   "2",
    //   "a2.297"
    // ],
    ["สรุป/ทบทวน Grammar", "label_main_eng_grammar", "100", "2", "a2.30"],
    [
      "Parts of Speech",
      "3_en_parts_of_speech.html",
      "1622276263",
      "2",
      "a2.31"
    ],
    ["Tenses", "3_en_tense_review.html", "1622276264", "2", "a2.32"],
    // [
    //   "ครูหวาน สรุปเรื่อง Tenses (YouTube)",
    //   "https://www.youtube.com/watch?v=1lJDJFZ82R0",
    //   "1642473370",
    //   "2",
    //   "a2.321"
    // ],
    ["If Clause", "3_en_con_if_review.html", "1622276265", "2", "a2.33"],
    [
      "Active/Passive Voice",
      "3_en_passive_voice_review.html",
      "1622276266",
      "2",
      "a2.34"
    ],
    [
      "การใช้ Infinitive และ Gerund",
      "3_en_infinitive_gerund.html",
      "1622276267",
      "2",
      "a2.35"
    ],
    [
      "แบบฝึกหัด Infinitive และ Gerund",
      "3_en_infinitive_gerund_exercise.html",
      "1622276268",
      "2",
      "a2.36"
    ],
    [
      "การใช้ a, an และ the",
      "3_en_article_review.html",
      "1622276269",
      "2",
      "a2.37"
    ],
    // [
    //   "ติวเตอร์ติด bangkoklawtutor ติว Grammar กพ",
    //   "https://www.youtube.com/watch?v=lCNboxbyxAo",
    //   "1622276269",
    //   "2",
    //   "a2.371"
    // ],
    ["แนวข้อสอบ Grammar", "label_main_eng__grammar_tests", "100", "2", "a2.38"],
    // ["ข้อสอบเสมือนจริง Grammar 2567-2568", "3_en_grammar_01.xml", "1743807250", "2", "a2.381"],
    ["แนวข้อสอบ Grammar 01", "3_en_grmmr_01.xml", "1622276271", "2", "a2.39"],
    ["แนวข้อสอบ Grammar 02", "3_en_grmmr_02.xml", "1622276272", "2", "a2.40"],
    [
      "แนวข้อสอบ Tense_ชุดที่_1",
      "3_en_tense_01.xml",
      "1622276273",
      "2",
      "a2.41"
    ],
    [
      "แนวข้อสอบ Tense_ชุดที่_2",
      "3_en_tense_02.xml",
      "1667696787",
      "2",
      "a2.42"
    ],
    [
      "แนวข้อสอบ Infinitive vs Gerund_1",
      "3_en_infinitive_01.xml",
      "1622276275",
      "2",
      "a2.43"
    ],
    [
      "แนวข้อสอบ Infinitive vs Gerund_2",
      "3_en_infinitive_02.xml",
      "1622276276",
      "2",
      "a2.44"
    ],
    ["จดหมาย", "label_main_eng_letters", "100", "2", "a2.45"],
    ["จดหมาย 1: letter of complaint", "3_en_lttr_06.html", "1744861887", "2", "a2.451"],
    ["จดหมาย 2: บันทึกข้อความเชิญประชุม", "3_en_memo_review_project.html", "1622276278", "2", "a2.452"],
    ["จดหมาย 3", "3_en_lttr_01.html", "1622276278", "2", "a2.46"],
    ["จดหมาย 4", "3_en_lttr_02.html", "1622276279", "2", "a2.47"],
    ["จดหมาย 5", "3_en_lttr_03.html", "1622276280", "2", "a2.48"],
    ["จดหมาย 6", "3_en_lttr_04.html", "1622276281", "2", "a2.49"],
    ["จดหมาย 7", "3_en_lttr_05.html", "1622276282", "2", "a2.50"],
    ["จดหมาย 8: จดหมายเลื่อนตำแหน่ง", "3_en_promotion_lettrs.html", "1622276283", "2", "a2.501"],


    ["แนวข้อสอบ Reading", "label_main_eng_reading", "100", "2", "a2.51"],

    //*****************
    [
      "ข้อสอบ Reading: Healthy Food",
      "3_en_shrt_healthy_food.html",
      "1742107002",
      "2",
      "a2.51001"
    ],
    [
      "ข้อสอบ Reading: Earthquakes",
      "3_en_lng_earthquake.html",
      "1745148052",
      "2",
      "a2.510011"
    ],

    [
      "ข้อสอบ Reading: Screen Time",
      "3_en_lng_screen_time_b1.html",
      "1742107002",
      "2",
      "a2.5101"
    ],
    [
      "ข้อสอบ Reading: Screen Time (ศัพท์ยากขึ้น)",
      "3_en_lng_screen_time_b2.html",
      "1742107002",
      "2",
      "a2.5102"
    ],
    [
      "ข้อสอบ Reading ชุดที่ 1: Artificial Intelligence",
      "3_en_long_pssge_07.html",
      "1742107002",
      "2",
      "a2.511"
    ],
    [
      "ข้อสอบ Reading ชุดที่ 2: COVID-19",
      "3_en_long_pssge_03.html",
      "1622276284",
      "2",
      "a2.52"
    ],
    [
      "ข้อสอบ Reading ชุดที่ 3",
      "3_en_long_pssge_04.html",
      "1622276285",
      "2",
      "a2.53"
    ],
    [
      "ข้อสอบ Reading ชุดที่ 4",
      "3_en_long_pssge_01.html",
      "1622276286",
      "2",
      "a2.54"
    ],
    [
      "ข้อสอบ Reading ชุดที่ 5",
      "3_en_long_pssge_02.html",
      "1622276287",
      "2",
      "a2.55"
    ],
    [
      "ข้อสอบ Reading ชุดที่ 6",
      "3_en_long_pssge_05.html",
      "1622276288",
      "2",
      "a2.56"
    ],
    [
      "ข้อสอบ Reading ชุดที่ 7",
      "3_en_long_pssge_06.html",
      "1622276289",
      "2",
      "a2.57"
    ],
    [
      "ข้อสอบ Reading ชุดที่ 8 AI: A Double-Edged Sword",
      "3_en_long_pssge_08.html",
      "1742114839",
      "2",
      "a2.58"
    ],
    // ****************


    // [
    //   "พี่รวิ พาฝึกทำโจทย์ Reading (YouTube) ",
    //   "https://www.youtube.com/watch?v=ZYWMD2B3-q0",
    //   "1622276295",
    //   "2",
    //   "a2.571"
    // ],
    // [
    //   "พี่แมง ป. ติว Reading (YouTube) ",
    //   "https://www.youtube.com/watch?v=MwtkSb3hV60",
    //   "1622276295",
    //   "2",
    //   "a2.5711"
    // ],
    // [
    //   "พี่รวิ เฉลยข้อสอบเสมือนจริง อังกฤษ ก.พ. ปี 62 (YouTube)",
    //   "https://www.youtube.com/watch?v=bZpYcozxGMk",
    //   "1622276289",
    //   "2",
    //   "a2.572"
    // ],
    // [
    //   "พี่แมง ป. ติวภาษาอังกฤษ ข้อสอบเสมือนจริง (YouTube)",
    //   "https://www.youtube.com/watch?v=Oq0ocanZZCs",
    //   "1622276289",
    //   "2",
    //   "a2.573"
    // ],
    // [
    //   "พี่เกด  เฉลยภาษาอังกฤษข้อสอบ ก.พ. (YouTube)",
    //   "https://www.youtube.com/watch?v=4ajcme8fxZA",
    //   "1622276289",
    //   "2",
    //   "a2.574"
    // ],
  ];

  static const law = [
    ["ระเบียบบริหารราชการแผ่นดิน", "label_main_governance", "100", "3", "a3.10"],
    [
      "พ.ร.บ. ระเบียบบริหารราชการแผ่นดิน พ.ศ. ๒๕๓๔ (แก้ไขเพิ่มเติม ถึง ปัจจุบัน)",
      "5_1_1_state_admin_regulation.html",
      "1622276292",
      "3",
      "a3.11"
    ],
    [
      // ไฟล์ ถาม-ตอบ ที่ใช้ javascript ให้ต่อท้ายด้วยคำว่า exercise เพราะ จะได้แสดง help icon บน app bar เพื่อบอก วิธีการเลื่อนข้อไปข้ออื่น ๆ
      "ถาม-ตอบ พ.ร.บ. ระเบียบบริหารราชการแผ่นดิน",
      "q-and-a_good_govt_exercise.html",
      "1622276292",
      "3",
      "a3.111"
    ],
    [
      "แนวข้อสอบ ระเบียบบริหารราชการแผ่นดิน",
      "label_governance_questions",
      "100",
      "3",
      "a3.12"
    ],
    [
      "แนวข้อสอบระเบียบบริหารราชการแผ่นดิน ชุดที่ 1",
      "5_1_2_state_admin_reg_1.xml",
      "1747540659",
      "3",
      "a3.13"
    ],
    [
      "แนวข้อสอบระเบียบบริหารราชการแผ่นดิน ชุดที่ 2",
      "5_1_3_state_admin_reg_2.xml",
      "1622276296",
      "3",
      "a3.14"
    ],

    // [
    //   "LAW by Aun เฉลยแนวข้อสอบระเบียบบริหารราชการแผ่นดิน 50 ข้อ (YouTube)",
    //   "https://www.youtube.com/watch?v=JkZK3WXTEps",
    //   "1622276296",
    //   "3",
    //   "a3.141"
    // ],
    // [
    //   "พี่น็อต GoodBrain ติวระเบียบบริหารราชการแผ่นดิน (YouTube)",
    //   "https://www.youtube.com/watch?v=8BJw0kIST14",
    //   "1622276296",
    //   "3",
    //   "a3.142"
    // ],
    [
      "หลักการบริหารกิจการบ้านเมืองที่ดี",
      "label_main_good_governance",
      "100",
      "3",
      "a3.15"
    ],
    [
      "พระราชกฤษฎีกา ว่าด้วยหลักเกณฑ์และวิธีการบริหารกิจการบ้านเมืองที่ดี พ.ศ. ๒๕๔๖",
      "5_2_1_good_governance.html",
      "1622276296",
      "3",
      "a3.16"
    ],
    [
      "พระราชกฤษฎีกา ว่าด้วยหลักเกณฑ์และวิธีการบริหารกิจการบ้านเมืองที่ดี (ฉบับที่ ๒) พ.ศ. ๒๕๖๒",
      "5_2_1_(2)_good_governance.html",
      "1622276296",
      "3",
      "a3.161"
    ],

    [
      "สรุป พ.ร.ฎ. หลักเกณฑ์และวิธีการบริหารกิจการบ้านเมืองที่ดี",
      "goodGvnce_gist.html",
      "1689929515",
      "3",
      "a3.1611"
    ],

    [
      // ไฟล์ ถาม-ตอบ ที่ใช้ javascript ให้ต่อท้ายด้วยคำว่า exercise เพราะ จะได้แสดง help icon บน app bar เพื่อบอก วิธีการเลื่อนข้อไปข้ออื่น ๆ
      "ถาม-ตอบ พ.ร.ฎ. ว่าด้วยหลักเกณฑ์และวิธีการบริหารกิจการบ้านเมืองที่ดี ",
      "q-and-a_good_govt_principles_exercise.html",
      "1657263383",
      "3",
      "a3.162"
    ],
    [
      "แนวข้อสอบ หลักการบริหารกิจการบ้านเมืองที่ดี",
      "label_good_governance_questions",
      "100",
      "3",
      "a3.17"
    ],
    [
      "แนวข้อสอบหลักการบริหาร ฯ  ชุดที่ 1",
      "5_2_2_good_governance_1.xml",
      "1653770277",
      "3",
      "a3.18"
    ],
    [
      "แนวข้อสอบหลักการบริหาร ฯ ชุดที่ 2",
      "5_2_3_good_governance_2.xml",
      "1622276296",
      "3",
      "a3.19"
    ],
    [
      "วิธีปฏิบัติราชการทางปกครอง",
      "label_main_practical_rules",
      "100",
      "3",
      "a3.20"
    ],
    [
      "พระราชบัญญัติ วิธีปฏิบัติราชการทางปกครอง พ.ศ. ๒๕๓๙ และที่แก้ไขเพิ่มเติม",
      "5_3_1_administrative_procedure.html",
      "1622276296",
      "3",
      "a3.21"
    ],

    [
      "กฎกระทรวง กําหนดกรณีอื่นที่เจ้าหน้าที่จะทําการพิจารณาทางปกครองไม่ได้ พ.ศ. ๒๕๖๖",
      "5_3_1_administrative_procedure_2566.html",
      "1687169108",
      "3",
      "a3.210"
    ],

    //  PDF OK OK  OK  OK  OK  OK
    // [
    //   "ความรับผิดทางละเมิดของเจ้าหน้าที่ \nโดย สำนักความรับผิดทางแพ่ง ร่วมกับ สำนักงานคลังเขต 7",
    //   "violation_explained.pdf",
    //   "1695720516",
    //   "3",
    //   "a3.2101"
    // ],

    [
      "สรุป สาระสำคัญ พระราชบัญญัติ วิธีปฏิบัติราชการทางปกครอง",
      "guideline_for_issuing_official_order_act.html",
      "1658975827",
      "3",
      "a3.211"
    ],
    [
      "ตัวอย่างคำสั่งทางปกครอง",
      "adminstrative-order-explained.html",
      "1727038495",
      "3",
      "a3.2111"
    ],
    [
      "ถาม-ตอบ พ.ร.บ. วิธีปฏิบัติราชการทางปกครอง",
      "q-and-a_practice_law_exercise.html",
      "1662528452",
      "3",
      "a3.212"
    ],
    [
      "แนวข้อสอบ วิธีปฏิบัติราชการทางปกครอง",
      "label_practical_rules_questions",
      "100",
      "3",
      "a3.22"
    ],
    [
      "แนวข้อสอบ วิธีปฏิบัติราชการทางปกครอง ชุดที่ 1",
      "5_3_2_administrative_procedure_1.xml",
      "1683351672",
      "3",
      "a3.221"
    ],
    [
      "แนวข้อสอบ วิธีปฏิบัติราชการทางปกครอง ชุดที่ 2",
      "5_3_3_administrative_procedure_2.xml",
      "1622276296",
      "3",
      "a3.23"
    ],

    // [
    //   "การปฏิบัติราชการทางอิเล็กทรอนิกส์ ๒๕๖๕",
    //   "label_main_electornics_act",
    //   "100",
    //   "3",
    //   "a3.24"
    // ],
    //
    //
    //
    //
    // [
    //   "พรบ การปฏิบัติราชการทางอิเล็กทรอนิกส์ พ.ศ. ๒๕๖๕",
    //   "5_3_4_electornics_act.html",
    //   "1667027445",
    //   "3",
    //   "a3.25"
    // ],

    // // [
    // //   "พี่แมง ป. เฉลยแนวข้อสอบ วิชา พ.ร.บ.วิธีปฎิบัติราชการทางปกครอง (YouTube)",
    // //   "https://www.youtube.com/watch?v=tS3vUgdkx_w",
    // //   "1622276296",
    // //   "3",
    // //   "a3.231"
    // // ],

    //  ทดลองเรียก วิดีโอจาก youTube -- มี error เลยยังไม่เอา
    //   [
    //     "YouTube Video Lessons",
    //     "https://www.youtube.com/watch?v=GbIdCuqNHrQ",
    //     "1622276296",
    //     "3",
    //     "a3.232"
    //   ],

    // //  ทดลองเรียก วิดีโอจาก youTube -- มี error แต่ก็ยังเอาใช้งาน  =====OK====
    //   [
    //     "วิดีโอ กฎหมาย บย youTube",
    //     "youtube_law",
    //     "1622276296",
    //     "3",
    //     "a3.2321"
    //   ],

    // ["ลิงค์", "label_links", "100", "3", "a3.24"],  //Flutter เปิด pdf ไม่สะดวก ถ้าลิงค์ไปเว็บไซต์ OK
    // [
    //   "youTube อัตราส่วน",
    //   "https://www.youtube.com/watch?v=1lJDJFZ82R0",
    //   "1622276296",
    //   "3",
    //   "a3.25"
    // ],
    [
      "หน้าที่และความรับผิดในการปฏิบัติหน้าที่ราชการ",
      "label_main_responsibility",
      "100",
      "3",
      "a3.26"
    ],

    [
      "พระราชบัญญัติ ความรับผิดทางละเมิดของเจ้าหน้าที่ พ.ศ. ๒๕๓๙",
      "5_4_1_violation_penalty.html",
      "1622276296",
      "3",
      "a3.28"
    ],
    //
    // [
    //   "พี่น็อต GoodBrain ติว พ.ร.บ.ความรับผิดทางละเมิดของเจ้าหน้าที่",
    //   "https://www.youtube.com/watch?v=HHvE9mctV0E",
    //   "1622276296",
    //   "3",
    //   "a3.281"
    // ],

    [
      "สาระสำคัญของ พ.ร.บ. ความรับผิดทางละเมิดของเจ้าหน้าที่",
      "5_4_2_violation_penalty_gist.html",
      "1622276296",
      "3",
      "a3.29"
    ],
    [
      "ระเบียบสำนักนายกรัฐมนตรีว่าด้วยหลักเกณฑ์การปฏิบัติเกี่ยวกับความรับผิดทางละเมิดของเจ้าหน้าที่ พ.ศ. 2539 และที่แก้ไขเพิ่มเติม",
      "5_4_3_violation_penalty_regulations.html",
      "1622276296",
      "3",
      "a3.30"
    ],

    [
      "แนวข้อสอบ ความรับผิดทางละเมิด",
      "label_violation_penalty",
      "100",
      "3",
      "a3.32"
    ],
    [
      "แนวข้อสอบ ความรับผิดต่อตำแหน่งหน้าที่ราชการ",
      "5_6_1_criminal_law_1.xml",
      "1622276296",
      "3",
      "a3.33"
    ],
    [
      "แนวข้อสอบ ความรับผิดทางละเมิดของเจ้าหน้าที",
      "5_4_5_violation_penalty_1.xml",
      "1670573255",
      "3",
      "a3.34"
    ],
    //
    // [
    //   "ติวเตอร์ ดร.หญิง ธิติญา ติวพ.ร.บ.ความรับผิดทางละเมิดของเจ้าหน้าที่ (YouTube)",
    //   "https://www.youtube.com/watch?v=_qUaKhdi7Uk",
    //   "1622276296",
    //   "3",
    //   "a3.341"
    // ],

    // ["แนวข้อสอบ เกี่ยวกับวินัย", "label_discipline", "100", "3", "a3.35"],
    // [
    //   "แนวข้อสอบ วินัยข้าราชการพลเรือน",
    //   "5_4_6_violation_penalty_2_discipline.xml",
    //   "1622276296",
    //   "3",
    //   "a3.36"
    // ],
    // ["ลิงค์", "label_interesting_links", "100", "3", "a3.37"],
    // [
    //   "ลิงค์ที่น่าศึกษาเพิ่มเติม",
    //   "5_4_1_1_violation_penalty_useful_links.html",
    //   "1622276296",
    //   "3",
    //   "a3.38"
    // ],
    [
      "เจตคติและจริยธรรม สําหรับข้าราชการ",
      "label_main_ethics",
      "100",
      "3",
      "a3.39"
    ],
    [
      "พระราชบัญญัติมาตรฐานทางจริยธรรม พ.ศ. ๒๕๖๒",
      "5_5_1_ethics_acts_2562.html",
      "1622276296",
      "3",
      "a3.40"
    ],

    [
      "สรุปสาระสำคัญ พ.ร.บ.มาตรฐานทางจริยธรรม",
      "5_5_2_ethics_acts_essence_of.html",
      "1622276296",
      "3",
      "a3.42"
    ],

    [
      "ตัวอย่างพฤติกรรม ตาม พ.ร.บ.มาตรฐานทางจริยธรรม (Infographics ของ ก.พ.)",
      "ocsc_ethics.pdf",
      "1705906849",
      "3",
      "a3.44"
    ],

    [
      "คำอธิบายและตัวอย่างพฤติกรรม ตามมาตรฐานทางจริยธรรม (เอกสารของ ก.พ.)",
      "etics_behaviors_explained.pdf",
      "1705906849",
      "3",
      "a3.441"
    ],


    ["จริยธรรมข้าราชการ", "label_official_ethics", "100", "3", "a3.44"],
    [
      "แนวข้อสอบ จริยธรรมข้าราชการ",
      "5_5_3_ethics_1.xml",
      "1670568518",
      "3",
      "a3.45"
    ],
    [
      "กฎหมายอาญา ที่เกี่ยวข้อง",
      "label_main_criminal_law_act",
      "100",
      "3",
      "a3.46"
    ],
    [
      "ความผิดต่อตำแหน่งหน้าที่ราชการ (มาตรา ๑๔๗-๑๖๖)",
      "5_6_1_criminal_law.html",
      "1670568518",
      "3",
      "a3.47"
    ],

    [
      "คดีตัวอย่างการกระทำความผิดต่อหน้าที่ ของเจ้าพนักงาน",
      "ocsc_criminal_law.pdf",
      "1670568518",
      "3",
      "a3.4701"
    ],


    [
      "แนวข้อสอบ ความผิดต่อตำแหน่งหน้าที่ราชการ",
      "5_5_4_criminal_law_1.xml",
      "100",
      "3",
      "a3.471"
    ],

    [
      "ข้อสอบเสมือนจริง(กฎหมาย)",
      "label_main_electornics_act",
      "100",
      "3",
      "a3.48"
    ],

    [
      "ข้อสอบเสมือนจริง 2567-2568",
      "ocsc_law_2567_paper-pencil-eExam.xml",
      "1747993354",
      "3",
      "a3.481"
    ],
    [
      "ข้อสอบเสมือนจริง - จับเวลา\n(2563-2566) ",
      "realTest_law_exercise.html",
      "1695800108",
      "3",
      "a3.49"
    ],

    // [
    //   "ข้อสอบเสมือนจริง-กฎหมายคละ\ne-Exam 2567 ",
    //   "realTest_law_eExam_2567.xml",
    //   "1724826657",
    //   "3",
    //   "a3.491"
    // ],





    // [
    //   "ติวกฎหมาย สอบ กพ (YouTube)",
    //   "label_main_law_tutor",
    //   "100",
    //   "3",
    //   "a3.450"
    // ],

    // [
    //   "ครูเป้ ชลสิทธิ์ ติวกฎหมาย รวมทุกเรื่องที่ออกสอบ (YouTube)",
    //   "https://www.youtube.com/watch?v=nc6g-6yZhzY",
    //   "1622276296",
    //   "3",
    //   "a3.451"
    // ],

    // [
    //   "พี่แมง ป. ติวรวมข้อสอบ ความรู้และลักษณะการเป็นข้าราชการที่ดี (YouTube)",
    //   "https://www.youtube.com/watch?v=EZJI1EUlGvM&t=47s",
    //   "1622276296",
    //   "3",
    //   "a3.452"
    // ],
    // [
    //   "The Master ติวกฎหมาย สอบผ่านได้ในคลิปเดียว (YouTube)",
    //   "https://www.youtube.com/watch?v=rHsR3Ij96d0&t=114s",
    //   "1622276296",
    //   "3",
    //   "a3.453"
    // ],
  ];
  static const practice = [
    // [
    //   "ข้อสอบ จากเว็บของ กพ.",
    //   "label_main_questions_ocsc",
    //   "100",
    //   "4",
    //   "a4.10"
    // ],
    [
      "ความสามารถทั่วไป/ภาษาไทย/ข้าราชการที่ดี",
      "4_full_exam_ocsc_gen_th.html",
      "1622276295",
      "4",
      "a4.11"
    ],
    ["ภาษาอังกฤษ ", "4_full_exam_ocsc_eng.html", "1622276297", "4", "a4.12"],

    ["ฝึกทำข้อสอบ ชุดเต็ม", "label_main_full_test", "100", "4", "a4.121"],
    [
      "ข้อสอบชุดเต็ม ชุดที่ 1\nเวลา 3 ชั่วโมง",
      "4_full_exam_all_01.html",
      "1698123701",
      "4",
      "a4.122"
    ],
    [
      "เฉลยข้อสอบชุดเต็ม ชุดที่ 1",
      "4_full_exam_all_01_ans.html",
      // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
      "1698123701",
      "4",
      "a4.123"
    ],


    [
      "ข้อสอบชุดเต็ม ชุดที่ 2\nเวลา 3 ชั่วโมง",
      "4_full_exam_all_02.html",
      "1698123701",
      "4",
      "a4.124"
    ],
    [
      "เฉลยข้อสอบชุดเต็ม ชุดที่ 2",
      "4_full_exam_all_02_answer.html",  // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
      "1698123701",
      "4",
      "a4.125"
    ],

    [
      "ข้อสอบชุดเต็ม ชุดที่ 3\nเวลา 3 ชั่วโมง",
      "4_full_exam_all_03.html",
      "1704696527",
      "4",
      "a4.126"
    ],
    [
      "เฉลยข้อสอบชุดเต็ม ชุดที่ 3",
      "4_full_exam_all_03_answer.html",  // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
      "1704696527",
      "4",
      "a4.127"
    ],

    [
      "ข้อสอบชุดเต็ม ชุดที่ 4\nเวลา 3 ชั่วโมง",
      "4_full_exam_all_04.html",
      "1704696527",
      "4",
      "a4.128"
    ],
    [
      "เฉลยข้อสอบชุดเต็ม ชุดที่ 4",
      "4_full_exam_all_04_answer.html",  // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
      "1704696527",
      "4",
      "a4.1281"
    ],
    [
      "ข้อสอบชุดเต็ม ชุดที่ 5\nเวลา 3 ชั่วโมง",
      "4_full_exam_all_05.html",
      "1704696527",
      "4",
      "a4.129"
    ],
    [
      "เฉลยข้อสอบชุดเต็ม ชุดที่ 5",
      "4_full_exam_all_05_answer.html",  // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
      "1704696527",
      "4",
      "a4.1291"
    ],

    [
      "ข้อสอบชุดเต็ม ชุดที่ 6\nเวลา 3 ชั่วโมง",
      "4_full_exam_all_06.html",
      "1722420833",
      "4",
      "a4.1292"
    ],
    [
      "เฉลยข้อสอบชุดเต็ม ชุดที่ 6",
      "4_full_exam_all_06_answer.html",  // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
      "1722420834",
      "4",
      "a4.1293"
    ],

    // [
    //   "ข้อสอบชุดเต็ม ชุดที่ 7\nเวลา 3 ชั่วโมง",
    //   "4_full_exam_all_07.html",
    //   "1704696527",
    //   "4",
    //   "a4.1294"
    // ],
    // [
    //   "เฉลยข้อสอบชุดเต็ม ชุดที่ 7",
    //   "4_full_exam_all_07_answer.html",  // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
    //   "1704696527",
    //   "4",
    //   "a4.1295"
    // ],


    [
      "ความสามารถททางการคิดวิเคราะห์",
      "label_main_analysis",
      "100",
      "4",
      "a4.13"
    ],
    [
      "ความสามารถในการคิดวิเคราะห์ ชุดที่ 1",
      "4_full_exam_gen_01.html",
      "1622276296",
      "4",
      "a4.14"
    ],
    [
      "ความสามารถในการคิดวิเคราะห์ ชุดที่ 2 ",
      "4_full_exam_gen_02.html",
      "1622276296",
      "4",
      "a4.15"
    ],
    [
      "ความสามารถในการคิดวิเคราะห์ ชุดที่ 3 ",
      "4_full_exam_gen_03.html",
      "1622276296",
      "4",
      "a4.16"
    ],
    [
      "ความสามารถในการคิดวิเคราะห์ ชุดที่ 4 ",
      "4_full_exam_gen_04.html",
      "1622276296",
      "4",
      "a4.17"
    ],
    [
      "ความสามารถในการคิดวิเคราะห์ ชุดที่ 5 ",
      "4_full_exam_gen_05.html",
      "1622276296",
      "4",
      "a4.18"
    ],
    [
      "ความสามารถในการคิดวิเคราะห์ ชุดที่ 6 ",
      "4_full_exam_gen_06.html",
      "1622276296",
      "4",
      "a4.19"
    ],
    [
      "ความสามารถในการคิดวิเคราะห์ ชุดที่ 7 ",
      "4_full_exam_gen_07.html",
      "1622276296",
      "4",
      "a4.20"
    ],
    [
      "ความสามารถในการคิดวิเคราะห์ ชุดที่ 8 ",
      "4_full_exam_gen_08.html",
      "1622276296",
      "4",
      "a4.21"
    ],
    [
      "ความสามารถในการคิดวิเคราะห์ ชุดที่ 9 ",
      "4_full_exam_gen_09.html",
      "1622276296",
      "4",
      "a4.22"
    ],
    [
      "ความสามารถในการคิดวิเคราะห์ ชุดที่ 10 ",
      "4_full_exam_gen_10.html",
      "1622276296",
      "4",
      "a4.23"
    ],
    ["ภาษาอังกฤษ", "label_main_english_tests", "100", "4", "a4.24"],
    [
      "ภาษาอังกฤษ ชุดที่ 1 ",
      "4_full_exam_en_01.html",
      "1622276296",
      "4",
      "a4.25"
    ],
    [
      "ภาษาอังกฤษ ชุดที่ 2 ",
      "4_full_exam_en_02.html",
      "1622276296",
      "4",
      "a4.26"
    ],
    [
      "ภาษาอังกฤษ ชุดที่ 3 ",
      "4_full_exam_en_03.html",
      "1622276296",
      "4",
      "a4.27"
    ],
    [
      "ภาษาอังกฤษ ชุดที่ 4 ",
      "4_full_exam_en_04.html",
      "1622276296",
      "4",
      "a4.28"
    ],
    [
      "ภาษาอังกฤษ ชุดที่ 5 ",
      "4_full_exam_en_05.html",
      "1622276296",
      "4",
      "a4.29"
    ],
    [
      "ภาษาอังกฤษ ชุดที่ 6 ",
      "4_full_exam_en_06.html",
      "1622276296",
      "4",
      "a4.30"
    ],
    [
      "ภาษาอังกฤษ ชุดที่ 7 ",
      "4_full_exam_en_07.html",
      "1622276296",
      "4",
      "a4.31"
    ],
    [
      "ภาษาอังกฤษ ชุดที่ 8 ",
      "4_full_exam_en_08.html",
      "1622276296",
      "4",
      "a4.32"
    ],
    [
      "ภาษาอังกฤษ ชุดที่ 9 ",
      "4_full_exam_en_09.html",
      "1622276296",
      "4",
      "a4.33"
    ],
    [
      "ภาษาอังกฤษ ชุดที่ 10 ",
      "4_full_exam_en_10.html",
      "1622276296",
      "4",
      "a4.34"
    ],
    [
      "การเป็นข้าราชการที่ดี",
      "label_main_being_good_civl_servants",
      "100",
      "4",
      "a4.35"
    ],
    [
      "การเป็นข้าราชการที่ดี ชุดที่ 1 ",
      "5_full_exam_good_cv_01.html",
      "1622276296",
      "4",
      "a4.36"
    ],
    [
      "การเป็นข้าราชการที่ดี ชุดที่ 2 ",
      "5_full_exam_good_cv_02.html",
      "1622276296",
      "4",
      "a4.37"
    ],
  ];


  // static const List newBigList = [
  //   // รวมให้เป็น List เดียว จาก general[] english[] law[] และ practicee[]
  //   ...MyHomePage.general,
  //   ...MyHomePage.english,
  //   ...MyHomePage.law,
  //   ...MyHomePage.practice
  //   // ...testFiles,
  // ];

  //debugPrint("newBigList จำนวน สมาชิก: ${newBigList.length} รายการ");





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
    //  _loadSessionState();
    _checkLastOpenTime();
    _doRandomNumber();


    //   checkVersion(); //สำหรับแสดง bottom bar notification for update

    fetchData();  // ไปเอาข้อมูลจาก Google Sheets

    // testHowMuchTimeAMethodUsed();  // ตรวจดูว่า method ใช้เวลาทำงาน นานเท่าไร
  }



  // Future<void> fetchData() async {
  //   final GSheetsData = await _sheetsAPI.fetchData();
  //   setState(() {
  //     myGSheetData = GSheetsData;
  //   });
  //     debugPrint("data from sheets: $myGSheetData");
  // }

  // Future<void> fetchData() async {
  //   final GSheetsData = await _sheetsAPI.fetchData();
  //   setState(() {
  //     myGSheetData = GSheetsData;
  //   });
  //
  //   debugPrint("data from sheets: $myGSheetData");
  //
  //   // 🔽 Call this after data is loaded
  //   // await checkAndShowUpdateBadge(myGSheetData); // not use because flutter_app_badger package is discontinued
  //    await checkVersion();
  // }

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
//    debugPrint("getCount นับจำนวนใน OcscTjkTable: $countX");

    //

    // ดูข้อมูลในตาราง itemTable อันนี้ ใช้เพื่อทดสอบเฉย ๆ เสร็จแล้ว ต้อง comment ออก
    // เพราะทำให้หน้าจอ MainMenu ไม่แสดงอะไร เพราะ ต้องเอาค่าไปเชคว่า เป็น 0 หรือไม่
    // เพื่อดูว่า เข้ามาครั้งแรกหรือเปล่า  ถ้ามีการเชคตารางนี้ด้วย และส่งออกไปเป็น String
    // ตอนเชค ผลก็จะไม่ใช่ 0 และจะไม่เอาข้อมูลใส่ตาราง OcscTable และ ตาราง itemTable
    // ทำให้ไม่ข้อมูล จึงต้อง comment ออก
    // var y = await dbClient.rawQuery('SELECT COUNT (*) from itemTable');
    // int countY = Sqflite.firstIntValue(y);
    // String myCount = "\nOcscTjkTable: $countX; \nitemTable: $countY";
    return countX;
  }




  @override
  Widget build(BuildContext context) {
    debugPrint("isDialogHidingExpired before showFirstMessage: $isDialogHidingExpired");

    showFirstMessage(context, isDialogHidingExpired, isVoteFiveStarsAlready, isShowRequestFiveStarBox); // แสดง dialog แสดงข่าวสาร ตอนเปิดโปรแกรม
    //   showDialog_work_in_progress(context);

    final providerModel = Provider.of<ProviderModel>(context,
        listen: false); // สำหรับการซื้อในแอพ

//    // ใช้ revenueCat แทน เพราะหา การซื้อครั้งก่อนไม่ได้ ใช้ firebase function
//     // ก็มีปัญหา error เยอะ เรียกฟังก์ชันไม่สำเร็จ
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

    // if (msgFromGSheets.isNotEmpty) {
    //   for (int i = 0; i < msgFromGSheets.length; i++) {
    //     // debugPrint("debugPrint record $i" + msgFromGSheets[i].toString());
    //     //String description = msgFromGSheets['description'];
    //     String description = msgFromGSheets[i]['description'];
    //     debugPrint("Description from GSheets $i: $description");
    //   }
    //
    // }


    const List newBigList = [
      // รวมให้เป็น List เดียว จาก general[] english[] law[] และ practicee[]
      ...MyHomePage.general,
      ...MyHomePage.english,
      ...MyHomePage.law,
      ...MyHomePage.practice
      // ...testFiles,
    ];
    debugPrint("newBigList จำนวน สมาชิก: ${newBigList.length} รายการ");
    // newBigList.asMap().forEach((i, value) {
    //   debugPrint('index=$i, value=$value');
    // });
    final isDarkMde =
        Provider.of<ThemeNotifier>(context, listen: false).darkTheme;
    debugPrint("isDarkMde checked: $isDarkMde");

    // สำหรับ ไอคอน สว่าง-มืด
    const IconData nightlight_outlined = IconData(0xf214, fontFamily: 'MaterialIcons');
    const IconData wb_sunny_outlined = IconData(0xf4bc, fontFamily: 'MaterialIcons');
    const IconData mode_night = IconData(0xe3f4, fontFamily: 'MaterialIcons');
    const IconData sunny = IconData(0xf0575, fontFamily: 'MaterialIcons');

    // final countDwnIndx =
    //     Provider.of<ThemeNotifier>(context, listen: false).thisExamIndexFromPref;

    final theme = Provider.of<ThemeNotifier>(context,
        listen: false); // ใช้สำหรับ update ตัวแปร index ด้วย
    //  int thisIndex = examScheduleIndex;
    int countDwnIndx = theme.thisExamIndexFromPref;
    // int dateInstalled = ((theme.installDate) / 1000).round(); // วันที่ ที่ติดตั้งแอพ

    // final myInstallDate = Provider.of<ThemeNotifier>(context,
    //     listen: false);  // วันที่ ที่ติดตั้งแอพ
    // int dateInstalled = ((myInstallDate.installDate) / 1000).round();
    // debugdebugPrint("install at: $dateInstalled");


    List<String> messageList = countDown_global.split("xyz"); // แปลงเป็น list จะได้นับจำนวนได้ แต่ละอัน คั่นด้วย xyz
    debugPrint("thisIndex from sharePref countDwnIndx: $countDwnIndx");
    debugPrint("msg length: ${messageList.length}");
    if (countDwnIndx >= messageList.length){
      countDwnIndx = 0;
    }
    // prepareOcscTjkTableData(
    //     general: general, english: english, law: law, practice: practice);


    // ไม่เอาแล้ว เพราะไม่ได้เอาจุดแดง เอาข้อมูลใน หน้าเมนู มาใส่ที่นี่เลยทั้งหมด จะเพิ่มหรือลดเมนู ก็จะได้ปรับได้ทันทีเลย
    prepareOcscTjkTableData(newList: newBigList);

    // เอานี่แทน  ไม่ได้ เพราะภ้าลบหมด ข้อมูลความก้าวหน้าในวงกลม ก็จะถูกลบไปด้วย
    //  populateOcscTjkTable(wholeList: newBigList);


    // getCountDwnMsg();
    // var _countDownMsg = getCountDwnMsg();

    //  bool isDarkMode = false;  // ใช้ในเมนู บน AppBar

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
                        //   toggle();
                      },
                      value: notifier.darkTheme,
                    ),
                  )
                ],
              ), // end of chile: Row(
            )
          ],
        ),
        // ถ้าจะมี drawer ก็นำมาวางตรงนี้
        // drawer: Drawer();

        body: FutureBuilder(
          future: Future.wait([getCount(), getCountDwnMsg()]),
          // เรียกใช้ multiple future
          // getCount() ใช้ตรวจสอบข้อมูลในตาราง, getCountDwnMsg() ไปเอานับถอยหลัง จาก pastebin
          builder: (ctx, snapshot) {
            // Checking if future is resolved or not
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occured',
                    style: TextStyle(fontSize: 18),
                  ),
                );
                // if we got our data
              } else if (snapshot.hasData) {
                debugPrint("general listXXX: ${MyHomePage.general}");
                //    debugPrint("ดูว่าในตาราง OcscTjkTable มีข้อมูลไหม ");
                getCount().then((numOfRecordsInOcscTjkTable) {
                  //ถ้ามีข้อมูลในตาราง OcscTjkTable แล้ว ไม่ทำอะไร ลองดู เพราะเห็นมีรายการซำ้กัน ใน mainMenu
                  if (numOfRecordsInOcscTjkTable! <= 0) {
                    debugPrint("ตาราง OcscTjkTable ไม่มีข้อมูล ");
                    var newList = [
                      // รวมให้เป็น List เดียว จาก general[] english[] law[] และ practicee[]
                      ...MyHomePage.general,
                      ...MyHomePage.english,
                      ...MyHomePage.law,
                      ...MyHomePage.practice
                      // ...testFiles,
                    ]; // merge lists
                    // debugPrint(
                    //     "all files count < 0 data before check If 0: ${snapshot.data}"); // จำนวนแถวข้อมูล ในตาราง OcscTjkTable มาจาก getCount()
                    // debugPrint("all files: ${newList.length}: $newList");
                  }
                });

                // แก้ไปแก้มา ตกลงเลย ไม่ได้ใช้ getCount และ FutureBuilder ด้วย เดี๋ยวต้องดูอีกทีเอาออก
                // ถ้ามีข้อมูล ต้องเชคว่า มีอะไรเพิ่มเข้ามา หรือไม่

                //  final data = snapshot.data;
                var countDownMessage = snapshot.data![1].toString();  // 1 คือตัวที่ 2 ตอนเรียก future builder
                debugPrint("countDownMessage in Main: $countDownMessage");
                debugPrint("msgFromGSheets before mainMenu: $msgFromGSheets");

                //   debugPrint("curr_ver in Main: ${msgFromGSheets[6].toString()}");

//                 bool pastebin_not_ok = countDownMessage.contains("html") || countDownMessage.contains("title") || countDownMessage.contains("429");
// if(pastebin_not_ok){
//   countDownMessage = countDown_global;
// }

                // data คือ จำนวนแถวในตาราง OcscTjkTable ได้มาจาก getCount()
                //   getExamDataFromXmlAndWriteToItemTable(context, "dummy_xml.xml");

                // getCountDwnMsg().then((thisMsg){
                //   final countDownMsg = thisMsg;
                //   debugPrint("countDownMsg inside:  $countDownMsg");
                // });
                // debugPrint("countDownMsg inside:  $countDownMsg");
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // image: AssetImage('assets/images/beach04.png'),  // ช้า ต้องรอให้โหลดเสร็จ
                      image: widget.beachImage.image,
                      // เรียกใช่้รูป beach04.png ที่ preload เอาไว้ก่อนหน้านี้แล้ว จะได้มาทันที ไม่ต้องรอ ไม่่งั้น ตัวหนังสือมาครบ มีหยุดขาวนิดนึง แล้วรูปจึงตามมา
                      fit: BoxFit.cover,
                      // fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          // เว้นเป็นพื้นที่ว่างเอาไว้ สำหรับ logo ที่ติดอยู่ในภาพ beach04.png ที่ใช้เป็น background
                          height: 40,
                          width: 200,
                        ),
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    'เลือกหัวข้อประเภทข้อสอบ',
                                    //  'ฟรี!!! ช่วงโปรโมชั่น',
                                    style: TextStyle(
                                      fontFamily: 'Athiti',
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white60,
                                      //   color: Colors.yellowAccent,
                                    ),
                                  ),
                                  // Text(
                                  //   '(ปกติ 199.- บาท)',
                                  //   style: TextStyle(
                                  //     fontFamily: 'Athiti',
                                  //     fontSize: 18,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: Colors.white60,
                                  //     // color: Colors.yellowAccent,
                                  //   ),
                                  // ),
                                  const SizedBox(
                                      width: double.infinity, height: 12.0),
                                  //Text(general[[1][0]].toString()),
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
                                    //Use of SizedBox for spacing
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
                                        //navigateToP2(context);
                                        debugPrint(
                                            "ปุ่ม Go to ความสามารถทั่วไป ถูกกด aaa aa");
                                        if (msgFromGSheets.isNotEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MainMenu(
                                                  //myMenuContents: general,
                                                  myType: "1",
                                                  title: "ความสามารถทั่วไป",
                                                  fileList:
                                                  MyHomePage.general,
                                                  // examScheduleIndex: 1,
                                                  examScheduleIndex:
                                                  countDwnIndx,
                                                  countDownMessage:
                                                  countDownMessage,
                                                  msgFromGSheets: msgFromGSheets,
                                                  //fileList: newList,
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
                                    //Use of SizedBox for spacing
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
                                        // TODO
                                        // navigateToP3(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MainMenu(
                                                //    myMenuContents: english,
                                                myType: "2",
                                                title: "ภาษาอังกฤษ",
                                                fileList:
                                                MyHomePage.english,
                                                examScheduleIndex:
                                                countDwnIndx,
                                                countDownMessage:
                                                countDownMessage,
                                                msgFromGSheets: msgFromGSheets,
                                                //fileList: newList,
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    //Use of SizedBox for spacing
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
                                        // TODO
                                        //navigateToP4(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MainMenu(
                                                //           myMenuContents: law,
                                                myType: "3",
                                                title:
                                                "การเป็นข้าราชการที่ดี",
                                                fileList: MyHomePage.law,
                                                examScheduleIndex:
                                                countDwnIndx,
                                                countDownMessage:
                                                countDownMessage,
                                                msgFromGSheets: msgFromGSheets,
                                                //fileList: newList,
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    //Use of SizedBox for spacing
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
                                        // TODO
                                        // navigateToP3(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MainMenu(
                                                //          myMenuContents: practice,
                                                myType: "4",
                                                title: "ฝึกทำข้อสอบ จับเวลา ",
                                                fileList:
                                                MyHomePage.practice,
                                                examScheduleIndex:
                                                countDwnIndx,
                                                countDownMessage:
                                                countDownMessage,
                                                msgFromGSheets: msgFromGSheets,
                                                //fileList: newList,
                                              )),
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(
                                    //Use of SizedBox for spacing
                                    height: 30,
                                  ),
                                  Text(
                                    //  "Version: ${widget.version}", // เปลี่ยนเป็น stateful เรียกตรงจาก widget ไม่ได้
                                    "Version: $version", // เรียกจากใน snapshot
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  Text(
                                    //  "Build: ${widget.buildNumber}",
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

            // Displaying LoadingSpinner to indicate waiting state
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          //future: getData(),
          // future: _countDownMsg = getCountDwnMsg();

          //   future: Future.wait([getCount(), getCountDwnMsg()]), // เรียกใช้ multiple future
          // https://www.edoardovignati.it/how-to-wait-for-multiple-futures-with-futurebuilder-in-flutter/

          // future:
          // getCount(),  // เชคว่า มีข้อมูลในตาราง OcscTjkTable หรือไม่ ถ้าไม่มี นับจะได้ 0 แสดงว่า
          // เป็นการเปิดใช้งานครั้งแรก โดยจะไปทำงานที่ FutureBuilder
          // getCountDwnMsg() เป็นการไปเอาข้อมูลนับถอยหลัง จาก pastebin
        ),

        // for showing UPDATE available (if any) bottom bar

        bottomNavigationBar: _showUpdateBanner
            ? GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // Tap outside the 'Click here' link → dismiss banner
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjust padding as needed
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2), // Border color and width
                      borderRadius: BorderRadius.circular(12), // Rounded corners
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
                      // style: const TextStyle(
                      //   color: Colors.white,
                      //   fontWeight: FontWeight.bold,
                      //   decoration: TextDecoration.none,
                      // ),
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

  // void prepareOcscTjkTableData(
  void prepareOcscTjkTableData ({required List newList}) async {

    // ไปเอาข้อมูลติดตั้งแอพ ใน sharePref ซึ่งอยู่ใน theme.dart

    int? dateInstalled = await AppUtils.getInstallDateEpochSeconds();


    debugPrint("install at: $dateInstalled");

    // debugPrint(
    //     "all files data before check If 0: ${snapshot.data}"); // จำนวนแถวข้อมูล ในตาราง OcscTjkTable มาจาก getCount()
    //   debugPrint("all files after merge: ${newList.length}: $newList");
    // create list of files to compare with database
    // List menuNameList = [];
    // for (var i = 0; i < newList.length; i++) {
    // //  fileNameList.add(newList[i][1]);
    //   menuNameList.add(newList[i][0]);  // เปลี่ยนเป็นชื่อเมนูดีกว่า ถ้ามีการเปลี่ยนแปลง จะได้เปลี่ยนหน้าเมนูในแอปให้ด้วย
    // }
    var dbClient = await SqliteDB().db;
    var x = await dbClient!.rawQuery('SELECT COUNT (*) from OcscTjkTable');
    int? countX = Sqflite.firstIntValue(x);
    debugPrint("เข้ามาครั้งแรก ข้อมูลใน OcscTjkTable : $countX");
    if (countX == 0) {  // ตาราง OcscTjkTable ว่างเปล่า แสดงว่า เป็นการใช้งานครั้งแรก
      // เพิ่มทุกไฟล์ เข้าตาราง OcscTjkTable
      addToOcscTjkTable(wholeList: newList); // เอาข้อมูลเข้าตาราง OcscTjkTable กำหนด isNew เป็น 0 จะได้ไม่มีปุ่มแดง
    } else {  // กรณีมีข้อมูลในตาราง OcscTjkTable แล้ว

      // กรณีไม่ใช่เป็นการใช้งานครั้งแรก

      // ทำ 3 อย่าง  + 1 คือ ตำแหน่งด้วย เผื่อมีการย้ายตำแหน่งในเมนู
      // 1. เชคว่า มีการเพิ่มข้อสอบชุดใหม่ ทั้งชุดเข้ามาหรือไม่ ถ้ามี เอาเพิ่มในตาราง OcscTjkTable และกำหนด isNew=1
      //  2. เชคว่า มีการลบชุดข้อสอบเดิมออกหรือไม่ ถ้ามี ต้องเอาออกจาก ตาราง OcscTjkTable ด้วย
      //  ไม่งั้นจะ crash ตอนเอาข้อมูลวันที่จาก ตาราง มาเชคกับ list ซึ่งลบไปแล้ว ก็จะไม่เจอ เป็น null ทำให้ crash บอกว่า source must not be null
      //  3.  เชควันที่ว่า วันที่ของไฟล์ใด มากกว่าของเดิมในตาราง  OcscTjkTable ถ้ามากกว่า อัพเดท isNew=1 ไฟล์นี้ ในตาราง OcscTjkTable เพื่อให้มีจุดแดง
      // 4. เชคตำแหน่ง ถ้าใหม่ ให้ update ในตารางด้วย

      debugPrint("mapYYY: before check");
      List<String> menuNameListFromMain = [];
      List<String> fileNameListFromMain = [];

      debugPrint("จำนวนข้อมูลใน newList: ${newList.length}");

      for (var i = 0; i < newList.length; i++) {
        final menuName = newList[i][0];
        final fileName = newList[i][1];
        final createDateStr = newList[i][2];
        final whatType = int.parse(newList[i][3]);
        final position = newList[i][4];
        final dateFromFile = int.parse(createDateStr);

        // Collect menu and file names
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

// ✅ Delete stale entries not in the main list
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
    // ไม่ใช่เข้ามาครั้งแรก ทำ 3 อย่าง
    // 1. เชคว่า มีการเพิ่มข้อสอบชุดใหม่เข้ามาหรือไม่ ถ้ามี เอาเพิ่มในตาราง OcscTjkTable และอัพเดท isNew=1,
    // brandNew = 1 (ใหม่ทั้งชุด)  -- ตอนนี้ใช้ชื่อ field_2 ไปก่อน  // เปลี่ยนเป็น เก็บ is_clicked_main_menu: 0 not clicked, 1 clicked already. if clicked no reddot
    //  2. เชคว่า มีการลบชุดข้อสอบเดิมออกหรือไม่ ถ้ามี ต้องเอาออกจาก ตาราง OcscTjkTable ด้วย
    //  ไม่งั้นจะ crash ตอนเอาข้อมูลวันที่จาก ตาราง มาเชคกับ list ซึ่งลบไปแล้ว ก็จะไม่เจอ เป็น null ทำให้ crash บอกว่า source must not be null
    //  3.  เชควันที่ว่า ที่ส่งเข้ามา ใหม่กว่า ของเดิมไหม ถ้าใหม่กว่า ให้มีจุดแดง โดยอัพเดท isNew ในตาราง OcscTjkTable เป็น 1, brandNew=2 (มีเพิ่ม ข้อใหม่)  -- ตอนนี้ใช้ชื่อ field_2 ไปก่อน
  }

  // ของเดิมไปเอามาจาก pastebin.com แต่ไม่ค่อยเสถียร แล้วอีกอย่าง package ไม่อัพเดท ทำให้ conflict
  // กับ package อื่น เช่น webview ก็พลอยอัพเดทไม่ได้ -- ตกลง เลิกใช้ดีกว่า ใช้เป็นตัวแปร const แทน
  // Future <String?> getCountDwnMsg() async {
  //   String? thisCountDwnMsg = countDown_global;
  //   return thisCountDwnMsg;
  // }

  // ไปเอาจาก Firebase  -- ยังไม่ได้ทำ
  Future <String?> getCountDwnMsg() async {
    String? thisCountDwnMsg = countDown_global;
// final uid = "d8LV0oogW2xOZGbzJHeW";
// var data = await FirebaseFirestore.instance
//     .collection()
//
    return thisCountDwnMsg;
  }








  //
//   Future<String?>   async {
//     var countDown;
//
//     final String isPastebinAvailable = await checkWebsiteAvailability(url: 'https://pastebin.com');
//    // final isPastebinAvailable = await requestGET(url: 'https://pastebin.com');
// debugPrint("isPastebinAvailable in getCountDwnMsg: $isPastebinAvailable");
//
//     if (isPastebinAvailable == "no") {
//       debugPrint("pastebin is not available.");
//       countDown = "วันมาฆะบูชา _X_ ๒๖ กุมภาพันธ์ ๒๕๖๗  _X_ 2024-02-26 00:00:01xyzวันจักรี _X_ ๘ เมษายน ๒๕๖๗  _X_ 2024-04-08 00:00:01xyzวันสงกรานต์ _X_ ๑๓ เมษายน ๒๕๖๗  _X_ 2024-04-13 00:00:01xyzวันฉัตรมงคล  _X_ ๖ พฤษภาคม ๒๕๖๗  _X_ 2024-05-06 00:00:01xyzวันวิสาบูชา _X_ ๒๒ พฤษภาคม  ๒๕๖๗  _X_ 2024-05-22 00:00:01xyzวันเฉลิมพระชนมพรรษาสมเด็จพระนางเจ้าฯ พระบรมราชินี _X_ ๓ มิถุนายน  ๒๕๖๗  _X_ 2024-06-03 00:00:01xyzวันอาสาฬหบูชา _X_ ๒๐ กรกฎาคม  ๒๕๖๗  _X_ 2024-07-20 00:00:01xyzวันเข้าพรรษา _X_ ๒๑ กรกฎาคม    ๒๕๖๗  _X_ 2024-07-21 00:00:01xyzวันเฉลิมพระชนมพรรษาพระบาทสมเด็จพระวชิรเกล้าเจ้าอยู่หัว รัชกาลที่ 10 _X_ ๒๘ กรกฎาคม  ๒๕๖๗  _X_ 2024-07-28 00:00:01xyzวันแม่แห่งชาติ &&&วันเฉลิมพระชนมพรรษา &&&สมเด็จพระนางเจ้าสิริกิติ์ พระบรมราชินีนาถ พระบรมราชชนนีพันปีหลวง _X_ ๑๒ สิงหาคม  ๒๕๖๗  _X_ 2024-08-12 00:00:01xyzวันนวมินทรมหาราช (วันคล้ายวันสวรรคต)&&& พระบาทสมเด็จพระบรมชนกาธิเบศร มหาภูมิพลอดุลยเดชมหาราช บรมนาถบพิตร _X_ ๑๓ ตุลาคม  ๒๕๖๗  _X_ 2024-10-13 00:00:01xyzวันปิยมหาราช _X_ ๒๓ ตุลาคม  ๒๕๖๗  _X_ 2024-10-23 00:00:01xyzวันพ่อแห่งชาติ  _X_ ๕ ธันวาคม  ๒๕๖๗  _X_ 2024-12-05 00:00:01xyzวันรัฐธรรมนูญ _X_ ๑๐ ธันวาคม  ๒๕๖๗  _X_ 2024-12-10 00:00:01xyzวันสิ้นปี _X_ ๓๑ ธันวาคม  ๒๕๖๗  _X_ 2024-12-31 00:00:01xyzวันขึ้นปีใหม่  _X_ ๑ มกราคม ๒๕๖๘  _X_ 2025-01-01 00:00:01";
//     }else {
//       debugPrint("pastebin is available.");
//       final primaryApiDevKey =
//           'c-dOY4999bE7pXEtfIsKHq6UF-m6LeMx'; // get from https://pastebin.com/
//       var pasteVisibility = pbn.Visibility.public;
//       var pastebinClient = withSingleApiDevKey(
//         apiDevKey: primaryApiDevKey,
//       );
//       String url = "TmqFdgNA";
//       final result = await pastebinClient.rawPaste(
//         // ให้กำลังใจ หรือแสดงข่าวสาร
//         // ข้อความใน pastebin
//         // แต่ละเรื่องคั่นด้วย xyz  ถ้ามีการขึ้นบรรทัดใหม่ ให้คั่นด้วย &&&
//         // ใส่ลิงค์ได้ โดยขึ้นต้นด้วย https://www ...
//         pasteKey: url,
//         visibility: pasteVisibility,
//       );
//       countDown = result.fold((l) => null, (r) => r); // นับถอยหลัง
//     }
//     debugPrint("countDownMsgFromMain: $countDown");
//     return countDown;
//   }

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
    // สำหรับแสดงข่าวสาร ตอนเปิด
    // String myPackage = 'com.thongjoon.ocsc_exam_prep';
    if(!showWelcomeDialogNoMore){ // ให้แสดง welcome dialog ถ้ายังไม่บอกว่า ไม่ต้องแสดงอีกตลอดไป
      debugPrint("outside  if ((!_isDialogShown &&");
      if ((!_isDialogShown && _isThereCurrentDialogShowing(context) &&
          isDialogHidingDayExpired)) {
        _isDialogShown = true; // ป้องกันไม่ให้เข้ามาอีกครั้ง
        debugPrint("inside  if ((!_isDialogShown &&");
        // ไม่แสดง dialog ซ้ำ ถ้ากำลังแสดงอยู่แล้ว
        // Display your dialog here
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 540),
                  child: Theme(
                    // Use your custom themeForGreetingDialog
                    data: themeForGreetingDialog,
                    child: AlertDialog(
                      content: SingleChildScrollView(
                        // ทำให้มีเลื่อนได้ เตรียมไว้เผื่อมียาว จะได้ไม่ overflow
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
                              //   style: Theme.of(context).textTheme.bodyLarge,
                              //   style: selectedTextStyleWelcome,
                              style: TextStyle(
                                fontFamily: 'Athiti',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: themeForGreetingDialog.primaryColor,
                                //  color: Colors.indigo,
                                //color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign
                                  .center, // Align the text within the Text widget
                            ),
                            SizedBox(height: 6),
                            const Text(
                              'ติ-ชม-สอบถาม ใช้เมนู 3 จุดในแอพ',
                              style: TextStyle(
                                //        fontFamily: 'Athiti',
                                fontSize: 15,
                                // fontWeight: FontWeight.bold,
                                fontWeight: FontWeight.normal,
                                color: Colors.indigo,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // const Text('ใช้งานกับ Android 8 (Oreo) ขึ้นไป',
                            //   style: TextStyle(
                            //     //        fontFamily: 'Athiti',
                            //     fontSize: 10,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.red,
                            //   ),
                            // ),
                            SizedBox(height: 5),
                            flutterVisibility.Visibility(
                              // จะแสดง ขอกำลังใจเมื่อ 1)เลยเวลาจำนวนวันที่กำหนดหลังจากเปิดใช้งานครั้งแรก เพื่อให้คนได้ใช้
                              // ก่อนที่จะชวนให้โหวต และ 2)ยังไม่ได้คลิกลิงค์ไปโหวต
                              visible: (shouldShowVoteFiveStar &&
                                  !isVoteFiveStarsAlready && isShowRequestFiveStarBox),
                              child: Container(
                                // padding: EdgeInsets.all(8.0),
                                padding: EdgeInsets.only(
                                  left: 15.0, right: 15.0, bottom: 5,),
                                // Set padding only on the left and right
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red, // Set the border color
                                    width: 2.0, // Set the border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Set the border radius
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 5),
                                    const Text(
                                      'ขอกำลังใจ 5 ดาว',
                                      style: TextStyle(
                                        //        fontFamily: 'Athiti',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    // SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () {
                                        _setOptionNotShowDialog();
                                        // Close the first dialog
                                        Navigator.of(context).pop();

                                        if (Platform.isIOS || Platform.isMacOS) {
                                          // ไป App Store
                                          _launchURL('https://apps.apple.com/th/app/%E0%B9%80%E0%B8%95%E0%B8%A3-%E0%B8%A2%E0%B8%A1%E0%B8%AA%E0%B8%AD%E0%B8%9A-%E0%B8%81%E0%B8%9E-%E0%B8%A0%E0%B8%B2%E0%B8%84-%E0%B8%81/id1622156979?l=th');
                                        } else if (Platform.isAndroid) {
                                          // ไป Google Play
                                          _launchURL(
                                              'https://play.google.com/store/apps/details?id=$packageName');
                                          // _launchURL(  // ก็ เหมือน ๆ กับ บรรทัดบน ดูแล้วไปหน้าเดียวกันบน play store
                                          //     'market://details?id=$packageName'); // packageName จาก packageInfo_plus
                                        }

                                      },
                                      child: RichText(
                                        text: const TextSpan(
                                          text: 'ให้คะแนน 5 ดาว ',
                                          style: TextStyle(
                                            //  fontFamily: 'Athiti',
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
                                                //   backgroundColor: Colors.yellow,
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
                                  //   'หัวข้อเรื่อง แนะนำ',
                                  'มีอะไรใหม่',
                                  style: TextStyle(
                                    fontFamily: 'Athiti',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    //color: Colors.indigo,
                                    // color: Theme.of(context).primaryColor,
                                    color: themeForGreetingDialog.primaryColor,
                                  ),
                                  textAlign: TextAlign
                                      .center, // Align the text within the Text widget
                                ),
                              ),
                            ),
                            // SizedBox(height: 5),
                            // const Text(
                            //   '\u2764️ ฝึกจับเวลาชุดเต็ม (3 ช.ม.) ชุดที่ 5',
                            //   style: TextStyle(
                            //     //        fontFamily: 'Athiti',
                            //     fontSize: 16,
                            //     color: Colors.indigo,
                            //     // color: Theme.of(context).primaryColor,
                            //   ),
                            //   textAlign: TextAlign.left,
                            // ),

                            const Text(
                              '\u2764️ UPDATE!! ข้อสอบเสมือนจริง เม.ย. 2568 เรื่อง อนุกรม\n ',
                              style: TextStyle(
                                //        fontFamily: 'Athiti',
                                fontSize: 16,
                                color: Colors.indigo,
                                //color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            // end of const Text(


                            // const Text(
                            //   '\u2764️ UPDATE!! \u2600 ปรับปรุงคำอธิบายอนุกรม \u2600 เพิ่มสีปากกากระดาษทด  \u2600 แก้ปัญหาบางหน้าจอดำ บน Samsung Galaxy  \u2600 แก้ไขคำผิด และอื่น ๆ ',
                            //   style: TextStyle(
                            //     //        fontFamily: 'Athiti',
                            //     fontSize: 16,
                            //     color: Colors.indigo,
                            //     //color: Theme.of(context).primaryColor,
                            //   ),
                            //   textAlign: TextAlign.left,
                            // ),
                            // end of const Text(


                            // SizedBox(height: 10),
                            // Container(
                            //   color: Colors.yellow,
                            //   child: Center(
                            //     child: Text(
                            //       'รุ่นนี้ มีอะไรใหม่!!!',
                            //       style: TextStyle(
                            //         fontFamily: 'Athiti',
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.bold,
                            //         //color: Colors.indigo,
                            //         // color: Theme.of(context).primaryColor,
                            //         color: themeForGreetingDialog.primaryColor,
                            //       ),
                            //       textAlign: TextAlign
                            //           .center, // Align the text within the Text widget
                            //     ),
                            //   ),
                            // ),
                            // const Text("\u2022 เพิ่มแบบฝึกชุดเต็ม ชุดที่ 4 และ\n\u2022 ปรับปรุงคำอธิบายและเพิ่มข้อสอบเสมือนจริง",
                            //   style: TextStyle(
                            //   //        fontFamily: 'Athiti',
                            //   fontSize: 14,
                            //   color: Colors.indigo,
                            //   //color: Theme.of(context).primaryColor,
                            // ),
                            // textAlign: TextAlign.left,
                            // ),
                          ],

                        ),
                      ),

                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                //   _saveCurrentTime(); // Save the current time when tapped
                                //   Navigator.of(context).pop();
                                // },
                                Navigator.of(context)
                                    .pop(); // Remove the current dialog

                                if (isVoteFiveStarsAlready) {
                                  _dont_show_welcome_dialog_anymore();
                                } else {
                                  _saveCurrentTime(); // Save the current time when tapped
                                }
                              },
                              child: RichText(
                                text: TextSpan(
                                  //text:   'ไม่ต้องแสดงอีก 5 วัน',
                                  text: isVoteFiveStarsAlready
                                      ? "ไม่ต้องแสดงอีกตลอดไป"
                                      : "ไม่ต้องแสดงอีก 5 วัน",
                                  style: TextStyle(
                                    fontSize: 12,
                                    // Keep the size for the rest of the text
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
          // Set _isDialogShown to true after displaying the dialog
          _isDialogShown = true;
        });
      } // end of  if((!_isDialogShown && _isThereCurrentDialogShowing(context) && isDialogHidingDay

    }  // end of noMore

  }

  void showDialog_work_in_progress(BuildContext context) {
    if (!_isDialogShown && _isThereCurrentDialogShowing(context)) {
      // ไม่แสดง dialog ซ้ำ ถ้ากำลังแสดงอยู่แล้ว
      // Display your dialog here
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              //  title: Text('Dialog Title'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/data/images/work_in_progress.png',
                      // Adjust the path as needed
                      height: 150, // Adjust the height as needed
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
        // Set _isDialogShown to true after displaying the dialog
        _isDialogShown = true;
      });
    }
  }

  // Future<void> _loadPackageInfo() async {
  //   final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   setState(() {
  //     appName = packageInfo.appName;
  //     packageName = packageInfo.packageName;
  //     version = packageInfo.version;
  //     buildNumber = packageInfo.buildNumber;
  //   });
  // }

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
// สำหรับสุ่มให้แสดง ขอกำลังใจ ใน welcome dialog box ตอนเปิด
    // คือ จะไม่แสดงทุกครั้ง แต่สุ่มเอา

    // Create an instance of the Random class
    Random random = Random();

    // Generate a random integer between 1 (inclusive) and 3 (inclusive)
    int randomNumber = random.nextInt(4) + 1;

// เพิ่มโอกาสให้มากขึ้น เป็น 3 ใน 4
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

    // วันแรกที่เริ่มใช้งาน
    // ************************  from chatGPT

    int minutesDifferenceFirstUse = 0;
    int daysDifferenceFirstUse = 0;

    // Retrieve the stored time from SharedPreferences
    int storedTime =  SharedPreferencesManager().getInt('timeOfFirstRun') ?? 0;

    bool isVoteClicked =  SharedPreferencesManager().getBool('isVote_5_stars_Clicked') ?? false;

// Create a DateTime object using the stored time and isUtc: true
    DateTime firstTimeUse = DateTime.fromMillisecondsSinceEpoch(storedTime, isUtc: true);

    // สำหรับให้แสดงข้อความ ขอโหวต 5 ดาว หลังจากเปิดใช้งานครั้งแรกแล้ว 7 วัน คือ ให้ลองใช้ก่อน แล้วจึงขอให้โหวต
    // สำหรับทดสอบ กำหนดเป็นนาที จะได้ไม่ต้องรอเป็นวัน
// Calculate the difference in minutes using UTC time
    //คิดเป็นนาที
    minutesDifferenceFirstUse = DateTime.now().toUtc().difference(firstTimeUse).inMinutes;
    // bool shouldVoteFiveStar = minutesDifferenceFirstUse >= 2;

    //คิดเป็นวัน
    daysDifferenceFirstUse = DateTime.now().toUtc().difference(firstTimeUse).inDays;
    bool shouldVoteFiveStar = daysDifferenceFirstUse >= 7;



// หาเวลา ตอนคลิก ไม่ต้องแสดงอีก 5 วัน เพื่อจะได้ดูว่าครบ 5 วันหรือยัง
    DateTime lastOpenTime =
    DateTime.fromMillisecondsSinceEpoch(SharedPreferencesManager().getInt('dialogLastOpenTime') ?? 0);

    // คิดเป็นนาที
    int minutesDifference = DateTime.now().difference(lastOpenTime).inMinutes;
    //  bool isHidingDaysPassed = minutesDifference >= 2;


    // Calculate the difference in days
    // คิดเป็นวัน
    int daysDifference = DateTime.now().difference(lastOpenTime).inDays;
    // Check if 5 days have passed since the last open
    bool isHidingDaysPassed = daysDifference >= 5;



    firstOpenApp = firstTimeUse;
    shouldShowVoteFiveStar = shouldVoteFiveStar;
    isVoteFiveStarsAlready = isVoteClicked;
    isDialogHidingExpired = isHidingDaysPassed;

    // สำหรับแสดง dialog
    debugPrint("สำหรับแสดง dialog");
    debugPrint("isHidingDaysPassed in _checkLastOpenTime: $isHidingDaysPassed");

    // สำหรับแสดง ให้กดโหวต 5 ดาว
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

    // จำไว้ว่า เวลาไปเอาข้อมูลที่ต้องรอด้วย async/await หรือ Future ถ้าจะเอามาปรับตัวแปร ก็ใช้การ setState

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
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    await SharedPreferencesManager().setInt('dialogLastOpenTime', DateTime.now().millisecondsSinceEpoch);
  }

  void _setOptionNotShowDialog() async {
//    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    await SharedPreferencesManager().setBool('isVote_5_stars_Clicked', true);
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    bool launched = await launchUrl(uri);

    if (!launched) {
      throw 'Could not launch $url';
    }
  }

  // ไม่ได้ เพราะ ถ้าลบหมดทุกครั้ง ข้อมูลความก้าวหน้าในวงกลม ก็จะหายไปด้วย จึงใช้ไม่ได้ ไม่ได้ใช้อันนี้
  Future<void> populateOcscTjkTable({required List wholeList}) async {
    final dbClient = await SqliteDB().db; // Assuming SqliteDB is your database class

    // Check if the table is empty
    final countResult = await dbClient!.rawQuery('SELECT COUNT(*) as count FROM OcscTjkTable');
    final int rowCount = Sqflite.firstIntValue(countResult) ?? 0;
    debugPrint("Table OcscTjkTable row count: $rowCount");

    // If table is not empty, delete all existing data
    if (rowCount > 0) {
      await dbClient.rawDelete('DELETE FROM OcscTjkTable');
      debugPrint("Deleted all existing rows from OcscTjkTable");
    }

    // Insert all items from wholeList
    debugPrint("Entering populateOcscTjkTable: wholeList.length = ${wholeList.length}");
    for (var i = 0; i < wholeList.length; i++) {
      await dbClient.rawInsert(
        'INSERT INTO "OcscTjkTable"(menu_name, file_name, progress_pic_name, dateCreated, isNew, exam_type, field_2, position, open_last, field_5) VALUES(?,?,?,?,?,?,?,?,?,?)',
        [
          wholeList[i][0], // menu_name
          wholeList[i][1], // file_name
          "p00.png",       // progress_pic_name
          wholeList[i][2], // dateCreated
          0,               // isNew (default to 0 for first use)
          wholeList[i][3], // exam_type
          0,               // field_2 (int)
          wholeList[i][4], // position (text)
          "top",           // open_last (text)
          "reserved"       // field_5 (text)
        ],
      );
    }
    debugPrint("Finished populating OcscTjkTable with ${wholeList.length} rows");
  }

  // checkAndShowUpdateBadge(List<Map<String, dynamic>> myGSheetData) {
  //   //
  // }
  Future<void> checkAndShowUpdateBadge(List<Map<String, dynamic>> gsheetData) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    debugPrint("version from package: $localVersion");

    // 🔍 Find 'ocsc_curr_version_android' in GSheet data
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
    //
    // if (_isNewerVersion(cleanRemoteVersion, localVersion)) {
    //   FlutterAppBadger.updateBadgeCount(1); // 🔴 Show badge
    // } else {
    //   FlutterAppBadger.removeBadge(); // ✅ Remove badge if already shown
    // }
  }

  // bool _isNewerVersion(String latest, String current) {
  //   List<int> latestParts = latest.split('.').map(int.parse).toList();
  //   List<int> currentParts = current.split('.').map(int.parse).toList();
  //
  //   for (int i = 0; i < latestParts.length; i++) {
  //     if (i >= currentParts.length || latestParts[i] > currentParts[i]) return true;
  //     if (latestParts[i] < currentParts[i]) return false;
  //   }
  //   return false;
  // }

  Future<void> checkVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final String local = packageInfo.version;
    // final String remote = "3.4.50"; // Replace with GSheet version

    // Get version from Sheets
    String? remote;
    String? version_ios_gsheets;
    String? whats_new_android_gsheets;
    String? whats_new_ios_gsheets;

    // Iterate through the Google Sheets data
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
    // for (var record in myGSheetData) {
    //   if (record['name'] == 'ocsc_curr_version_android') {
    //     remote = record['description'];
    //     break;
    //   }
    // }

    if (remote == null) {
      debugPrint('No version found from Google Sheets.');
      return;
    }

    String latest = remote.split('+').first;




    debugPrint("current version from GSheets: $latest");
    if (_isNewerVersion(latest, local)) {
      setState(() {
        _localVersion = local;  // for both Android and iOS

        //  _remoteVersion = latest; // for Android
        //  _remoteVersion_iOS = version_ios_gsheets!; // for Android

        _remoteVersion = latest.contains('+') ? latest.split('+')[0] : latest;  // for Android  เอา build หลังเตรื่องหมาย + ออกไป (ถ้ามี)
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


  // for bottom bar notification for Update available
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        context.read<BadgeNotifier>().updateBadgeStatus(false);
      }
    });
  }

  // for bottom bar notification for Update available
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

// void updatePositionInOcscTjkTable({fileName, required String position}) async {
//   final dbClient = await SqliteDB().db;
//   var res = await dbClient!.rawQuery('''
//     UPDATE OcscTjkTable
//     SET position = ?
//     WHERE file_name = ?
//     ''', ['$position', '$fileName']);
// }

Future<void> updatePositionInOcscTjkTable({required String fileName, required String position}) async {
  final dbClient = await SqliteDB().db;
  if (dbClient != null) {
    try {
      // Begin a transaction
      await dbClient.transaction((txn) async {
        // Perform the update within the transaction
        var res = await txn.rawQuery(''' 
          UPDATE OcscTjkTable 
          SET position = ? 
          WHERE file_name = ? 
        ''', ['$position', '$fileName']);
      });
    } catch (e) {
      // Handle any errors that occur during the transaction
      print("Error during transaction: $e");
      // } finally {
      //   // Ensure the database connection is closed only after the transaction
      //   // Do not close the database connection during the transaction block
      //   await dbClient.close();
    }
  }
}





Future retrieveDateFromSQflite({required String fileName}) async {
  var dbClient = await SqliteDB().db; //
  final res = (await dbClient!.rawQuery(
      """ SELECT position, dateCreated, field_2 FROM OcscTjkTable WHERE file_name = '$fileName' """));

  // final res = (await dbClient.rawQuery(
  //     """ SELECT dateCreated FROM OcscTjkTable WHERE file_name = '1_ocsc_answer.xml' """));
  var thisDate;
  int dateFromSQL;
  String pos;
  int is_clicked_main;
  String posAndDate;
  if (res.length > 0) {
    // มี error Bad state No elements ก็เลยต้องเพิ่มการตรวจสอบเข้ามา
    debugPrint("mapxxx rest/first: ${res.first}");
    thisDate = res.first;
    dateFromSQL = thisDate["dateCreated"];
    pos = thisDate["position"];
    is_clicked_main = thisDate["field_2"];  // field_2 เก็บว่า เมนูนี้ คลิกแล้วหรือยัง สำหรัแใช้แสดงจุดแดง
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
//dateFromSQL = thisDate["dateCreated"];
  // debugPrint("dateFromSQL fileName: $fileName mapxxx: $dateFromSQL");
  //return dateFromSQL;
  return posAndDate;
  // } // end of if(fileName.contains
}

// void checkIfNewMenu({required String fileName}) {}

//void deleteMenuItemFromTableIfNotExist({List<String> fileListInMain}) {
Future<void> deleteMenuItemFromTableIfNotExist({required List<String> menuListInMain}) async {
  // เอาข้อมูลจากฐานข้อมูล
  // การใช้ then จาก https://medium.com/flutter-community/a-guide-to-using-futures-in-flutter-for-beginners-ebeddfbfb967
  getDataFromOcscTjkTable().then((List<String> menuNameListFromTable) {
    // เอาข้อมูลจากฐานข้อมูล
    // การใช้ then จาก https://medium.com/flutter-community/a-guide-to-using-futures-in-flutter-for-beginners-ebeddfbfb967
    // debugPrint("mapYYY: length of value ${fileNameListFromTable.length}");
    var notFoundList = [];
    for (var i = 0; i < menuNameListFromTable.length; i++) {
      // debugPrint(
      //     "file from ocscTable - menuNameListFromTable[i]: ${menuNameListFromTable[i]}");
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

// void deleteNonExistMenuFile({required List fileList}) async {
//   debugPrint(" === deleteNonExistMenuFile === ");
//   debugPrint("num of record to be deleted - fileList: ${fileList.length}");
//   var dbClient = await SqliteDB().db;
//   for (var i = 0; i < fileList.length; i++) {
//     debugPrint("not found to be deleted: ${fileList[i]}");
//     var y = await dbClient!.rawDelete(
//         'DELETE FROM OcscTjkTable WHERE menu_name = ?',
//         [fileList[i]]); // ลบเมนู
//     // var z = await dbClient
//     //     .rawDelete('DELETE FROM itemTable WHERE file_name = ?', [fileList[i]]);  // ลบชื่อไฟล์
//   }
// }


void deleteNonExistMenuFile({required List fileList}) async {
  debugPrint(" === deleteNonExistMenuFile === ");
  debugPrint("num of record to be deleted - fileList: ${fileList.length}");
  var dbClient = await SqliteDB().db;

  // Use a transaction to wrap the delete operations
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

void testHowMuchTimeAMethodUsed() async {  // -- เรียกใช้ที่ initState
  const Duration threshold = Duration(seconds: 2);
  await measureExecutionTime(
    //  method: fetchData, // Method to be measured-- ตรวจดูเวลา  เปลี่ยนชื่อ method ตามที่ต้องการัด
    method: getDataFromOcscTjkTable, // Method to be measured-- ตรวจดูเวลา  เปลี่ยนชื่อ method ตามที่ต้องการัด
    threshold: threshold,  // Threshold of 2 seconds
  );
}


Future<T> measureExecutionTime<T>({
  required Future<T> Function() method, // Generic method
  required Duration threshold,          // Time limit to compare against
}) async {
  // Record start time
  final DateTime startTime = DateTime.now();

  // Execute the method and wait for its result
  final T result = await method();

  // Record end time
  final DateTime endTime = DateTime.now();

  // Calculate execution time
  final Duration executionTime = endTime.difference(startTime);

  // Check if execution time exceeds the threshold
  if (executionTime > threshold) {
    debugPrint(
      'Warning: Method took too much time: ${executionTime.inMilliseconds} ms',
    );
  } else {
    debugPrint(
      'Method executed within time: ${executionTime.inMilliseconds} ms',
    );
  }

  return result; // Return the result from the method
}



Future<List<String>> getDataFromOcscTjkTable() async {
  final dbClient = await SqliteDB().db;
  List<Map> results = await dbClient!.rawQuery('SELECT * FROM OcscTjkTable');
  // List<String> fileNameFromOcscTjkTable = [];
  List<String> menuNameFromOcscTjkTable = [];
  results.forEach((result) {
    //  fileNameFromOcscTjkTable.add(result['file_name']);
    menuNameFromOcscTjkTable.add(result['menu_name']);
  });
  // debugPrint("mapYYY: fileNameFromOcscTjkTable: $fileNameFromOcscTjkTable");
  return menuNameFromOcscTjkTable;
  // return fileNameFromOcscTjkTable;
}
//
// Future<List<String>> getFileNameFromOcscTjkTable() async {
//   final dbClient = await SqliteDB().db;
//   List<Map> results = await dbClient.rawQuery('SELECT * FROM OcscTjkTable');
//   List<String> fileNameFromOcscTjkTable = [];
//   //List<String> menuNameFromOcscTjkTable = [];
//   results.forEach((result) {
//       fileNameFromOcscTjkTable.add(result['file_name']);
//    // menuNameFromOcscTjkTable.add(result['menu_name']);
//   });
//   // debugPrint("mapYYY: fileNameFromOcscTjkTable: $fileNameFromOcscTjkTable");
//  // return menuNameFromOcscTjkTable;
//    return fileNameFromOcscTjkTable;
// }

//void removeMenuItemFromDatabaseIfNotExist({List listName}) {}

// checkAndUpdateOcscTjkTable(
Future<void> addNewDataIfAny(
    {required String menuName,
      required String fileName,
      required String createDate,
      required int whatType,
      required String position}) async {
  // if (menuName.contains("pdf")) {
  //   debugPrint("menuName pdf: $menuName");
  // }
  if (menuName.contains("ทดสอบ")) {
    debugPrint("menu ก่อนเอาเข้าฐานข้อมูล: $menuName file: $fileName");
  }

  // if (fileName.contains("https")) {
  //   debugPrint("fileName for youtube: $fileName");
  // }
  int thisDate = int.parse(createDate); // เปลี่ยน String เป็น int
  // เพราะ ในฐานข้อมูล เป็นประเภท integer แต่วันที่ ที่ส่งเข้ามา เป็น String

  final dbClient = await SqliteDB().db;
  //ดูว่ามีไฟล์นี้ในฐานข้อมูลไหม ถ้าไม่มี แสดงว่า เพิ่มข้อสอบชุดนี้เข้ามาใหม่ ให้เอาเข้าฐานข้อมูลด้วย
  var x = await dbClient!.rawQuery(
//      'SELECT COUNT (*) from OcscTjkTable WHERE file_name = ?', ["$fileName"]);
      'SELECT COUNT (*) from OcscTjkTable WHERE menu_name = ?',
      ["$menuName"]); // เปลี่ยน เอาชื่อเมนูไปเทียบดีกว่า
  int? countX = Sqflite.firstIntValue(x);
  // if (fileName.contains("https")) {
  //   debugPrint("fileName for youtube: $fileName พบหรือไม่: $countX");
  // }
//  debugPrint(" นับชื่อเมนู $menuName ว่ามีในตาราง Ocsc หรือไม่ เพื่อดูว่า เป็นไฟล์ใหม่หรือเปล่า  ถ้าเป็น 0 แสดงว่า ใหม่ countX: $countX");
  if (countX == 0) {
    debugPrint(
        "xx all files If data countx == 0 ไฟล์ใหม่  '$menuName' '$fileName' $thisDate  ");
    // เอาเข้าฐานข้อมูล


    await dbClient.transaction((txn) async {
      var result = await txn.rawInsert(
          'INSERT INTO "OcscTjkTable"(menu_name, file_name, progress_pic_name, dateCreated, isNew, exam_type, field_2, position, open_last, field_5) '
              'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            menuName,
            fileName,
            'p00.png',
            thisDate,
            1,          // isNew = 1 (red dot)
            whatType,
            0,          // field_2
            position,
            '0',        // open_last
            'reserved'  // field_5
          ]
      );
      debugPrint("Insert result: $result");
    });
    //   debugPrint("xx all files If data result: $result");
    //   return result;
  } else {
    // ถ้าเป็นไฟล์ที่มีอยู่แล้ว ตรวจเรื่อง position อาจจะมีเปลี่ยน ถ้ามี ปรับฐานข้อมูลด้วย
  }
}

// void addToOcscTjkTable({required List wholeList}) async {
//   final dbClient = await SqliteDB().db;
//   // แถว ๆ นี้แหละ มันวนหลายรอบ เข้ามาใหม่ซิง ๆ ไม่เป็นไร แต่ ถ้าลบไฟล์ในมือถือ แล้วให้รันใหม่ จะวนหลายรอบ
//   int res;
//   debugPrint("enter addToOcscTjkTable: wholeList.length =  ${wholeList.length}");
//   for (var i = 0; i < wholeList.length; i++) {
//     res = await dbClient!.rawInsert(
//         'INSERT INTO "OcscTjkTable"(menu_name,file_name,progress_pic_name,dateCreated,isNew,exam_type,field_2,position,open_last,field_5) VALUES(?,?,?,?,?,?,?,?,?,?)',
//         [
//           // (field id เป็น auto generated จึงไม่มี เพราะ ให้โปรแกรมใส่เอง
//
//           // wholeList[i][0] - ชื่อเมนู,  wholeList[i][1] - ชื่อไฟล์, wholeList[i][2] - วันที่,  wholeList[i][3] - ประเภท
//           wholeList[i][0], // field: menu_name
//           wholeList[i][1], // field: file_name
//           "p00.png",  //  field: progress_pic_name
//           wholeList[i][2],  // field: dateCreated
//           0,  // field: isNew กำหนดให้เป็น 0 เลย เพราะ เป็นการเปิดใช้ครั้งแรก
//           wholeList[i][3], // field: exam_type
//           0, // field: field_2 (int)
//           wholeList[i][4], // field: position (text)
//           "top", // field: open_last (text)
//           "reserved" // field: field_5 (text)
//         ]);
//   }
//   //return res;
// }


void addToOcscTjkTable({required List wholeList}) async {
  final dbClient = await SqliteDB().db;

  // Start a transaction
  await dbClient!.transaction((txn) async {
    int res;
    debugPrint("enter addToOcscTjkTable: wholeList.length =  ${wholeList.length}");

    for (var i = 0; i < wholeList.length; i++) {
      res = await txn.rawInsert(
          'INSERT INTO "OcscTjkTable"(menu_name, file_name, progress_pic_name, dateCreated, isNew, exam_type, field_2, position, open_last, field_5) '
              'VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            wholeList[i][0], // field: menu_name
            wholeList[i][1], // field: file_name
            "p00.png", // field: progress_pic_name
            wholeList[i][2], // field: dateCreated
            0, // field: isNew
            wholeList[i][3], // field: exam_type
            0, // field: field_2 (int)
            wholeList[i][4], // field: position
            "top", // field: open_last
            "reserved" // field: field_5
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
      createDate); // เปลี่ยน String เป็น int เพราะ ในฐานข้อมูล เป็นประเภท integer แต่วันที่ ที่ส่งเข้ามา เป็น String
  final dbClient = await SqliteDB().db;
  //ดูว่ามีไฟล์นี้ในฐานข้อมูลไหม ถ้าไม่มี แสดงว่า เพิ่มข้อสอบชุดนี้เข้ามาใหม่ ให้เอาเข้าฐานข้อมูลด้วย
  var x = await dbClient!.rawQuery(
      'SELECT COUNT (*) from OcscTjkTable WHERE file_name = ?', ["$fileName"]);
  int? countX = Sqflite.firstIntValue(x);

  if (countX == 0) {
    // debugPrint(
    //     "xx all files If data countx == 0 ไฟล์ใหม่  '$menuName' '$fileName' $thisDate  ");
    // เอาเข้าฐานข้อมูล

    // debugPrint(
    //     "xx all files If data:: menuName: $menuName, fileName: $fileName, createDate:     , whatType: $whatType ");
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
    //  debugPrint("xx all files If data result: $result");
    return result;
  }
}

// new screen page One
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
  //Navigator.push(context, MaterialPageRoute(builder: (context) => mainMenu()));
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
      'INSERT INTO hashTable (name, str_value) VALUES("appMode", "light")'); // กำหนดค่าเริ่มต้นไว้เลย
  // return res;
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
  if(firstRun==false){  // ถ้าใน sharePref ไม่มี หรือ มีแต่เป็น false แสดงว่า เป็นการใช้งานครั้งแกชรก
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


  // Writing and Reading from any class
  await SharedPreferencesManager().setIntIfNotExists('timeOfFirstRun', DateTime.now().toUtc().millisecondsSinceEpoch);
  int storedTime = SharedPreferencesManager().getInt('timeOfFirstRun');
  debugPrint("storedTime from main>sharePrefManager: $storedTime");

  await SharedPreferencesManager().setBoolIfNotExists('isVote_5_stars_Clicked', false);
  await SharedPreferencesManager().setBoolIfNotExists('noMoreShowWelcomeDialog', false);

  bool isVote_5_stars_Clicked = SharedPreferencesManager().getBool('isVote_5_stars_Clicked');
  debugPrint("isVote_5_stars_Clicked from main>sharePrefManager: $isVote_5_stars_Clicked");

} // end of Future setDefaultValueForWelcomDialog()




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
      // Do something if the website is available
    } else {
      isWebsiteAvailable = "no";
      debugPrint('statusCode is not equal to 200 -- Website is down.');
      // Set a variable to something if the website is down
    }
  } on SocketException {
    isWebsiteAvailable = "no";
    debugPrint('SocketException: Website is down.');
    // Set a variable to something if the website is down
  } on HttpException {
    isWebsiteAvailable = "no";
    debugPrint('HttpException: Website is down.');
    // Set a variable to something if the website is down
  }
  return isWebsiteAvailable;
}


//
//
// Future<dynamic> requestGET({required String url}) async {
//   try {
//     final response = await http.get(Uri.parse(url));
//     switch (response.statusCode) {
//       case 200:
//       case 201:
//         final result = jsonDecode(response.body);
//         final jsonResponse = {'success': true, 'response': result};
//         return jsonResponse;
//       case 400:
//         final result = jsonDecode(response.body);
//         final jsonResponse = {'success': false, 'response': result};
//         return jsonResponse;
//       case 401:
//         final jsonResponse = {
//           'success': false,
//           'response': ConstantUtil.UNAUTHORIZED
//         };
//         return jsonResponse;
//       case 500:
//       case 501:
//       case 502:
//         final jsonResponse = {
//           'success': false,
//           'response': ConstantUtil.SOMETHING_WRONG
//         };
//         return jsonResponse;
//       default:
//         final jsonResponse = {
//           'success': false,
//           'response': ConstantUtil.SOMETHING_WRONG
//         };
//         return jsonResponse;
//     }
//   } on SocketException {
//     final jsonResponse = {
//       'success': false,
//       'response': ConstantUtil.NO_INTERNET
//     };
//     return jsonResponse;
//   } on FormatException {
//     final jsonResponse = {
//       'success': false,
//       'response': ConstantUtil.BAD_RESPONSE
//     };
//     return jsonResponse;
//   } on HttpException {
//     final jsonResponse = {
//       'success': false,
//       'response': ConstantUtil.SOMETHING_WRONG  //Server not responding
//     };
//     return jsonResponse;
//   }
// }
//

Future insertExamFileData({required List listName}) async {
  // debugPrint("listName: $listName");
  int? res;
  for (var i = 0; i < listName.length; i++) {
    //   debugPrint("listName: $i length: ${listName.length} $listName ");
    // Add to table
    final dbClient = await SqliteDB().db;
    // final res = await dbClient.rawQuery(""" SELECT * FROM ExamProgress; """);
    // return res;

    res = await dbClient!.rawInsert(
        'INSERT INTO "OcscTjkTable"(menu_name,file_name,progress_pic_name,dateCreated,isNew,exam_type,field_2,position,open_last,field_5) VALUES(?,?,?,?,?,?,?,?,?,?)',
        [
          // listName[i][0] - ชื่อเมนู,  listName[i][1] - ชื่อไฟล์, listName[i][2] - วันที่,  listName[i][3] - ประเภท
          listName[i][0],
          // field: menu_name   (field id เป็น auto generated จึงไม่มี เพราะ ให้โปรแกรมใส่เอง
          listName[i][1],
          // field: file_name
          "p00.png",
          //  field: progress_pic_name
          listName[i][2],
          // field: dateCreated
          0,
          // field: isNew
          listName[i][3],
          // field: exam_type
          0,
          // field: field_2 (int)
          "reserved",
          // field: position (text)
          "tbl_q1",
          // field: open_last (text)
          "reserved"
          // field: field_5 (text)
        ]);
  }
  return res;
}

class ConstantUtil {  // สำหรับเรียกใช้ตอน เชคสถานะของ pastebin.com
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

// constants/strings.dart
const String keyUsername = "key_username";

// บังคับให้พิมพ์ข้อมูลทั้งหมด โดยไม่มีการตัด เพราะ flutter จะตัดข้อมูล ถ้ายาวมากๆ เช่น ใน list มีสมาชิกสัก 500 ก็จะพิมพ์ให้ดูเพียง จำนวนหนึ่งเท่านั้น ไม่พิมพ์ทั้งหมด
void debugPrintWrapped(String text) {
  final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}


Future<int> getInstallDate() async {  // วันติดตั้งแอป กะจะใช้กับ isNew
  final dir = await getApplicationSupportDirectory();
  final stat = await dir.stat();
  //return stat.changed; // Returns the creation date
  // return stat.changed.millisecondsSinceEpoch; // Convert to epoch timestamp
  return (stat.changed.millisecondsSinceEpoch ~/ 1000); // Convert to seconds
}





class Data extends ChangeNotifier {
  // สำหรับ รับค่ามาจาก JavaScript แล้วส่งต่อ เช่น ส่งไป Willpopscope เพื่อ เมื่อคลิกแล้วส่งข้อมูลไปหน้าเมนู สำหรับแสดงว่า ทำไปมากน้อย กี่ข้อ
  String data = "112233";

  void changeString(String newString) {
    data = newString;
    debugPrint("newString from JS in Data class to notifyListeners: $newString");
    notifyListeners();
  }
}






 // import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
// //import 'dart:js_interop';
// // import 'package:flutter_app_badger/flutter_app_badger.dart';  // discontinued
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:http/http.dart' as http;
// // import 'package:in_app_update/in_app_update.dart';
// // import 'package:upgrader/upgrader.dart';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:ocsc_exam_prep/sharePreferencesManager.dart';
// import 'package:ocsc_exam_prep/src/constant.dart';
// import 'package:ocsc_exam_prep/store_config.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:path_provider/path_provider.dart';
// //import 'package:rating_dialog/rating_dialog.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/src/widgets/visibility.dart' as flutterVisibility; // สำหรับซ่อน ชวนให้โหวต 5 ดาว
//
// import 'package:ocsc_exam_prep/theme.dart';
// // import 'package:pastebin/pastebin.dart';
//
// import 'package:provider/provider.dart';
// import 'package:purchases_flutter/models/store.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqflite/sqflite.dart';
//
// import 'ProviderModel.dart';
// import 'curriculum.dart';
//
// // import 'logic/dash_counter.dart';
// // import 'logic/dash_purchases.dart';
// // import 'logic/dash_upgrades.dart';
// // import 'logic/firebase_notifier.dart';
// import 'mainMenu.dart';
// import 'sqlite_db.dart';
// import 'dart:math'; // สำหรับหา random number เพื่อแสดง ขอกำลังใจ 5 ดาว
// //import 'package:pastebin/pastebin.dart' as pbn;
// import 'package:ocsc_exam_prep/googleSheetsAPI.dart';
//
// import'package:ocsc_exam_prep/app_utils.dart';
//
// import 'package:connectivity_plus/connectivity_plus.dart'; // สำหรับเชคว่าต่ออินเทอร์เน็ตหรือเปล่า
//
// //const countDown_global = "วันมาฆะบูชา _X_ ๒๖ กุมภาพันธ์ ๒๕๖๗  _X_ 2024-02-26 00:00:01xyzวันจักรี _X_ ๘ เมษายน ๒๕๖๗  _X_ 2024-04-08 00:00:01xyzวันสงกรานต์ _X_ ๑๓ เมษายน ๒๕๖๗  _X_ 2024-04-13 00:00:01xyzวันฉัตรมงคล  _X_ ๖ พฤษภาคม ๒๕๖๗  _X_ 2024-05-06 00:00:01xyzวันวิสาบูชา _X_ ๒๒ พฤษภาคม  ๒๕๖๗  _X_ 2024-05-22 00:00:01xyzวันเฉลิมพระชนมพรรษาสมเด็จพระนางเจ้าฯ พระบรมราชินี _X_ ๓ มิถุนายน  ๒๕๖๗  _X_ 2024-06-03 00:00:01xyzวันอาสาฬหบูชา _X_ ๒๐ กรกฎาคม  ๒๕๖๗  _X_ 2024-07-20 00:00:01xyzวันเข้าพรรษา _X_ ๒๑ กรกฎาคม    ๒๕๖๗  _X_ 2024-07-21 00:00:01xyzวันเฉลิมพระชนมพรรษาพระบาทสมเด็จพระวชิรเกล้าเจ้าอยู่หัว รัชกาลที่ 10 _X_ ๒๘ กรกฎาคม  ๒๕๖๗  _X_ 2024-07-28 00:00:01xyzวันแม่แห่งชาติ &&&วันเฉลิมพระชนมพรรษา &&&สมเด็จพระนางเจ้าสิริกิติ์ พระบรมราชินีนาถ พระบรมราชชนนีพันปีหลวง _X_ ๑๒ สิงหาคม  ๒๕๖๗  _X_ 2024-08-12 00:00:01xyzวันนวมินทรมหาราช (วันคล้ายวันสวรรคต)&&& พระบาทสมเด็จพระบรมชนกาธิเบศร มหาภูมิพลอดุลยเดชมหาราช บรมนาถบพิตร _X_ ๑๓ ตุลาคม  ๒๕๖๗  _X_ 2024-10-13 00:00:01xyzวันปิยมหาราช _X_ ๒๓ ตุลาคม  ๒๕๖๗  _X_ 2024-10-23 00:00:01xyzวันพ่อแห่งชาติ  _X_ ๕ ธันวาคม  ๒๕๖๗  _X_ 2024-12-05 00:00:01xyzวันรัฐธรรมนูญ _X_ ๑๐ ธันวาคม  ๒๕๖๗  _X_ 2024-12-10 00:00:01xyzวันสิ้นปี _X_ ๓๑ ธันวาคม  ๒๕๖๗  _X_ 2024-12-31 00:00:01xyzวันขึ้นปีใหม่  _X_ ๑ มกราคม ๒๕๖๘  _X_ 2025-01-01 00:00:01";
// const countDown_global = "สอบ ก.พ. e-Exam รอบที่ 6 _X_ วันที่ 26 เม.ย. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-26 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 7 _X_ วันที่ 27 เม.ย. 67 เวลา 09.00 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-27 09:00:00xyzสอบ ก.พ. e-Exam รอบที่ 8 _X_ วันที่ 27 เม.ย. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-27 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 9 _X_ วันที่ 28 เม.ย. 67 เวลา 09.00 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-28 09:00:00xyzสอบ ก.พ. e-Exam รอบที่ 10 _X_ วันที่ 28 เม.ย. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-04-28 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 11 _X_ วันที่ 24 พ.ค. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-24 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 12 _X_ วันที่ 25 พ.ค. 67 เวลา 09.00 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-25 09:00:00xyzสอบ ก.พ. e-Exam รอบที่ 13 _X_ วันที่ 25 พ.ค. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-25 14:30:00xyzสอบ ก.พ. e-Exam รอบที่ 14 _X_ วันที่ 26 พ.ค. 67 เวลา 09.00 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-26 09:00:00xyzสอบ ก.พ. e-Exam รอบที่ 15 _X_ วันที่ 26 พ.ค. 67 เวลา 14.30 น. &&&นับถอยหลัง วันสอบ _X_ 2024-05-26 14:30:00";
// // ต้องเชคว่า สถานะการซื้อ ถ้ายังไม่ซื้อ จะมีปุ่มซื้อหรือไม่
// // ใน ProviderModel ใส่ข้อมูลในตาราง hashTable เป็น true ตอนซื้อแล้ว แต่ยังไม่แน่ ว่า ถ้าไม่กดปุ่ม อันนี้จะทำงานหรือไม่
// // ต้องทดสอบ ตอนส่งขึ้นจริง แล้วดูว่า ถ้ายังไม่ซื้อ จะมีปุ่มซื้อปรากฏหรือไม่
// // เพราะไม่แน่ใจว่า เส้นทางไปไงมาไง เชคใน Google Play ก่อน หรือเปล่า
// // คือ ถ้าดาวน์โหลดมาติดตั้งจาก play store ในตาราง hashTable และ
// // ใน sharePref จะไม่มีข้อมูลเกี่ยวกับการซื้อ (sku)  จะมีปุ่มซื้อปรากฏ แต่ถ้าซื้อแล้ว
// // จะเขียนข้อมูลลงตาราง hastTable แม้ว่าจะลบถอนติดตั้ง และติดตั้งใหม่ inapp purchase ก็จะ
// // เขียนลงตาราง hashTable ว่าซื้อแล้ว (sku, true) เพราะตอนทดสอบ ปรากฏว่า
// // ใน ProviderModel ไปที่ซื้อแล้ว แสดงว่า สันนิษฐานว่า มีการเชคจากเครื่อง -- อันนี้ จึงต้องทดสอบอีกที ตอนเอาขึ้นจริง
//
// // Gives the option to override in tests.
// class IAPConnection {
//   static InAppPurchase? _instance;
//
//   static set instance(InAppPurchase value) {
//     _instance = value;
//   }
//
//   static InAppPurchase get instance {
//     _instance ??= InAppPurchase.instance;
//     debugPrint("_instance in main.dart: $_instance");
//     return _instance!;
//   }
//
// // static Future<bool> get isConfigured async =>
// //     await _channel.invokeMethod('isConfigured') as bool;
//
// }
//
//
//
// Future main() async {
//
//   // await Firebase.initializeApp(
//   //   options: DefaultFirebaseOptions.currentPlatform,
//   // ),
//
//   WidgetsFlutterBinding.ensureInitialized();
//
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);  // for Edge-to-edge SDK 35
//
//   //WidgetsFlutterBinding.ensureInitialized();
//   //PlatformDispatcher.instance.onReportTimings = (_) {};
//
//   if (Platform.isAndroid) {
//     await InAppWebViewController.setWebContentsDebuggingEnabled(true);
//   }
//
//
//   // Initialize SharedPreferencesManager once in your app, preferably at the beginning เพื่อให้ใช้ sharePref ตัวเดียวกัน
//   await SharedPreferencesManager().initialize();
//
//   if (Platform.isIOS || Platform.isMacOS) {
//     StoreConfig(
//       store: Store.appStore,
//       apiKey: appleApiKey,
//     );
//   } else if (Platform.isAndroid) {
//     // Run the app passing --dart-define=AMAZON=true
//     const useAmazon = bool.fromEnvironment("amazon");
//     StoreConfig(
//       store: useAmazon ? Store.amazon : Store.playStore,
//       apiKey: useAmazon ? amazonApiKey : googleApiKey,
//     );
//     debugPrint("googleApiKey: $googleApiKey");
//   }
//
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // เชคว่า configure แล้วหรือยัง
//   // Check if purchase has already been configured
//   bool purchasesConfigured = await Purchases.isConfigured;
//   debugPrint("purchasesConfigured already: $purchasesConfigured");
//   // If purchase has not been configured, then call _configureSDK
//   if (!purchasesConfigured) {
//     await _configureSDK();
//   }
//
//   // int? installDate = await getInstallDate();
//   // print("App Installed Date: $installDate");
//
//   runApp(
//     const MyApp(),
//   );
// } // end of void main()
//
//
// //
// // static Future<bool> get isConfigured async =>
// //     await _channel.invokeMethod('isConfigured') as bool;
// //
//
//
//
// Future<void> _configureSDK() async {
//   // Enable debug logs before calling `configure`.
//   await Purchases.setLogLevel(LogLevel.debug);
//
//   /*
//     - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
//     - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
//     */
//   PurchasesConfiguration configuration;
//   if (StoreConfig.isForAmazonAppstore()) { // update เป็น รุ่น 8 ของ Revenuecat
//     // เอามาจาก ตัวอย่าง ที่ https://github.com/RevenueCat/purchases-flutter/blob/main/revenuecat_examples/MagicWeather/lib/main.dart
//     configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
//       ..appUserID = null
//       ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
//   } else {
//     configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
//       ..appUserID = null
//       ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
//   }
//   // if (StoreConfig.isForAmazonAppstore()) {  // รุ่น 6 ของเก่า ของ Revenuecat
//   //   configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
//   //     ..appUserID = null
//   //    ..observerMode = false;
//   //
//   // } else {
//   //   configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
//   //     ..appUserID = null
//   //  ..observerMode = false;
//   // }
//
//   await Purchases.configure(configuration);
// } // end of _configureSDK()  -- revenueCat
//
//
//
//
// //สำหรับ in_app_purchases  -- ถึงตงนี้  กำลังแก้ใน paymentscreen.dart ด้วย
// // Auto-consume must be true on iOS.
// // // To try without auto-consume on another platform, change `true` to `false` here.
//
// //เอาออก จะใช้ของ codelabs
// // final bool _kAutoConsume = Platform.isIOS || true;
// //
// // const String _kConsumableId = 'consumable';
// // const String _kUpgradeId = 'upgrade';
// // const String _kSilverSubscriptionId = 'subscription_silver';
// // const String _kGoldSubscriptionId = 'subscription_gold';
// // const List<String> _kProductIds = <String>[
// //   _kConsumableId,
// //   _kUpgradeId,
// //   _kSilverSubscriptionId,
// //   _kGoldSubscriptionId,
// // ];
//
// // บางที มีเมนูซ้ำกัน 3 ครั้ง รูปหน้า ก็ไม่มา *** อย่าลืมแก้  ******* แก้แล้ว เพิ่ม unique ตอนสร้างตาราง
// class MyApp extends StatefulWidget {
//   // This widget is the root of your application.
//
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {  // WidgetsBindingObserver เพื่อว่า จะได้ลบข้อมูลในกระดาษทด ตอน exit โปรแกรม
//
//   // AppUpdateInfo? _updateInfo;
//   GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
//   bool _flexibleUpdateAvailable = false;
//
//   var _prefs;
//   late Image beachImage;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   late Data _data;
//
//   // สำหรับ แสดง dialog ตอนเปิดใช้งาน ตรงนี้เป็นส่วนให้ผู้ใช้ปิดไม่ให้แสดงอีก 5 วัน
//   //ถ้าต้องการเปลี่ยนจำนวนวัน ให้ค้นหาว่า Check if 5 days have passed since the last open
//   bool isDialogHidingExpired = false;  // กำหนดให้เป็น false เลย ไม่งั้น มีปัญหา
//   //เกี่ยวกับ lateInitializationError เพราะมัวไปเอาจาก sharePref ยังไม่ทันเสร็จ
//   bool? isAlertboxOpened;
//   late Future<String?> _countDownMsg;  // สำหรับ นับถอยหลังวันสอบ หน้าเมนูหลัก
//
//   // late Future<String?> _curr_version;  // สำหรับทำ badge notification จุดแดงที่ icon แสดงว่ามี Update
//
//   // for google sheets
//   // final GoogleSheetsAPI _sheetsAPI = GoogleSheetsAPI();
//   // List<Map<String, dynamic>> myGSheetData = [];
//
//
//   // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//   //   android: AndroidInAppWebViewOptions(
//   //     useHybridComposition: true,
//   //   ),);
//
//   // InAppWebViewSettings(
//   // mediaPlaybackRequiresUserGesture: false,
//   // useHybridComposition: true,
//   // allowsInlineMediaPlayback: true,
//   // );
//
//   @override
//   void initState() {
//     super.initState();
//     // checkForUpdate();
//     // flexibleUpdate();
//
//     WidgetsBinding.instance.addObserver(this);
//
//     isAlertboxOpened = false; // preventing welcome dialog to show multiple times
//     _prefs = SharedPreferences.getInstance();
//
//     getLastDialogOpenTime();
//
//     beachImage = Image.asset(
//         "assets/images/beach04.png"); // เพื่อจะ preload รูปเข้ามาก่อน
//
//
//     listPdfFiles();  // to check only
//     //   aboutPageBkg = Image.asset("assets/images/page_about.png");
//     // _countDownMsg = getCountDwnMsg();
//     //  fetchData();
//     //  flexibleUpdate();
//   }
//
//   //
//   // Future<void> checkForUpdate() async {
//   //   InAppUpdate.checkForUpdate().then((info) {
//   //     setState(() {
//   //       _updateInfo = info;
//   //     });
//   //  //   flexibleUpdate();
//   //
//   //   }).catchError((e) {
//   //     showSnack(e.toString());
//   //   });
//   // }
//
//   // Future<void> fetchData() async {
//   //   final GSheetsData = await _sheetsAPI.fetchData();
//   //   setState(() {
//   //     myGSheetData = GSheetsData;
//   //   });
//   //  //    debugPrint("data from sheets: ${_myGSheetData[2]}");
//   // }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     precacheImage(beachImage.image, context);
// //    precacheImage(aboutPageBkg.image, context);
//   }
//
//   @override
//   void dispose() {
//     clearDrawingOnExit(); // ลบข้อมูลในกระดาษทด Clear drawing on app exit
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   void clearDrawingOnExit() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('savedDrawing');
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     createHashTableIfNotExist();
//     createOcscTjkTableIfNotExist();
//     createItemTableIfNotExist();
//     deleteOrphantRecords();
// //    getBooleanValue("is_First_Run"); // ตรวจดูเฉย ๆ ไม่ได้ทำอะไรต่อ ที่ทำจริง อยู่ใน mainMenu.dart ใช้แสดงจุดแดง isNew
//     setDefaultValueForWelcomDialog();
//     return ChangeNotifierProvider<Data>(
//
//       // สำหรับรับค่ามาจาก Javascript และส่ง Willpopscope
//       create: (_) => Data(),
//       child: ChangeNotifierProvider(
//         // สำหรับ theme
//         create: (_) => ThemeNotifier(),
//         child: Consumer<ThemeNotifier>(
//           builder: (context, notifier, child) {
//             debugPrint("notifier.darkTheme: ${notifier.darkTheme}");
//             debugPrint("notifier.isFirstRun: ${notifier.isFirstRun}");
//             return MultiProvider(
//               providers: [
//                 // สำหรับ in_app purchases
//                 ChangeNotifierProvider(create: (_) => ProviderModel()),
//                 // สำหรับ bottom bar notification for Update
//                 ChangeNotifierProvider(create: (_) => BadgeNotifier()),
//               ],
//               //    return ChangeNotifierProvider(
//               //     // สำหรับ in_app purchases
//               //     create: (_) => ProviderModel(),
//               // child: ChangeNotifierProvider<FirebaseNotifier>(
//               //     create: (_) => FirebaseNotifier(),
//               //     child: ChangeNotifierProvider<DashUpgrades>(
//               //       create: (context) => DashUpgrades(
//               //         context.read<DashCounter>(),
//               //         context.read<FirebaseNotifier>(),
//               //         ),
//               //       lazy: false,
//               //       child: ChangeNotifierProvider<DashPurchases>(
//               //         create: (context) => DashPurchases(
//               //           context.read<DashCounter>(),
//               //           context.read<FirebaseNotifier>(),
//               //           context.read<IAPRepo>(),
//               //         ),
//               //         lazy: false,
//               child: MaterialApp(
//                 title: 'OCSC Exam Prep Application',
//                 theme: notifier.darkTheme ? dark : light, //theme: dark,
//                 //home: UpgradeAlert(upgrader: Upgrader(messages: MyThaiMsgForUpgraderDialog()),
//
//                 home: MyHomePage(
//                   title: 'เตรียมสอบ ก.พ. (ภาค ก.)',
//                   beachImage: beachImage,
//                   isDialogHidingExpired: isDialogHidingExpired, //ส่งมาจาก myApp()
//                 ),
//               ),
//             );
//
//             //      ))));  // สลับกับบรรทัดบน ถ้า เอา คอมเม้น พวก ChangeNotifierProvider ออก
//           },
//         ),
//       ),
//     );
//   }
//
//   void deleteOrphantRecords() async {
//     var dbClient = await SqliteDB().db;
//     await dbClient!.rawDelete(
//       'delete from itemTable where file_name not in (select file_name from OcscTjkTable)',
//     );
//   }
//
//   void getLastDialogOpenTime() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     DateTime lastOpenTime =
//     DateTime.fromMillisecondsSinceEpoch(prefs.getInt('dialogLastOpenTime') ?? 0);
//
//     // Calculate the difference in days
//     int daysDifference = DateTime.now().difference(lastOpenTime).inDays;
//
//     // Check if 5 days have passed since the last open
//     // bool isDialogHidingDaysPassed = daysDifference >= 5;
//
//     // คิดเป็นนาที
//     int minutesDifference = DateTime.now().difference(lastOpenTime).inMinutes;
//     bool isDialogHidingDaysPassed = minutesDifference >= 2;
//
//     // จำไว้ว่า เวลาไปเอาข้อมูลที่ต้องรอด้วย async/await หรือ Future ถ้าจะเอามาปรับตัวแปร ก็ใช้การ setState
//     setState(() {
//       isDialogHidingExpired = isDialogHidingDaysPassed;
//     });
//   }
//
//   void showSnack(String text) {
//     if (_scaffoldKey.currentContext != null) {
//       ScaffoldMessenger.of(_scaffoldKey.currentContext!)
//           .showSnackBar(SnackBar(content: Text(text)));
//     }
//   }
//
//   void listPdfFiles() async {
//     Directory dir = Directory('/data/user/0/com.thongjoon.ocsc_exam_prep/app_flutter');
//     List<FileSystemEntity> files = dir.listSync();
//
//     for (var file in files) {
//       if (file is File && file.path.endsWith('.pdf')) {
//         print('PDF File: ${file.path}');
//       }
//     }
//   }
// //
// // void flexibleUpdate() {
// //   _updateInfo?.updateAvailability ==
// //       UpdateAvailability.updateAvailable
// //       ? () {
// //     InAppUpdate.startFlexibleUpdate().then((_) {
// //       setState(() {
// //         _flexibleUpdateAvailable = true;
// //       });
// //     }).catchError((e) {
// //       showSnack(e.toString());
// //     });
// //   }
// //       : null;
// // }
//
//
// //Future<String> getCountDwnMsg() {}
// }
//
// class BadgeNotifier extends ChangeNotifier {
//   bool _showBadge = false;
//
//   bool get showBadge => _showBadge;
//
//   void updateBadgeStatus(bool value) {
//     _showBadge = value;
//     notifyListeners();
//   }
// }
//
// Future _launchUrl() async {
//   final Uri _url = Uri.parse('https://play.google.com/store/apps/details?id=com.thongjoon.ocsc_exam_prep');
//   if (!await launchUrl(_url)) {
//     throw Exception('Could not launch $_url');
//   }
// }
//
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage(
//       {super.key,
//         required this.title,
//         required this.beachImage,
//         this.appName,
//         this.packageName,
//         this.version,
//         this.buildNumber,
//         required this.isDialogHidingExpired,
//       });
//
//   final String title;
//   final Image beachImage;
//   final bool isDialogHidingExpired;
//   final String? appName;
//   final String? packageName;
//   final String? version;
//   final String? buildNumber;
//
//
//   // *******************************************************************************************
// //  เมนูของเต็ม รวมของเก่าด้วย backup เอาไว้ที่  "C:\_flutter\bckup\main_bckup_หน้าเมนูเต็ม.txt"
// // เวลาจะแก้เมนูที่มีอยู่แล้ว ต้องลบออกก่อน แล้ว run โปรแกรมใหม่ เพื่อให้ลบข้อมูลในฐานข้อมูลออกก่อน
// // เสร็จแล้ว จึง paste เข้ามาใหม่ แล้วจึงแก้ ไม่งั้น ก็จะยังเป็นของเดิม เพราะไปเอาข้อมูลจากในฐานข้อมูล
// // ถ้าเปลี่ยนชื่อไฟล์เฉย ๆ โดยไม่ลบของเดิมออกก่อน ก็จะไปเอาไฟล์เก่ามาแสดงเหมือนเดิม
//   static const general = [
//     ["ตัวอย่างข้อสอบ ของ กพ.", "label_main_ocscSample", "10012", "1", "a1.0"],
//     //
//     // ชื่อในเมนู - ชื่อไฟล์ - วันที่ - ประเภท - ตำแหน่งที่ปรากฎ
//     [
//       "ข้อสอบ จากเว็บของ กพ",
//       // ชื่อที่จะปรากฏบนเมนู
//       "1_ocsc_answer.xml",
//       // ชื่อไฟล์ที่ใช้งาน ของเรื่องนี้
//      // "1633248995",
//       "1745575210",
//       // เลขวันที่ epoch date สร้างด้วยไฟล์ util/find_seconds.html
//       "1",
//       // หน้าที่ 1 หน้า 2=อังกฤษ   3=กฎหมาย
//       "a1.00"
//       // ใช้เรียงลำดับ a1 คือ หน้า 1 หลังจุด ใช้เรียงแบบอักษร ไม่ใช่ตัวเลข คือ 1 > 11 > 111 > 2 > 22 > 3 ...
//     ],
//     // ชื่อในเมนู, ชื่อไฟล์, วันที่, ประเภท 1=ทั่วไป 2=อังกฤษ 3=กฎหมาย 4=ทำข้อสอบ, ลำดับ
//     // ลำดับ ใช้้เป็น String เพราะจะได้เรียงง่าย ๆ เมื่อมีการเพิ่มหัวข้อ เช่น a1.21 -> a1.211 ->a1.22 เมื่อจะแทรก ก็กำหนดเลขให้ต่อกันไปได้ ไม่ต้องเรียงใหม่
//
//     // เวลาเอาหัวข้อใหม่
//     // 1.  ให้ ใส่ลำดับ ต่อจากลำดับที่ต้องการ โดยแทรก เช่น
//     // ของเดิม เรียง a1.12 -> a1.13 -> a1.14
//     // ถ้าต้องการแทรก ระหว่าง a1.12 กับ a1.13 ให้เพิ่มลำดับ เป็น a1.121
//     // จะเรียงเป็น a1.12 -> a1.121 -> a1.13 -> a1.14 คือเรียงแบบตัวอักษร ไม่ใช่ตัวเลข
// // 2. อย่าลืม แต่ละไฟล์ ต้องใช้ชื่อที่ไม่ซ้ำกัน เพราะใช้ชื่อ ไปค้นหาข้อมูล หาวันที่ หา isNew เป็นต้น
//
// //ทดสอบ การส่งข้อมูล flutter-javascript
// //
//     //   ["ทดสอบ click", "clickTest.html", "1619737501", "1", "a1.01"],
// //
// //     ["เพิ่มเข้ามา dummy ทดสอบเศษส่วน", "dummy.xml", "1670311159", "1", "a1.011"], //   OK
// //
//
// //     [
// //       "ทดสอบ เงื่อนไขสัญลักษณ์ katex_flutter",
// //       "test_symbol_condition.xml",
// //       "1654053737",
// //       "1",
// //       "a1.014"
// //     ],
//
//     //   ["ทดสอบ ก่อนส่ง", "new383may_to be added.xml", "1653455084", "1", "a1.011"],
//     ["การคิดวิเคราะห์เชิงภาษา", "label_main_langAnlysis", "1002", "1", "a1.03"],
//     ["ภาษาไทย", "label_thai", "100", "1", "a1.1"],
//
//     //   ["ทดสอบ xml", "xml_add_new.xml", "1622276201", "1", "a1.10"],
//
//     ["การเรียงประโยค (5 ข้อ)", "label_ordering_phrases", "1000", "1", "a1.12"],
//     [
//       "เทคนิคการทำข้อสอบเรียงประโยค",
//       "sentence_order.html",
//       "1622276201",
//       "1",
//       "a1.14"
//     ],
//     [
//       "เรียงประโยค ชุดที่ 1",
//       "2_th_3_word_order_1.xml",
//       // "1718269548",
//       "1747390641",
//       "1",
//       "a1.15"
//     ],
//     [
//       "เรียงประโยค  ชุดที่ 2",
//       "2_th_3_word_order_2.xml",
//       "1718100908",
//       "1",
//       "a1.16"
//     ],
//     [
//       "เรียงประโยค  ชุดที่ 3",
//       "2_th_3_word_order_3.xml",
//       "1622276204",
//       "1",
//       "a1.17"
//     ],
//     [
//       "การวิเคราะห์เหตุผลเชิงภาษา\n(เงื่อนไขภาษา)  (5 ข้อ)",
//       "label_thai_rationale",
//       "105",
//       "1",
//       "a1.18"
//     ],
//
//     [
//       "การตัดสินข้อสรุป เงื่อนไขภาษา",
//       "true_false_cannot_say.html",
//       "1704707099",
//       "1",
//       "a1.181"
//     ],
//
//     [
//       "เงื่อนไขภาษา ชุดที่ 1",
//       "1_thai_conclusion_from_text_01.xml",
//       "1670839961",
//       "1",
//       "a1.19"
//     ],
//     [
//       "เงื่อนไขภาษา ชุดที่ 2",
//       "1_thai_conclusion_from_text_02.xml",
//       "1720236920",
//       "1",
//       "a1.20"
//     ],
//     [
//       "เงื่อนไขภาษา ชุดที่ 3",
//       "1_thai_conclusion_from_text_03.xml",
//       "1622276212",
//       "1",
//       "a1.21"
//     ],
//
//     [
//       "บทความสั้น\n(บทความสั้น-ยาว รวมกัน ประมาณ 10 ข้อ)",
//       "label_short_passages",
//       "100",
//       "1",
//       "a1.22"
//     ],
//     [
//       "เทคนิคการทำข้อสอบ บทความสั้น",
//       "how_to_shrt_pssge.html",
//       "1622276214",
//       "1",
//       "a1.23"
//     ],
//     [
//       "บทความสั้น ชุดที่ 1",
//       "2_th_4_short_passage_04.xml",
//       "1622276215",
//       "1",
//       "a1.24"
//     ],
//     [
//       "บทความสั้น ชุดที่ 2",
//       "2_th_4_short_passage_02.xml",
//       "1622276216",
//       "1",
//       "a1.25"
//     ],
//
//     [
//       "บทความสั้น ชุดที่ 3",
//       "2_th_4_short_passage_01.xml",
//       "1622276216",
//       "1",
//       "a1.251"
//     ],
//     [
//       "บทความสั้น ชุดที่ 4",
//       "2_th_4_short_passage_03.xml",
//       "1622276216",
//       "1",
//       "a1.252"
//     ],
//
//     ["บทความยาว", "label_long_passages", "100", "1", "a1.259"],
//
//     [
//       "เทคนิคการทำข้อสอบ บทความยาว",
//       "2_th_5_long_passage_00_tips.html",
//       "1622276218",
//       "1",
//       "a1.26"
//     ],
//     [
//       "บทความยาว ชุดที่ 1",
//       "2_th_5_long_passage_01.html",
//       "1653524970",
//       "1",
//       "a1.27"
//     ],
//     [
//       "บทความยาว ชุดที่ 2",
//       "2_th_5_long_passage_02.html",
//       "1622276221",
//       "1",
//       "a1.28"
//     ],
//     [
//       "บทความยาว ชุดที่ 3",
//       "2_th_5_long_passage_03.html",
//       "1622276222",
//       "1",
//       "a1.29"
//     ],
//     [
//       "บทความยาว ชุดที่ 4",
//       "2_th_5_long_passage_04.html",
//       "1622276223",
//       "1",
//       "a1.30"
//     ],
//     [
//       "บทความยาว ชุดที่ 5",
//       "2_th_5_long_passage_05.html",
//       "1622276234",
//       "1",
//       "a1.31"
//     ],
//     [
//       "บทความยาว ชุดที่ 6 ",
//       "2_th_5_long_passage_06.html",
//       "1622276225",
//       "1",
//       "a1.32"
//     ],
//
//     ["บทความยาว", "label_long_passages", "100", "1", "a1.27"],
//     [
//       "เทคนิคการทำข้อสอบ บทความยาว",
//       "2_th_5_long_passage_00_tips.html",
//       "1622276218",
//       "1",
//       "a1.33"
//     ],
//     [
//       "บทความยาว ชุดที่ 1",
//       "2_th_5_long_passage_01.html",
//       "1653524970",
//       "1",
//       "a1.34"
//     ],
//     [
//       "บทความยาว ชุดที่ 2",
//       "2_th_5_long_passage_02.html",
//       "1622276221",
//       "1",
//       "a1.35"
//     ],
//     [
//       "บทความยาว ชุดที่ 3",
//       "2_th_5_long_passage_03.html",
//       "1622276222",
//       "1",
//       "a1.36"
//     ],
//     [
//       "บทความยาว ชุดที่ 4",
//       "2_th_5_long_passage_04.html",
//       "1622276223",
//       "1",
//       "a1.37"
//     ],
//     [
//       "บทความยาว ชุดที่ 5",
//       "2_th_5_long_passage_05.html",
//       "1622276234",
//       "1",
//       "a1.38"
//     ],
//     [
//       "บทความยาว ชุดที่ 6 ",
//       "2_th_5_long_passage_06.html",
//       "1622276225",
//       "1",
//       "a1.39"
//     ],
//
//     ["การคิดวิเคราะห์เชิงนามธรรม", "label_main_abstract", "100", "1", "a1.390"],
//     [
//       "การหาความสัมพันธ์ ของคำ\nข้อความ อุปมาอุปไมย  (5 ข้อ)",
//       "label_metaphore",
//       "10011",
//       "1",
//       "a1.40"
//     ],
//     [
//       "หลักการทำข้อสอบ อุปมาอุปไมย",
//       "1_metaphor_lang_00.html",
//       "1622276232",
//       "1",
//       "a1.41"
//     ],
//     [
//       "คำลักษณนาม ที่ควรรู้ ",
//       "character_of_nouns.html",
//       "1746747678",
//       "1",
//       "a1.42"
//     ],
//     [
//       "คำอุปมาอุปไมย ที่ควรรู้ ",
//       "1_metaphor_lang_01_with_search.html",
//       "1622276233",
//       "1",
//       "a1.421"
//     ],
//
//     [
//       "อุปมาอุปไมย ชุดที่ 1 ",
//       "1_metaphor_lang_04.xml",
//       "1746773195",
//       "1",
//       "a1.43"
//     ],
//     [
//       "อุปมาอุปไมย ชุดที่ 2 ",
//       "1_metaphor_lang_01.xml",
//       "1622276235",
//       "1",
//       "a1.44"
//     ],
//     [
//       "อุปมาอุปไมย ชุดที่ 3",
//       "1_metaphor_lang_02.xml",
//       "1622276236",
//       "1",
//       "a1.45"
//     ],
//     [
//       "อุปมาอุปไมย ชุดที่ 4 ",
//       "1_metaphor_lang_03.xml",
//       "1622276237",
//       "1",
//       "a1.46"
//     ],
//     // [
//     //   "สำนวน-คำเปรียบเทียบ",
//     //   "1_metaphor_lang_01_with_search.html",
//     //   "1684709817",
//     //   "1",
//     //   "a1.461"
//     // ],
//     // [
//     //   "สำนวนสุภาษิต ชุดที่ 1",
//     //   "1_thai_reasoning_01.xml",
//     //   "1622276240",
//     //   "1",
//     //   "a1.47"
//     // ],
//     // [
//     //   "สำนวนสุภาษิต ชุดที่ 2",
//     //   "1_thai_reasoning_02.xml",
//     //   "1622276241",
//     //   "1",
//     //   "a1.48"
//     // ],
//
//     [
//       "การคิดวิเคราะห์เชิงปริมาณ",
//       "label_main_quantitative_analysis",
//       "100",
//       "1",
//       "a1.49"
//     ],
//     //
//
//     ["อนุกรม (5 ข้อ)", "label_num_reasoning", "100", "1", "a1.492"],
//     [
//       "หลักการทำข้อสอบ อนุกรม",
//       "1_num_reasng_00_tips.html",
//       "1622276244",
//       "1",
//       "a1.50"
//     ],
//     [
//       "แบบฝึกข้อสอบอนุกรม",
//       "sequential_num_exercise.html",
//       "1661142042",
//       "1",
//       "a1.501"
//     ],
//
//     ["อนุกรม ชุดที่ 1", "1_num_reasng_01.xml", "1747262051", "1", "a1.51"],
//     ["อนุกรม ชุดที่ 2", "1_num_reasng_02.xml", "1654404665", "1", "a1.52"],
//     ["อนุกรม ชุดที่ 3", "1_num_reasng_03.xml", "1622276247", "1", "a1.53"],
//     ["อนุกรม ชุดที่ 4", "1_num_reasng_04.xml", "1622276248", "1", "a1.54"],
//     ["อนุกรม ชุดที่ 5", "1_num_reasng_05.xml", "1622276249", "1", "a1.55"],
//     ["อนุกรม ชุดที่ 6", "1_num_reasng_06.xml", "1622276250", "1", "a1.56"],
//     ["อนุกรม ชุดที่ 7", "1_num_reasng_07.xml", "1654404665", "1", "a1.57"],
//     //
//     ["เงื่อนไขสัญลักษณ์ (10 ข้อ)", "label_symbol", "100", "1", "a1.58"],
//     [
//       "หลักการทำข้อสอบ เงื่อนไขสัญลักษณ์ ",
//       "1_symbol_cndtng_00.html",
//       "1622276253",
//       "1",
//       "a1.59"
//     ],
//
//     [
//       "แบบฝึกหัด เงื่อนไขสัญลักษณ์ ",
//       "symbol_cndtng_exercise.html",
//       "1681204126",
//       "1",
//       "a1.591"
//     ],
//
//     [
//       "เงื่อนไขสัญลักษณ์  ชุดที่ 1 ",
//       "1_symbol_cndtng_01.xml",
//       "1747108783",
//       "1",
//       "a1.60"
//     ],
//     [
//       "เงื่อนไขสัญลักษณ์  ชุดที่ 2 ",
//       "1_symbol_cndtng_02.xml",
//       "1654404665",
//       "1",
//       "a1.61"
//     ],
//     [
//       "เงื่อนไขสัญลักษณ์  ชุดที่ 3  ",
//       "1_symbol_cndtng_03.xml",
//       "1622276255",
//       "1",
//       "a1.62"
//     ],
//
//     ["คณิตศาสตร์ทั่วไป  (5 ข้อ) ", "label_basic_math", "100", "1", "a1.621"],
//     [
//       "ร้อยละ-อัตราส่วน",
//       "1_gen_math_04_percent_ratio.xml",
//       "1622276276",
//       "1",
//       "a1.63"
//     ],
//
//     ["คิดลัด ร้อยละ", "1_percent_shortcut.html", "1641015648", "1", "a1.631"],
//
//     [
//       "ความเร็ว-เวลา-ระยะทาง",
//       "1_gen_math_06_speed_time_distance.xml",
//       "1622276277",
//       "1",
//       "a1.64"
//     ],
//     // ["กระแสน้ำ", "1_gen_math_07_current.xml", "1622276278", "1", "a1.65"],
//     ["แบบฝึกเลขยกกำลัง", "exponent_exercise.html", "1666167001", "1", "a1.651"],
//
//     ["แบบฝึกโอเปอเรชั่น", "operate_exercise.html", "1655796937", "1", "a1.652"],
//     ["โอเปอเรชั่น", "1_gen_math_operate_01.xml", "1712817896", "1", "a1.66"],
//     [
//       "ตัวอย่างโจทย์และวิธีคิด กำไร ร้อยละ",
//       "1_sales_problem_sample.html",
//       "1653653059",
//       "1",
//       "a1.67"
//     ],
//     ["โจทย์สมการ", "1_gen_math_05_equation.xml", "1681252051", "1", "a1.671"],
//     ["ค.ร.น./ห.ร.ม", "1_gen_math_01_lcm_gcd.xml", "1622276272", "1", "a1.672"],
//     [
//       "บัญญัติไตรยางค์",
//       "1_gen_math_03_rule_of_three.xml",
//       "1646718720",
//       "1",
//       "a1.673"
//     ],
//
//     [
//       "โจทย์คละคณิตศาสตร์",
//       "1_gen_math_02_misc_01.xml",
//       "1746788491",
//       "1",
//       "a1.68"
//     ],
//
//     ["ตารางข้อมูล  (5 ข้อ)", "label_data_chart", "100", "1", "a1.69"],
//     [
//       "เทคนิคการทำข้อสอบ ตาราง",
//       "solving_table_problems.html",
//       "1660192837",
//       "1",
//       "a1.70"
//     ],
//     ["แบบฝึกตารางข้อมูล", "table_exercise.html", "1632538220", "1", "a1.701"],
//     [
//       "วิเคราะห์ข้อมูล-ตาราง ชุดที่ 1",
//       "1_graph_chart_table_02.html",
//       "1632538219",
//       "1",
//       "a1.702"
//     ],
//     [
//       "วิเคราะห์ข้อมูล-ตาราง ชุดที่ 2",
//       "1_graph_chart_table_03.html",
//       "1683532682",
//       "1",
//       "a1.703"
//     ],
//
//     [
//       "ฝึกข้อสอบเสมือนจริง จับเวลา",
//       "label_main_mathAuthenticTestExercise",
//       "100",
//       "1",
//       "a1.80"
//     ],
//     [
//       "คณิตศาสตร์ \n8 ปี (2559-2566)",
//       "realTest_math_exercise.html",
//       "1712114055",
//       "1",
//       "a1.801"
//     ],
//     [
//       "คณิตศาสตร์ ปี 2567-2568",
//       "realTest_math_exercise_2.html",
//       "1717667201",
//       "1",
//       "a1.8011"
//     ],
//
//     [
//       "อุปมา-อุปไมย",
//       "realTest_thai_metaphor_exercise.html",
//       "1712114054",
//       "1",
//       "a1.802"
//     ],
//
//     // [
//     //   "วิดีโอจาก YouTube",
//     //   "label_main_video_youtube_math",
//     //   "100",
//     //   "1",
//     //   "a1.803"
//     // ],
//     // //  ทดลองเรียก วิดีโอจาก youTube -- มี error แต่ก็ยังเอาใช้งาน  =====OK====
//     //   [
//     //     "วิดีโอ YouTube คณิตศาสตร์",
//     //     "youtube_math",
//     //     "1731016756",
//     //     "1",
//     //     "a1.8031"
//     //   ],
//
// //    เสริมพื้นฐาน  อาจจะออก -------------------  ++++++++  ------------------  อาจจะออก -----------
// //    เสริมพื้นฐาน  อาจจะออก -------------------  ++++++++  ------------------  อาจจะออก -----------
// //    เสริมพื้นฐาน  อาจจะออก -------------------  ++++++++  ------------------  อาจจะออก -----------
// //
// //     [
// //       "เนื้อหาเพิ่มเติม เสริมพื้นฐาน ประสบการณ์",
// //       "label_main_extra_contents",
// //       "100",
// //       "1",
// //       "a1.71"
// //     ],
// //
// //     [
// //       "เทคนิคการทำข้อสอบ ภาษาไทย",
// //       "tips_for_thai_test.html",
// //       "1622276191",
// //       "1",
// //       "a1.72"
// //     ],
// //
// //     [
// //       "คำภาษาไทย ยุคใหม่ ที่มักเขียนผิด",
// //       "modern_thai_words_often_misspelled.html",
// //       "1622276194",
// //       "1",
// //       "a1.73"
// //     ],
// //
// //     [
// //       "การใช้คำให้ถูกต้องตามหลักภาษา",
// //       "label_fill_in_blanks",
// //       "1001",
// //       "1",
// //       "a1.74"
// //     ],
// //     [
// //       "เติมคำในช่องว่าง ชุดที่ 1",
// //       "2_th_1_word2.xml",
// //       "1622276206",
// //       "1",
// //       "a1.75"
// //     ], // ไม่มี
// //     [
// //       "เติมคำในช่องว่าง ชุดที่ 2",
// //       "2_th_1_word3.xml",
// //       "162237620",
// //       "1",
// //       "a1.76"
// //     ],
// //     [
// //       "เติมคำในช่องว่าง ชุดที่ 3 ",
// //       "2_th_1_word4.xml",
// //       "1622276199",
// //       "1",
// //       "a1.77"
// //     ],
// //
// //     ["ข้อบกพร่องทางภาษา", "label_thai_grammar", "100", "1", "a1.7701"],
// //     [
// //       "ข้อบกพร่องทางภาษา ชุดที่ 1",
// //       "2_th_2_sentence1.xml",
// //       "1622276206",
// //       "1",
// //       "a1.78"
// //     ],
// //     [
// //       "ข้อบกพร่องทางภาษา ชุดที่ 2",
// //       "2_th_2_sentence2.xml",
// //       "1622276207",
// //       "1",
// //       "a1.79"
// //     ],
// //
// //     [
// //       "ฝึกคิดคณิตศาสตร์ (สดมภ์) ชุดที่ 2",
// //       "1_columns_02.html",
// //       "1653259542",
// //       "1",
// //       "a1.80"
// //     ],
// //     [
// //       "หลักคิดลัด โจทย์สมการ",
// //       "linear_equations_tricks.html",
// //       "1622276269",
// //       "1",
// //       "a1.81"
// //     ],
// //     [
// //       "แบบฝึกคิดลัดแก้สมการ",
// //       "1_gen_math_06_equation.xml",
// //       "1622276270",
// //       "1",
// //       "a1.82"
// //     ],
// //
// //     ["คิดลัด ร้อยละ", "1_percent_shortcut.html", "1641015648", "1", "a1.86"],
// //
// //     ["กราฟ แผนภูมิ", "1_graph_chart_table_01.html", "1641015648", "1", "a1.87"],
//     //
//     // [
//     //   "พี่นุช ติวสอบ ก.พ. ภาคพิเศษ ปี 63 (YouTube)",
//     //   "https://www.youtube.com/watch?v=mzjmUsZxmWQ",
//     //   "1718415320",
//     //   "1",
//     //   "a1.933"
//     // ],
//   ];
//   static const english = [
//     //   ["เทคนิคทำข้อสอบ กพ", "label_main_tips_and_tricks", "100", "2", "a2.00"],
//     // [
//     //   "The Master แนะเทคนิคทำ อังกฤษ ง่าย ๆ สำหรับคนที่ไม่มีพื้นฐานอังกฤษ พร้อมสอน grammar vocab reading และ conversation(YouTube)",
//     //   "https://www.youtube.com/watch?v=5-I1AQMN60E&t=1820",
//     //   "100",
//     //   "2",
//     //   "a2.01"
//     // ],
//     // [
//     //   "ดร.หญิง ธิติญา แนะเทคนิคสุดปัง! ทำข้อสอบ ก.พ. ภาษาอังกฤษ (YouTube)",
//     //   "https://www.youtube.com/watch?v=kZsgvzHJOv8",
//     //   "100",
//     //   "2",
//     //   "a2.02"
//     // ],
//     ["แนวข้อสอบ บทสนทนา", "label_main_conversation", "100", "2", "a2.10"],
//     ["บทสนทนา ชุดที่ 1", "3_en_convr_easy_01.xml", "1622276250", "2", "a2.11"],
//     ["บทสนทนา ชุดที่ 2", "3_en_convr_easy_02.xml", "1622276246", "2", "a2.12"],
//     ["บทสนทนา ชุดที่ 3", "3_en_convr_easy_001.xml", "1622276245", "2", "a2.13"],
//     ["บทสนทนา ชุดที่ 4", "3_en_convr_easy_04.xml", "1622276246", "2", "a2.14"],
//     [
//       "บทสนทนา ชุดที่ 5",
//       "3_en_convr_normal_01.xml",
//       "1622276247",
//       "2",
//       "a2.15"
//     ],
//     ["บทสนทนา ชุดที่ 6", "3_en_long_cnvr_01.html", "1622276248", "2", "a2.16"],
//     ["บทสนทนา ชุดที่ 7", "3_en_long_cnvr_02.html", "1622276249", "2", "a2.17"],
//     ["บทสนทนา ชุดที่ 8", "3_en_long_cnvr_03.html", "1622276250", "2", "a2.18"],
//     ["บทสนทนา ชุดที่ 9", "3_en_long_cnvr_04.html", "1622276251", "2", "a2.19"],
//     ["บทสนทนา ชุดที่ 10", "3_en_long_cnvr_05.html", "1622276252", "2", "a2.20"],
//     ["บทสนทนา ชุดที่ 11", "3_en_long_cnvr_06.html", "1622276253", "2", "a2.21"],
//     [
//       "บทสนทนา ชุดที่ 12 ",
//       "3_en_long_cnvr_07.html",
//       "1622276254",
//       "2",
//       "a2.22"
//     ],
//     [
//       "บทสนทนา ชุดที่ 14 (ข้อสอบเสมือนจริง)",
//       "3_en_long_cnvr_09.html",
//       "1669530226",
//       "2",
//       "a2.221"
//     ],
//     ["บทสนทนา แนวข้อสอบจริง 2568 ชุดที่ 1", "3_en_long_cnvr_realTest_like_1.html", "1745114937", "2", "a2.222"],
//     ["บทสนทนา แนวข้อสอบจริง 2568 ชุดที่ 2", "3_en_long_cnvr_realTest_like_2.html", "1745114937", "2", "a2.223"],
//
//     ["คำศัพท์", "label_main_eng_vocab", "100", "2", "a2.23"],
//     [
//       "คำศัพท์ภาษาอังกฤษที่ควรรู้จัก",
//       "vocab_study.html",
//       "1619737502",
//       "2",
//       "a2.231"
//     ],
//     [
//       "คำภาษาอังกฤษที่มักใช้ผิด",
//       "commonly_confused_words_with_search.html",
//       "1668749358",
//       "2",
//       "a2.232"
//     ],
//
//     [
//       "กริยาวลี (Phrasal Verbs)",
//       "3_en_phrasal_verbs.html",
//       "1622276256",
//       "2",
//       "a2.24"
//     ],
//     ["คำศัพท์ ชุดที่ 1", "3_en_vocab_01.xml", "1746490140", "2", "a2.25"],
//     ["คำศัพท์ ชุดที่ 2", "3_en_vocab_02.xml", "1622276258", "2", "a2.26"],
//     ["คำศัพท์ ชุดที่ 3", "3_en_vocab_03.xml", "1622276259", "2", "a2.27"],
//     [
//       "คำศัพท์ ชุดที่ 4: Odd One Out",
//       "3_en_vocab_04.xml",
//       "1622276260",
//       "2",
//       "a2.28"
//     ],
//     [
//       "คำศัพท์ ชุดที่ 5: Phrasal Verbs",
//       "3_en_phrasal_verbs_01.xml",
//       "1622276261",
//       "2",
//       "a2.29"
//     ],
//     // [
//     //   "พี่แมง ป. ศัพท์อังกฤษ ก.พ. 600 คำ ที่ออกสอบบ่อย (มีเอกสารแจกฟรี)  ep1/6 (YouTube)",
//     //   "https://www.youtube.com/watch?v=f55XcXO9yww&t=2399s",
//     //   "1622276261",
//     //   "2",
//     //   "a2.291"
//     // ],
//     // [
//     //   "พี่แมง ป. ศัพท์อังกฤษที่ออกสอบบ่อย ep2/6 (YouTube)",
//     //   "https://www.youtube.com/watch?v=lVWa1_rL0P4&t=77s",
//     //   "1622276261",
//     //   "2",
//     //   "a2.292"
//     // ],
//     // [
//     //   "พี่แมง ป. ศัพท์อังกฤษที่ออกสอบบ่อย ep3/6 (YouTube)",
//     //   "https://www.youtube.com/watch?v=PI7hqH8yWNw&t=45s",
//     //   "1622276261",
//     //   "2",
//     //   "a2.293"
//     // ],
//     // [
//     //   "พี่แมง ป. ศัพท์อังกฤษที่ออกสอบบ่อย ep4/6 (YouTube)",
//     //   "https://www.youtube.com/watch?v=_lBFC8qs7vM",
//     //   "1622276261",
//     //   "2",
//     //   "a2.294"
//     // ],
//     // [
//     //   "พี่แมง ป. ศัพท์อังกฤษที่ออกสอบบ่อย ep5/6 (YouTube)",
//     //   "https://www.youtube.com/watch?v=ZaDMGuzwdkI",
//     //   "1622276261",
//     //   "2",
//     //   "a2.295"
//     // ],
//     // [
//     //   "พี่แมง ป. ศัพท์อังกฤษที่ออกสอบบ่อย ep6/6 (YouTube)",
//     //   "https://www.youtube.com/watch?v=wszNjiS32Xc",
//     //   "1622276261",
//     //   "2",
//     //   "a2.296"
//     // ],
//     // [
//     //   "พี่รวิ ติวศัพท์อังกฤษ ก.พ. ข้อสอบเสมือนจริง (YouTube)",
//     //   "https://www.youtube.com/watch?v=9oZvyGzi3qo",
//     //   "1622276261",
//     //   "2",
//     //   "a2.297"
//     // ],
//     ["สรุป/ทบทวน Grammar", "label_main_eng_grammar", "100", "2", "a2.30"],
//     [
//       "Parts of Speech",
//       "3_en_parts_of_speech.html",
//       "1622276263",
//       "2",
//       "a2.31"
//     ],
//     ["Tenses", "3_en_tense_review.html", "1622276264", "2", "a2.32"],
//     // [
//     //   "ครูหวาน สรุปเรื่อง Tenses (YouTube)",
//     //   "https://www.youtube.com/watch?v=1lJDJFZ82R0",
//     //   "1642473370",
//     //   "2",
//     //   "a2.321"
//     // ],
//     ["If Clause", "3_en_con_if_review.html", "1622276265", "2", "a2.33"],
//     [
//       "Active/Passive Voice",
//       "3_en_passive_voice_review.html",
//       "1622276266",
//       "2",
//       "a2.34"
//     ],
//     [
//       "การใช้ Infinitive และ Gerund",
//       "3_en_infinitive_gerund.html",
//       "1622276267",
//       "2",
//       "a2.35"
//     ],
//     [
//       "แบบฝึกหัด Infinitive และ Gerund",
//       "3_en_infinitive_gerund_exercise.html",
//       "1622276268",
//       "2",
//       "a2.36"
//     ],
//     [
//       "การใช้ a, an และ the",
//       "3_en_article_review.html",
//       "1622276269",
//       "2",
//       "a2.37"
//     ],
//     // [
//     //   "ติวเตอร์ติด bangkoklawtutor ติว Grammar กพ",
//     //   "https://www.youtube.com/watch?v=lCNboxbyxAo",
//     //   "1622276269",
//     //   "2",
//     //   "a2.371"
//     // ],
//     ["แนวข้อสอบ Grammar", "label_main_eng__grammar_tests", "100", "2", "a2.38"],
//     // ["ข้อสอบเสมือนจริง Grammar 2567-2568", "3_en_grammar_01.xml", "1743807250", "2", "a2.381"],
//     ["แนวข้อสอบ Grammar 01", "3_en_grmmr_01.xml", "1622276271", "2", "a2.39"],
//     ["แนวข้อสอบ Grammar 02", "3_en_grmmr_02.xml", "1622276272", "2", "a2.40"],
//     [
//       "แนวข้อสอบ Tense_ชุดที่_1",
//       "3_en_tense_01.xml",
//       "1622276273",
//       "2",
//       "a2.41"
//     ],
//     [
//       "แนวข้อสอบ Tense_ชุดที่_2",
//       "3_en_tense_02.xml",
//       "1667696787",
//       "2",
//       "a2.42"
//     ],
//     [
//       "แนวข้อสอบ Infinitive vs Gerund_1",
//       "3_en_infinitive_01.xml",
//       "1622276275",
//       "2",
//       "a2.43"
//     ],
//     [
//       "แนวข้อสอบ Infinitive vs Gerund_2",
//       "3_en_infinitive_02.xml",
//       "1622276276",
//       "2",
//       "a2.44"
//     ],
//     ["จดหมาย", "label_main_eng_letters", "100", "2", "a2.45"],
//     ["จดหมาย 1: letter of complaint", "3_en_lttr_06.html", "1744861887", "2", "a2.451"],
//     ["จดหมาย 2: บันทึกข้อความเชิญประชุม", "3_en_memo_review_project.html", "1622276278", "2", "a2.452"],
//     ["จดหมาย 3", "3_en_lttr_01.html", "1622276278", "2", "a2.46"],
//     ["จดหมาย 4", "3_en_lttr_02.html", "1622276279", "2", "a2.47"],
//     ["จดหมาย 5", "3_en_lttr_03.html", "1622276280", "2", "a2.48"],
//     ["จดหมาย 6", "3_en_lttr_04.html", "1622276281", "2", "a2.49"],
//     ["จดหมาย 7", "3_en_lttr_05.html", "1622276282", "2", "a2.50"],
//     ["จดหมาย 8: จดหมายเลื่อนตำแหน่ง", "3_en_promotion_lettrs.html", "1622276283", "2", "a2.501"],
//
//
//     ["แนวข้อสอบ Reading", "label_main_eng_reading", "100", "2", "a2.51"],
//
//     //*****************
//     [
//       "ข้อสอบ Reading: Healthy Food",
//       "3_en_shrt_healthy_food.html",
//       "1742107002",
//       "2",
//       "a2.51001"
//     ],
//     [
//       "ข้อสอบ Reading: Earthquakes",
//       "3_en_lng_earthquake.html",
//       "1745148052",
//       "2",
//       "a2.510011"
//     ],
//
//     [
//       "ข้อสอบ Reading: Screen Time",
//       "3_en_lng_screen_time_b1.html",
//       "1742107002",
//       "2",
//       "a2.5101"
//     ],
//     [
//       "ข้อสอบ Reading: Screen Time (ศัพท์ยากขึ้น)",
//       "3_en_lng_screen_time_b2.html",
//       "1742107002",
//       "2",
//       "a2.5102"
//     ],
//     [
//       "ข้อสอบ Reading ชุดที่ 1: Artificial Intelligence",
//       "3_en_long_pssge_07.html",
//       "1742107002",
//       "2",
//       "a2.511"
//     ],
//     [
//       "ข้อสอบ Reading ชุดที่ 2: COVID-19",
//       "3_en_long_pssge_03.html",
//       "1622276284",
//       "2",
//       "a2.52"
//     ],
//     [
//       "ข้อสอบ Reading ชุดที่ 3",
//       "3_en_long_pssge_04.html",
//       "1622276285",
//       "2",
//       "a2.53"
//     ],
//     [
//       "ข้อสอบ Reading ชุดที่ 4",
//       "3_en_long_pssge_01.html",
//       "1622276286",
//       "2",
//       "a2.54"
//     ],
//     [
//       "ข้อสอบ Reading ชุดที่ 5",
//       "3_en_long_pssge_02.html",
//       "1622276287",
//       "2",
//       "a2.55"
//     ],
//     [
//       "ข้อสอบ Reading ชุดที่ 6",
//       "3_en_long_pssge_05.html",
//       "1622276288",
//       "2",
//       "a2.56"
//     ],
//     [
//       "ข้อสอบ Reading ชุดที่ 7",
//       "3_en_long_pssge_06.html",
//       "1622276289",
//       "2",
//       "a2.57"
//     ],
//     [
//       "ข้อสอบ Reading ชุดที่ 8 AI: A Double-Edged Sword",
//       "3_en_long_pssge_08.html",
//       "1742114839",
//       "2",
//       "a2.58"
//     ],
//     // ****************
//
//
//     // [
//     //   "พี่รวิ พาฝึกทำโจทย์ Reading (YouTube) ",
//     //   "https://www.youtube.com/watch?v=ZYWMD2B3-q0",
//     //   "1622276295",
//     //   "2",
//     //   "a2.571"
//     // ],
//     // [
//     //   "พี่แมง ป. ติว Reading (YouTube) ",
//     //   "https://www.youtube.com/watch?v=MwtkSb3hV60",
//     //   "1622276295",
//     //   "2",
//     //   "a2.5711"
//     // ],
//     // [
//     //   "พี่รวิ เฉลยข้อสอบเสมือนจริง อังกฤษ ก.พ. ปี 62 (YouTube)",
//     //   "https://www.youtube.com/watch?v=bZpYcozxGMk",
//     //   "1622276289",
//     //   "2",
//     //   "a2.572"
//     // ],
//     // [
//     //   "พี่แมง ป. ติวภาษาอังกฤษ ข้อสอบเสมือนจริง (YouTube)",
//     //   "https://www.youtube.com/watch?v=Oq0ocanZZCs",
//     //   "1622276289",
//     //   "2",
//     //   "a2.573"
//     // ],
//     // [
//     //   "พี่เกด  เฉลยภาษาอังกฤษข้อสอบ ก.พ. (YouTube)",
//     //   "https://www.youtube.com/watch?v=4ajcme8fxZA",
//     //   "1622276289",
//     //   "2",
//     //   "a2.574"
//     // ],
//   ];
//
//   static const law = [
//     ["ระเบียบบริหารราชการแผ่นดิน", "label_main_governance", "100", "3", "a3.10"],
//     [
//       "พ.ร.บ. ระเบียบบริหารราชการแผ่นดิน พ.ศ. ๒๕๓๔ (แก้ไขเพิ่มเติม ถึง ปัจจุบัน)",
//       "5_1_1_state_admin_regulation.html",
//       "1622276292",
//       "3",
//       "a3.11"
//     ],
//     [
//       // ไฟล์ ถาม-ตอบ ที่ใช้ javascript ให้ต่อท้ายด้วยคำว่า exercise เพราะ จะได้แสดง help icon บน app bar เพื่อบอก วิธีการเลื่อนข้อไปข้ออื่น ๆ
//       "ถาม-ตอบ พ.ร.บ. ระเบียบบริหารราชการแผ่นดิน",
//       "q-and-a_good_govt_exercise.html",
//       "1622276292",
//       "3",
//       "a3.111"
//     ],
//     [
//       "แนวข้อสอบ ระเบียบบริหารราชการแผ่นดิน",
//       "label_governance_questions",
//       "100",
//       "3",
//       "a3.12"
//     ],
//     [
//       "แนวข้อสอบระเบียบบริหารราชการแผ่นดิน ชุดที่ 1",
//       "5_1_2_state_admin_reg_1.xml",
//       "1670568512",
//       "3",
//       "a3.13"
//     ],
//     [
//       "แนวข้อสอบระเบียบบริหารราชการแผ่นดิน ชุดที่ 2",
//       "5_1_3_state_admin_reg_2.xml",
//       "1622276296",
//       "3",
//       "a3.14"
//     ],
//
//     // [
//     //   "LAW by Aun เฉลยแนวข้อสอบระเบียบบริหารราชการแผ่นดิน 50 ข้อ (YouTube)",
//     //   "https://www.youtube.com/watch?v=JkZK3WXTEps",
//     //   "1622276296",
//     //   "3",
//     //   "a3.141"
//     // ],
//     // [
//     //   "พี่น็อต GoodBrain ติวระเบียบบริหารราชการแผ่นดิน (YouTube)",
//     //   "https://www.youtube.com/watch?v=8BJw0kIST14",
//     //   "1622276296",
//     //   "3",
//     //   "a3.142"
//     // ],
//     [
//       "หลักการบริหารกิจการบ้านเมืองที่ดี",
//       "label_main_good_governance",
//       "100",
//       "3",
//       "a3.15"
//     ],
//     [
//       "พระราชกฤษฎีกา ว่าด้วยหลักเกณฑ์และวิธีการบริหารกิจการบ้านเมืองที่ดี พ.ศ. ๒๕๔๖",
//       "5_2_1_good_governance.html",
//       "1622276296",
//       "3",
//       "a3.16"
//     ],
//     [
//       "พระราชกฤษฎีกา ว่าด้วยหลักเกณฑ์และวิธีการบริหารกิจการบ้านเมืองที่ดี (ฉบับที่ ๒) พ.ศ. ๒๕๖๒",
//       "5_2_1_(2)_good_governance.html",
//       "1622276296",
//       "3",
//       "a3.161"
//     ],
//
//     [
//       "สรุป พ.ร.ฎ. หลักเกณฑ์และวิธีการบริหารกิจการบ้านเมืองที่ดี",
//       "goodGvnce_gist.html",
//       "1689929515",
//       "3",
//       "a3.1611"
//     ],
//
//     [
//       // ไฟล์ ถาม-ตอบ ที่ใช้ javascript ให้ต่อท้ายด้วยคำว่า exercise เพราะ จะได้แสดง help icon บน app bar เพื่อบอก วิธีการเลื่อนข้อไปข้ออื่น ๆ
//       "ถาม-ตอบ พ.ร.ฎ. ว่าด้วยหลักเกณฑ์และวิธีการบริหารกิจการบ้านเมืองที่ดี ",
//       "q-and-a_good_govt_principles_exercise.html",
//       "1657263383",
//       "3",
//       "a3.162"
//     ],
//     [
//       "แนวข้อสอบ หลักการบริหารกิจการบ้านเมืองที่ดี",
//       "label_good_governance_questions",
//       "100",
//       "3",
//       "a3.17"
//     ],
//     [
//       "แนวข้อสอบหลักการบริหาร ฯ  ชุดที่ 1",
//       "5_2_2_good_governance_1.xml",
//       "1653770277",
//       "3",
//       "a3.18"
//     ],
//     [
//       "แนวข้อสอบหลักการบริหาร ฯ ชุดที่ 2",
//       "5_2_3_good_governance_2.xml",
//       "1622276296",
//       "3",
//       "a3.19"
//     ],
//     [
//       "วิธีปฏิบัติราชการทางปกครอง",
//       "label_main_practical_rules",
//       "100",
//       "3",
//       "a3.20"
//     ],
//     [
//       "พระราชบัญญัติ วิธีปฏิบัติราชการทางปกครอง พ.ศ. ๒๕๓๙ และที่แก้ไขเพิ่มเติม",
//       "5_3_1_administrative_procedure.html",
//       "1622276296",
//       "3",
//       "a3.21"
//     ],
//
//     [
//       "กฎกระทรวง กําหนดกรณีอื่นที่เจ้าหน้าที่จะทําการพิจารณาทางปกครองไม่ได้ พ.ศ. ๒๕๖๖",
//       "5_3_1_administrative_procedure_2566.html",
//       "1687169108",
//       "3",
//       "a3.210"
//     ],
//
//     //  PDF OK OK  OK  OK  OK  OK
//     // [
//     //   "ความรับผิดทางละเมิดของเจ้าหน้าที่ \nโดย สำนักความรับผิดทางแพ่ง ร่วมกับ สำนักงานคลังเขต 7",
//     //   "violation_explained.pdf",
//     //   "1695720516",
//     //   "3",
//     //   "a3.2101"
//     // ],
//
//     [
//       "สรุป สาระสำคัญ พระราชบัญญัติ วิธีปฏิบัติราชการทางปกครอง",
//       "guideline_for_issuing_official_order_act.html",
//       "1658975827",
//       "3",
//       "a3.211"
//     ],
//     [
//       "ตัวอย่างคำสั่งทางปกครอง",
//       "adminstrative-order-explained.html",
//       "1727038495",
//       "3",
//       "a3.2111"
//     ],
//     [
//       "ถาม-ตอบ พ.ร.บ. วิธีปฏิบัติราชการทางปกครอง",
//       "q-and-a_practice_law_exercise.html",
//       "1662528452",
//       "3",
//       "a3.212"
//     ],
//     [
//       "แนวข้อสอบ วิธีปฏิบัติราชการทางปกครอง",
//       "label_practical_rules_questions",
//       "100",
//       "3",
//       "a3.22"
//     ],
//     [
//       "แนวข้อสอบ วิธีปฏิบัติราชการทางปกครอง ชุดที่ 1",
//       "5_3_2_administrative_procedure_1.xml",
//       "1683351672",
//       "3",
//       "a3.221"
//     ],
//     [
//       "แนวข้อสอบ วิธีปฏิบัติราชการทางปกครอง ชุดที่ 2",
//       "5_3_3_administrative_procedure_2.xml",
//       "1622276296",
//       "3",
//       "a3.23"
//     ],
//
//     // [
//     //   "การปฏิบัติราชการทางอิเล็กทรอนิกส์ ๒๕๖๕",
//     //   "label_main_electornics_act",
//     //   "100",
//     //   "3",
//     //   "a3.24"
//     // ],
//     //
//     //
//     //
//     //
//     // [
//     //   "พรบ การปฏิบัติราชการทางอิเล็กทรอนิกส์ พ.ศ. ๒๕๖๕",
//     //   "5_3_4_electornics_act.html",
//     //   "1667027445",
//     //   "3",
//     //   "a3.25"
//     // ],
//
//     // // [
//     // //   "พี่แมง ป. เฉลยแนวข้อสอบ วิชา พ.ร.บ.วิธีปฎิบัติราชการทางปกครอง (YouTube)",
//     // //   "https://www.youtube.com/watch?v=tS3vUgdkx_w",
//     // //   "1622276296",
//     // //   "3",
//     // //   "a3.231"
//     // // ],
//
//     //  ทดลองเรียก วิดีโอจาก youTube -- มี error เลยยังไม่เอา
//     //   [
//     //     "YouTube Video Lessons",
//     //     "https://www.youtube.com/watch?v=GbIdCuqNHrQ",
//     //     "1622276296",
//     //     "3",
//     //     "a3.232"
//     //   ],
//
//     // //  ทดลองเรียก วิดีโอจาก youTube -- มี error แต่ก็ยังเอาใช้งาน  =====OK====
//     //   [
//     //     "วิดีโอ กฎหมาย บย youTube",
//     //     "youtube_law",
//     //     "1622276296",
//     //     "3",
//     //     "a3.2321"
//     //   ],
//
//     // ["ลิงค์", "label_links", "100", "3", "a3.24"],  //Flutter เปิด pdf ไม่สะดวก ถ้าลิงค์ไปเว็บไซต์ OK
//     // [
//     //   "youTube อัตราส่วน",
//     //   "https://www.youtube.com/watch?v=1lJDJFZ82R0",
//     //   "1622276296",
//     //   "3",
//     //   "a3.25"
//     // ],
//     [
//       "หน้าที่และความรับผิดในการปฏิบัติหน้าที่ราชการ",
//       "label_main_responsibility",
//       "100",
//       "3",
//       "a3.26"
//     ],
//
//     [
//       "พระราชบัญญัติ ความรับผิดทางละเมิดของเจ้าหน้าที่ พ.ศ. ๒๕๓๙",
//       "5_4_1_violation_penalty.html",
//       "1622276296",
//       "3",
//       "a3.28"
//     ],
//     //
//     // [
//     //   "พี่น็อต GoodBrain ติว พ.ร.บ.ความรับผิดทางละเมิดของเจ้าหน้าที่",
//     //   "https://www.youtube.com/watch?v=HHvE9mctV0E",
//     //   "1622276296",
//     //   "3",
//     //   "a3.281"
//     // ],
//
//     [
//       "สาระสำคัญของ พ.ร.บ. ความรับผิดทางละเมิดของเจ้าหน้าที่",
//       "5_4_2_violation_penalty_gist.html",
//       "1622276296",
//       "3",
//       "a3.29"
//     ],
//     [
//       "ระเบียบสำนักนายกรัฐมนตรีว่าด้วยหลักเกณฑ์การปฏิบัติเกี่ยวกับความรับผิดทางละเมิดของเจ้าหน้าที่ พ.ศ. 2539 และที่แก้ไขเพิ่มเติม",
//       "5_4_3_violation_penalty_regulations.html",
//       "1622276296",
//       "3",
//       "a3.30"
//     ],
//
//     [
//       "แนวข้อสอบ ความรับผิดทางละเมิด",
//       "label_violation_penalty",
//       "100",
//       "3",
//       "a3.32"
//     ],
//     [
//       "แนวข้อสอบ ความรับผิดต่อตำแหน่งหน้าที่ราชการ",
//       "5_6_1_criminal_law_1.xml",
//       "1622276296",
//       "3",
//       "a3.33"
//     ],
//     [
//       "แนวข้อสอบ ความรับผิดทางละเมิดของเจ้าหน้าที",
//       "5_4_5_violation_penalty_1.xml",
//       "1670573255",
//       "3",
//       "a3.34"
//     ],
//     //
//     // [
//     //   "ติวเตอร์ ดร.หญิง ธิติญา ติวพ.ร.บ.ความรับผิดทางละเมิดของเจ้าหน้าที่ (YouTube)",
//     //   "https://www.youtube.com/watch?v=_qUaKhdi7Uk",
//     //   "1622276296",
//     //   "3",
//     //   "a3.341"
//     // ],
//
//     // ["แนวข้อสอบ เกี่ยวกับวินัย", "label_discipline", "100", "3", "a3.35"],
//     // [
//     //   "แนวข้อสอบ วินัยข้าราชการพลเรือน",
//     //   "5_4_6_violation_penalty_2_discipline.xml",
//     //   "1622276296",
//     //   "3",
//     //   "a3.36"
//     // ],
//     // ["ลิงค์", "label_interesting_links", "100", "3", "a3.37"],
//     // [
//     //   "ลิงค์ที่น่าศึกษาเพิ่มเติม",
//     //   "5_4_1_1_violation_penalty_useful_links.html",
//     //   "1622276296",
//     //   "3",
//     //   "a3.38"
//     // ],
//     [
//       "เจตคติและจริยธรรม สําหรับข้าราชการ",
//       "label_main_ethics",
//       "100",
//       "3",
//       "a3.39"
//     ],
//     [
//       "พระราชบัญญัติมาตรฐานทางจริยธรรม พ.ศ. ๒๕๖๒",
//       "5_5_1_ethics_acts_2562.html",
//       "1622276296",
//       "3",
//       "a3.40"
//     ],
//
//     [
//       "สรุปสาระสำคัญ พ.ร.บ.มาตรฐานทางจริยธรรม",
//       "5_5_2_ethics_acts_essence_of.html",
//       "1622276296",
//       "3",
//       "a3.42"
//     ],
//
//     [
//       "ตัวอย่างพฤติกรรม ตาม พ.ร.บ.มาตรฐานทางจริยธรรม (Infographics ของ ก.พ.)",
//       "ocsc_ethics.pdf",
//       "1705906849",
//       "3",
//       "a3.44"
//     ],
//
//     [
//       "คำอธิบายและตัวอย่างพฤติกรรม ตามมาตรฐานทางจริยธรรม (เอกสารของ ก.พ.)",
//       "etics_behaviors_explained.pdf",
//       "1705906849",
//       "3",
//       "a3.441"
//     ],
//
//
//     ["จริยธรรมข้าราชการ", "label_official_ethics", "100", "3", "a3.44"],
//     [
//       "แนวข้อสอบ จริยธรรมข้าราชการ",
//       "5_5_3_ethics_1.xml",
//       "1670568518",
//       "3",
//       "a3.45"
//     ],
//     [
//       "กฎหมายอาญา ที่เกี่ยวข้อง",
//       "label_main_criminal_law_act",
//       "100",
//       "3",
//       "a3.46"
//     ],
//     [
//       "ความผิดต่อตำแหน่งหน้าที่ราชการ (มาตรา ๑๔๗-๑๖๖)",
//       "5_6_1_criminal_law.html",
//       "1670568518",
//       "3",
//       "a3.47"
//     ],
//
//     [
//       "คดีตัวอย่างการกระทำความผิดต่อหน้าที่ ของเจ้าพนักงาน",
//       "ocsc_criminal_law.pdf",
//       "1670568518",
//       "3",
//       "a3.4701"
//     ],
//
//
//     [
//       "แนวข้อสอบ ความผิดต่อตำแหน่งหน้าที่ราชการ",
//       "5_5_4_criminal_law_1.xml",
//       "100",
//       "3",
//       "a3.471"
//     ],
//
//     [
//       "ข้อสอบเสมือนจริง(กฎหมาย)",
//       "label_main_electornics_act",
//       "100",
//       "3",
//       "a3.48"
//     ],
//
//     [
//       "ข้อสอบเสมือนจริง 2567-2568",
//       "ocsc_law_2567_paper-pencil-eExam.xml",
//       "1746606670",
//       "3",
//       "a3.481"
//     ],
//     [
//       "ข้อสอบเสมือนจริง - จับเวลา\n(2563-2566) ",
//       "realTest_law_exercise.html",
//       "1695800108",
//       "3",
//       "a3.49"
//     ],
//
//     // [
//     //   "ข้อสอบเสมือนจริง-กฎหมายคละ\ne-Exam 2567 ",
//     //   "realTest_law_eExam_2567.xml",
//     //   "1724826657",
//     //   "3",
//     //   "a3.491"
//     // ],
//
//
//
//
//
//     // [
//     //   "ติวกฎหมาย สอบ กพ (YouTube)",
//     //   "label_main_law_tutor",
//     //   "100",
//     //   "3",
//     //   "a3.450"
//     // ],
//
//     // [
//     //   "ครูเป้ ชลสิทธิ์ ติวกฎหมาย รวมทุกเรื่องที่ออกสอบ (YouTube)",
//     //   "https://www.youtube.com/watch?v=nc6g-6yZhzY",
//     //   "1622276296",
//     //   "3",
//     //   "a3.451"
//     // ],
//
//     // [
//     //   "พี่แมง ป. ติวรวมข้อสอบ ความรู้และลักษณะการเป็นข้าราชการที่ดี (YouTube)",
//     //   "https://www.youtube.com/watch?v=EZJI1EUlGvM&t=47s",
//     //   "1622276296",
//     //   "3",
//     //   "a3.452"
//     // ],
//     // [
//     //   "The Master ติวกฎหมาย สอบผ่านได้ในคลิปเดียว (YouTube)",
//     //   "https://www.youtube.com/watch?v=rHsR3Ij96d0&t=114s",
//     //   "1622276296",
//     //   "3",
//     //   "a3.453"
//     // ],
//   ];
//   static const practice = [
//     // [
//     //   "ข้อสอบ จากเว็บของ กพ.",
//     //   "label_main_questions_ocsc",
//     //   "100",
//     //   "4",
//     //   "a4.10"
//     // ],
//     [
//       "ความสามารถทั่วไป/ภาษาไทย/ข้าราชการที่ดี",
//       "4_full_exam_ocsc_gen_th.html",
//       "1622276295",
//       "4",
//       "a4.11"
//     ],
//     ["ภาษาอังกฤษ ", "4_full_exam_ocsc_eng.html", "1622276297", "4", "a4.12"],
//
//     ["ฝึกทำข้อสอบ ชุดเต็ม", "label_main_full_test", "100", "4", "a4.121"],
//     [
//       "ข้อสอบชุดเต็ม ชุดที่ 1\nเวลา 3 ชั่วโมง",
//       "4_full_exam_all_01.html",
//       "1698123701",
//       "4",
//       "a4.122"
//     ],
//     [
//       "เฉลยข้อสอบชุดเต็ม ชุดที่ 1",
//       "4_full_exam_all_01_ans.html",
//       // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
//       "1698123701",
//       "4",
//       "a4.123"
//     ],
//
//
//     [
//       "ข้อสอบชุดเต็ม ชุดที่ 2\nเวลา 3 ชั่วโมง",
//       "4_full_exam_all_02.html",
//       "1698123701",
//       "4",
//       "a4.124"
//     ],
//     [
//       "เฉลยข้อสอบชุดเต็ม ชุดที่ 2",
//       "4_full_exam_all_02_answer.html",  // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
//       "1698123701",
//       "4",
//       "a4.125"
//     ],
//
//     [
//       "ข้อสอบชุดเต็ม ชุดที่ 3\nเวลา 3 ชั่วโมง",
//       "4_full_exam_all_03.html",
//       "1704696527",
//       "4",
//       "a4.126"
//     ],
//     [
//       "เฉลยข้อสอบชุดเต็ม ชุดที่ 3",
//       "4_full_exam_all_03_answer.html",  // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
//       "1704696527",
//       "4",
//       "a4.127"
//     ],
//
//     [
//       "ข้อสอบชุดเต็ม ชุดที่ 4\nเวลา 3 ชั่วโมง",
//       "4_full_exam_all_04.html",
//       "1704696527",
//       "4",
//       "a4.128"
//     ],
//     [
//       "เฉลยข้อสอบชุดเต็ม ชุดที่ 4",
//       "4_full_exam_all_04_answer.html",  // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
//       "1704696527",
//       "4",
//       "a4.1281"
//     ],
//     [
//       "ข้อสอบชุดเต็ม ชุดที่ 5\nเวลา 3 ชั่วโมง",
//       "4_full_exam_all_05.html",
//       "1704696527",
//       "4",
//       "a4.129"
//     ],
//     [
//       "เฉลยข้อสอบชุดเต็ม ชุดที่ 5",
//       "4_full_exam_all_05_answer.html",  // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
//       "1704696527",
//       "4",
//       "a4.1291"
//     ],
//
//     [
//       "ข้อสอบชุดเต็ม ชุดที่ 6\nเวลา 3 ชั่วโมง",
//       "4_full_exam_all_06.html",
//       "1722420833",
//       "4",
//       "a4.1292"
//     ],
//     [
//       "เฉลยข้อสอบชุดเต็ม ชุดที่ 6",
//       "4_full_exam_all_06_answer.html",  // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
//       "1722420834",
//       "4",
//       "a4.1293"
//     ],
//
//     // [
//     //   "ข้อสอบชุดเต็ม ชุดที่ 7\nเวลา 3 ชั่วโมง",
//     //   "4_full_exam_all_07.html",
//     //   "1704696527",
//     //   "4",
//     //   "a4.1294"
//     // ],
//     // [
//     //   "เฉลยข้อสอบชุดเต็ม ชุดที่ 7",
//     //   "4_full_exam_all_07_answer.html",  // ถ้า ยังไม่ซื้อ ไม่ให้ใช้งาน ต้องเปลี่ยนเป็น _answer
//     //   "1704696527",
//     //   "4",
//     //   "a4.1295"
//     // ],
//
//
//     [
//       "ความสามารถททางการคิดวิเคราะห์",
//       "label_main_analysis",
//       "100",
//       "4",
//       "a4.13"
//     ],
//     [
//       "ความสามารถในการคิดวิเคราะห์ ชุดที่ 1",
//       "4_full_exam_gen_01.html",
//       "1622276296",
//       "4",
//       "a4.14"
//     ],
//     [
//       "ความสามารถในการคิดวิเคราะห์ ชุดที่ 2 ",
//       "4_full_exam_gen_02.html",
//       "1622276296",
//       "4",
//       "a4.15"
//     ],
//     [
//       "ความสามารถในการคิดวิเคราะห์ ชุดที่ 3 ",
//       "4_full_exam_gen_03.html",
//       "1622276296",
//       "4",
//       "a4.16"
//     ],
//     [
//       "ความสามารถในการคิดวิเคราะห์ ชุดที่ 4 ",
//       "4_full_exam_gen_04.html",
//       "1622276296",
//       "4",
//       "a4.17"
//     ],
//     [
//       "ความสามารถในการคิดวิเคราะห์ ชุดที่ 5 ",
//       "4_full_exam_gen_05.html",
//       "1622276296",
//       "4",
//       "a4.18"
//     ],
//     [
//       "ความสามารถในการคิดวิเคราะห์ ชุดที่ 6 ",
//       "4_full_exam_gen_06.html",
//       "1622276296",
//       "4",
//       "a4.19"
//     ],
//     [
//       "ความสามารถในการคิดวิเคราะห์ ชุดที่ 7 ",
//       "4_full_exam_gen_07.html",
//       "1622276296",
//       "4",
//       "a4.20"
//     ],
//     [
//       "ความสามารถในการคิดวิเคราะห์ ชุดที่ 8 ",
//       "4_full_exam_gen_08.html",
//       "1622276296",
//       "4",
//       "a4.21"
//     ],
//     [
//       "ความสามารถในการคิดวิเคราะห์ ชุดที่ 9 ",
//       "4_full_exam_gen_09.html",
//       "1622276296",
//       "4",
//       "a4.22"
//     ],
//     [
//       "ความสามารถในการคิดวิเคราะห์ ชุดที่ 10 ",
//       "4_full_exam_gen_10.html",
//       "1622276296",
//       "4",
//       "a4.23"
//     ],
//     ["ภาษาอังกฤษ", "label_main_english_tests", "100", "4", "a4.24"],
//     [
//       "ภาษาอังกฤษ ชุดที่ 1 ",
//       "4_full_exam_en_01.html",
//       "1622276296",
//       "4",
//       "a4.25"
//     ],
//     [
//       "ภาษาอังกฤษ ชุดที่ 2 ",
//       "4_full_exam_en_02.html",
//       "1622276296",
//       "4",
//       "a4.26"
//     ],
//     [
//       "ภาษาอังกฤษ ชุดที่ 3 ",
//       "4_full_exam_en_03.html",
//       "1622276296",
//       "4",
//       "a4.27"
//     ],
//     [
//       "ภาษาอังกฤษ ชุดที่ 4 ",
//       "4_full_exam_en_04.html",
//       "1622276296",
//       "4",
//       "a4.28"
//     ],
//     [
//       "ภาษาอังกฤษ ชุดที่ 5 ",
//       "4_full_exam_en_05.html",
//       "1622276296",
//       "4",
//       "a4.29"
//     ],
//     [
//       "ภาษาอังกฤษ ชุดที่ 6 ",
//       "4_full_exam_en_06.html",
//       "1622276296",
//       "4",
//       "a4.30"
//     ],
//     [
//       "ภาษาอังกฤษ ชุดที่ 7 ",
//       "4_full_exam_en_07.html",
//       "1622276296",
//       "4",
//       "a4.31"
//     ],
//     [
//       "ภาษาอังกฤษ ชุดที่ 8 ",
//       "4_full_exam_en_08.html",
//       "1622276296",
//       "4",
//       "a4.32"
//     ],
//     [
//       "ภาษาอังกฤษ ชุดที่ 9 ",
//       "4_full_exam_en_09.html",
//       "1622276296",
//       "4",
//       "a4.33"
//     ],
//     [
//       "ภาษาอังกฤษ ชุดที่ 10 ",
//       "4_full_exam_en_10.html",
//       "1622276296",
//       "4",
//       "a4.34"
//     ],
//     [
//       "การเป็นข้าราชการที่ดี",
//       "label_main_being_good_civl_servants",
//       "100",
//       "4",
//       "a4.35"
//     ],
//     [
//       "การเป็นข้าราชการที่ดี ชุดที่ 1 ",
//       "5_full_exam_good_cv_01.html",
//       "1622276296",
//       "4",
//       "a4.36"
//     ],
//     [
//       "การเป็นข้าราชการที่ดี ชุดที่ 2 ",
//       "5_full_exam_good_cv_02.html",
//       "1622276296",
//       "4",
//       "a4.37"
//     ],
//   ];
//
//
//   // static const List newBigList = [
//   //   // รวมให้เป็น List เดียว จาก general[] english[] law[] และ practicee[]
//   //   ...MyHomePage.general,
//   //   ...MyHomePage.english,
//   //   ...MyHomePage.law,
//   //   ...MyHomePage.practice
//   //   // ...testFiles,
//   // ];
//
//   //debugPrint("newBigList จำนวน สมาชิก: ${newBigList.length} รายการ");
//
//
//
//
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   bool _showUpdateBanner = false;  // for Update is available
//   String _localVersion = ''; // for Update is available
//   String _remoteVersion = ''; // for Update is available for Android
//   String _remoteVersion_iOS = ''; // for Update is available for IOS
//   String _whatsNew_Android = '';
//   String _whatsNew_iOS = '';
//
//   int _selectedIndex = 0;// for Update is available
//
//   late Future<void> _packageInfoFuture;
//   bool _isThereCurrentDialogShowing(BuildContext context) =>
//       ModalRoute.of(context)?.isCurrent ?? false;
//
//   // สำหรับแสดง dialog ตอนเปิดแอพ
//   bool _isDialogShown = false;
//   bool isDialogHidingExpired = true;
//   bool isShowRequestFiveStarBox = true;
//
//
//   DateTime? firstOpenApp;  // สำหรับเก็บวันเดือนปีที่เปิดใช้ครั้งแรก เพื่อแสดง dialog ชวนโหวด 5 ดาว
//   bool shouldShowVoteFiveStar = false;
//   bool isVoteFiveStarsAlready = false; // สำหรับว่า ถ้าโหวตแล้ว จะมีตัวเลือก ให้ไม่แสดง dialog อีกตลอดไป
//   String? appName;
//   String? packageName;
//   String? version;
//   String? buildNumber;
//   final GoogleSheetsAPI _sheetsAPI = GoogleSheetsAPI();
//   List<Map<String, dynamic>> myGSheetData = [];
//
//
//   @override
//   void initState() {
//     super.initState();
//     _packageInfoFuture = _loadPackageInfo();
//     //  _loadSessionState();
//     _checkLastOpenTime();
//     _doRandomNumber();
//
//
//     //   checkVersion(); //สำหรับแสดง bottom bar notification for update
//
//     fetchData();  // ไปเอาข้อมูลจาก Google Sheets
//
//     // testHowMuchTimeAMethodUsed();  // ตรวจดูว่า method ใช้เวลาทำงาน นานเท่าไร
//   }
//
//
//
//   // Future<void> fetchData() async {
//   //   final GSheetsData = await _sheetsAPI.fetchData();
//   //   setState(() {
//   //     myGSheetData = GSheetsData;
//   //   });
//   //     debugPrint("data from sheets: $myGSheetData");
//   // }
//
//   // Future<void> fetchData() async {
//   //   final GSheetsData = await _sheetsAPI.fetchData();
//   //   setState(() {
//   //     myGSheetData = GSheetsData;
//   //   });
//   //
//   //   debugPrint("data from sheets: $myGSheetData");
//   //
//   //   // 🔽 Call this after data is loaded
//   //   // await checkAndShowUpdateBadge(myGSheetData); // not use because flutter_app_badger package is discontinued
//   //    await checkVersion();
//   // }
//
//   Future<bool> isConnected() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         return true;
//       }
//     } on SocketException catch (_) {
//       return false;
//     }
//     return false;
//   }
//
//   Future<void> fetchData() async {
//     if (await isConnected()) {
//       try {
//         final GSheetsData = await _sheetsAPI.fetchData();
//
//         setState(() {
//           myGSheetData = GSheetsData;
//         });
//
//         debugPrint("data from sheets: $myGSheetData");
//
//         await checkVersion();
//       } catch (e) {
//         debugPrint('Exception while fetching data: $e');
//         ScaffoldMessenger.of(context).showSnackBar(  // snackbar not working
//           const SnackBar(content: Text('Error fetching data. Please try again.')),
//         );
//       }
//     } else {
//       debugPrint('Device offline.');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar( // snackbar not working
//             content: Text('No internet connection. Cannot fetch updates.')),
//       );
//     }
//   }
//
//
//   Future<int?> getCount() async {
//     // ถูกเรียกโดยใช้ snapshot
//     var dbClient = await SqliteDB().db;
//     var x = await dbClient!.rawQuery('SELECT COUNT (*) from OcscTjkTable');
//     int? countX = Sqflite.firstIntValue(x);
// //    debugPrint("getCount นับจำนวนใน OcscTjkTable: $countX");
//
//     //
//
//     // ดูข้อมูลในตาราง itemTable อันนี้ ใช้เพื่อทดสอบเฉย ๆ เสร็จแล้ว ต้อง comment ออก
//     // เพราะทำให้หน้าจอ MainMenu ไม่แสดงอะไร เพราะ ต้องเอาค่าไปเชคว่า เป็น 0 หรือไม่
//     // เพื่อดูว่า เข้ามาครั้งแรกหรือเปล่า  ถ้ามีการเชคตารางนี้ด้วย และส่งออกไปเป็น String
//     // ตอนเชค ผลก็จะไม่ใช่ 0 และจะไม่เอาข้อมูลใส่ตาราง OcscTable และ ตาราง itemTable
//     // ทำให้ไม่ข้อมูล จึงต้อง comment ออก
//     // var y = await dbClient.rawQuery('SELECT COUNT (*) from itemTable');
//     // int countY = Sqflite.firstIntValue(y);
//     // String myCount = "\nOcscTjkTable: $countX; \nitemTable: $countY";
//     return countX;
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint("isDialogHidingExpired before showFirstMessage: $isDialogHidingExpired");
//
//     showFirstMessage(context, isDialogHidingExpired, isVoteFiveStarsAlready, isShowRequestFiveStarBox); // แสดง dialog แสดงข่าวสาร ตอนเปิดโปรแกรม
//     //   showDialog_work_in_progress(context);
//
//     final providerModel = Provider.of<ProviderModel>(context,
//         listen: false); // สำหรับการซื้อในแอพ
//
// //    // ใช้ revenueCat แทน เพราะหา การซื้อครั้งก่อนไม่ได้ ใช้ firebase function
// //     // ก็มีปัญหา error เยอะ เรียกฟังก์ชันไม่สำเร็จ
//     providerModel.initPlatformState();
//     bool isBuyFromProvider = providerModel.removeAds;
//     debugPrint("isBuyFromProvider from main.dart: $isBuyFromProvider");
//
// // สำหรับข้อมูล ให้กำลังใจ และ นับถอยหลัง จาก Google Sheets
//     List msgFromGSheets = myGSheetData;
//     debugPrint("record length: ${msgFromGSheets.length}");
//
//     if(msgFromGSheets.isEmpty){
//       // ถ้าไม่มีอินเทอร์เน็ต คือ offline อยู่ ให้ใช้ข้อความนี้  ---------------
//       msgFromGSheets = [
//         {'name': 'exam_schedule', 'description': 'วันขึ้นปีใหม่_X_ 1 มกราคม_X_2024-01-01 00:00:01xyzวันสงกรานต์_X_ 13 เมษายน_X_2024-01-01 00:00:01'},
//         {'name': 'message_android_bought', 'description': '**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี**xyz**ความพยายามอยู่ที่ไหน ความสำเร็จอยู่ที่นั่น**'},
//         {'name': 'message_android_not_buy_yet', 'description': '**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี**xyz**ความพยายามอยู่ที่ไหน ความสำเร็จอยู่ที่นั่น**'},
//         {'name': 'message_ios_bought', 'description': '**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี**xyz**ความพยายามอยู่ที่ไหน ความสำเร็จอยู่ที่นั่น**'},
//         {'name': 'message_ios_not_buy_yet', 'description': '**ขอให้ท่าน โชคดี สอบผ่านฉลุย**xyz**ขอให้ท่าน โชคดี**xyz**ความพยายามอยู่ที่ไหน ความสำเร็จอยู่ที่นั่น**'},
//         {'name': 'ocsc_curr_version_android', 'description':'3.0.0+25680101'},
//       ];
//
//     }
//
//     debugPrint("msgFromGSheets XX: $msgFromGSheets");
//     debugPrint("record length XX: ${msgFromGSheets.length}");
//     debugPrint("record[5] XX: ${msgFromGSheets[5]}");
//     debugPrint("version from package: $version");
//
//     // if (msgFromGSheets.isNotEmpty) {
//     //   for (int i = 0; i < msgFromGSheets.length; i++) {
//     //     // debugPrint("debugPrint record $i" + msgFromGSheets[i].toString());
//     //     //String description = msgFromGSheets['description'];
//     //     String description = msgFromGSheets[i]['description'];
//     //     debugPrint("Description from GSheets $i: $description");
//     //   }
//     //
//     // }
//
//
//     const List newBigList = [
//       // รวมให้เป็น List เดียว จาก general[] english[] law[] และ practicee[]
//       ...MyHomePage.general,
//       ...MyHomePage.english,
//       ...MyHomePage.law,
//       ...MyHomePage.practice
//       // ...testFiles,
//     ];
//     debugPrint("newBigList จำนวน สมาชิก: ${newBigList.length} รายการ");
//     // newBigList.asMap().forEach((i, value) {
//     //   debugPrint('index=$i, value=$value');
//     // });
//     final isDarkMde =
//         Provider.of<ThemeNotifier>(context, listen: false).darkTheme;
//     debugPrint("isDarkMde checked: $isDarkMde");
//
//     // สำหรับ ไอคอน สว่าง-มืด
//     const IconData nightlight_outlined = IconData(0xf214, fontFamily: 'MaterialIcons');
//     const IconData wb_sunny_outlined = IconData(0xf4bc, fontFamily: 'MaterialIcons');
//     const IconData mode_night = IconData(0xe3f4, fontFamily: 'MaterialIcons');
//     const IconData sunny = IconData(0xf0575, fontFamily: 'MaterialIcons');
//
//     // final countDwnIndx =
//     //     Provider.of<ThemeNotifier>(context, listen: false).thisExamIndexFromPref;
//
//     final theme = Provider.of<ThemeNotifier>(context,
//         listen: false); // ใช้สำหรับ update ตัวแปร index ด้วย
//     //  int thisIndex = examScheduleIndex;
//     int countDwnIndx = theme.thisExamIndexFromPref;
//     // int dateInstalled = ((theme.installDate) / 1000).round(); // วันที่ ที่ติดตั้งแอพ
//
//     // final myInstallDate = Provider.of<ThemeNotifier>(context,
//     //     listen: false);  // วันที่ ที่ติดตั้งแอพ
//     // int dateInstalled = ((myInstallDate.installDate) / 1000).round();
//     // debugdebugPrint("install at: $dateInstalled");
//
//
//     List<String> messageList = countDown_global.split("xyz"); // แปลงเป็น list จะได้นับจำนวนได้ แต่ละอัน คั่นด้วย xyz
//     debugPrint("thisIndex from sharePref countDwnIndx: $countDwnIndx");
//     debugPrint("msg length: ${messageList.length}");
//     if (countDwnIndx >= messageList.length){
//       countDwnIndx = 0;
//     }
//     // prepareOcscTjkTableData(
//     //     general: general, english: english, law: law, practice: practice);
//
//
//     // ไม่เอาแล้ว เพราะไม่ได้เอาจุดแดง เอาข้อมูลใน หน้าเมนู มาใส่ที่นี่เลยทั้งหมด จะเพิ่มหรือลดเมนู ก็จะได้ปรับได้ทันทีเลย
//     prepareOcscTjkTableData(newList: newBigList);
//
//     // เอานี่แทน  ไม่ได้ เพราะภ้าลบหมด ข้อมูลความก้าวหน้าในวงกลม ก็จะถูกลบไปด้วย
//     //  populateOcscTjkTable(wholeList: newBigList);
//
//
//     // getCountDwnMsg();
//     // var _countDownMsg = getCountDwnMsg();
//
//     //  bool isDarkMode = false;  // ใช้ในเมนู บน AppBar
//
//     return SafeArea(
//       minimum: const EdgeInsets.all(1.0),
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           title: Text(this.widget.title),
//           actions: [
//             Tooltip(
//               message: "ปรับโหมด มืด-สว่าง",
//               child: Row(
//                 children: [
//                   Transform.rotate(
//                     angle: 3.14159 / 4, // Rotating 45 degrees (change angle as needed)
//                     child: Icon(
//                       isDarkMde == true ? wb_sunny_outlined : mode_night, // Change icon based on isDarkMde
//                       color: isDarkMde == true ? Colors.pink[100] : Colors.yellow,
//                       size: isDarkMde == true ? 30 : 18.0,
//                     ),
//                   ),
//
//                   Consumer<ThemeNotifier>(
//                     builder: (context, notifier, child) => Switch(
//                       activeColor: Colors.lime,
//                       onChanged: (val) {
//                         notifier.toggleTheme();
//                         //   toggle();
//                       },
//                       value: notifier.darkTheme,
//                     ),
//                   )
//                 ],
//               ), // end of chile: Row(
//             )
//           ],
//         ),
//         // ถ้าจะมี drawer ก็นำมาวางตรงนี้
//         // drawer: Drawer();
//
//         body: FutureBuilder(
//           future: Future.wait([getCount(), getCountDwnMsg()]),
//           // เรียกใช้ multiple future
//           // getCount() ใช้ตรวจสอบข้อมูลในตาราง, getCountDwnMsg() ไปเอานับถอยหลัง จาก pastebin
//           builder: (ctx, snapshot) {
//             // Checking if future is resolved or not
//             if (snapshot.connectionState == ConnectionState.done) {
//               // If we got an error
//               if (snapshot.hasError) {
//                 return Center(
//                   child: Text(
//                     '${snapshot.error} occured',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 );
//                 // if we got our data
//               } else if (snapshot.hasData) {
//                 debugPrint("general list: ${MyHomePage.general}");
//                 //    debugPrint("ดูว่าในตาราง OcscTjkTable มีข้อมูลไหม ");
//                 getCount().then((numOfRecordsInOcscTjkTable) {
//                   //ถ้ามีข้อมูลในตาราง OcscTjkTable แล้ว ไม่ทำอะไร ลองดู เพราะเห็นมีรายการซำ้กัน ใน mainMenu
//                   if (numOfRecordsInOcscTjkTable! <= 0) {
//                     debugPrint("ตาราง OcscTjkTable ไม่มีข้อมูล ");
//                     var newList = [
//                       // รวมให้เป็น List เดียว จาก general[] english[] law[] และ practicee[]
//                       ...MyHomePage.general,
//                       ...MyHomePage.english,
//                       ...MyHomePage.law,
//                       ...MyHomePage.practice
//                       // ...testFiles,
//                     ]; // merge lists
//                     // debugPrint(
//                     //     "all files count < 0 data before check If 0: ${snapshot.data}"); // จำนวนแถวข้อมูล ในตาราง OcscTjkTable มาจาก getCount()
//                     // debugPrint("all files: ${newList.length}: $newList");
//                   }
//                 });
//
//                 // แก้ไปแก้มา ตกลงเลย ไม่ได้ใช้ getCount และ FutureBuilder ด้วย เดี๋ยวต้องดูอีกทีเอาออก
//                 // ถ้ามีข้อมูล ต้องเชคว่า มีอะไรเพิ่มเข้ามา หรือไม่
//
//                 //  final data = snapshot.data;
//                 var countDownMessage = snapshot.data![1].toString();  // 1 คือตัวที่ 2 ตอนเรียก future builder
//                 debugPrint("countDownMessage in Main: $countDownMessage");
//                 debugPrint("msgFromGSheets before mainMenu: $msgFromGSheets");
//
//                 //   debugPrint("curr_ver in Main: ${msgFromGSheets[6].toString()}");
//
// //                 bool pastebin_not_ok = countDownMessage.contains("html") || countDownMessage.contains("title") || countDownMessage.contains("429");
// // if(pastebin_not_ok){
// //   countDownMessage = countDown_global;
// // }
//
//                 // data คือ จำนวนแถวในตาราง OcscTjkTable ได้มาจาก getCount()
//                 //   getExamDataFromXmlAndWriteToItemTable(context, "dummy_xml.xml");
//
//                 // getCountDwnMsg().then((thisMsg){
//                 //   final countDownMsg = thisMsg;
//                 //   debugPrint("countDownMsg inside:  $countDownMsg");
//                 // });
//                 // debugPrint("countDownMsg inside:  $countDownMsg");
//                 return Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       // image: AssetImage('assets/images/beach04.png'),  // ช้า ต้องรอให้โหลดเสร็จ
//                       image: widget.beachImage.image,
//                       // เรียกใช่้รูป beach04.png ที่ preload เอาไว้ก่อนหน้านี้แล้ว จะได้มาทันที ไม่ต้องรอ ไม่่งั้น ตัวหนังสือมาครบ มีหยุดขาวนิดนึง แล้วรูปจึงตามมา
//                       fit: BoxFit.cover,
//                       // fit: BoxFit.fill,
//                     ),
//                   ),
//                   child: Column(
//                     //   crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         const SizedBox(
//                           // เว้นเป็นพื้นที่ว่างเอาไว้ สำหรับ logo ที่ติดอยู่ในภาพ beach04.png ที่ใช้เป็น background
//                           height: 40,
//                           width: 200,
//                         ),
//                         Expanded(
//                           child: Center(
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 // mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   const Text(
//                                     'เลือกหัวข้อประเภทข้อสอบ',
//                                     //  'ฟรี!!! ช่วงโปรโมชั่น',
//                                     style: TextStyle(
//                                       fontFamily: 'Athiti',
//                                       fontSize: 25,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white60,
//                                       //   color: Colors.yellowAccent,
//                                     ),
//                                   ),
//                                   // Text(
//                                   //   '(ปกติ 199.- บาท)',
//                                   //   style: TextStyle(
//                                   //     fontFamily: 'Athiti',
//                                   //     fontSize: 18,
//                                   //     fontWeight: FontWeight.bold,
//                                   //     color: Colors.white60,
//                                   //     // color: Colors.yellowAccent,
//                                   //   ),
//                                   // ),
//                                   const SizedBox(
//                                       width: double.infinity, height: 12.0),
//                                   //Text(general[[1][0]].toString()),
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 40.0,
//                                     child: ElevatedButton(
//                                       style: ButtonStyle(
//                                           backgroundColor:
//                                           WidgetStateProperty.all<Color>(
//                                               Colors.blue[300]!)),
//                                       clipBehavior: Clip.none,
//                                       child: const Text(
//                                         'หลักสูตรและโครงสร้างข้อสอบ ก.พ. (ภาค ก.)',
//                                         style: TextStyle(
//                                           fontFamily: 'Athiti',
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Color(0xffFFFF00),
//                                         ),
//                                       ),
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                               const Curriculum(
//                                                 key: null,
//                                               )),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     //Use of SizedBox for spacing
//                                     height: 5,
//                                   ),
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 40.0,
//                                     child: ElevatedButton(
//                                       style: ButtonStyle(
//                                           backgroundColor:
//                                           WidgetStateProperty.all<Color>(
//                                               Colors.blue[300]!)),
//                                       child: const Text(
//                                         'ความสามารถทั่วไป',
//                                         style: TextStyle(
//                                             fontFamily: 'Athiti',
//                                             color: Color(0xff003366),
//                                             fontSize: 22,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       onPressed: () {
//                                         //navigateToP2(context);
//                                         debugPrint(
//                                             "ปุ่ม Go to ความสามารถทั่วไป ถูกกด aaa aa");
//                                         if (msgFromGSheets.isNotEmpty) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) => MainMenu(
//                                                   //myMenuContents: general,
//                                                   myType: "1",
//                                                   title: "ความสามารถทั่วไป",
//                                                   fileList:
//                                                   MyHomePage.general,
//                                                   // examScheduleIndex: 1,
//                                                   examScheduleIndex:
//                                                   countDwnIndx,
//                                                   countDownMessage:
//                                                   countDownMessage,
//                                                   msgFromGSheets: msgFromGSheets,
//                                                   //fileList: newList,
//                                                 )),
//                                           );}else{
//                                           const Center(
//                                             child: CircularProgressIndicator(),
//                                           );
//                                         };
//                                       },
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     //Use of SizedBox for spacing
//                                     height: 5,
//                                   ),
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 40.0,
//                                     child: ElevatedButton(
//                                       style: ButtonStyle(
//                                           backgroundColor:
//                                           WidgetStateProperty.all<Color>(
//                                               Colors.blue[300]!)),
//                                       child: const Text(
//                                         'ภาษาอังกฤษ',
//                                         style: TextStyle(
//                                             fontFamily: 'Athiti',
//                                             color: Color(0xff003366),
//                                             fontSize: 22,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       onPressed: () {
//                                         debugPrint("cccc cc");
//                                         // TODO
//                                         // navigateToP3(context);
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => MainMenu(
//                                                 //    myMenuContents: english,
//                                                 myType: "2",
//                                                 title: "ภาษาอังกฤษ",
//                                                 fileList:
//                                                 MyHomePage.english,
//                                                 examScheduleIndex:
//                                                 countDwnIndx,
//                                                 countDownMessage:
//                                                 countDownMessage,
//                                                 msgFromGSheets: msgFromGSheets,
//                                                 //fileList: newList,
//                                               )),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     //Use of SizedBox for spacing
//                                     height: 5,
//                                   ),
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 40.0,
//                                     child: ElevatedButton(
//                                       style: ButtonStyle(
//                                           backgroundColor:
//                                           WidgetStateProperty.all<Color>(
//                                               Colors.blue[300]!)),
//                                       child: const Text(
//                                         'การเป็นข้าราชการที่ดี',
//                                         style: TextStyle(
//                                             fontFamily: 'Athiti',
//                                             color: Color(0xff003366),
//                                             fontSize: 22,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       onPressed: () {
//                                         // TODO
//                                         //navigateToP4(context);
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => MainMenu(
//                                                 //           myMenuContents: law,
//                                                 myType: "3",
//                                                 title:
//                                                 "การเป็นข้าราชการที่ดี",
//                                                 fileList: MyHomePage.law,
//                                                 examScheduleIndex:
//                                                 countDwnIndx,
//                                                 countDownMessage:
//                                                 countDownMessage,
//                                                 msgFromGSheets: msgFromGSheets,
//                                                 //fileList: newList,
//                                               )),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     //Use of SizedBox for spacing
//                                     height: 5,
//                                   ),
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 40.0,
//                                     child: ElevatedButton(
//                                       style: ButtonStyle(
//                                           backgroundColor:
//                                           WidgetStateProperty.all<Color>(
//                                               Colors.blue[300]!)),
//                                       child: const Text(
//                                         'ฝึกทำข้อสอบ จับเวลา',
//                                         style: TextStyle(
//                                             fontFamily: 'Athiti',
//                                             color: Color(0xff003366),
//                                             fontSize: 22,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       onPressed: () {
//                                         // TODO
//                                         // navigateToP3(context);
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => MainMenu(
//                                                 //          myMenuContents: practice,
//                                                 myType: "4",
//                                                 title: "ฝึกทำข้อสอบ จับเวลา ",
//                                                 fileList:
//                                                 MyHomePage.practice,
//                                                 examScheduleIndex:
//                                                 countDwnIndx,
//                                                 countDownMessage:
//                                                 countDownMessage,
//                                                 msgFromGSheets: msgFromGSheets,
//                                                 //fileList: newList,
//                                               )),
//                                         );
//                                       },
//                                     ),
//                                   ),
//
//                                   const SizedBox(
//                                     //Use of SizedBox for spacing
//                                     height: 30,
//                                   ),
//                                   Text(
//                                     //  "Version: ${widget.version}", // เปลี่ยนเป็น stateful เรียกตรงจาก widget ไม่ได้
//                                     "Version: $version", // เรียกจากใน snapshot
//                                     style: const TextStyle(
//                                         fontSize: 15, color: Colors.white),
//                                   ),
//                                   Text(
//                                     //  "Build: ${widget.buildNumber}",
//                                     "Build: $buildNumber",
//                                     style: const TextStyle(
//                                         fontSize: 15, color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ]),
//                 );
//               }
//             }
//
//             // Displaying LoadingSpinner to indicate waiting state
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           },
//           //future: getData(),
//           // future: _countDownMsg = getCountDwnMsg();
//
//           //   future: Future.wait([getCount(), getCountDwnMsg()]), // เรียกใช้ multiple future
//           // https://www.edoardovignati.it/how-to-wait-for-multiple-futures-with-futurebuilder-in-flutter/
//
//           // future:
//           // getCount(),  // เชคว่า มีข้อมูลในตาราง OcscTjkTable หรือไม่ ถ้าไม่มี นับจะได้ 0 แสดงว่า
//           // เป็นการเปิดใช้งานครั้งแรก โดยจะไปทำงานที่ FutureBuilder
//           // getCountDwnMsg() เป็นการไปเอาข้อมูลนับถอยหลัง จาก pastebin
//         ),
//
//         // for showing UPDATE available (if any) bottom bar
//
//         bottomNavigationBar: _showUpdateBanner
//             ? GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: () {
//             // Tap outside the 'Click here' link → dismiss banner
//             setState(() {
//               _showUpdateBanner = false;
//             });
//           },
//           child: Container(
//             color: Colors.amber[800],
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   Theme.of(context).platform == TargetPlatform.iOS
//                       ? 'มีข้อสอบใหม!!! ฟรี UPDATE ที่ App Store\n รุ่นของท่าน: $_localVersion รุ่นใหม่: $_remoteVersion_iOS \n $_whatsNew_iOS'
//                       : 'มีข้อสอบใหม!!! ฟรี UPDATE ที่ Play Store\n รุ่นของท่าน: $_localVersion รุ่นใหม่: $_remoteVersion \n $_whatsNew_Android',
//                   style: const TextStyle(
//                       fontFamily: 'Athiti',
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14
//                   ),
//
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 6),
//                 GestureDetector(
//                   onTap: () async {
//                     final String url = Platform.isIOS
//                         ? 'https://apps.apple.com/app/id1622156979'
//                         : 'https://play.google.com/store/apps/details?id=com.thongjoon.ocsc_exam_prep';
//
//                     if (await canLaunchUrl(Uri.parse(url))) {
//                       await launchUrl(Uri.parse(url),
//                           mode: LaunchMode.externalApplication);
//                     } else {
//                       debugPrint("Could not launch store URL");
//                     }
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjust padding as needed
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white, width: 2), // Border color and width
//                       borderRadius: BorderRadius.circular(12), // Rounded corners
//                     ),
//                     child: Text(
//                       Platform.isIOS
//                           ? '👉 กดที่นี่ เพื่อ UPDATE'
//                           : '👉 กดที่นี่ เพื่อ UPDATE',
//                       style: const TextStyle(
//                           fontFamily: 'Athiti',
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.none,
//                           fontSize: 16
//                       ),
//                       // style: const TextStyle(
//                       //   color: Colors.white,
//                       //   fontWeight: FontWeight.bold,
//                       //   decoration: TextDecoration.none,
//                       // ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//             : null,
//       ),
//     );
//   }
//
//   // void prepareOcscTjkTableData(
//   void prepareOcscTjkTableData ({required List newList}) async {
//
//     // ไปเอาข้อมูลติดตั้งแอพ ใน sharePref ซึ่งอยู่ใน theme.dart
//
//     int? dateInstalled = await AppUtils.getInstallDateEpochSeconds();
//
//     // final myInstallDate = Provider.of<ThemeNotifier>(context,
//     //     listen: false);  // วันที่ ที่ติดตั้งแอพ
//     // int dateInstalled = ((myInstallDate.installDate) / 1000).round();
//     debugPrint("install at: $dateInstalled");
//
//     // debugPrint(
//     //     "all files data before check If 0: ${snapshot.data}"); // จำนวนแถวข้อมูล ในตาราง OcscTjkTable มาจาก getCount()
//     //   debugPrint("all files after merge: ${newList.length}: $newList");
//     // create list of files to compare with database
//     // List menuNameList = [];
//     // for (var i = 0; i < newList.length; i++) {
//     // //  fileNameList.add(newList[i][1]);
//     //   menuNameList.add(newList[i][0]);  // เปลี่ยนเป็นชื่อเมนูดีกว่า ถ้ามีการเปลี่ยนแปลง จะได้เปลี่ยนหน้าเมนูในแอปให้ด้วย
//     // }
//     var dbClient = await SqliteDB().db;
//     var x = await dbClient!.rawQuery('SELECT COUNT (*) from OcscTjkTable');
//     int? countX = Sqflite.firstIntValue(x);
//     debugPrint("เข้ามาครั้งแรก ข้อมูลใน OcscTjkTable : $countX");
//     if (countX == 0) {  // ตาราง OcscTjkTable ว่างเปล่า แสดงว่า เป็นการใช้งานครั้งแรก
//       // เพิ่มทุกไฟล์ เข้าตาราง OcscTjkTable
//       addToOcscTjkTable(wholeList: newList); // เอาข้อมูลเข้าตาราง OcscTjkTable กำหนด isNew เป็น 0 จะได้ไม่มีปุ่มแดง
//     } else {  // กรณีมีข้อมูลในตาราง OcscTjkTable แล้ว
//
//       // กรณีไม่ใช่เป็นการใช้งานครั้งแรก
//
//       // ทำ 3 อย่าง  + 1 คือ ตำแหน่งด้วย เผื่อมีการย้ายตำแหน่งในเมนู
//       // 1. เชคว่า มีการเพิ่มข้อสอบชุดใหม่ ทั้งชุดเข้ามาหรือไม่ ถ้ามี เอาเพิ่มในตาราง OcscTjkTable และกำหนด isNew=1
//       //  2. เชคว่า มีการลบชุดข้อสอบเดิมออกหรือไม่ ถ้ามี ต้องเอาออกจาก ตาราง OcscTjkTable ด้วย
//       //  ไม่งั้นจะ crash ตอนเอาข้อมูลวันที่จาก ตาราง มาเชคกับ list ซึ่งลบไปแล้ว ก็จะไม่เจอ เป็น null ทำให้ crash บอกว่า source must not be null
//       //  3.  เชควันที่ว่า วันที่ของไฟล์ใด มากกว่าของเดิมในตาราง  OcscTjkTable ถ้ามากกว่า อัพเดท isNew=1 ไฟล์นี้ ในตาราง OcscTjkTable เพื่อให้มีจุดแดง
//       // 4. เชคตำแหน่ง ถ้าใหม่ ให้ update ในตารางด้วย
//
// // updateOcscTjkTblOnceAndForAll();
//       //
//       //ddd
//       debugPrint("mapYYY: before check");
//       List<String> menuNameListFromMain = [];
//       List<String> fileNameListFromMain = [];
//       // สำหรับเอาไปเปรียบเทียบกับ ชื่อไฟล์ในฐานข้อมูล
//       // ถ้าไม่พบ จะลบออกจากฐานข้อมูล คือ ในกรณีที่มีการลบหัวข้อบางหัวข้อออกไป ก็ให้ลบออกจากฐาน
//       //ข้อมูลด้วย มิฉะนั้น จะ Error ตอน เชควันที่ ใน mainMenu
//
//       // newList คือ จำนวนข้อมูลทุกหมวด (ความสามารถทั่วไป อังกฤษ ...) ใน main
//       debugPrint("จำนวนข้อมูลใน newList: ${newList.length}");
//
//
//
//       //  addNewDataIfAny();
//       for (var i = 0; i < newList.length; i++) { // newList คือ รายการวิชาและlabel ทั้งหมด
//         //    debugPrintWrapped("fileName (ชื่อไฟล์ทั้งหมด): ${newList[i][1]}"); // debugPrintWrapped คือ ให้แสดงทั้งหมด อย่าตัดมาแสดงบางส่วน
//         //     debugPrint("วนรอบที่ $i) ไฟล์: ${newList[i][1]}");
//         //debugPrint("check isNew file names: $i ${newList[i][1]}");
//         // checkAndUpdateOcscTjkTable( // ของเดิม ที่เอามา น่าจะต้อง เอาออกไป เพราะจะซ้ำซ้อน ทำที่นี่แล้ว
//
//         // ไฟล์ใหม่ซิง ๆ ถ้ามี รู้ได้โดยการเอาวันที่ของไฟล์ เปรียบเทียบกับวันที่ในตาราง OcscTjkTable
//         // 1) ถ้ามีเพิ่มชุดใหม่ทั้งชุด  ให้เพิ่มใน OcscTjkTable ด้วย และกำหนด isNew=1
//         addNewDataIfAny(
//             position: newList[i][4],
//             menuName: newList[i][0],
//             fileName: newList[i][1],
//             createDate: newList[i][2],
//             whatType: int.parse(newList[i][3]));
//
//         // เอาชื่อเมนู เพิ่มในรายการ menuNameListFromMain เพื่อเปรียบเทียบ กับชื่อเมนูในตาราง OcscTjkTable มั็ง??
//         //   fileNameListFromMain.add(newList[i][1]); // ชื่อไฟล์
//         menuNameListFromMain.add(newList[i][0]); // ชื่อเมนู
//       } // end of for
//
//       // ทดสอบว่ามีข้อมูลหรือไม่
//       debugPrint(
//           "ชื่อเมนูทั้งหมด  menuNameListFromMain จำนวน ${menuNameListFromMain.length}");
//       // menuNameListFromMain.asMap().forEach((i, value) {
//       //        debugPrint('index=$i, value=$value');
//       // });
//       // 2) ถ้ามีการลบ ให้ลบออกจาก ตาราง OcscTjkTable ด้วย -- แต่ไม่ลบออกจาก itemTable -- จริง ๆ ต้องลบ --  เวลาจะปรับใน itemTable ต้องเชคก่อน ถ้ามี update ถ้าไม่มี insert
//       //  deleteMenuItemFromTableIfNotExist(fileListInMain: fileNameListFromMain);
//       deleteMenuItemFromTableIfNotExist(menuListInMain: menuNameListFromMain);
//
//       // 3) เชควันที่ของไฟล์ที่ส่งเข้ามาว่า ใหม่หรือไม่ โดยใช้ข้อมูลจากตาราง itemTable
//       // ถ้าใหม่ใส่จุดแดง โดยอัพเดท isNew=1 และ brandNew=2
//
//       for (var i = 0; i < newList.length; i++) {
//
//         if(newList[i][1] == '1_symbol_cndtng_01.xml') {
//           debugPrint("file name: ${newList[i][1]} date in variable: ${newList[i][2]}");
//         }
//
//         // String? thisDateInMain = findFileDateAndPos(examList: thisFileList, fileName: thisFileName);
//         // int? thisDateInMainVariable = int.parse(thisDateInMain!);
//         //
//
//         retrieveDateFromSQflite(fileName: newList[i][1])
//             .then((positionAndDate) async {
//           int dateFromFile = int.parse(newList[i][2]); // จากไฟล์ในหน้า main
//           String position = newList[i][4]; // จากไฟล์ในหน้า main
//
//           var posAndDateArr = positionAndDate.split("aa");
//           String pos = posAndDateArr[0];
//
//           // debugPrint(
//           //     "afa: NewFile: $i  ${newList[i][1]} position_from_main: $position pos_sql: $pos");
//
//           int dateFromDB = int.parse(posAndDateArr[1]);
//
//           debugPrint("fileName xxx: ${newList[i][0]}");
//           debugPrint("dateFromDB xxx: $dateFromDB");
//           debugPrint("dateFromFile xxx: $dateFromFile");
//           int isMenuClickedFromDB = int.parse(posAndDateArr[2]);
//
//           bool isNewlyUploaded = false; // เชคกับวันที่ในฐานข้อมูล ว่า ส่งขึ้นมาใหม่หรือเปล่า ถ้าส่งใหม่ วันที่จะคนละวันกับที่มีในฐานข้อมูล คือ จะใหม่กว่า
//           if(dateFromFile > dateFromDB){
//             isNewlyUploaded = true;
//           }else{
//             isNewlyUploaded = false;
//           }
//
//
//           if (position != pos) {
//             // debugPrint(
//             //     "file to update pos: ${newList[i][1]}  NEW position: $position OLD pos: $pos");
//             updatePositionInOcscTjkTable(
//                 fileName: newList[i][1], position: position);
//           }
//           // ถ้าใหม่กว่า ให้ update ตาราง OcscTjkTable
//
//
//           if (!(newList[i][1].contains("label"))) { // ถ้าไม่ใช่ label (ชื่อแถบ)
//             debugPrint("name: ${newList[i][1]}");
//             debugPrint("dateFromDB: $dateFromDB");
//             debugPrint("dateFromMainVariable: $dateFromFile");
//             debugPrint("is this menu clicked from DB: $isMenuClickedFromDB");
//             int now = DateTime.now().millisecondsSinceEpoch ~/ 1000; // current time in seconds
//             int sixtyDaysAgo = now - (60 * 24 * 60 * 60); // 90 days ago in seconds
//
//
//             // ถ้า วันที่ ในเมนู ใหม่กว่า ันที่ในฐานข้อมูล และ วันที่ ไม่เกิน 60 วัน และยังไม่ได้คลิกเมนูนี้ ก็ถือว่า ยังใหม่อยู่
//             // ไม่ต้องเชค ว่าคลิกหรือยัง เพราะ ถ้าใหม่กว่าในฐานข้อมูล ก็ แสดงว่า เพิ่งเข้ามาดู เพราะของเดิมยังไม่ได้ปรับ
//             // ส่วนเวลาจะเอาออก ให้ดูว่า คลิกหรือยัง ถ้าคลิกแล้ว หรือเกิน 60 วันแล้ว ก็เอาจุดแกงออก
//
//             bool isWithinSixtyDays = dateFromFile > sixtyDaysAgo;
//
//             debugPrint("อออ fileName : ${newList[i][1]}");
//             debugPrint("อออ isNewlyUpdated ใหม่หรือเปล่า: $isNewlyUploaded");
//             debugPrint("อออ dateFromFile วันที่ในหน้าเมนู: $dateFromFile");
//             debugPrint("อออ isWithinSixtyDaysู: $isWithinSixtyDays");
//             debugPrint("อออ sixtyDaysAgo 60 วัน ก่อนหน้านีู้: $sixtyDaysAgo");
//             debugPrint("อออ dateFromDB วันที่ในฐานข้อมูล: $dateFromDB");
//             debugPrint("อออ dateInstalled วันที่ติดตั้งเริ่มใช้งาน: $dateInstalled");
//
//
//             await dbClient.transaction((txn) async {
// // เชคว่า ต้องเป็นวันที่ใหม่กว่า วันที่เก็บอยู่ในฐานข้อมูลในมือถือ ถอยไปไม่เกิน 60 วัน และไม่ก่อนการติดตั้งแอป
//             // ไม่งั้น ติดตั้งใหม่ เปิดมามีปุ่มแดงเต็มไปหมด ให้เริ่มแสดงปุ่มแดง เฉพาะมีการเพิ่มของใหม่ เริ่มตั้งแต่วัน
//               // ที่ติดตั้งโปรแกรเป็นต้นไป ก่อนหน้าวันติดตั้ง ถึงแม้้จะอยู่ภายใน 60 วัน ก็ไม่แสดงจุดแดง
//
//           //    print("Comparison result: ${isNewlyUploaded == true && dateFromFile >= sixtyDaysAgo && dateFromFile > dateInstalled!}");
//                 print("Comparison result not checking date installed: ${isNewlyUploaded == true && dateFromFile >= sixtyDaysAgo}");
//
//                 if(isNewlyUploaded == true){
//                   debugPrint("อออ NEW add redDot ใหม่กว่า: ${newList[i][1]}");
//                 }
//                 if(isWithinSixtyDays){
//                   debugPrint("อออ NEW add redDot ภายใน 60 วัน: ${newList[i][1]}");
//                 }
//
//
//
//                 //             if (isNewlyUploaded == true && dateFromFile > sixtyDaysAgo && dateFromFile > dateInstalled!) {
//                 if (isNewlyUploaded == true && dateFromFile > sixtyDaysAgo) {
//
//
//
//                 //             // เพิ่มจุดแดง โดยให้ isNew เป็น 1
//
//                 debugPrint("Criteria met--Add redDot ${newList[i][1]}");
//                   await txn.rawUpdate('''
//                       UPDATE OcscTjkTable
//                       SET isNew = 1, field_2 = 0
//                       WHERE file_name = ?
//                       ''', [newList[i][1]]);
//                 }else{
//                 debugPrint("Criteria NOT met -- No redDot ${newList[i][1]}");
//                 await txn.rawUpdate('''
//                     UPDATE OcscTjkTable
//                     SET isNew = 0, dateCreated = ?, field_2 = 0
//                     WHERE file_name = ?
//                     ''', [dateFromFile, newList[i][1]]);
//               }
//             });
//
//
//
//     //         int now = DateTime.now().millisecondsSinceEpoch ~/ 1000; // current time in seconds
//     //         int sixtyDaysAgo = now - (60 * 24 * 60 * 60); // 90 days ago in seconds
//     //
//     //
//     //         // ถ้า วันที่ ในเมนู ใหม่กว่า ันที่ในฐานข้อมูล และ วันที่ ไม่เกิน 60 วัน และยังไม่ได้คลิกเมนูนี้ ก็ถือว่า ยังใหม่อยู่
//     //         // ไม่ต้องเชค ว่าคลิกหรือยัง เพราะ ถ้าใหม่กว่าในฐานข้อมูล ก็ แสดงว่า เพิ่งเข้ามาดู เพราะของเดิมยังไม่ได้ปรับ
//     //         // ส่วนเวลาจะเอาออก ให้ดูว่า คลิกหรือยัง ถ้าคลิกแล้ว หรือเกิน 60 วันแล้ว ก็เอาจุดแกงออก
//     //
//     //          await dbClient.transaction((txn) async {
//     //           if (
//     //               dateFromFile > dateFromDB &&
//     //               dateFromFile >= sixtyDaysAgo &&
//     //                isMenuClickedFromDB == 0
//     //           ) {
//     // //             // เพิ่มจุดแดง โดยให้ isNew เป็น 1
//     //             await txn.rawUpdate('''
//     //   UPDATE OcscTjkTable
//     //   SET isNew = 1, dateCreated = ?
//     //   WHERE file_name = ?
//     // ''', [dateFromFile, newList[i][1]]);
//     //            } else if (isMenuClickedFromDB == 1){ // ถ้าคลิกแล้ว เอาจุดแดงออก
//     // // //             // ให้ isNew เป็น 0
//     //             await txn.rawUpdate('''
//     //   UPDATE OcscTjkTable
//     //   SET isNew = 0, dateCreated = ?
//     //   WHERE file_name = ?
//     // ''', [dateFromFile, newList[i][1]]);
//     //            }
//     //          });
//
//
//             //  if (
//             //     dateFromFile > dateFromDB &&
//             //     dateFromFile >= sixtyDaysAgo &&
//             //     isMenuClickedFromDB == 0
//             // ) {
//             //   // เพิ่มจะแดง โดย ให้ isNew ในตาราง ocscTjkTable เป็น 1
//             //    final dbClient = await SqliteDB().db;
//             //    var res = await dbClient!.rawQuery('''
//             //   UPDATE OcscTjkTable
//             //   SET isNew = 1
//             //   WHERE file_name = ?
//             //   ''', ['${newList[i][1]}']);
//             // }else{
//             //   // ให้ isNew ในตาราง ocscTjkTable เป็น 0
//             //   final dbClient = await SqliteDB().db;
//             //   var res = await dbClient!.rawQuery('''
//             //   UPDATE OcscTjkTable
//             //   SET isNew = 0
//             //   WHERE file_name = ?
//             //   ''', ['${newList[i][1]}']);
//             // }
//           }
//         });
//       }
//     }
//   }
//
//   // void updateIsNewInOcscTjkTable({required String fileName}) async {
//   //
//   //   // ปุ่มแดง หน้าเมนูหลัก
//   //   // ถ้าไม่มีชื่อไฟล์ในตาราง แสดงว่าเป็นไฟล์ใหม่ซิง ๆ ให้ปุ่มแดงทันที
//   //   // ถ้ามีชื่อ เชควันที่ต่อว่า วันที่ก่อนวันติดตั้ง และ มียังทำค้าง คือมี isNew อย่างนี้ ก็ให้ปุ่มแดง เพราะยังมีข้อใหม่ที่ต้องทำ
//   //   // ถ้านอกเหนือจากนี้ ไม่มีปุ่มแดง
//   //
//   //   //  debugPrint("thisDate main File to Update: $fileName");
//   //   // ดูว่า ไฟล์นี้ในตาราง itemTable คลิกหรือยัง สถานะยังใหม่หรือเปล่า
//   //
//   //   final dbClient = await SqliteDB().db;
//   //
//   //   // var isAllNew = Sqflite.firstIntValue(await dbClient!.rawQuery(
//   //   //     'SELECT COUNT (*) FROM itemTable WHERE file_name = ? AND isNew = ?',
//   //   //     ["$fileName", "1"]));
//   //
//   //   var count = Sqflite.firstIntValue(await dbClient!.rawQuery(
//   //       'SELECT COUNT (*) FROM itemTable WHERE file_name = ? AND isNew = ?',
//   //       ["$fileName", "1"]));
//   //
//   //   //     'SELECT COUNT (*) FROM itemTable WHERE file_name = ? and isClicked=? and isNew=?',
//   //   //     ["$fileName", "false", "1"])); // นับจำนวน record ในตาราง itemTable เงื่อนไขคือ เอาชื่อไฟล์นี้
//   //   // // ยังไม่คลิก และสถานะคือใหม่ (isClick="false", isNew=1)
//   //   debugPrint("เชคตาราง itemTable เสร็จหรือยัง ใน main.dart: ไฟล์:  $fileName #ยังไม่ได้ทำ $count ข้อ");
//   //
//   //   if(count! > 0) {
//   //     debugPrint(
//   //         "เชคในตาราง itemTable จาก main.dart ว่า ไฟล์นี้ ยังใหม่อยู่หรือเปล่า");
//   //     debugPrint("ชื่อไฟล์: $fileName  ใหม่");
//   //     var res = await dbClient.rawQuery('''
//   //   UPDATE OcscTjkTable
//   //   SET isNew = 1, field_2 = 0
//   //   WHERE file_name = ?
//   //   ''', ['$fileName']);
//   //   }else{
//   //     debugPrint(
//   //         "เชคในตาราง itemTable จาก main.dart ว่า ไฟล์นี้ ยังใหม่อยู่หรือเปล่า");
//   //     debugPrint("ชื่อไฟล์: $fileName  เก่า");
//   //     var res = await dbClient .rawQuery('''
//   //   UPDATE OcscTjkTable
//   //   SET isNew = 0, field_2 = 0
//   //   WHERE file_name = ?
//   //   ''', ['$fileName']);
//   //   }
//   //
//   //   // var res = await dbClient!.rawQuery('''
//   //   // UPDATE OcscTjkTable
//   //   // SET isNew = 1, field_2 = 2
//   //   // WHERE file_name = ?
//   //   // ''', ['$fileName']);
//   // }
//   // // end of function void updateIsNewInOcscTjkTable
//
//
//   initInApp(provider) async {
//     debugPrint("check going to initInApp from Main -- before going");
//     await provider.initInApp();
//     debugPrint("check going to initInApp from Main -- after going");
//   }
//
//   initPlatformState(provider) async {
//     debugPrint(
//         "check going to initPlatformState (revenueCat) from Main -- before going");
//     await provider.initPlatformState();
//     debugPrint("provider.removeAds: ${provider.remov}");
//   }
//
//   void updateOcscTjkTblOnceAndForAll() {
//     // ไม่ใช่เข้ามาครั้งแรก ทำ 3 อย่าง
//     // 1. เชคว่า มีการเพิ่มข้อสอบชุดใหม่เข้ามาหรือไม่ ถ้ามี เอาเพิ่มในตาราง OcscTjkTable และอัพเดท isNew=1,
//     // brandNew = 1 (ใหม่ทั้งชุด)  -- ตอนนี้ใช้ชื่อ field_2 ไปก่อน  // เปลี่ยนเป็น เก็บ is_clicked_main_menu: 0 not clicked, 1 clicked already. if clicked no reddot
//     //  2. เชคว่า มีการลบชุดข้อสอบเดิมออกหรือไม่ ถ้ามี ต้องเอาออกจาก ตาราง OcscTjkTable ด้วย
//     //  ไม่งั้นจะ crash ตอนเอาข้อมูลวันที่จาก ตาราง มาเชคกับ list ซึ่งลบไปแล้ว ก็จะไม่เจอ เป็น null ทำให้ crash บอกว่า source must not be null
//     //  3.  เชควันที่ว่า ที่ส่งเข้ามา ใหม่กว่า ของเดิมไหม ถ้าใหม่กว่า ให้มีจุดแดง โดยอัพเดท isNew ในตาราง OcscTjkTable เป็น 1, brandNew=2 (มีเพิ่ม ข้อใหม่)  -- ตอนนี้ใช้ชื่อ field_2 ไปก่อน
//   }
//
//   // ของเดิมไปเอามาจาก pastebin.com แต่ไม่ค่อยเสถียร แล้วอีกอย่าง package ไม่อัพเดท ทำให้ conflict
//   // กับ package อื่น เช่น webview ก็พลอยอัพเดทไม่ได้ -- ตกลง เลิกใช้ดีกว่า ใช้เป็นตัวแปร const แทน
//   // Future <String?> getCountDwnMsg() async {
//   //   String? thisCountDwnMsg = countDown_global;
//   //   return thisCountDwnMsg;
//   // }
//
//   // ไปเอาจาก Firebase  -- ยังไม่ได้ทำ
//   Future <String?> getCountDwnMsg() async {
//     String? thisCountDwnMsg = countDown_global;
// // final uid = "d8LV0oogW2xOZGbzJHeW";
// // var data = await FirebaseFirestore.instance
// //     .collection()
// //
//     return thisCountDwnMsg;
//   }
//
//
//
//
//
//
//
//
//   //
// //   Future<String?>   async {
// //     var countDown;
// //
// //     final String isPastebinAvailable = await checkWebsiteAvailability(url: 'https://pastebin.com');
// //    // final isPastebinAvailable = await requestGET(url: 'https://pastebin.com');
// // debugPrint("isPastebinAvailable in getCountDwnMsg: $isPastebinAvailable");
// //
// //     if (isPastebinAvailable == "no") {
// //       debugPrint("pastebin is not available.");
// //       countDown = "วันมาฆะบูชา _X_ ๒๖ กุมภาพันธ์ ๒๕๖๗  _X_ 2024-02-26 00:00:01xyzวันจักรี _X_ ๘ เมษายน ๒๕๖๗  _X_ 2024-04-08 00:00:01xyzวันสงกรานต์ _X_ ๑๓ เมษายน ๒๕๖๗  _X_ 2024-04-13 00:00:01xyzวันฉัตรมงคล  _X_ ๖ พฤษภาคม ๒๕๖๗  _X_ 2024-05-06 00:00:01xyzวันวิสาบูชา _X_ ๒๒ พฤษภาคม  ๒๕๖๗  _X_ 2024-05-22 00:00:01xyzวันเฉลิมพระชนมพรรษาสมเด็จพระนางเจ้าฯ พระบรมราชินี _X_ ๓ มิถุนายน  ๒๕๖๗  _X_ 2024-06-03 00:00:01xyzวันอาสาฬหบูชา _X_ ๒๐ กรกฎาคม  ๒๕๖๗  _X_ 2024-07-20 00:00:01xyzวันเข้าพรรษา _X_ ๒๑ กรกฎาคม    ๒๕๖๗  _X_ 2024-07-21 00:00:01xyzวันเฉลิมพระชนมพรรษาพระบาทสมเด็จพระวชิรเกล้าเจ้าอยู่หัว รัชกาลที่ 10 _X_ ๒๘ กรกฎาคม  ๒๕๖๗  _X_ 2024-07-28 00:00:01xyzวันแม่แห่งชาติ &&&วันเฉลิมพระชนมพรรษา &&&สมเด็จพระนางเจ้าสิริกิติ์ พระบรมราชินีนาถ พระบรมราชชนนีพันปีหลวง _X_ ๑๒ สิงหาคม  ๒๕๖๗  _X_ 2024-08-12 00:00:01xyzวันนวมินทรมหาราช (วันคล้ายวันสวรรคต)&&& พระบาทสมเด็จพระบรมชนกาธิเบศร มหาภูมิพลอดุลยเดชมหาราช บรมนาถบพิตร _X_ ๑๓ ตุลาคม  ๒๕๖๗  _X_ 2024-10-13 00:00:01xyzวันปิยมหาราช _X_ ๒๓ ตุลาคม  ๒๕๖๗  _X_ 2024-10-23 00:00:01xyzวันพ่อแห่งชาติ  _X_ ๕ ธันวาคม  ๒๕๖๗  _X_ 2024-12-05 00:00:01xyzวันรัฐธรรมนูญ _X_ ๑๐ ธันวาคม  ๒๕๖๗  _X_ 2024-12-10 00:00:01xyzวันสิ้นปี _X_ ๓๑ ธันวาคม  ๒๕๖๗  _X_ 2024-12-31 00:00:01xyzวันขึ้นปีใหม่  _X_ ๑ มกราคม ๒๕๖๘  _X_ 2025-01-01 00:00:01";
// //     }else {
// //       debugPrint("pastebin is available.");
// //       final primaryApiDevKey =
// //           'c-dOY4999bE7pXEtfIsKHq6UF-m6LeMx'; // get from https://pastebin.com/
// //       var pasteVisibility = pbn.Visibility.public;
// //       var pastebinClient = withSingleApiDevKey(
// //         apiDevKey: primaryApiDevKey,
// //       );
// //       String url = "TmqFdgNA";
// //       final result = await pastebinClient.rawPaste(
// //         // ให้กำลังใจ หรือแสดงข่าวสาร
// //         // ข้อความใน pastebin
// //         // แต่ละเรื่องคั่นด้วย xyz  ถ้ามีการขึ้นบรรทัดใหม่ ให้คั่นด้วย &&&
// //         // ใส่ลิงค์ได้ โดยขึ้นต้นด้วย https://www ...
// //         pasteKey: url,
// //         visibility: pasteVisibility,
// //       );
// //       countDown = result.fold((l) => null, (r) => r); // นับถอยหลัง
// //     }
// //     debugPrint("countDownMsgFromMain: $countDown");
// //     return countDown;
// //   }
//
//   void showFirstMessage(BuildContext context, bool isDialogHidingExpired, bool isVoteFiveStarsAlready, bool isShowRequestFiveStarBox) async {
//     bool isDialogHidingDayExpired = isDialogHidingExpired;
//     bool isClickVoteAlready = isVoteFiveStarsAlready;
//     bool showWelcomeDialogNoMore = SharedPreferencesManager().getBool(
//         'noMoreShowWelcomeDialog');
//
//     debugPrint("widget.isDialogHidingExpired: ${widget.isDialogHidingExpired}");
//     debugPrint("shouldShowVoteFiveStar: $shouldShowVoteFiveStar");
//     debugPrint("isDialogHidingDayExpired: $isDialogHidingDayExpired");
//     debugPrint("!_isDialogShown inside showFirstMessage: ${!(_isDialogShown)}");
//     debugPrint(
//         "_isThereCurrentDialogShowing(context): ${_isThereCurrentDialogShowing(
//             context)}");
//     debugPrint("showWelcomeDialogNoMore: $showWelcomeDialogNoMore");
//     // สำหรับแสดงข่าวสาร ตอนเปิด
//     // String myPackage = 'com.thongjoon.ocsc_exam_prep';
//     if(!showWelcomeDialogNoMore){ // ให้แสดง welcome dialog ถ้ายังไม่บอกว่า ไม่ต้องแสดงอีกตลอดไป
//       debugPrint("outside  if ((!_isDialogShown &&");
//       if ((!_isDialogShown && _isThereCurrentDialogShowing(context) &&
//           isDialogHidingDayExpired)) {
//         _isDialogShown = true; // ป้องกันไม่ให้เข้ามาอีกครั้ง
//         debugPrint("inside  if ((!_isDialogShown &&");
//         // ไม่แสดง dialog ซ้ำ ถ้ากำลังแสดงอยู่แล้ว
//         // Display your dialog here
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return Center(
//                 child: Container(
//                   constraints: BoxConstraints(maxHeight: 540),
//                   child: Theme(
//                     // Use your custom themeForGreetingDialog
//                     data: themeForGreetingDialog,
//                     child: AlertDialog(
//                       content: SingleChildScrollView(
//                         // ทำให้มีเลื่อนได้ เตรียมไว้เผื่อมียาว จะได้ไม่ overflow
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Image.asset(
//                               'assets/images/exam_prep_logo.png',
//                               height: 60,
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               'ยินดีต้อนรับ',
//                               //   style: Theme.of(context).textTheme.bodyLarge,
//                               //   style: selectedTextStyleWelcome,
//                               style: TextStyle(
//                                 fontFamily: 'Athiti',
//                                 fontSize: 25,
//                                 fontWeight: FontWeight.bold,
//                                 color: themeForGreetingDialog.primaryColor,
//                                 //  color: Colors.indigo,
//                                 //color: Theme.of(context).primaryColor,
//                               ),
//                               textAlign: TextAlign
//                                   .center, // Align the text within the Text widget
//                             ),
//                             SizedBox(height: 6),
//                             const Text(
//                               'ติ-ชม-สอบถาม ใช้เมนู 3 จุดในแอพ',
//                               style: TextStyle(
//                                 //        fontFamily: 'Athiti',
//                                 fontSize: 15,
//                                 // fontWeight: FontWeight.bold,
//                                 fontWeight: FontWeight.normal,
//                                 color: Colors.indigo,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             // const Text('ใช้งานกับ Android 8 (Oreo) ขึ้นไป',
//                             //   style: TextStyle(
//                             //     //        fontFamily: 'Athiti',
//                             //     fontSize: 10,
//                             //     fontWeight: FontWeight.bold,
//                             //     color: Colors.red,
//                             //   ),
//                             // ),
//                             SizedBox(height: 5),
//                             flutterVisibility.Visibility(
//                               // จะแสดง ขอกำลังใจเมื่อ 1)เลยเวลาจำนวนวันที่กำหนดหลังจากเปิดใช้งานครั้งแรก เพื่อให้คนได้ใช้
//                               // ก่อนที่จะชวนให้โหวต และ 2)ยังไม่ได้คลิกลิงค์ไปโหวต
//                               visible: (shouldShowVoteFiveStar &&
//                                   !isVoteFiveStarsAlready && isShowRequestFiveStarBox),
//                               child: Container(
//                                 // padding: EdgeInsets.all(8.0),
//                                 padding: EdgeInsets.only(
//                                   left: 15.0, right: 15.0, bottom: 5,),
//                                 // Set padding only on the left and right
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Colors.red, // Set the border color
//                                     width: 2.0, // Set the border width
//                                   ),
//                                   borderRadius: BorderRadius.circular(
//                                       10.0), // Set the border radius
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     SizedBox(height: 5),
//                                     const Text(
//                                       'ขอกำลังใจ 5 ดาว',
//                                       style: TextStyle(
//                                         //        fontFamily: 'Athiti',
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.redAccent,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     // SizedBox(height: 5),
//                                     GestureDetector(
//                                       onTap: () {
//                                         _setOptionNotShowDialog();
//                                         // Close the first dialog
//                                         Navigator.of(context).pop();
//
//                                         if (Platform.isIOS || Platform.isMacOS) {
//                                           // ไป App Store
//                                           _launchURL('https://apps.apple.com/th/app/%E0%B9%80%E0%B8%95%E0%B8%A3-%E0%B8%A2%E0%B8%A1%E0%B8%AA%E0%B8%AD%E0%B8%9A-%E0%B8%81%E0%B8%9E-%E0%B8%A0%E0%B8%B2%E0%B8%84-%E0%B8%81/id1622156979?l=th');
//                                         } else if (Platform.isAndroid) {
//                                           // ไป Google Play
//                                           _launchURL(
//                                               'https://play.google.com/store/apps/details?id=$packageName');
//                                           // _launchURL(  // ก็ เหมือน ๆ กับ บรรทัดบน ดูแล้วไปหน้าเดียวกันบน play store
//                                           //     'market://details?id=$packageName'); // packageName จาก packageInfo_plus
//                                         }
//
//                                       },
//                                       child: RichText(
//                                         text: const TextSpan(
//                                           text: 'ให้คะแนน 5 ดาว ',
//                                           style: TextStyle(
//                                             //  fontFamily: 'Athiti',
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.indigo,
//                                             decoration: TextDecoration.underline,
//                                           ),
//                                           children: <TextSpan>[
//                                             TextSpan(
//                                               text: 'คลิกที่นี่',
//                                               style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: 16,
//                                                 decoration: TextDecoration
//                                                     .underline,
//                                                 //   backgroundColor: Colors.yellow,
//                                               ),
//                                             ),
//                                             TextSpan(text: ' \nขอบคุณมาก'),
//                                           ],
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//
//
//                                   ],
//
//                                 ),
//                               ),
//                             ),
//
//                             SizedBox(height: 15),
//                             Container(
//                               color: Colors.yellow,
//                               child: Center(
//                                 child: Text(
//                                   //   'หัวข้อเรื่อง แนะนำ',
//                                   'มีอะไรใหม่',
//                                   style: TextStyle(
//                                     fontFamily: 'Athiti',
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     //color: Colors.indigo,
//                                     // color: Theme.of(context).primaryColor,
//                                     color: themeForGreetingDialog.primaryColor,
//                                   ),
//                                   textAlign: TextAlign
//                                       .center, // Align the text within the Text widget
//                                 ),
//                               ),
//                             ),
//                             // SizedBox(height: 5),
//                             // const Text(
//                             //   '\u2764️ ฝึกจับเวลาชุดเต็ม (3 ช.ม.) ชุดที่ 5',
//                             //   style: TextStyle(
//                             //     //        fontFamily: 'Athiti',
//                             //     fontSize: 16,
//                             //     color: Colors.indigo,
//                             //     // color: Theme.of(context).primaryColor,
//                             //   ),
//                             //   textAlign: TextAlign.left,
//                             // ),
//
//                             const Text(
//                               '\u2764️ UPDATE!! ข้อสอบเสมือนจริง เม.ย. 2568 เรื่อง อนุกรม\n ',
//                               style: TextStyle(
//                                 //        fontFamily: 'Athiti',
//                                 fontSize: 16,
//                                 color: Colors.indigo,
//                                 //color: Theme.of(context).primaryColor,
//                               ),
//                               textAlign: TextAlign.left,
//                             ),
//                             // end of const Text(
//
//
//                             // const Text(
//                             //   '\u2764️ UPDATE!! \u2600 ปรับปรุงคำอธิบายอนุกรม \u2600 เพิ่มสีปากกากระดาษทด  \u2600 แก้ปัญหาบางหน้าจอดำ บน Samsung Galaxy  \u2600 แก้ไขคำผิด และอื่น ๆ ',
//                             //   style: TextStyle(
//                             //     //        fontFamily: 'Athiti',
//                             //     fontSize: 16,
//                             //     color: Colors.indigo,
//                             //     //color: Theme.of(context).primaryColor,
//                             //   ),
//                             //   textAlign: TextAlign.left,
//                             // ),
//                             // end of const Text(
//
//
//                             // SizedBox(height: 10),
//                             // Container(
//                             //   color: Colors.yellow,
//                             //   child: Center(
//                             //     child: Text(
//                             //       'รุ่นนี้ มีอะไรใหม่!!!',
//                             //       style: TextStyle(
//                             //         fontFamily: 'Athiti',
//                             //         fontSize: 16,
//                             //         fontWeight: FontWeight.bold,
//                             //         //color: Colors.indigo,
//                             //         // color: Theme.of(context).primaryColor,
//                             //         color: themeForGreetingDialog.primaryColor,
//                             //       ),
//                             //       textAlign: TextAlign
//                             //           .center, // Align the text within the Text widget
//                             //     ),
//                             //   ),
//                             // ),
//                             // const Text("\u2022 เพิ่มแบบฝึกชุดเต็ม ชุดที่ 4 และ\n\u2022 ปรับปรุงคำอธิบายและเพิ่มข้อสอบเสมือนจริง",
//                             //   style: TextStyle(
//                             //   //        fontFamily: 'Athiti',
//                             //   fontSize: 14,
//                             //   color: Colors.indigo,
//                             //   //color: Theme.of(context).primaryColor,
//                             // ),
//                             // textAlign: TextAlign.left,
//                             // ),
//                           ],
//
//                         ),
//                       ),
//
//                       actions: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 //   _saveCurrentTime(); // Save the current time when tapped
//                                 //   Navigator.of(context).pop();
//                                 // },
//                                 Navigator.of(context)
//                                     .pop(); // Remove the current dialog
//
//                                 if (isVoteFiveStarsAlready) {
//                                   _dont_show_welcome_dialog_anymore();
//                                 } else {
//                                   _saveCurrentTime(); // Save the current time when tapped
//                                 }
//                               },
//                               child: RichText(
//                                 text: TextSpan(
//                                   //text:   'ไม่ต้องแสดงอีก 5 วัน',
//                                   text: isVoteFiveStarsAlready
//                                       ? "ไม่ต้องแสดงอีกตลอดไป"
//                                       : "ไม่ต้องแสดงอีก 5 วัน",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     // Keep the size for the rest of the text
//                                     color: Colors.indigo,
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                 ),
//                                 textAlign: TextAlign.left,
//                               ),
//                             ),
//
//                             ElevatedButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text('รับทราบ'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//           // Set _isDialogShown to true after displaying the dialog
//           _isDialogShown = true;
//         });
//       } // end of  if((!_isDialogShown && _isThereCurrentDialogShowing(context) && isDialogHidingDay
//
//     }  // end of noMore
//
//   }
//
//   void showDialog_work_in_progress(BuildContext context) {
//     if (!_isDialogShown && _isThereCurrentDialogShowing(context)) {
//       // ไม่แสดง dialog ซ้ำ ถ้ากำลังแสดงอยู่แล้ว
//       // Display your dialog here
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               //  title: Text('Dialog Title'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Image.asset(
//                       'assets/data/images/work_in_progress.png',
//                       // Adjust the path as needed
//                       height: 150, // Adjust the height as needed
//                     ),
//                     SizedBox(height: 16),
//                     const Text('ช่วงนี้ ผมปิดชั่วคราวเพื่อปรับปรุง \n'
//                         'แต่ยังมีการอัพเดทข้อมูลอยู่\n\n'
//                         'ถ้าท่านได้ซื้อแล้ว ยังใช้รุ่นเต็มได้เหมือนเดิม\n\n'
//                         'ผู้ใช้รายใหม่จะไม่เห็นแอพนี้ บน Play Store\n\n '
//                         'ถ้าท่านลบแอพนี้ และต้องการติดตั้งใหม่ ต้องเข้าทางบัญชี Play Store ของท่าน '
//                         'และดูแอพที่ไม่ได้ติดตั้ง\n\n'
//                         'ถ้าต้องการซื้อรุ่นเต็ม ก็ยังทำได้เหมือนเดิม\n\n'
//                         'ถ้ายังไม่ซื้อแต่ต้องการใช้รุ่นเต็ม ให้ส่งเมลถึงผมทางเมนู 3 จุด '
//                         'เพื่อสมัครเข้าร่วมทดสอบแอพนี้'),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('รับทราบ'),
//                 ),
//               ],
//             );
//           },
//         );
//         // Set _isDialogShown to true after displaying the dialog
//         _isDialogShown = true;
//       });
//     }
//   }
//
//   // Future<void> _loadPackageInfo() async {
//   //   final PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   //   setState(() {
//   //     appName = packageInfo.appName;
//   //     packageName = packageInfo.packageName;
//   //     version = packageInfo.version;
//   //     buildNumber = packageInfo.buildNumber;
//   //   });
//   // }
//
//   Future<void> _loadPackageInfo() async {
//     try {
//       final PackageInfo packageInfo = await PackageInfo.fromPlatform();
//       setState(() {
//         appName = packageInfo.appName;
//         packageName = packageInfo.packageName;
//         version = packageInfo.version;
//         buildNumber = packageInfo.buildNumber;
//         debugPrint("appName: $appName");
//         debugPrint("packageName: $packageName");
//         debugPrint("version: $version");
//         debugPrint("buildNumber: $buildNumber");
//       });
//     } catch (e) {
//       debugPrint('Error loading package info: $e');
//     }
//   }
//
//   void _doRandomNumber(){
// // สำหรับสุ่มให้แสดง ขอกำลังใจ ใน welcome dialog box ตอนเปิด
//     // คือ จะไม่แสดงทุกครั้ง แต่สุ่มเอา
//
//     // Create an instance of the Random class
//     Random random = Random();
//
//     // Generate a random integer between 1 (inclusive) and 3 (inclusive)
//     int randomNumber = random.nextInt(4) + 1;
//
// // เพิ่มโอกาสให้มากขึ้น เป็น 3 ใน 4
//     if(randomNumber == 1 || randomNumber == 2 || randomNumber == 4){
//       isShowRequestFiveStarBox = true;
//     }else{
//       isShowRequestFiveStarBox = false;
//     }
//     debugPrint('Random Number: $randomNumber');
//     debugPrint("isShowRequestFiveStarBox: $isShowRequestFiveStarBox");
//     setState(() {
//       isShowRequestFiveStarBox;
//     });
//   }
//   void _checkLastOpenTime() async {
//
//     // วันแรกที่เริ่มใช้งาน
//     // ************************  from chatGPT
//
//     int minutesDifferenceFirstUse = 0;
//     int daysDifferenceFirstUse = 0;
//
//     // Retrieve the stored time from SharedPreferences
//     int storedTime =  SharedPreferencesManager().getInt('timeOfFirstRun') ?? 0;
//
//     bool isVoteClicked =  SharedPreferencesManager().getBool('isVote_5_stars_Clicked') ?? false;
//
// // Create a DateTime object using the stored time and isUtc: true
//     DateTime firstTimeUse = DateTime.fromMillisecondsSinceEpoch(storedTime, isUtc: true);
//
//     // สำหรับให้แสดงข้อความ ขอโหวต 5 ดาว หลังจากเปิดใช้งานครั้งแรกแล้ว 7 วัน คือ ให้ลองใช้ก่อน แล้วจึงขอให้โหวต
//     // สำหรับทดสอบ กำหนดเป็นนาที จะได้ไม่ต้องรอเป็นวัน
// // Calculate the difference in minutes using UTC time
//     //คิดเป็นนาที
//     minutesDifferenceFirstUse = DateTime.now().toUtc().difference(firstTimeUse).inMinutes;
//     // bool shouldVoteFiveStar = minutesDifferenceFirstUse >= 2;
//
//     //คิดเป็นวัน
//     daysDifferenceFirstUse = DateTime.now().toUtc().difference(firstTimeUse).inDays;
//     bool shouldVoteFiveStar = daysDifferenceFirstUse >= 7;
//
//
//
// // หาเวลา ตอนคลิก ไม่ต้องแสดงอีก 5 วัน เพื่อจะได้ดูว่าครบ 5 วันหรือยัง
//     DateTime lastOpenTime =
//     DateTime.fromMillisecondsSinceEpoch(SharedPreferencesManager().getInt('dialogLastOpenTime') ?? 0);
//
//     // คิดเป็นนาที
//     int minutesDifference = DateTime.now().difference(lastOpenTime).inMinutes;
//     //  bool isHidingDaysPassed = minutesDifference >= 2;
//
//
//     // Calculate the difference in days
//     // คิดเป็นวัน
//     int daysDifference = DateTime.now().difference(lastOpenTime).inDays;
//     // Check if 5 days have passed since the last open
//     bool isHidingDaysPassed = daysDifference >= 5;
//
//
//
//     firstOpenApp = firstTimeUse;
//     shouldShowVoteFiveStar = shouldVoteFiveStar;
//     isVoteFiveStarsAlready = isVoteClicked;
//     isDialogHidingExpired = isHidingDaysPassed;
//
//     // สำหรับแสดง dialog
//     debugPrint("สำหรับแสดง dialog");
//     debugPrint("isHidingDaysPassed in _checkLastOpenTime: $isHidingDaysPassed");
//
//     // สำหรับแสดง ให้กดโหวต 5 ดาว
//     debugPrint("สำหรับแสดง ให้กดโหวต 5 ดาว");
//     debugPrint("storedTime: $storedTime");
//     debugPrint("DateTime.now (UTC): ${DateTime.now().toUtc()}");
//     debugPrint("firstTimeUse (UTC): $firstTimeUse");
//     debugPrint("for testing -- minutesDifferenceFirstUse: $minutesDifferenceFirstUse");
//     debugPrint("for testing -- daysDifferenceFirstUse: $daysDifferenceFirstUse");
//     debugPrint("shouldVoteFiveStar: $shouldVoteFiveStar");
//
//     debugPrint("isDialogHidingExpired before setState: $isDialogHidingExpired");
//     debugPrint("isVoteClicked: $isVoteClicked");
//     debugPrint("isVoteFiveStarsAlready: $isVoteFiveStarsAlready");
//
//     // จำไว้ว่า เวลาไปเอาข้อมูลที่ต้องรอด้วย async/await หรือ Future ถ้าจะเอามาปรับตัวแปร ก็ใช้การ setState
//
//     setState(() {
//       isDialogHidingExpired;
//       firstOpenApp;
//       shouldShowVoteFiveStar;
//       isVoteFiveStarsAlready;
//     });
//   }
//
//
//   void _dont_show_welcome_dialog_anymore() async {
//     await SharedPreferencesManager().setBool('noMoreShowWelcomeDialog', true);
//   }
//
//   void _saveCurrentTime() async {
//     //  SharedPreferences prefs = await SharedPreferences.getInstance();
//     await SharedPreferencesManager().setInt('dialogLastOpenTime', DateTime.now().millisecondsSinceEpoch);
//   }
//
//   void _setOptionNotShowDialog() async {
// //    SharedPreferences myPrefs = await SharedPreferences.getInstance();
//     await SharedPreferencesManager().setBool('isVote_5_stars_Clicked', true);
//   }
//
//   Future<void> _launchURL(String url) async {
//     Uri uri = Uri.parse(url);
//     bool launched = await launchUrl(uri);
//
//     if (!launched) {
//       throw 'Could not launch $url';
//     }
//   }
//
//   // ไม่ได้ เพราะ ถ้าลบหมดทุกครั้ง ข้อมูลความก้าวหน้าในวงกลม ก็จะหายไปด้วย จึงใช้ไม่ได้ ไม่ได้ใช้อันนี้
//   Future<void> populateOcscTjkTable({required List wholeList}) async {
//     final dbClient = await SqliteDB().db; // Assuming SqliteDB is your database class
//
//     // Check if the table is empty
//     final countResult = await dbClient!.rawQuery('SELECT COUNT(*) as count FROM OcscTjkTable');
//     final int rowCount = Sqflite.firstIntValue(countResult) ?? 0;
//     debugPrint("Table OcscTjkTable row count: $rowCount");
//
//     // If table is not empty, delete all existing data
//     if (rowCount > 0) {
//       await dbClient.rawDelete('DELETE FROM OcscTjkTable');
//       debugPrint("Deleted all existing rows from OcscTjkTable");
//     }
//
//     // Insert all items from wholeList
//     debugPrint("Entering populateOcscTjkTable: wholeList.length = ${wholeList.length}");
//     for (var i = 0; i < wholeList.length; i++) {
//       await dbClient.rawInsert(
//         'INSERT INTO "OcscTjkTable"(menu_name, file_name, progress_pic_name, dateCreated, isNew, exam_type, field_2, position, open_last, field_5) VALUES(?,?,?,?,?,?,?,?,?,?)',
//         [
//           wholeList[i][0], // menu_name
//           wholeList[i][1], // file_name
//           "p00.png",       // progress_pic_name
//           wholeList[i][2], // dateCreated
//           0,               // isNew (default to 0 for first use)
//           wholeList[i][3], // exam_type
//           0,               // field_2 (int)
//           wholeList[i][4], // position (text)
//           "top",           // open_last (text)
//           "reserved"       // field_5 (text)
//         ],
//       );
//     }
//     debugPrint("Finished populating OcscTjkTable with ${wholeList.length} rows");
//   }
//
//   // checkAndShowUpdateBadge(List<Map<String, dynamic>> myGSheetData) {
//   //   //
//   // }
//   Future<void> checkAndShowUpdateBadge(List<Map<String, dynamic>> gsheetData) async {
//     final PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     String localVersion = packageInfo.version;
//     debugPrint("version from package: $localVersion");
//
//     // 🔍 Find 'ocsc_curr_version_android' in GSheet data
//     String? remoteVersion;
//     for (var item in gsheetData) {
//       if (item['name'] == 'ocsc_curr_version_android') {
//         remoteVersion = item['description'];
//         break;
//       }
//     }
//
//     if (remoteVersion == null) {
//       debugPrint("No remote version found.");
//       return;
//     }
//
//     String cleanRemoteVersion = remoteVersion.split('+').first;
//     debugPrint("Remote version: $cleanRemoteVersion");
//     //
//     // if (_isNewerVersion(cleanRemoteVersion, localVersion)) {
//     //   FlutterAppBadger.updateBadgeCount(1); // 🔴 Show badge
//     // } else {
//     //   FlutterAppBadger.removeBadge(); // ✅ Remove badge if already shown
//     // }
//   }
//
//   // bool _isNewerVersion(String latest, String current) {
//   //   List<int> latestParts = latest.split('.').map(int.parse).toList();
//   //   List<int> currentParts = current.split('.').map(int.parse).toList();
//   //
//   //   for (int i = 0; i < latestParts.length; i++) {
//   //     if (i >= currentParts.length || latestParts[i] > currentParts[i]) return true;
//   //     if (latestParts[i] < currentParts[i]) return false;
//   //   }
//   //   return false;
//   // }
//
//   Future<void> checkVersion() async {
//     final packageInfo = await PackageInfo.fromPlatform();
//     final String local = packageInfo.version;
//     // final String remote = "3.4.50"; // Replace with GSheet version
//
//     // Get version from Sheets
//     String? remote;
//     String? version_ios_gsheets;
//     String? whats_new_android_gsheets;
//     String? whats_new_ios_gsheets;
//
//     // Iterate through the Google Sheets data
//     for (var record in myGSheetData) {
//       switch (record['name']) {
//         case 'ocsc_curr_version_android':
//           remote = record['description'];
//           break;
//         case 'ocsc_curr_version_ios':
//           version_ios_gsheets = record['description'];
//           break;
//         case 'whats_new_android':
//           whats_new_android_gsheets = record['description'];
//           break;
//         case 'whats_new_ios':
//           whats_new_ios_gsheets = record['description'];
//           break;
//       }
//     }
//     // for (var record in myGSheetData) {
//     //   if (record['name'] == 'ocsc_curr_version_android') {
//     //     remote = record['description'];
//     //     break;
//     //   }
//     // }
//
//     if (remote == null) {
//       debugPrint('No version found from Google Sheets.');
//       return;
//     }
//
//     String latest = remote.split('+').first;
//
//
//
//
//     debugPrint("current version from GSheets: $latest");
//     if (_isNewerVersion(latest, local)) {
//       setState(() {
//         _localVersion = local;  // for both Android and iOS
//
//       //  _remoteVersion = latest; // for Android
//       //  _remoteVersion_iOS = version_ios_gsheets!; // for Android
//
//         _remoteVersion = latest.contains('+') ? latest.split('+')[0] : latest;  // for Android  เอา build หลังเตรื่องหมาย + ออกไป (ถ้ามี)
//         _remoteVersion_iOS = version_ios_gsheets!.contains('+') ? version_ios_gsheets.split('+')[0] : version_ios_gsheets;
//
//         _whatsNew_Android = whats_new_android_gsheets!;
//         _whatsNew_iOS = whats_new_ios_gsheets!;
//         _showUpdateBanner = true;
//
//       });
//     }
//   }
//
//
//   bool _isNewerVersion(String latest, String current) {
//     List<int> latestParts = latest.split('.').map(int.parse).toList();
//     List<int> currentParts = current.split('.').map(int.parse).toList();
//
//     for (int i = 0; i < latestParts.length; i++) {
//       if (i >= currentParts.length || latestParts[i] > currentParts[i]) return true;
//       if (latestParts[i] < currentParts[i]) return false;
//     }
//     return false;
//   }
//
//
//   // for bottom bar notification for Update available
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       if (index == 1) {
//         context.read<BadgeNotifier>().updateBadgeStatus(false);
//       }
//     });
//   }
//
//   // for bottom bar notification for Update available
//   BottomNavigationBarItem _buildNavItem(IconData icon, String label, bool showDot) {
//     return BottomNavigationBarItem(
//       icon: Stack(
//         children: [
//           Icon(icon),
//           if (showDot)
//             Positioned(
//               right: 0,
//               top: 0,
//               child: Container(
//                 width: 10,
//                 height: 10,
//                 decoration: const BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//         ],
//       ),
//       label: label,
//     );
//   }
//
//
// } // end of class _MyHomePageState
//
// // void updatePositionInOcscTjkTable({fileName, required String position}) async {
// //   final dbClient = await SqliteDB().db;
// //   var res = await dbClient!.rawQuery('''
// //     UPDATE OcscTjkTable
// //     SET position = ?
// //     WHERE file_name = ?
// //     ''', ['$position', '$fileName']);
// // }
//
// void updatePositionInOcscTjkTable({required String fileName, required String position}) async {
//   final dbClient = await SqliteDB().db;
//   if (dbClient != null) {
//     try {
//       // Begin a transaction
//       await dbClient.transaction((txn) async {
//         // Perform the update within the transaction
//         var res = await txn.rawQuery('''
//           UPDATE OcscTjkTable
//           SET position = ?
//           WHERE file_name = ?
//         ''', ['$position', '$fileName']);
//       });
//     } catch (e) {
//       // Handle any errors that occur during the transaction
//       print("Error during transaction: $e");
//       // } finally {
//       //   // Ensure the database connection is closed only after the transaction
//       //   // Do not close the database connection during the transaction block
//       //   await dbClient.close();
//     }
//   }
// }
//
//
//
//
//
// Future retrieveDateFromSQflite({required String fileName}) async {
//   var dbClient = await SqliteDB().db; //
//   final res = (await dbClient!.rawQuery(
//       """ SELECT position, dateCreated, field_2 FROM OcscTjkTable WHERE file_name = '$fileName' """));
//
//   // final res = (await dbClient.rawQuery(
//   //     """ SELECT dateCreated FROM OcscTjkTable WHERE file_name = '1_ocsc_answer.xml' """));
//   var thisDate;
//   int dateFromSQL;
//   String pos;
//   int is_clicked_main;
//   String posAndDate;
//   if (res.length > 0) {
//     // มี error Bad state No elements ก็เลยต้องเพิ่มการตรวจสอบเข้ามา
//       debugPrint("mapxxx rest/first: ${res.first}");
//     thisDate = res.first;
//     dateFromSQL = thisDate["dateCreated"];
//     pos = thisDate["position"];
//     is_clicked_main = thisDate["field_2"];  // field_2 เก็บว่า เมนูนี้ คลิกแล้วหรือยัง สำหรัแใช้แสดงจุดแดง
//       debugPrint("isClicked_main in DB -- retrieveDateFromSQflite: $is_clicked_main");
//     posAndDate = pos + "aa" + dateFromSQL.toString() + "aa" + is_clicked_main.toString();
//   } else {
//      debugPrint("mapxxx - length <= 0: ${res.first}");
//     thisDate = 111111;
//     dateFromSQL = 111111;
//     pos = "00";
//     is_clicked_main = 0;
//     posAndDate = pos + "aa" + dateFromSQL.toString() + "aa" + is_clicked_main.toString();
//   }
// //dateFromSQL = thisDate["dateCreated"];
//   // debugPrint("dateFromSQL fileName: $fileName mapxxx: $dateFromSQL");
//   //return dateFromSQL;
//   return posAndDate;
//   // } // end of if(fileName.contains
// }
//
// // void checkIfNewMenu({required String fileName}) {}
//
// //void deleteMenuItemFromTableIfNotExist({List<String> fileListInMain}) {
// void deleteMenuItemFromTableIfNotExist({required List<String> menuListInMain}) {
//   // เอาข้อมูลจากฐานข้อมูล
//   // การใช้ then จาก https://medium.com/flutter-community/a-guide-to-using-futures-in-flutter-for-beginners-ebeddfbfb967
//   getDataFromOcscTjkTable().then((List<String> menuNameListFromTable) {
//     // เอาข้อมูลจากฐานข้อมูล
//     // การใช้ then จาก https://medium.com/flutter-community/a-guide-to-using-futures-in-flutter-for-beginners-ebeddfbfb967
//     // debugPrint("mapYYY: length of value ${fileNameListFromTable.length}");
//     var notFoundList = [];
//     for (var i = 0; i < menuNameListFromTable.length; i++) {
//       // debugPrint(
//       //     "file from ocscTable - menuNameListFromTable[i]: ${menuNameListFromTable[i]}");
//       if (!(menuListInMain.contains(menuNameListFromTable[i]))) {
//         notFoundList.add(menuNameListFromTable[i]);
//       }
//     }
//     debugPrint("mapYYY: notfound: $notFoundList");
//
//     if (notFoundList.isNotEmpty) {
//       deleteNonExistMenuFile(fileList: notFoundList);
//     }
//
//   }, onError: (error) {
//     debugPrint("deleteNonExistMenuFile error:  $error");
//   });
// }
//
// // void deleteNonExistMenuFile({required List fileList}) async {
// //   debugPrint(" === deleteNonExistMenuFile === ");
// //   debugPrint("num of record to be deleted - fileList: ${fileList.length}");
// //   var dbClient = await SqliteDB().db;
// //   for (var i = 0; i < fileList.length; i++) {
// //     debugPrint("not found to be deleted: ${fileList[i]}");
// //     var y = await dbClient!.rawDelete(
// //         'DELETE FROM OcscTjkTable WHERE menu_name = ?',
// //         [fileList[i]]); // ลบเมนู
// //     // var z = await dbClient
// //     //     .rawDelete('DELETE FROM itemTable WHERE file_name = ?', [fileList[i]]);  // ลบชื่อไฟล์
// //   }
// // }
//
//
// void deleteNonExistMenuFile({required List fileList}) async {
//   debugPrint(" === deleteNonExistMenuFile === ");
//   debugPrint("num of record to be deleted - fileList: ${fileList.length}");
//   var dbClient = await SqliteDB().db;
//
//   // Use a transaction to wrap the delete operations
//   try {
//     await dbClient!.transaction((txn) async {
//       for (var i = 0; i < fileList.length; i++) {
//         debugPrint("not found to be deleted: ${fileList[i]}");
//
//         var y = await txn.rawDelete(
//             'DELETE FROM OcscTjkTable WHERE menu_name = ?',
//             [fileList[i]]
//         );
//         debugPrint("Deleted $y records where menu_name = ${fileList[i]}");
//       }
//     });
//   } catch (e) {
//     debugPrint("Error deleting records: $e");
//   }
// }
//
// void testHowMuchTimeAMethodUsed() async {  // -- เรียกใช้ที่ initState
//   const Duration threshold = Duration(seconds: 2);
//   await measureExecutionTime(
//     //  method: fetchData, // Method to be measured-- ตรวจดูเวลา  เปลี่ยนชื่อ method ตามที่ต้องการัด
//     method: getDataFromOcscTjkTable, // Method to be measured-- ตรวจดูเวลา  เปลี่ยนชื่อ method ตามที่ต้องการัด
//     threshold: threshold,  // Threshold of 2 seconds
//   );
// }
//
//
// Future<T> measureExecutionTime<T>({
//   required Future<T> Function() method, // Generic method
//   required Duration threshold,          // Time limit to compare against
// }) async {
//   // Record start time
//   final DateTime startTime = DateTime.now();
//
//   // Execute the method and wait for its result
//   final T result = await method();
//
//   // Record end time
//   final DateTime endTime = DateTime.now();
//
//   // Calculate execution time
//   final Duration executionTime = endTime.difference(startTime);
//
//   // Check if execution time exceeds the threshold
//   if (executionTime > threshold) {
//     debugPrint(
//       'Warning: Method took too much time: ${executionTime.inMilliseconds} ms',
//     );
//   } else {
//     debugPrint(
//       'Method executed within time: ${executionTime.inMilliseconds} ms',
//     );
//   }
//
//   return result; // Return the result from the method
// }
//
//
//
// Future<List<String>> getDataFromOcscTjkTable() async {
//   final dbClient = await SqliteDB().db;
//   List<Map> results = await dbClient!.rawQuery('SELECT * FROM OcscTjkTable');
//   // List<String> fileNameFromOcscTjkTable = [];
//   List<String> menuNameFromOcscTjkTable = [];
//   results.forEach((result) {
//     //  fileNameFromOcscTjkTable.add(result['file_name']);
//     menuNameFromOcscTjkTable.add(result['menu_name']);
//   });
//   // debugPrint("mapYYY: fileNameFromOcscTjkTable: $fileNameFromOcscTjkTable");
//   return menuNameFromOcscTjkTable;
//   // return fileNameFromOcscTjkTable;
// }
// //
// // Future<List<String>> getFileNameFromOcscTjkTable() async {
// //   final dbClient = await SqliteDB().db;
// //   List<Map> results = await dbClient.rawQuery('SELECT * FROM OcscTjkTable');
// //   List<String> fileNameFromOcscTjkTable = [];
// //   //List<String> menuNameFromOcscTjkTable = [];
// //   results.forEach((result) {
// //       fileNameFromOcscTjkTable.add(result['file_name']);
// //    // menuNameFromOcscTjkTable.add(result['menu_name']);
// //   });
// //   // debugPrint("mapYYY: fileNameFromOcscTjkTable: $fileNameFromOcscTjkTable");
// //  // return menuNameFromOcscTjkTable;
// //    return fileNameFromOcscTjkTable;
// // }
//
// //void removeMenuItemFromDatabaseIfNotExist({List listName}) {}
//
// // checkAndUpdateOcscTjkTable(
// void addNewDataIfAny(
//     {required String menuName,
//       required String fileName,
//       required String createDate,
//       required int whatType,
//       required String position}) async {
//   // if (menuName.contains("pdf")) {
//   //   debugPrint("menuName pdf: $menuName");
//   // }
//   if (menuName.contains("ทดสอบ")) {
//     debugPrint("menu ก่อนเอาเข้าฐานข้อมูล: $menuName file: $fileName");
//   }
//
//   // if (fileName.contains("https")) {
//   //   debugPrint("fileName for youtube: $fileName");
//   // }
//   int thisDate = int.parse(createDate); // เปลี่ยน String เป็น int
//   // เพราะ ในฐานข้อมูล เป็นประเภท integer แต่วันที่ ที่ส่งเข้ามา เป็น String
//
//   final dbClient = await SqliteDB().db;
//   //ดูว่ามีไฟล์นี้ในฐานข้อมูลไหม ถ้าไม่มี แสดงว่า เพิ่มข้อสอบชุดนี้เข้ามาใหม่ ให้เอาเข้าฐานข้อมูลด้วย
//   var x = await dbClient!.rawQuery(
// //      'SELECT COUNT (*) from OcscTjkTable WHERE file_name = ?', ["$fileName"]);
//       'SELECT COUNT (*) from OcscTjkTable WHERE menu_name = ?',
//       ["$menuName"]); // เปลี่ยน เอาชื่อเมนูไปเทียบดีกว่า
//   int? countX = Sqflite.firstIntValue(x);
//   // if (fileName.contains("https")) {
//   //   debugPrint("fileName for youtube: $fileName พบหรือไม่: $countX");
//   // }
// //  debugPrint(" นับชื่อเมนู $menuName ว่ามีในตาราง Ocsc หรือไม่ เพื่อดูว่า เป็นไฟล์ใหม่หรือเปล่า  ถ้าเป็น 0 แสดงว่า ใหม่ countX: $countX");
//   if (countX == 0) {
//     debugPrint(
//         "xx all files If data countx == 0 ไฟล์ใหม่  '$menuName' '$fileName' $thisDate  ");
//     // เอาเข้าฐานข้อมูล
//
//     // debugPrint(
//     //     "xx all files If data:: menuName: $menuName, fileName: $fileName, createDate: createDate, whatType: $whatType ");
//     // var batch = dbClient.batch(); // แก้ปัญหา database locked  // not working
//     // batch.rawInsert(
//     //     'INSERT INTO "OcscTjkTable"(menu_name,file_name,progress_pic_name,dateCreated,isNew,exam_type,field_2,position,open_last,field_5) VALUES(?,?,?,?,?,?,?,?,?,?)',
//     //     [
//     //       menuName,
//     //       fileName,
//     //       'p00.png',
//     //       thisDate,
//     //       2, // isNew 2 คือ จะมีปุ่มแดง และคำว่า (ใหม่ทั้งชุด) ต่อท้ายชื่อในเมนูนี้
//     //       whatType,
//     //       0, // field_2
//     //       position,
//     //       '0',
//     //       'reserved' //เอาใช้แล้ว สำหรับเก็บจำนวนข้อของแต่ละไฟล์ เพื่อว่า
//     //       ถ้ามีข้อเพิ่ม จะได้มีจุดแดงในหน้าเมนู ว่ามีการเพิ่มใหม่
//     // ตอนแรกให้เป็น 0 ก่อน
//
//     //     ]);
//
//     await dbClient.transaction((txn) async {
//       var result = await txn.rawInsert(
//           'INSERT INTO "OcscTjkTable"(menu_name, file_name, progress_pic_name, dateCreated, isNew, exam_type, field_2, position, open_last, field_5) '
//               'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
//           [
//             menuName,
//             fileName,
//             'p00.png',
//             thisDate,
//             1,          // isNew = 1 (red dot)
//             whatType,
//             0,          // field_2
//             position,
//             '0',        // open_last
//             'reserved'  // field_5
//           ]
//       );
//       debugPrint("Insert result: $result");
//     });
//     //   debugPrint("xx all files If data result: $result");
//     //   return result;
//   } else {
//     // ถ้าเป็นไฟล์ที่มีอยู่แล้ว ตรวจเรื่อง position อาจจะมีเปลี่ยน ถ้ามี ปรับฐานข้อมูลด้วย
//   }
// }
//
// // void addToOcscTjkTable({required List wholeList}) async {
// //   final dbClient = await SqliteDB().db;
// //   // แถว ๆ นี้แหละ มันวนหลายรอบ เข้ามาใหม่ซิง ๆ ไม่เป็นไร แต่ ถ้าลบไฟล์ในมือถือ แล้วให้รันใหม่ จะวนหลายรอบ
// //   int res;
// //   debugPrint("enter addToOcscTjkTable: wholeList.length =  ${wholeList.length}");
// //   for (var i = 0; i < wholeList.length; i++) {
// //     res = await dbClient!.rawInsert(
// //         'INSERT INTO "OcscTjkTable"(menu_name,file_name,progress_pic_name,dateCreated,isNew,exam_type,field_2,position,open_last,field_5) VALUES(?,?,?,?,?,?,?,?,?,?)',
// //         [
// //           // (field id เป็น auto generated จึงไม่มี เพราะ ให้โปรแกรมใส่เอง
// //
// //           // wholeList[i][0] - ชื่อเมนู,  wholeList[i][1] - ชื่อไฟล์, wholeList[i][2] - วันที่,  wholeList[i][3] - ประเภท
// //           wholeList[i][0], // field: menu_name
// //           wholeList[i][1], // field: file_name
// //           "p00.png",  //  field: progress_pic_name
// //           wholeList[i][2],  // field: dateCreated
// //           0,  // field: isNew กำหนดให้เป็น 0 เลย เพราะ เป็นการเปิดใช้ครั้งแรก
// //           wholeList[i][3], // field: exam_type
// //           0, // field: field_2 (int)
// //           wholeList[i][4], // field: position (text)
// //           "top", // field: open_last (text)
// //           "reserved" // field: field_5 (text)
// //         ]);
// //   }
// //   //return res;
// // }
//
//
// void addToOcscTjkTable({required List wholeList}) async {
//   final dbClient = await SqliteDB().db;
//
//   // Start a transaction
//   await dbClient!.transaction((txn) async {
//     int res;
//     debugPrint("enter addToOcscTjkTable: wholeList.length =  ${wholeList.length}");
//
//     for (var i = 0; i < wholeList.length; i++) {
//       res = await txn.rawInsert(
//           'INSERT INTO "OcscTjkTable"(menu_name, file_name, progress_pic_name, dateCreated, isNew, exam_type, field_2, position, open_last, field_5) '
//               'VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
//           [
//             wholeList[i][0], // field: menu_name
//             wholeList[i][1], // field: file_name
//             "p00.png", // field: progress_pic_name
//             wholeList[i][2], // field: dateCreated
//             0, // field: isNew
//             wholeList[i][3], // field: exam_type
//             0, // field: field_2 (int)
//             wholeList[i][4], // field: position
//             "top", // field: open_last
//             "reserved" // field: field_5
//           ]
//       );
//     }
//   });
// }
//
//
// Future checkAndUpdateOcscTjkTable(
//     {required String menuName,
//       required String fileName,
//       required String createDate,
//       required int whatType,
//       required String position}) async {
//   int thisDate = int.parse(
//       createDate); // เปลี่ยน String เป็น int เพราะ ในฐานข้อมูล เป็นประเภท integer แต่วันที่ ที่ส่งเข้ามา เป็น String
//   final dbClient = await SqliteDB().db;
//   //ดูว่ามีไฟล์นี้ในฐานข้อมูลไหม ถ้าไม่มี แสดงว่า เพิ่มข้อสอบชุดนี้เข้ามาใหม่ ให้เอาเข้าฐานข้อมูลด้วย
//   var x = await dbClient!.rawQuery(
//       'SELECT COUNT (*) from OcscTjkTable WHERE file_name = ?', ["$fileName"]);
//   int? countX = Sqflite.firstIntValue(x);
//
//   if (countX == 0) {
//     // debugPrint(
//     //     "xx all files If data countx == 0 ไฟล์ใหม่  '$menuName' '$fileName' $thisDate  ");
//     // เอาเข้าฐานข้อมูล
//
//     // debugPrint(
//     //     "xx all files If data:: menuName: $menuName, fileName: $fileName, createDate:     , whatType: $whatType ");
//     var result = await dbClient!.rawInsert(
//         'INSERT INTO "OcscTjkTable"(menu_name,file_name,progress_pic_name,dateCreated,isNew,exam_type,field_2,position,open_last,field_5) VALUES(?,?,?,?,?,?,?,?,?,?)',
//         [
//           menuName,
//           fileName,
//           'p00.png',
//           thisDate,
//           0,
//           whatType,
//           0,
//           'reserved',
//           '0',
//           'reserved'
//         ]);
//     //  debugPrint("xx all files If data result: $result");
//     return result;
//   }
// }
//
// // new screen page One
// class _PageOne extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('หลักสูตรการสอบ ก.พ. ภาค ก.'),
//       ),
//       body: Center(
//         child: Text(
//           'หน้า 1',
//         ),
//       ),
//     );
//   }
// }
//
// Future navigateToP1(context) async {
//   Navigator.push(context, MaterialPageRoute(builder: (context) => _PageOne()));
//   //Navigator.push(context, MaterialPageRoute(builder: (context) => mainMenu()));
// }
//
// void createHashTableIfNotExist() async {
//   var dbClient = await SqliteDB().db;
//   await dbClient!.execute("""
//       CREATE TABLE IF NOT EXISTS hashTable(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT,
//         str_value TEXT,
//         UNIQUE (name) ON CONFLICT REPLACE
//       )""");
//   await dbClient!.rawInsert(
//       'INSERT INTO hashTable (name, str_value) VALUES("appMode", "light")'); // กำหนดค่าเริ่มต้นไว้เลย
//   // return res;
// }
//
// Future createOcscTjkTableIfNotExist() async {
//   var dbClient = await SqliteDB().db;
//   var res = await dbClient!.execute("""
//       CREATE TABLE IF NOT EXISTS OcscTjkTable(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         menu_name TEXT,
//         file_name TEXT,
//         progress_pic_name TEXT,
//         dateCreated INTEGER,
//         isNew INTEGER,
//         exam_type INTEGER,
//         field_2 INTEGER,
//         position TEXT,
//         open_last TEXT DEFAULT "top",
//         field_5 TEXT,
//         UNIQUE (menu_name, file_name)  ON CONFLICT REPLACE
//       )""");
// }
//
// Future<bool> getBooleanValue(String key) async {
//   bool _isFirstRun = false;
//   bool firstRun = SharedPreferencesManager().getBool(key);
//   if(firstRun==false){  // ถ้าใน sharePref ไม่มี หรือ มีแต่เป็น false แสดงว่า เป็นการใช้งานครั้งแกชรก
//     _isFirstRun = true;
//   }else{
//     _isFirstRun = false;
//   }
//
//   debugPrint(
//       "the value of _isFirstRun from getBooleanValue function in Main.dart : $_isFirstRun");
//
//   return _isFirstRun;
// }
//
//
// Future setDefaultValueForWelcomDialog() async {
//
//   debugPrint("inside setDefaultValueForWelcomDialog");
//
//
//   // Writing and Reading from any class
//   await SharedPreferencesManager().setIntIfNotExists('timeOfFirstRun', DateTime.now().toUtc().millisecondsSinceEpoch);
//   int storedTime = SharedPreferencesManager().getInt('timeOfFirstRun');
//   debugPrint("storedTime from main>sharePrefManager: $storedTime");
//
//   await SharedPreferencesManager().setBoolIfNotExists('isVote_5_stars_Clicked', false);
//   await SharedPreferencesManager().setBoolIfNotExists('noMoreShowWelcomeDialog', false);
//
//   bool isVote_5_stars_Clicked = SharedPreferencesManager().getBool('isVote_5_stars_Clicked');
//   debugPrint("isVote_5_stars_Clicked from main>sharePrefManager: $isVote_5_stars_Clicked");
//
// } // end of Future setDefaultValueForWelcomDialog()
//
//
//
//
// Future createItemTableIfNotExist() async {
//   var dbClient = await SqliteDB().db;
//   var res = await dbClient!.execute("""
//       CREATE TABLE IF NOT EXISTS itemTable(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         file_name TEXT,
//         item_id TEXT,
//         item_date TEXT,
//         isClicked TEXT DEFAULT "false",
//         isNew TEXT,
//         UNIQUE (item_id) ON CONFLICT REPLACE
//       )""");
//   return res;
// }
//
// Future<dynamic> checkWebsiteAvailability({required String url}) async {
//   String isWebsiteAvailable;
//   try {
//     final response = await HttpClient().getUrl(Uri.parse(url)).then((request) => request.close());
//     if (response.statusCode == 200) {
//       isWebsiteAvailable = "yes";
//       debugPrint('statusCode: 200 -- Website is available.');
//       // Do something if the website is available
//     } else {
//       isWebsiteAvailable = "no";
//       debugPrint('statusCode is not equal to 200 -- Website is down.');
//       // Set a variable to something if the website is down
//     }
//   } on SocketException {
//     isWebsiteAvailable = "no";
//     debugPrint('SocketException: Website is down.');
//     // Set a variable to something if the website is down
//   } on HttpException {
//     isWebsiteAvailable = "no";
//     debugPrint('HttpException: Website is down.');
//     // Set a variable to something if the website is down
//   }
//   return isWebsiteAvailable;
// }
//
//
// //
// //
// // Future<dynamic> requestGET({required String url}) async {
// //   try {
// //     final response = await http.get(Uri.parse(url));
// //     switch (response.statusCode) {
// //       case 200:
// //       case 201:
// //         final result = jsonDecode(response.body);
// //         final jsonResponse = {'success': true, 'response': result};
// //         return jsonResponse;
// //       case 400:
// //         final result = jsonDecode(response.body);
// //         final jsonResponse = {'success': false, 'response': result};
// //         return jsonResponse;
// //       case 401:
// //         final jsonResponse = {
// //           'success': false,
// //           'response': ConstantUtil.UNAUTHORIZED
// //         };
// //         return jsonResponse;
// //       case 500:
// //       case 501:
// //       case 502:
// //         final jsonResponse = {
// //           'success': false,
// //           'response': ConstantUtil.SOMETHING_WRONG
// //         };
// //         return jsonResponse;
// //       default:
// //         final jsonResponse = {
// //           'success': false,
// //           'response': ConstantUtil.SOMETHING_WRONG
// //         };
// //         return jsonResponse;
// //     }
// //   } on SocketException {
// //     final jsonResponse = {
// //       'success': false,
// //       'response': ConstantUtil.NO_INTERNET
// //     };
// //     return jsonResponse;
// //   } on FormatException {
// //     final jsonResponse = {
// //       'success': false,
// //       'response': ConstantUtil.BAD_RESPONSE
// //     };
// //     return jsonResponse;
// //   } on HttpException {
// //     final jsonResponse = {
// //       'success': false,
// //       'response': ConstantUtil.SOMETHING_WRONG  //Server not responding
// //     };
// //     return jsonResponse;
// //   }
// // }
// //
//
// Future insertExamFileData({required List listName}) async {
//   // debugPrint("listName: $listName");
//   int? res;
//   for (var i = 0; i < listName.length; i++) {
//     //   debugPrint("listName: $i length: ${listName.length} $listName ");
//     // Add to table
//     final dbClient = await SqliteDB().db;
//     // final res = await dbClient.rawQuery(""" SELECT * FROM ExamProgress; """);
//     // return res;
//
//     res = await dbClient!.rawInsert(
//         'INSERT INTO "OcscTjkTable"(menu_name,file_name,progress_pic_name,dateCreated,isNew,exam_type,field_2,position,open_last,field_5) VALUES(?,?,?,?,?,?,?,?,?,?)',
//         [
//           // listName[i][0] - ชื่อเมนู,  listName[i][1] - ชื่อไฟล์, listName[i][2] - วันที่,  listName[i][3] - ประเภท
//           listName[i][0],
//           // field: menu_name   (field id เป็น auto generated จึงไม่มี เพราะ ให้โปรแกรมใส่เอง
//           listName[i][1],
//           // field: file_name
//           "p00.png",
//           //  field: progress_pic_name
//           listName[i][2],
//           // field: dateCreated
//           0,
//           // field: isNew
//           listName[i][3],
//           // field: exam_type
//           0,
//           // field: field_2 (int)
//           "reserved",
//           // field: position (text)
//           "tbl_q1",
//           // field: open_last (text)
//           "reserved"
//           // field: field_5 (text)
//         ]);
//   }
//   return res;
// }
//
// class ConstantUtil {  // สำหรับเรียกใช้ตอน เชคสถานะของ pastebin.com
//   static const String UNAUTHORIZED = "Unauthorized";
//   static const String SOMETHING_WRONG = "Something went wrong";
//   static const String NO_INTERNET = "No internet connection";
//   static const String BAD_RESPONSE = "Bad response";
// }
//
// class SharedPrefs {
//   static late SharedPreferences _sharedPrefs;
//
//   factory SharedPrefs() => SharedPrefs._internal();
//
//   SharedPrefs._internal();
//
//   Future<void> init() async {
//     _sharedPrefs ??= await SharedPreferences.getInstance();
//   }
//
//   String get username => _sharedPrefs.getString(keyUsername) ?? "";
//
//   set username(String value) {
//     _sharedPrefs.setString(keyUsername, value);
//   }
// }
//
// // constants/strings.dart
// const String keyUsername = "key_username";
//
// // บังคับให้พิมพ์ข้อมูลทั้งหมด โดยไม่มีการตัด เพราะ flutter จะตัดข้อมูล ถ้ายาวมากๆ เช่น ใน list มีสมาชิกสัก 500 ก็จะพิมพ์ให้ดูเพียง จำนวนหนึ่งเท่านั้น ไม่พิมพ์ทั้งหมด
// void debugPrintWrapped(String text) {
//   final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
//   pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
// }
//
//
// Future<int> getInstallDate() async {  // วันติดตั้งแอป กะจะใช้กับ isNew
//   final dir = await getApplicationSupportDirectory();
//   final stat = await dir.stat();
//   //return stat.changed; // Returns the creation date
//   // return stat.changed.millisecondsSinceEpoch; // Convert to epoch timestamp
//   return (stat.changed.millisecondsSinceEpoch ~/ 1000); // Convert to seconds
// }
//
//
//
//
//
// class Data extends ChangeNotifier {
//   // สำหรับ รับค่ามาจาก JavaScript แล้วส่งต่อ เช่น ส่งไป Willpopscope เพื่อ เมื่อคลิกแล้วส่งข้อมูลไปหน้าเมนู สำหรับแสดงว่า ทำไปมากน้อย กี่ข้อ
//   String data = "112233";
//
//   void changeString(String newString) {
//     data = newString;
//     debugPrint("newString from JS in Data class to notifyListeners: $newString");
//     notifyListeners();
//   }
// }
