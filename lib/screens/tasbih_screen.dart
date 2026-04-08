// lib/screens/tasbih_screen.dart
import 'package:flutter/material.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int count = 0;
  int target = 33;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<int>(
            value: target,
            items: [33, 99, 1000].map((e) => DropdownMenuItem(value: e, child: Text("الهدف: $e"))).toList(),
            onChanged: (v) => setState(() => target = v!),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => setState(() {
              if (count < target) count++;
              else count = 0; // Reset or vibrate
            }),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250, height: 250,
                  child: CircularProgressIndicator(
                    value: count / target,
                    strokeWidth: 8,
                    color: const Color(0xFFC9A84C),
                  ),
                ),
                Text("$count", style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => setState(() => count = 0)),
        ],
      ),
    );
  }
}
