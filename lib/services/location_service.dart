import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrayerService {
  Future<Map<String, dynamic>> getPrayerTimes() async {
    // 1. جلب الموقع
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    // 2. طلب البيانات من API
    final url = Uri.parse('https://api.aladhan.com/v1/timings/${DateTime.now().millisecondsSinceEpoch ~/ 1000}?latitude=${position.latitude}&longitude=${position.longitude}&method=4');
    
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body)['data']['timings'];
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}

