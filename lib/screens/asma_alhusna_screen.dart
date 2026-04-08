// lib/screens/asma_alhusna_screen.dart
import 'package:flutter/material.dart';

class AsmaAlHusnaScreen extends StatelessWidget {
  const AsmaAlHusnaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("أسماء الله الحسنى")),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1),
        itemCount: 99, // سنستخدم قائمة الأسماء الحقيقية هنا
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFF181818),
            child: InkWell(
              onTap: () => _showNameDetail(context, "الرحمن", "الواسع الرحمة الذي وسعت رحمته كل شيء"),
              child: Center(
                child: Text("الاسم $index", style: const TextStyle(fontSize: 18, color: Color(0xFFC9A84C))),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showNameDetail(BuildContext context, String name, String meaning) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        title: Text(name, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFC9A84C))),
        content: Text(meaning, textAlign: TextAlign.center),
      ),
    );
  }
}

