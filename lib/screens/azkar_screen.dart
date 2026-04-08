import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/azkar_data.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<int>> _currentCounts = {}; // تتبع العدادات الحالية لكل ذكر

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadProgress();
  }

  // تحميل التقدم المحفوظ
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      AzkarData.allAzkar.forEach((category, items) {
        _currentCounts[category] = items.map((item) {
          return prefs.getInt('azkar_${category}_${items.indexOf(item)}') ?? item.count;
        }).toList();
      });
    });
  }

  // حفظ التقدم
  Future<void> _updateCount(String category, int index) async {
    if (_currentCounts[category]![index] > 0) {
      setState(() {
        _currentCounts[category]![index]--;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('azkar_${category}_$index', _currentCounts[category]![index]);
      
      // اهتزاز خفيف عند الضغط (Haptic Feedback) إذا أردت إضافته لاحقاً
    }
  }

  // إعادة ضبط الأذكار (Reset)
  Future<void> _resetCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < AzkarData.allAzkar[category]!.length; i++) {
        _currentCounts[category]![i] = AzkarData.allAzkar[category]![i].count;
        prefs.remove('azkar_${category}_$i');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الأذكار اليومية", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFC9A84C),
          labelColor: const Color(0xFFC9A84C),
          tabs: const [
            Tab(text: "الصباح"),
            Tab(text: "المساء"),
            Tab(text: "النوم"),
          ],
        ),
      ),
      body: _currentCounts.isEmpty 
          ? const Center(child: CircularProgressIndicator()) 
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAzkarList('morning'),
                _buildAzkarList('evening'),
                _buildAzkarList('sleep'),
              ],
            ),
    );
  }

  Widget _buildAzkarList(String category) {
    final items = AzkarData.allAzkar[category]!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton.icon(
            onPressed: () => _resetCategory(category),
            icon: const Icon(Icons.refresh, color: Colors.grey),
            label: const Text("إعادة ضبط هذه القائمة", style: TextStyle(color: Colors.grey)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final current = _currentCounts[category]![index];
              final bool isDone = current == 0;

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isDone ? 0.5 : 1.0,
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: isDone ? Colors.black26 : const Color(0xFF181818),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isDone ? Colors.transparent : const Color(0xFF2A2416),
                    ),
                  ),
                  child: InkWell(
                    onTap: () => _updateCount(category, index),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            item.text,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Amiri',
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // عداد التكرار
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isDone ? Colors.green.withOpacity(0.2) : const Color(0xFFC9A84C).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: isDone ? Colors.green : const Color(0xFFC9A84C)),
                                ),
                                child: Text(
                                  isDone ? "تم" : "$current / ${item.count}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDone ? Colors.green : const Color(0xFFC9A84C),
                                  ),
                                ),
                              ),
                              Text(
                                item.reference,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          // مؤشر التقدم (Progress Bar) لكل ذكر
                          if (!isDone) 
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: LinearProgressIndicator(
                                value: 1 - (current / item.count),
                                backgroundColor: Colors.white10,
                                color: const Color(0xFFC9A84C),
                                minHeight: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
