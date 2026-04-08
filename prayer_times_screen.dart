// lib/screens/prayer_times_screen.dart
import 'package:flutter/material.dart';
import '../services/location_service.dart'; // الخدمة التي كتبناها سابقاً

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  Map<String, dynamic>? timings;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrayers();
  }

  _loadPrayers() async {
    try {
      var data = await PrayerService().getPrayerTimes();
      setState(() { timings = data; isLoading = false; });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("مواقيت الصلاة"), centerTitle: true),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(20),
            children: timings!.entries.map((e) => _buildPrayerRow(e.key, e.value)).toList(),
          ),
    );
  }

  Widget _buildPrayerRow(String name, String time) {
    return Card(
      color: const Color(0xFF181818),
      child: ListTile(
        title: Text(name, style: const TextStyle(color: Color(0xFFC9A84C))),
        trailing: Text(time, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
