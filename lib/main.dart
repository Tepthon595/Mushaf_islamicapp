// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مصحف المطور',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFC9A84C),
        scaffoldBackgroundColor: const Color(0xFF080808),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF111111),
          selectedItemColor: Color(0xFFC9A84C),
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const QuranListScreen(),      // شاشة القرآن
    const AzkarScreen(),          // شاشة الأذكار
    const TasbihScreen(),         // شاشة التسبيح
    const PrayerTimesScreen(),    // شاشة مواقيت الصلاة
    const AsmaAlHusnaScreen(),    // شاشة أسماء الله الحسنى
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'القرآن'),
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'الأذكار'),
          BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'تسبيح'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'الصلاة'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'الأسماء'),
        ],
      ),
    );
  }
}
