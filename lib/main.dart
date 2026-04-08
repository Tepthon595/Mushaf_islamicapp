import 'package:flutter/material.dart';
import 'screens/quran/surah_list_screen.dart';
import 'screens/azkar_screen.dart';
import 'screens/tasbih_screen.dart';
import 'screens/prayer_screen.dart';
import 'screens/asma_screen.dart';
import 'screens/settings_screen.dart';

void main() => runApp(const QuranApp());

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // الافتراضي كما في HTML
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080808),
        fontFamily: 'Cairo',
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF111111), elevation: 0),
        colorScheme: const ColorScheme.dark(primary: Color(0xFFC9A84C)),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded, size: 100, color: Color(0xFFC9A84C)),
            SizedBox(height: 20),
            Text("مصحف", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFC9A84C))),
          ],
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;
  final _screens = [
    const SurahListScreen(),
    const AzkarScreen(),
    const TasbihScreen(),
    const PrayerScreen(),
    const AsmaAlHusnaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF111111),
        selectedItemColor: const Color(0xFFC9A84C),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "قرآن"),
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: "أذكار"),
          BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: "تسابيح"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "صلاة"),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: "أسماء"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
      ),
    );
  }
}
