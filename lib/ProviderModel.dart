import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:in_app_purchase/in_app_purchase.dart';
//import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
// import 'package:in_app_purchase_ios/store_kit_wrappers.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
//import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:sqflite/sqflite.dart';
import 'consumable_store.dart';

import 'sqlite_db.dart';

// for revenueCat
import 'package:ocsc_exam_prep/src/constant.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ocsc_exam_prep/store_config.dart';

// revenueCat
bool _removeAds = false;
Offering? _offering;
// var _offering;
//
// bool get removeAds {
//   removeAds = _removeAds;
//   return removeAds;
// }
// // bool get removeAds => _removeAds;
// set removeAds(bool value) {
//   _removeAds = value;
// }

final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();

// -------- in-app 307 ---------
// List<PurchaseDetails> purchases = [];
// List<ProductDetails> products = [];
const bool kAutoConsume = true;
const String kConsumableId = '_kConsumableId';
//const String kConsumableId = 'exam_prep_tjk';
// const String kUpgradeId = 'non_consumable';
const String kUpgradeId = 'exam_prep_tjk';
const String kSilverSubscriptionId = 'silver_subscription';
const String kGoldSubscriptionId = 'gold_subscription';
const List<String> _kProductIds = <String>[
  // kConsumableId,
  kUpgradeId,
//  kSilverSubscriptionId,
  // kGoldSubscriptionId,
];

class ProviderModel with ChangeNotifier {
  // final InAppPurchase inAppPurchase = InAppPurchase.instance;
  // StreamSubscription<List<PurchaseDetails>> subscription;
  List<String> notFoundIds = [];
  List<String> consumables = [];
  bool isAvailable = false;
  bool purchasePending = false;
  bool loading = true;
  late String queryProductError;

  bool get removeAds => _removeAds;
  set removeAds(bool value) {
    _removeAds = value;
  }

  Offering? get offering => _offering;
  set offering(Offering? value) {
    _offering = value;
  }
// ถึงตรงนี้ ต่อไป เชค ว่าไปหน้า paymentScreen แล้วเป็นยังไง  --- OK

  // *****************  revnueCat



  Future<void> initPlatformState() async {
    print("removedAds inside initPlatformState ");
    // Enable debug logs before calling `configure`.
    await Purchases.setLogLevel(LogLevel.debug);
    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */




    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) { // update เป็น รุ่น 8  ของ Revenuecat
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
        ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
        ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
    }
    // if (StoreConfig.isForAmazonAppstore()) {
    //   configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
    //     ..appUserID = null
    //     ..observerMode = false;
    // } else {
    //   configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
    //     ..appUserID = null
    //     ..observerMode = false;
    //   print("PurchasesConfiguration(StoreConfig.instance.apiKey): ${PurchasesConfiguration(StoreConfig.instance.apiKey)}");
    // }



    // Check if purchase has already been configured
    bool purchasesConfigured = await Purchases.isConfigured;

    // If purchase has not been configured, then call _configureSDK
    if (!purchasesConfigured) {
      await Purchases.configure(configuration);
    }
    // appData.appUserID = await Purchases.appUserID;

    //print("removeAds -ProviderModel- appData.appUserID: ${appData.appUserID}");


    // ซื้อแล้วหรือยัง
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == true){  // ซื้อแล้ว
      _removeAds = true;
    }else{
      _removeAds = false;
      print ("_removeAds in ProviderModel: $_removeAds");
    }
//    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    // bool _isEntitled = customerInfo.entitlements.all['removeAds'].isActive;
    print("removeAds cust_info : $customerInfo");
    // print(
    //     "removeAds  -ProviderModel- cust entitlement: ${customerInfo.entitlements.all['removeAds'].isActive}");

// entitlementID คือ id ของ project นี้ ใน revenueCat
//     if (customerInfo.entitlements.all[entitlementID] != null &&
//         customerInfo.entitlements.all[entitlementID].isActive) {
//       // ซื้อแล้ว กำหนดให้ _removeAds เป็น true เพื่อจะได้ไม่แสดงปุ่มการซื้อ
//       // appData.entitlementIsActive = true;
//       _removeAds = true;
//       notifyListeners();
//       update_hashTable(product: kUpgradeId);
//       print(
//           "removeAds-(Yes) in ProviderModel after entitleMent is:  ${customerInfo.entitlements.all['removeAds'].isActive}");
    if (customerInfo.entitlements.all[entitlementID] != null) {
      print("removeAds entitleMent in ProviderModel is not null");
      if ( // แยกเชค เพื่อไม่ให้ isActive ไปเชค entitlement ถ้ายังไม่ซื้อ ไม่งั้นจะ error
      customerInfo.entitlements.all[entitlementID]!.isActive) {
        // ซื้อแล้ว กำหนดให้ _removeAds เป็น true เพื่อจะได้ไม่แสดงปุ่มการซื้อ
        _removeAds = true;
        print("_removeAds before notifyListeners in ProviderModel: $_removeAds");
        print("product: kUpgradeId: $kUpgradeId");
        
        update_hashTable(product: kUpgradeId);
        notifyListeners();
        print(
            "removeAds-(Yes SSS) in ProviderModel after entitleMent is:  ${customerInfo.entitlements.all['removeAds']!.isActive}");
      } else {
        // show message if entitlements not active
        print("entitlement error");
      }
    } else {
      print("removeAds entitleMent in ProviderModel is null");
      // ยังไม่ได้ซื้อ หาค่า offering เพื่อไปใช้ในหน้า paymenScreen
      // appData.entitlementIsActive = false; // กำหนดค่าใน singleton

      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException {
        print("No offering Platform Error");
        // await showDialog(
        //     context: context,
        //     builder: (BuildContext context) => ShowDialogToDismiss(
        //         title: "Error", content: e.message, buttonText: 'OK'));
      }
      print("removeAds-(No entitlement)  offerings: $offerings");

      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to your user
        print("removeAds offering error");
      } else {
        // current offering is available, show paywall
        _offering = offerings.current!;
        print("removeAds offering: $_offering");
        notifyListeners();
      }
    } // end of  if (customerInfo.entitlements.all[entitlementID] != null &&
  } // end of Future<void> initPlatformState() async

  // ********** end of  revnueCat

  Future<void> initInApp() async {
    // final Stream<List<PurchaseDetails>> purchaseUpdated =
    //     inAppPurchase.purchaseStream;
    // subscription = purchaseUpdated.listen((purchaseDetailsList) {
    //   _listenToPurchaseUpdated(purchaseDetailsList);
    // }, onDone: () {
    //   subscription.cancel();
    // }, onError: (error) {
    //   // handle error here.
    // });
    // await initStoreInfo();  // ยกเลิก inapp-purchase 307 ใช้ revenueCat แทน
    // await verifyPreviousPurchases(); // ยกเลิก inapp-purchase 307 ใช้ revenueCat แทน
  }

  // Future<void> inAppStream() async {
  //   final Stream<List<PurchaseDetails>> purchaseUpdated =
  //       inAppPurchase.purchaseStream;
  //   subscription = purchaseUpdated.listen((purchaseDetailsList) {}, onDone: () {
  //     subscription.cancel();
  //   }, onError: (error) {
  //     // handle error here.
  //   });
  // }

//   verifyPreviousPurchases() async {
//     print("==== =======verifyPreviousPurchases");
//  //   await inAppPurchase.restorePurchases();
//     await Future.delayed(const Duration(milliseconds: 100), () {
//       for (var pur in purchases) {
//         //       print("========= productID: ${pur.productID}");
//         if (pur.productID.contains('exam_prep_tjk')) {
//           //    removeAds = true;
//           // write to hashTable to remove buy button
//           update_hashTable(product: kUpgradeId);
//         }
//         if (pur.productID.contains('silver_subscription')) {
//           silverSubscription = true;
//         }
//
//         if (pur.productID.contains('gold_subscription')) {
//           goldSubscription = true;
//         }
//       }
// //      print("isBoughtAlready ======== productID removeAds:  $removeAds");
//       finishedLoad = true;
//     });
//
//     //  notifyListeners(); // try removing
//   }
//   //
  // bool _removeAds = false;
  // bool get removeAds => _removeAds;
  // set removeAds(bool value) {
  //   _removeAds = value;
  //   notifyListeners();
  // }

  bool _isFullVersion = false;
  bool get isFullVersion => _isFullVersion;
  set isFullVersion(bool value) {
    _isFullVersion = value;
    //   notifyListeners(); // try removing
  }

  bool _silverSubscription = false;
  bool get silverSubscription => _silverSubscription;
  set silverSubscription(bool value) {
    _silverSubscription = value;
    //   notifyListeners(); // try removing
  }

  bool _goldSubscription = false;
  bool get goldSubscription => _goldSubscription;
  set goldSubscription(bool value) {
    _goldSubscription = value;
    //  notifyListeners();  // try removing
  }

  bool _finishedLoad = false;
  bool get finishedLoad => _finishedLoad;
  set finishedLoad(bool value) {
    _finishedLoad = value;
    //   notifyListeners();  // try removing
  }

  // // Future<void> initStoreInfo() async {
  // //   final bool isAvailableStore = await inAppPurchase.isAvailable();
  // //   print("product available or not: $isAvailableStore");
  // //   if (!isAvailableStore) {
  // //     isAvailable = isAvailableStore;
  // //     products = [];
  // //     purchases = [];
  // //     notFoundIds = [];
  // //     consumables = [];
  // //     purchasePending = false;
  // //     loading = false;
  // //     return;
  // //   }
  //
  //   if (Platform.isIOS) {
  //     // in-app 3.0.7 -- ของใหม่
  //     final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
  //         inAppPurchase
  //             .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
  //     await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
  //     // in-app 1.0.9  --ของเก่า
  //     // var iosPlatformAddition =
  //     //     inAppPurchase.getPlatformAddition<InAppPurchaseIosPlatformAddition>();
  //     // await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
  //   }
  //
  //   ProductDetailsResponse productDetailResponse =
  //       await inAppPurchase.queryProductDetails(_kProductIds.toSet());
  //
  //   print("product found: ${productDetailResponse.productDetails}");
  //   print("product NOT found: ${productDetailResponse.notFoundIDs}");
  //
  //   if (productDetailResponse.error != null) {
  //     queryProductError = productDetailResponse.error.message;
  //     isAvailable = isAvailableStore;
  //     products = productDetailResponse.productDetails;
  //     purchases = [];
  //     notFoundIds = productDetailResponse.notFoundIDs;
  //     consumables = [];
  //     purchasePending = false;
  //     loading = false;
  //     return;
  //   }
  //
  //   if (productDetailResponse.productDetails.isEmpty) {
  //     queryProductError = null;
  //     isAvailable = isAvailableStore;
  //     products = productDetailResponse.productDetails;
  //     purchases = [];
  //     notFoundIds = productDetailResponse.notFoundIDs;
  //     consumables = [];
  //     purchasePending = false;
  //     loading = false;
  //     return;
  //   }
  //
  //   List<String> consumableProd = await ConsumableStore.load();
  //   isAvailable = isAvailableStore;
  //   products = productDetailResponse.productDetails;
  //   notFoundIds = productDetailResponse.notFoundIDs;
  //   consumables = consumableProd;
  //   purchasePending = false;
  //   loading = false;
  //   //  notifyListeners();  // try removing
  // }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumableProd = await ConsumableStore.load();
    consumables = consumableProd;
    //   notifyListeners();   // try removing
  }

  void showPendingUI() {
    purchasePending = true;
  }

//   void deliverProduct(PurchaseDetails purchaseDetails) async {
//     // IMPORTANT!! Always verify purchase details before delivering the product.
//     // ถ้าซื้อ exam_prep_tjk (แอพ เตรียมสอบ กพ)
//     if (purchaseDetails.productID == kConsumableId) {
//       // ปรับค่าใน ตาราง hashTable ว่าซื้อแล้ว จะได้เอาไปปรับ ไม่แสดงปุ่มซื้อ
//       print(
//           "isBoughtAlready in deliverProduct consumable: ${purchaseDetails.productID}");
//       update_hashTable(product: kConsumableId);
//       await ConsumableStore.save(purchaseDetails.purchaseID);
//       List<String> consumableProd = await ConsumableStore.load();
//       purchasePending = false;
//       consumables = consumableProd;
//     } else {
// //      print(
// //          "isBoughtAlready in deliverProduct NON- consumable: ${purchaseDetails.productID}");
//       purchases.add(purchaseDetails);
//       purchasePending = false;
//       update_hashTable(
//           product: purchaseDetails
//               .productID); // ไม่ต้อง update เพราะ เรียกจาก Google
//     }
//   }

// void handleError(IAPError error) {
//   purchasePending = false;
// }
//
// Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//   // IMPORTANT!! Always verify a purchase before delivering the product.
//   // For the purpose of an example, we directly return true.
//   return Future<bool>.value(true);
// }
//
// void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//   // handle invalid purchase here if  _verifyPurchase` failed.
// }
//
// void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//   purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//     print(
//         "isBoughtAlready, purchaseDetails.status: ${purchaseDetails.status}");
//     if (purchaseDetails.status == PurchaseStatus.pending) {
//       showPendingUI();
//     } else {
//       if (purchaseDetails.status == PurchaseStatus.error) {
//         handleError(purchaseDetails.error);
//       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//           purchaseDetails.status == PurchaseStatus.restored) {
//         bool valid = await _verifyPurchase(purchaseDetails);
//         if (valid) {
//           deliverProduct(purchaseDetails);
//         } else {
//           _handleInvalidPurchase(purchaseDetails);
//           return;
//         }
//       }
//       // if (Platform.isAndroid) {
//       //   if (!kAutoConsume && purchaseDetails.productID == kConsumableId) {
//       //     final InAppPurchaseAndroidPlatformAddition androidAddition =
//       //         inAppPurchase.getPlatformAddition<
//       //             InAppPurchaseAndroidPlatformAddition>();
//       //     await androidAddition.consumePurchase(purchaseDetails);
//       //   }
//       // }
//       if (purchaseDetails.pendingCompletePurchase) {
//         await inAppPurchase.completePurchase(purchaseDetails);
//         if (purchaseDetails.productID == 'consumable_product') {
//           print('================================You got coins');
//         }
//
//         verifyPreviousPurchases();
//       }
//     }
//   });
// }
// //
// // Future<void> confirmPriceChange(BuildContext context) async {
//   if (Platform.isAndroid) {
//     final InAppPurchaseAndroidPlatformAddition androidAddition = inAppPurchase
//         .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
//     var priceChangeConfirmationResult =
//         await androidAddition.launchPriceChangeConfirmationFlow(
//       sku: 'purchaseId',
//     );
//     if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Price change accepted'),
//       ));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           priceChangeConfirmationResult.debugMessage ??
//               "Price change failed with code ${priceChangeConfirmationResult.responseCode}",
//         ),
//       ));
//     }
//   }
//   if (Platform.isIOS) {
//     final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
//         inAppPurchase
//             .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//     await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
//     // var iapIosPlatformAddition =
//     //     inAppPurchase.getPlatformAddition<InAppPurchaseIosPlatformAddition>();
//     // await iapIosPlatformAddition.showPriceConsentIfNeeded();
//   }
// }

// GooglePlayPurchaseDetails getOldSubscription(
//     ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
//   GooglePlayPurchaseDetails oldSubscription;
//   if (productDetails.id == kSilverSubscriptionId &&
//       purchases[kGoldSubscriptionId] != null) {
//     oldSubscription =
//         purchases[kGoldSubscriptionId] as GooglePlayPurchaseDetails;
//   } else if (productDetails.id == kGoldSubscriptionId &&
//       purchases[kSilverSubscriptionId] != null) {
//     oldSubscription =
//         purchases[kSilverSubscriptionId] as GooglePlayPurchaseDetails;
//   }
//   return oldSubscription;
// }

//bool removeAds = false;
//
// void removeAdsFunc(newValue) {
//   removeAds = newValue;
//   notifyListeners();
// }

}

void update_hashTable({required String product}) async {
  print("enter update_hashTable function - providerModel");
  print("product bought: $product");
  // var dbClient = await SqliteDB().db;
  // await dbClient.rawInsert(
  //     'INSERT INTO hashTable (name, str_value) VALUES("sku", "true")'); // กำหนดค่าเริ่มต้นไว้เลย
  final dbClient = await SqliteDB().db;
  var count = Sqflite.firstIntValue(await dbClient!
      .rawQuery('SELECT COUNT (*) FROM hashTable WHERE name = "sku"'));
  // print("theme, column name: $thisName");
  print("count hashTbl: $count");
  if (count == 0) {
    print("x count xx: insert");
    await dbClient.rawQuery(
        'INSERT INTO hashTable (name, str_value) VALUES ("sku", "true")');
  } else {
    await dbClient
        .rawQuery('UPDATE hashTable SET str_value = "true" WHERE name = "sku"');
  }
}
//
// class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(
//       SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//     return true;
//   }
//
//   @override
//   bool shouldShowPriceConsent() {
//     return false;
//   }
// }
