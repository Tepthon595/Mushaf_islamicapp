class AsmaItem {
  final int n;
  final String ar;
  final String en;
  final String meaning;

  AsmaItem({required this.n, required this.ar, required this.en, required this.meaning});
}

class AsmaData {
  static final List<AsmaItem> list = [
    AsmaItem(n: 1, ar: "الرحمن", en: "Ar-Rahman", meaning: "الواسع الرحمة الذي وسعت رحمته كل شيء"),
    AsmaItem(n: 2, ar: "الرحيم", en: "Ar-Raheem", meaning: "المنعم بجلائل النعم وعظائمها"),
    // ... سيتم استكمال الـ 99 اسماً من ملف HTML
  ];
}

