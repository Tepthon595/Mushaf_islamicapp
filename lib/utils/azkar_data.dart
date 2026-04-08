class AzkarItem {
  final String text;
  final String translation;
  final int count;
  final String reference;

  AzkarItem({
    required this.text,
    required this.translation,
    required this.count,
    required this.reference,
  });
}

class AzkarData {
  static final Map<String, List<AzkarItem>> allAzkar = {
    'morning': [
      AzkarItem(
        text: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ",
        translation: "We have reached the morning and at this very time unto Allah belongs all sovereignty...",
        count: 1,
        reference: "رواه مسلم"
      ),
      AzkarItem(
        text: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
        translation: "Glory is to Allah and praise is to Him.",
        count: 100,
        reference: "رواه مسلم"
      ),
      // أضف باقي الأذكار من ملف HTML هنا بنفس النمط
    ],
    'evening': [
      AzkarItem(
        text: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ...",
        translation: "We have reached the evening...",
        count: 1,
        reference: "رواه مسلم"
      ),
    ],
    'sleep': [
      AzkarItem(
        text: "بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي...",
        translation: "In Your name my Lord I lie down...",
        count: 1,
        reference: "البخاري ومسلم"
      ),
    ],
  };
}

