// purchases_flutter 5.0.0
import 'package:purchases_flutter/purchases_flutter.dart';

class StoreConfig {
  final Store store;
  final String apiKey;
  static StoreConfig? _instance;

  factory StoreConfig({required Store store, required String apiKey}) {
    _instance ??= StoreConfig._internal(store, apiKey);
    return _instance!;
  }

  StoreConfig._internal(this.store, this.apiKey);

  static StoreConfig get instance {
    return _instance!;
  }

  static bool isForAppleStore() => instance.store == Store.appStore;

  static bool isForGooglePlay() => instance.store == Store.playStore;

  static bool isForAmazonAppstore() => instance.store == Store.amazon;
}



// import 'package:flutter/foundation.dart';
//
// enum Store { appleStore, googlePlay, amazonAppstore }
//
// class StoreConfig {
//   final Store store;
//   final String apiKey;
//  static StoreConfig? _instance;
//
//   factory StoreConfig({required Store store, required String apiKey}) {
//     _instance ??= StoreConfig._internal(store, apiKey);
//     return _instance!;
//   }
//
//   StoreConfig._internal(this.store, this.apiKey);
//
//   static StoreConfig get instance {
//     print("isForGooglePlay(): ${isForGooglePlay()}");
//     return _instance!;
//   }
//
//   static bool isForAppleStore() => _instance?.store == Store.appleStore;
//   static bool isForGooglePlay() => _instance?.store == Store.googlePlay;
//   static bool isForAmazonAppstore() => _instance?.store == Store.amazonAppstore;
// }
