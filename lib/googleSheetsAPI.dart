import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleSheetsAPI {
  static const String _apiUrl =
      'https://script.google.com/macros/s/AKfycbyztvjtMyVJ4DB7zZn7yO9U2yKAx4X3vYznGnQNW3Sxrv2gaY7RGYo7BlLWMoMphK8Q/exec';
// apiUrl สร้างขึ้นเอง จาก App script ใน Google sheets. ให้ chat GPT ช่วยเขียน app script เพื่อสร้าง api แล้วจึง deploy ออกมาเป็น api url

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        // Handle error
        print('Failed to load data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle exception
      print('Exception while fetching data: $e');
      return [];
    }
  }
}
