import 'package:flutter/material.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  String _currentZikr = "سبحان الله";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_currentZikr, style: const TextStyle(fontSize: 30, color: Color(0xFFC9A84C))),
        const SizedBox(height: 50),
        GestureDetector(
          onTap: () => setState(() => _counter++),
          child: Container(
            width: 200, height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC9A84C), width: 5),
            ),
            child: Center(child: Text('$_counter', style: const TextStyle(fontSize: 50))),
          ),
        ),
        TextButton(onPressed: () => setState(() => _counter = 0), child: const Text("تصفير")),
      ],
    );
  }
}

