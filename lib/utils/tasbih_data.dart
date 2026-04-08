class TasbihItem {
  final String text;
  final String translation;

  TasbihItem({required this.text, required this.translation});
}

class TasbihData {
  static final List<TasbihItem> commonZikr = [
    TasbihItem(text: "سُبْحَانَ اللَّهِ", translation: "Glory be to Allah"),
    TasbihItem(text: "الْحَمْدُ لِلَّهِ", translation: "Praise be to Allah"),
    TasbihItem(text: "لا إِلَهَ إِلا اللَّهُ", translation: "There is no god but Allah"),
    TasbihItem(text: "اللَّهُ أَكْبَرُ", translation: "Allah is the Greatest"),
    TasbihItem(text: "أستغفر الله", translation: "I seek forgiveness from Allah"),
    TasbihItem(text: "اللهم صلِّ على محمد", translation: "O Allah, send blessings upon Muhammad"),
  ];
}

