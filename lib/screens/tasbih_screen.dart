import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/tasbih_data.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  int _target = 33;
  int _totalDaily = 0;
  TasbihItem _selectedZikr = TasbihData.commonZikr[0];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalDaily = prefs.getInt('total_tasbih_daily') ?? 0;
    });
  }

  _increment() async {
    HapticFeedback.lightImpact(); // اهتزاز خفيف
    setState(() {
      _counter++;
      _totalDaily++;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_tasbih_daily', _totalDaily);
    
    if (_counter == _target) {
      HapticFeedback.vibrate(); // اهتزاز قوي عند اكتمال الهدف
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<TasbihItem>(
              value: _selectedZikr,
              dropdownColor: const Color(0xFF181818),
              underline: const SizedBox(),
              onChanged: (v) => setState(() => _selectedZikr = v!),
              items: TasbihData.commonZikr.map((e) => DropdownMenuItem(value: e, child: Text(e.text))).toList(),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _increment,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 280, height: 280,
                    child: CircularProgressIndicator(
                      value: _counter / _target,
                      strokeWidth: 12,
                      color: const Color(0xFFC9A84C),
                      backgroundColor: Colors.white10,
                    ),
                  ),
                  Column(
                    children: [
                      Text("$_counter", style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w900, color: Color(0xFFC9A84C))),
                      Text("الهدف: $_target", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _roundBtn(Icons.refresh, () => setState(() => _counter = 0)),
                const SizedBox(width: 20),
                _roundBtn(Icons.remove, () => setState(() => _counter > 0 ? _counter-- : null)),
                const SizedBox(width: 20),
                _roundBtn(Icons.edit, _showTargetDialog),
              ],
            ),
            const SizedBox(height: 40),
            Text("مجموع اليوم: $_totalDaily", style: const TextStyle(color: Color(0xFF2E7D4F), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _roundBtn(IconData icon, VoidCallback onTap) => IconButton(
    onPressed: onTap,
    icon: Icon(icon),
    style: IconButton.styleFrom(backgroundColor: const Color(0xFF181818), padding: const EdgeInsets.all(15)),
  );

  void _showTargetDialog() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("تحديد الهدف"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [33, 99, 100, 1000].map((t) => ActionChip(label: Text("$t"), onPressed: () { setState(() => _target = t); Navigator.pop(c); })).toList(),
        ),
      ),
    );
  }
}
