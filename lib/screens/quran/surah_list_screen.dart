import 'package:flutter/material.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  // ملاحظة: في النسخة الكاملة سنستدعي هذه البيانات من ملف JSON أو Model
  final List<Map<String, dynamic>> surahs = [
    {"n": 1, "s": "الفاتحة", "t": "Meccan", "a": 7},
    {"n": 2, "s": "البقرة", "t": "Medinan", "a": 286},
    // ... باقي السور
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredSurahs = surahs.where((s) => s['s'].contains(searchQuery)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('المصحف الإلكتروني', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'ابحث عن سورة...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFF181818),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          // قائمة السور
          Expanded(
            child: ListView.builder(
              itemCount: filteredSurahs.length,
              itemBuilder: (context, index) {
                final surah = filteredSurahs[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF1E1A10),
                    child: Text('${surah['n']}', style: TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                  title: Text(surah['s'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  subtitle: Text('${surah['t']} - آياتها ${surah['a']}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    // الانتقال لعرض السورة (سنبرمجها في الخطوة القادمة)
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

