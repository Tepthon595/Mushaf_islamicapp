import 'package:flutter/material.dart';
import 'quran/surah_list_screen.dart';
import '../prayer_times_screen.dart'; // سننشئه لاحقاً

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // القائمة المؤقتة للشاشات
  final List<Widget> _screens = [
    const SurahListScreen(), // شاشة القرآن
    const Center(child: Text('الأذكار (قريباً)')),
    const Center(child: Text('المسبحة (قريباً)')),
    const Center(child: Text('مواقيت الصلاة (قريباً)')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF111111),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'القرآن'),
          BottomNavigationBarItem(icon: Icon(Icons.Ads_click), label: 'الأذكار'),
          BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'المسبحة'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'الصلاة'),
        ],
      ),
    );
  }
}
