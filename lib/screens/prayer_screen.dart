import 'dart:async';
import 'package:flutter/material.dart';
import '../services/prayer_service.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final PrayerService _prayerService = PrayerService();
  Map<String, dynamic>? _data;
  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  String _nextPrayerName = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startCountdown();
  }

  void _loadData() async {
    try {
      final data = await _prayerService.fetchPrayerTimesByLocation();
      setState(() {
        _data = data;
        _isLoading = false;
        _updateNextPrayer();
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _updateNextPrayer() {
    if (_data == null) return;
    final next = _prayerService.getNextPrayer(_data!['timings']);
    setState(() {
      _nextPrayerName = next['name'];
      _remainingTime = next['remaining'];
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });
      } else {
        _updateNextPrayer(); // تحديث الصلاة عند انتهاء الوقت
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFFC9A84C)));

    final timings = _data!['timings'];
    final date = _data!['date'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF1E1A10), Color(0xFF080808)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("الصلاة القادمة: $_nextPrayerName", style: const TextStyle(fontSize: 18, color: Color(0xFFC9A84C))),
                    const SizedBox(height: 10),
                    Text(
                      "${_remainingTime.inHours}:${(_remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                    Text(date['hijri']['date'], style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildPrayerItem("الفجر", timings['Fajr']),
              _buildPrayerItem("الشروق", timings['Sunrise'], isSpecial: true),
              _buildPrayerItem("الظهر", timings['Dhuhr']),
              _buildPrayerItem("العصر", timings['Asr']),
              _buildPrayerItem("المغرب", timings['Maghrib']),
              _buildPrayerItem("العشاء", timings['Isha']),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerItem(String name, String time, {bool isSpecial = false}) {
    bool isNext = _nextPrayerName == name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNext ? const Color(0xFFC9A84C).withOpacity(0.1) : const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isNext ? const Color(0xFFC9A84C) : Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 18, fontWeight: isNext ? FontWeight.bold : FontWeight.normal)),
          Text(time, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFFC9A84C))),
        ],
      ),
    );
  }
}

