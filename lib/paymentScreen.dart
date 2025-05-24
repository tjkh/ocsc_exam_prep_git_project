// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart' as inApp;
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// // import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:provider/provider.dart';
// import 'ProviderModel.dart';

// revenueCat
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ocsc_exam_prep/src/constant.dart';
import 'package:ocsc_exam_prep/src/model/singletons_data.dart';
import 'package:ocsc_exam_prep/src/model/styles.dart';
import 'package:ocsc_exam_prep/theme.dart';
import 'ProviderModel.dart';

class PaymentScreen extends StatefulWidget {
  final bool
  isDarkMde; // สำหรับรับค่าว่า อยู่ในโหมดมืดหรือเปล่า จาก itemPageView
  final bool isBuy;

  const PaymentScreen({required Key key, required this.isDarkMde, required this.isBuy}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
 // late ProviderModel _appProvider;

  @override
  void initState() {
    final provider = Provider.of<ProviderModel>(context, listen: false);
  //  _appProvider = provider;
  //  initPlatformState(provider);
    provider.initPlatformState();
    super.initState();
  }

  // initPlatformState(provider) async {
  //   await provider.initPlatformState();
  // }

  // @override
  // void dispose() {
  //   if (Platform.isIOS) {
  //     var iosPlatformAddition = _appProvider.inAppPurchase
  //         .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
  //     iosPlatformAddition.setDelegate(null);
  //   }
  //   _appProvider.subscription.cancel();
  //   super.dispose();
  // }

  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderModel>(context, listen: false);
    Offering? offering = provider.offering;
    var myProductList = offering?.availablePackages;

    print("removeAds - offering in paymentScreen: $offering");
    bool isBought = provider.removeAds;
    // bool isBought = true;
    print("isBought (provider.removeAds) in paymentScreen: $isBought");
    bool isDark = widget.isDarkMde;

    // return Center(
    //   child: Text("removeAds - offering in paymentScreen: $offering"),
    // );
    return Theme(  // ตั้งให้ใช้ darkMode ตลอด เพราะมีพื้นสีดำ
      data: ThemeData.dark().copyWith( // Assuming your dark theme should be used
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white60),
          actionsIconTheme: IconThemeData(color: Colors.amber),
          centerTitle: false,
          elevation: 15,
          titleTextStyle: TextStyle(
            color: Colors.lightBlueAccent,
            fontFamily: 'Athiti',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: Scaffold(  // เพื่อว่า จะได้มีลูกศรกลับไปหน้าก่อนหน้า ไม่งั้นหาทางกลับไม่เจ
        // คือ ถ้าไม่ซื้อก็กลับได้ ไม่ใช่หาทางกลับยาก
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('เตรียมสอบ ก.พ. ภาค ก.'),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Wrap(
              children: <Widget>[
                Container(
                  height: 70.0,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                   // color: Colors.cyan,
                    //color: Theme.of(context).primaryColorDark,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
                  child: const Center(
                      child: Text('✨ ยินดีต้อนรับ',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 40))),
                ),
                const Padding(
                  padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
                  child: SizedBox(
                    child: Text(
                      'แตะที่ป้ายราคา เพื่อซื้อ',
                      style: kDescriptionTextStyle,
                    ),
                    width: double.infinity,
                  ),
                ),
                Container(
                  // สำหรับเป็นกรอบสี่เหลี่ยม ล้อมรอบชื่อ สอบ กพ และ ราคา
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ListView.builder(
                    itemCount: offering?.availablePackages.length,
                    itemBuilder: (BuildContext context, int index) {
                      var myProductList = offering?.availablePackages;
                      return Card(
                        color: Colors.black,
                        // color: Theme.of(context).primaryColorDark,
                        child: ListTile(
                          onTap: () async {
                            try {
                              CustomerInfo customerInfo =
                              await Purchases.purchasePackage(
                                  myProductList![index]);
                              appData.entitlementIsActive = customerInfo
                                  .entitlements.all[entitlementID]!.isActive;
                            } catch (e) {
                              print(e);
                            }
                            setState(() {});
                            // Navigator.pop(context);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          title: Text(
                            myProductList ![index].storeProduct.title,
                            style: kTitleTextStyle,
                          ),
                          subtitle: Text(
                            myProductList![index].storeProduct.description,
                            style: kDescriptionTextStyle.copyWith(
                                fontSize: kFontSizeSuperSmall),
                          ),
                          // trailing: Text(
                          //     myProductList[index].storeProduct.priceString,
                          //     style: kTitleTextStyle),
                          trailing:
                          !isBought // บางทีก็เป็น null ต้องเชคอีกที OK ไปเอาจาก RevCat
                              ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: new BoxDecoration(
                                borderRadius:
                                new BorderRadius.circular(6.0),
                                color: Colors.green),
                            child: Text(
                                myProductList![index]
                                    .storeProduct
                                    .priceString,
                                style: kTitleTextStyle),
                          )
                              : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: new BoxDecoration(
                                borderRadius:
                                new BorderRadius.circular(16.0),
                                color: Colors.green),
                            child: Text(
                              '  ✔  ',
                              style: kTitleTextStyle,
                            ),
                          ),
                        ),
                      );
                    },
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: 32, bottom: 16, left: 16.0, right: 16.0),
                    child: SizedBox(
                      child: Center(
                        child: Container(
                          child: TextButton(
                            child: Text("กู้คืนการซื้อ \(restore purchase\)"),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              restorePurchase();
                              goMainMenu();
                            },
                            // onPressed: () => [restorePurchase()],
                            // onPressed: () => [restorePurchase(), goMainMenu()],
                            // onPressed: () async {
                            //   try {
                            //     await Purchases.restorePurchases();
                            //     // ... check restored purchaserInfo to see if entitlement is now active
                            //   } on PlatformException catch (e) {
                            //     print("Error restoring purchases");
                            //   }
                            //   },
                          ),
                        ),
                      ),
                    )),
                Padding(
                  padding:
                  EdgeInsets.only(top: 25, bottom: 16, left: 16.0, right: 16.0),
                  child: SizedBox(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "สามารถสแกนจ่าย จากแอพธนาคาร บนมือถือ (โดยเลือกวิธีจ่ายแบบ PromptPay) หรือ จ่ายผ่าน ซิมโทรศัพท์ (AIS DTAC TrueMoveH) ShopeePay TrueMoney Wallet LINE Pay บัตรเดบิต บัตรเครดิต Google Play gift cards และ PayPal เป็นต้น",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.white54,
                                fontSize: 15),
                          ),
                          const Divider(),
                          Text(
                            "ซื้อครั้งเดียว ใช้ได้ตลอดไปทุกอย่างบนระบบปฏิบัติการเดียวกัน ใช้ได้ทั้งบนมือถือและ tablet",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.white54,
                                fontSize: 15),
                          ),
                          const Divider(),
                          Text(
                            "ถ้าเปลี่ยนมือถือใหม่ ให้กดที่ปุ่ม กู้คืนการซื้อ เพื่อใช้รุ่นเต็ม (มือถือใหม่ ต้องเป็นระบบเดิม คือข้ามระหว่าง Android-iPhone ไม่ได้ และต้องใช้ Account เดิมด้วย นะครับ)",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.white54,
                                fontSize: 15),
                          ),
                          const Divider(),
                          Text(
                            "ถ้าถอนโปรแกรมแล้วติดตั้งใหม่ ให้กดที่ปุ่ม กู้คืนการซื้อ เพื่อใช้รุ่นเต็มที่เคยซื้อแล้ว",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.white54,
                                fontSize: 15),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void restorePurchase() async {
    showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        }
    );
    try {
      await Purchases.restorePurchases();
      // ... check restored purchaserInfo to see if entitlement is now active
    // } on PlatformException catch (e) {
    //   print("Error restoring purchases");
    // }
    } on PlatformException catch (e){
      print("restore purchase error: ${e.message}");
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("ข้อผิดพลาด!!!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.red,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
              ),),
            content: Text("การกู้คืนการซื้อไม่สำเร็จ\nถ้าเคยซื้อแล้ว ให้ ส่งอีเมลแจ้งข้อผิดพลาด ทางเมนู 3 จุด",
              style: TextStyle(
                fontSize: 15, 
              ),),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("ตกลง "),
              ),
            ],
          );
        },
      );
    }
  } // end of  void restorePurchase() async

  void goMainMenu() async {
    Navigator.of(context).popUntil((route) => route.isFirst);

    //await Navigator.pop(context);
    // Navigator.of(context)
    //     .pop(MaterialPageRoute(builder: (context) => MyHomePage()));
  } // end of void goMainMenu

} // end of class
//
// @override
// Widget build(BuildContext context) {
//   final provider = Provider.of<ProviderModel>(context);
//
//   List<Widget> stack = [];
//   print("provider.queryProductError xxx: ${provider.queryProductError}");
//   if (provider.queryProductError == null) {
//     stack.add(
//       ListView(
//         children: [
//           _buildConnectionCheckTile(provider),
//           _buildProductList(provider),
//         ],
//       ),
//     );
//   } else {
//     stack.add(Center(
//       child: Text(provider.queryProductError),
//     ));
//   }
//   if (provider.purchasePending) {
//     stack.add(
//       Stack(
//         children: [
//           Opacity(
//             opacity: 0.3,
//             child: const ModalBarrier(dismissible: false, color: Colors.grey),
//           ),
//           Center(
//             child: CircularProgressIndicator(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('เตรียมสอบ กพ. ภาค ก.'),
//     ),
//     body: Stack(
//       children: stack,
//     ),
//   );
// }
//
// Card _buildConnectionCheckTile(provider) {
//   if (provider.loading) {
//     return Card(child: ListTile(title: const Text('Trying to connect...')));
//   }
//   final Widget storeHeader = provider.notFoundIds.isNotEmpty
//       ? ListTile(
//           leading: Icon(Icons.block,
//               color: provider.isAvailable
//                   ? Colors.grey
//                   : ThemeData.light().errorColor),
//           title: Text('The store is unavailable'))
//       : ListTile(
//           leading: Icon(Icons.check, color: Colors.green),
//           title: Text('The store is available'),
//         );
//   final List<Widget> children = <Widget>[storeHeader];
//   print("provider.isAvailable xxx: ${provider.isAvailable}");
//   if (!provider.isAvailable) {
//     children.addAll([
//       Divider(),
//       ListTile(
//         title: Text('Not connected',
//             style: TextStyle(color: ThemeData.light().errorColor)),
//         subtitle: const Text(
//             'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
//       ),
//     ]);
//   }
//   return Card(child: Column(children: children));
// }
//
// Card _buildProductList(provider) {
//   if (provider.loading) {
//     return Card(
//         child: (ListTile(
//             leading: CircularProgressIndicator(),
//             title: Text('Fetching products...'))));
//   }
//   if (!provider.isAvailable) {
//     return Card();
//   }
//   final ListTile productHeader = ListTile(title: Text('Products for Sale'));
//   List<ListTile> productList = <ListTile>[];
//   if (provider.notFoundIds.isNotEmpty) {
//     productList.add(ListTile(
//       title: Text('Products not found',
//           style: TextStyle(color: ThemeData.light().errorColor)),
//     ));
//   }
//
//   // This loading previous purchases code is just a demo. Please do not use this as it is.
//   // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
//   // We recommend that you use your own server to verify the purchase data.
//   Map<String, inApp.PurchaseDetails> purchasesIn =
//       Map.fromEntries(purchases.map((inApp.PurchaseDetails purchase) {
//     if (purchase.pendingCompletePurchase) {
//       provider.inAppPurchase.completePurchase(purchase);
//     }
//     return MapEntry<String, inApp.PurchaseDetails>(purchase.productID, purchase);
//   }));
//   productList.addAll(products.map(
//     (inApp.ProductDetails productDetails) {
//       inApp.PurchaseDetails previousPurchase = purchasesIn[productDetails.id];
//       return ListTile(
//           title: Text(
//             productDetails.title,
//           ),
//           subtitle: Text(
//             productDetails.description,
//           ),
//           trailing: previousPurchase != null
//               ? IconButton(
//                   onPressed: () => provider.confirmPriceChange(context),
//                   icon: Icon(
//                     Icons.check,
//                     color: Colors.green,
//                     //color: Colors.red,
//                     size: 40,
//                   ))
//               : TextButton(
//                   child: Text(productDetails.id == kConsumableId &&
//                           provider.consumables.length > 0
//                       ? "Buy more\n${productDetails.price}"
//                       : productDetails.price),
//                   style: TextButton.styleFrom(
//                     backgroundColor: Colors.green[800],
//                     primary: Colors.white,
//                   ),
//                   onPressed: () {
//                     inApp.PurchaseParam purchaseParam;
//
//                     if (Platform.isAndroid) {
//                       // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
//                       // verify the latest status of you your subscription by using server side receipt validation
//                       // and update the UI accordingly. The subscription purchase status shown
//                       // inside the app may not be accurate.
//                       final oldSubscription = provider.getOldSubscription(
//                           productDetails, purchasesIn);
//
//                       purchaseParam = GooglePlayPurchaseParam(
//                           productDetails: productDetails,
//                           applicationUserName: null,
//                           changeSubscriptionParam: (oldSubscription != null)
//                               ? ChangeSubscriptionParam(
//                                   // oldPurchaseDetails: oldSubscription,
//                                   // prorationMode: ProrationMode
//                                   //     .immediateWithTimeProration,
//                                 )
//                               : null);
//                     } else {
//                       purchaseParam = inApp.PurchaseParam(
//                         productDetails: productDetails,
//                         applicationUserName: null,
//                       );
//                     }
//
//                     if (productDetails.id == kConsumableId) {
//                       print("isBoughtAlready, buy button pressed");
//                       provider.inAppPurchase.buyConsumable(
//                           purchaseParam: purchaseParam,
//                           autoConsume: kAutoConsume || Platform.isIOS);
//                     } else {
//                       provider.inAppPurchase
//                           .buyNonConsumable(purchaseParam: purchaseParam);
//                     }
//                   },
//                 ));
//     },
//   ));
//
//   return Card(
//       child:
//           Column(children: <Widget>[productHeader, Divider()] + productList));
// }
//}
