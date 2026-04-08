import 'package:flutter/material.dart';
import '../../models/quran_models.dart';
import '../../services/audio_service.dart';

class SurahViewScreen extends StatefulWidget {
  final Surah surah;
  const SurahViewScreen({super.key, required this.surah});

  @override
  State<SurahViewScreen> createState() => _SurahViewScreenState();
}

class _SurahViewScreenState extends State<SurahViewScreen> {
  final QuranAudioService _audioService = QuranAudioService();
  double _fontSize = 24.0;
  int? _activeAyahIndex;

  // بيانات تجريبية (يجب جلبها من API أو ملف JSON لاحقاً)
  List<Ayah> ayahs = [
    Ayah(numberInSurah: 1, number: 1, text: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3"),
    Ayah(numberInSurah: 2, number: 2, text: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/2.mp3"),
  ];

  void _playSequence(int index) {
    if (index >= ayahs.length) return;
    setState(() => _activeAyahIndex = index);
    _audioService.playAyah(ayahs[index].audioUrl, index, () {
      _playSequence(index + 1); // تشغيل تلقائي للآية التالية
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.name),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => _fontSize += 2)),
          IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() => _fontSize -= 2)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ayahs.length,
        itemBuilder: (context, index) {
          bool isActive = _activeAyahIndex == index;
          return GestureDetector(
            onTap: () => _playSequence(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Colors.amber.withOpacity(0.1) : Colors.transparent,
                border: const Border(bottom: BorderSide(color: Color(0xFF1E1A10))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    ayahs[index].text,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontFamily: 'Amiri',
                      color: isActive ? const Color(0xFFC9A84C) : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("${ayahs[index].numberInSurah}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

