// lib/screens/azkar_screen.dart
import 'package:flutter/material.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [Tab(text: "أذكار الصباح"), Tab(text: "أذكار المساء"), Tab(text: "أذكار الصلاة")],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAzkarList("morning"),
            _buildAzkarList("evening"),
            _buildAzkarList("after_prayer"),
          ],
        ),
      ),
    );
  }

  Widget _buildAzkarList(String category) {
    // هنا نضع منطق العداد كما في التسابيح
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.all(8),
        color: const Color(0xFF181818),
        child: ListTile(
          title: const Text("الذكر هنا..."),
          subtitle: const Text("العدد: 3"),
          trailing: const Icon(Icons.touch_app, color: Color(0xFFC9A84C)),
        ),
      ),
    );
  }
}

