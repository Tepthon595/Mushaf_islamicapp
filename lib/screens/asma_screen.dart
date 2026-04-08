import 'package:flutter/material.dart';
import '../utils/asma_data.dart';

class AsmaAlHusnaScreen extends StatefulWidget {
  const AsmaAlHusnaScreen({super.key});

  @override
  State<AsmaAlHusnaScreen> createState() => _AsmaAlHusnaScreenState();
}

class _AsmaAlHusnaScreenState extends State<AsmaAlHusnaScreen> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    final filtered = AsmaData.list.where((a) => a.ar.contains(_search) || a.en.toLowerCase().contains(_search.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("أسماء الله الحسنى"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: "ابحث عن اسم...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFF181818),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final item = filtered[index];
          return InkWell(
            onTap: () => _showDetail(item),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2A2416)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${item.n}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  Text(item.ar, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC9A84C))),
                  Text(item.en, style: const TextStyle(fontSize: 10, color: Colors.white70)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDetail(AsmaItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF080808),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.ar, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFFC9A84C))),
            const SizedBox(height: 10),
            Text(item.en, style: const TextStyle(fontSize: 20, color: Colors.grey)),
            const Divider(color: Color(0xFF1E1A10), height: 40),
            Text(item.meaning, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, height: 1.5)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

