import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerService {
  static const String _baseUrl = "https://api.aladhan.com/v1/timings";

  // جلب المواقيت بناءً على الإحداثيات (GPS)
  Future<Map<String, dynamic>> fetchPrayerTimesByLocation() async {
    Position position = await _determinePosition();
    final url = Uri.parse(
        "$_baseUrl/${DateTime.now().millisecondsSinceEpoch ~/ 1000}?latitude=${position.latitude}&longitude=${position.longitude}&method=4");
    
    return _handleResponse(url);
  }

  // جلب المواقيت بناءً على اسم المدينة (البحث)
  Future<Map<String, dynamic>> fetchPrayerTimesByCity(String city, String country) async {
    final url = Uri.parse(
        "https://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=4");
    
    return _handleResponse(url);
  }

  Future<Map<String, dynamic>> _handleResponse(Uri url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      _saveLastLocation(data['meta']['timezone']);
      return data;
    } else {
      throw Exception("Failed to load prayer times");
    }
  }

  // تحديد الموقع مع معالجة الأخطاء
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return Future.error('Permission denied');
    }
    return await Geolocator.getCurrentPosition();
  }

  // حساب الصلاة القادمة والوقت المتبقي
  Map<String, dynamic> getNextPrayer(Map<String, dynamic> timings) {
    final now = DateTime.now();
    final format = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    
    List<MapEntry<String, DateTime>> prayerDates = [];
    final prayerNames = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];

    for (var name in prayerNames) {
      prayerDates.add(MapEntry(name, DateTime.parse("$format ${timings[name]}:00")));
    }

    // البحث عن أول صلاة وقتها بعد "الآن"
    for (var prayer in prayerDates) {
      if (prayer.value.isAfter(now)) {
        return {"name": _translate(prayer.key), "time": prayer.value, "remaining": prayer.value.difference(now)};
      }
    }

    // إذا انتهت صلوات اليوم، الصلاة القادمة هي فجر الغد
    return {"name": "الفجر", "time": prayerDates[0].value.add(const Duration(days: 1)), "remaining": prayerDates[0].value.add(const Duration(days: 1)).difference(now)};
  }

  String _translate(String name) {
    Map<String, String> trans = {"Fajr": "الفجر", "Dhuhr": "الظهر", "Asr": "العصر", "Maghrib": "المغرب", "Isha": "العشاء"};
    return trans[name] ?? name;
  }

  Future<void> _saveLastLocation(String timezone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_timezone', timezone);
  }
}
