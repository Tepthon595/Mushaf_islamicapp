// lib/utils/quran_data.dart
class QuranData {
  static const List<Map<String, dynamic>> surahs = [
    {"n": 1, "s": "الفاتحة", "t": "Meccan", "a": 7, "en": "Al-Fatihah"},
    {"n": 2, "s": "البقرة", "t": "Medinan", "a": 286, "en": "Al-Baqarah"},
    // ... أضف بقية الـ 114 سورة هنا بنفس النسق
  ];

  static const List<Map<String, String>> reciters = [
    {"name": "مشاري العفاسي", "slug": "ar.alafasy"},
    {"name": "عبد الباسط عبد الصمد", "slug": "ar.abdulsamad"},
    {"name": "سعد الغامدي", "slug": "ar.saoodshuraym"},
  ];
}

