import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // للوصول لمزود الحالة

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الإعدادات")),
      body: ListView(
        children: [
          _buildSectionTitle("المظهر واللغة"),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text("الوضع الليلي"),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (v) {
                // منطق تبديل الثيم
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("لغة التطبيق"),
            subtitle: const Text("العربية"),
            onTap: () { /* إظهار قائمة اللغات */ },
          ),
          const Divider(),
          _buildSectionTitle("إعدادات الصلاة"),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("طريقة الحساب"),
            subtitle: const Text("رابطة العالم الإسلامي"),
            onTap: () {},
          ),
          const Divider(),
          _buildSectionTitle("إعدادات الصوت"),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("القارئ الافتراضي"),
            subtitle: const Text("مشاري العفاسي"),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.all(16),
    child: Text(title, style: const TextStyle(color: Color(0xFFC9A84C), fontWeight: FontWeight.bold)),
  );
}

