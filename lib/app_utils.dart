import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtils {

  static Future<int?> getInstallDateEpochSeconds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('first_run_date')) {
      return prefs.getInt('first_run_date');
    }

    // Fallback: use the app support dir creation/mod time
    final dir = await getApplicationSupportDirectory();
    final stat = await dir.stat();
    final installEpoch = stat.changed.millisecondsSinceEpoch ~/ 1000;

    // Save it permanently
    await prefs.setInt('first_run_date', installEpoch);

    return installEpoch;
  }


  // ตัวอย่าง ถ้าจะเพิ่มฟังก์ชันอื่น ๆ ที่สามารถเรียกใช้ได้ทุกที่ ด้วย รูปแบบ async/await หรือ .then
  /// Save the first run date to SharedPreferences
  static Future<void> saveFirstRunDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('first_run_date')) {
      int nowEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await prefs.setInt('first_run_date', nowEpoch);
    }
  }

  /// Get the first run date from SharedPreferences
  static Future<int?> getFirstRunDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('first_run_date'); // Returns stored epoch time
  }
} // end of class AppUtils
