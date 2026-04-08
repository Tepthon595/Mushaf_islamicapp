import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مصحف',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'AE'), // اللغة الافتراضية عربية
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080808),
        primaryColor: const Color(0xFFC9A84C),
        fontFamily: 'Cairo', // تأكد من إضافة الخط في pubspec.yaml
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFC9A84C),
          secondary: Color(0xFF2E7D4F),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
