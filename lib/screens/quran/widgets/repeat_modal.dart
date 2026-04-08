// lib/screens/quran/widgets/repeat_modal.dart
import 'package:flutter/material.dart';

class RepeatModal extends StatefulWidget {
  final int currentSurah;
  final int totalAyahs;
  final Function(int start, int end, int count) onStart;

  const RepeatModal({super.key, required this.currentSurah, required this.totalAyahs, required this.onStart});

  @override
  State<RepeatModal> createState() => _RepeatModalState();
}

class _RepeatModalState extends State<RepeatModal> {
  int startAyah = 1;
  int endAyah = 1;
  int repeatCount = 1;

  @override
  void initState() {
    super.initState();
    endAyah = widget.totalAyahs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("إعدادات التكرار للحفظ", style: TextStyle(fontSize: 20, color: Color(0xFFC9A84C))),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNumberPicker("من آية", startAyah, (v) => setState(() => startAyah = v)),
              _buildNumberPicker("إلى آية", endAyah, (v) => setState(() => endAyah = v)),
            ],
          ),
          const SizedBox(height: 20),
          _buildNumberPicker("عدد التكرارات", repeatCount, (v) => setState(() => repeatCount = v)),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D4F), minimumSize: const Size(double.infinity, 50)),
            onPressed: () {
              widget.onStart(startAyah, endAyah, repeatCount);
              Navigator.pop(context);
            },
            child: const Text("بدء التكرار الآن"),
          )
        ],
      ),
    );
  }

  Widget _buildNumberPicker(String label, int value, Function(int) onChange) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Row(
          children: [
            IconButton(onPressed: () => onChange(value + 1), icon: const Icon(Icons.add_circle_outline)),
            Text("$value", style: const TextStyle(fontSize: 18)),
            IconButton(onPressed: () => value > 1 ? onChange(value - 1) : null, icon: const Icon(Icons.remove_circle_outline)),
          ],
        )
      ],
    );
  }
}

