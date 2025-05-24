import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static final SharedPreferencesManager _instance = SharedPreferencesManager._internal();

  factory SharedPreferencesManager() {
    return _instance;
  }

  SharedPreferencesManager._internal();

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Conditionally set int value in SharedPreferences if it doesn't exist
  Future<void> setIntIfNotExists(String key, int value) async {
    if (!_prefs!.containsKey(key)) {
      await _prefs!.setInt(key, value);
      print("$key written to SharedPreferences");
    } else {
      print("$key already exists in SharedPreferences");
    }
  }

  // Conditionally set bool value in SharedPreferences if it doesn't exist
  Future<void> setBoolIfNotExists(String key, bool value) async {
    if (!_prefs!.containsKey(key)) {
      await _prefs!.setBool(key, value);
      print("$key written to SharedPreferences");
    } else {
      print("$key already exists in SharedPreferences");
    }
  }



  // Set int value in SharedPreferences
  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  // Get int value from SharedPreferences
  int getInt(String key) {
    return _prefs?.getInt(key) ?? 0;
  }

  // Set bool value in SharedPreferences
  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  // Get bool value from SharedPreferences
  bool getBool(String key) {
    return _prefs?.getBool(key) ?? false;
  }

}
