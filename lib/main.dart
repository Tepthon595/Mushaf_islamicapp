import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF080808),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const MushafApp());
}

// ═══════════════════════════════════
// THEMES
// ═══════════════════════════════════
class AppTheme {
  final String id;
  final String name;
  final Color bg, bg2, bg3, bg4;
  final Color gold, gold2, gold3;
  final Color text, text2, text3;
  final Color border, border2;
  final Color green, green2;
  final Color accent;
  const AppTheme({
    required this.id, required this.name,
    required this.bg, required this.bg2, required this.bg3, required this.bg4,
    required this.gold, required this.gold2, required this.gold3,
    required this.text, required this.text2, required this.text3,
    required this.border, required this.border2,
    required this.green, required this.green2,
    required this.accent,
  });
}

const List<AppTheme> allThemes = [
  AppTheme(
    id: 'dark_gold', name: 'الذهبي الداكن',
    bg: Color(0xFF080808), bg2: Color(0xFF111111), bg3: Color(0xFF181818), bg4: Color(0xFF1F1F1F),
    gold: Color(0xFFC9A84C), gold2: Color(0xFFE8CC7A), gold3: Color(0xFFF5E4A8),
    text: Color(0xFFF0E8D8), text2: Color(0xFF9A8868), text3: Color(0xFF4A4030),
    border: Color(0xFF1E1A10), border2: Color(0xFF2A2416),
    green: Color(0xFF2E7D4F), green2: Color(0xFF3DA366),
    accent: Color(0xFFC9A84C),
  ),
  AppTheme(
    id: 'emerald', name: 'الزمردي',
    bg: Color(0xFF050D0A), bg2: Color(0xFF0A1A12), bg3: Color(0xFF0F2018), bg4: Color(0xFF152A1E),
    gold: Color(0xFF4CAF7D), gold2: Color(0xFF6BCFA0), gold3: Color(0xFF9EE8C8),
    text: Color(0xFFD8F0E8), text2: Color(0xFF68987E), text3: Color(0xFF304840),
    border: Color(0xFF102018), border2: Color(0xFF1A3026),
    green: Color(0xFF2E7D4F), green2: Color(0xFF3DA366),
    accent: Color(0xFF4CAF7D),
  ),
  AppTheme(
    id: 'midnight_blue', name: 'أزرق الفجر',
    bg: Color(0xFF050810), bg2: Color(0xFF0A1020), bg3: Color(0xFF0F1830), bg4: Color(0xFF15203A),
    gold: Color(0xFF5B8CCC), gold2: Color(0xFF7AACE8), gold3: Color(0xFFA8CCF5),
    text: Color(0xFFD8E8F8), text2: Color(0xFF687898), text3: Color(0xFF304050),
    border: Color(0xFF101828), border2: Color(0xFF1A2838),
    green: Color(0xFF2E5D8F), green2: Color(0xFF3D7FBF),
    accent: Color(0xFF5B8CCC),
  ),
  AppTheme(
    id: 'desert', name: 'الصحراء',
    bg: Color(0xFF100C06), bg2: Color(0xFF1C1409), bg3: Color(0xFF261C0C), bg4: Color(0xFF302414),
    gold: Color(0xFFD4924A), gold2: Color(0xFFEFB068), gold3: Color(0xFFF8D098),
    text: Color(0xFFF5E8D0), text2: Color(0xFFA08060), text3: Color(0xFF504028),
    border: Color(0xFF201808), border2: Color(0xFF302816),
    green: Color(0xFF7D5A2E), green2: Color(0xFFAF8048),
    accent: Color(0xFFD4924A),
  ),
  AppTheme(
    id: 'purple_night', name: 'ليلة بنفسجية',
    bg: Color(0xFF080510), bg2: Color(0xFF10091C), bg3: Color(0xFF180D28), bg4: Color(0xFF201434),
    gold: Color(0xFF9B6FCC), gold2: Color(0xFFBD96E8), gold3: Color(0xFFDCC5F8),
    text: Color(0xFFECD8FF), text2: Color(0xFF806898), text3: Color(0xFF402858),
    border: Color(0xFF180C28), border2: Color(0xFF281840),
    green: Color(0xFF5E3D8F), green2: Color(0xFF8A5EC2),
    accent: Color(0xFF9B6FCC),
  ),
  AppTheme(
    id: 'rose_gold', name: 'الذهب الوردي',
    bg: Color(0xFF0E0808), bg2: Color(0xFF1C1010), bg3: Color(0xFF261818), bg4: Color(0xFF302020),
    gold: Color(0xFFCC7A7A), gold2: Color(0xFFE8A0A0), gold3: Color(0xFFF8C8C8),
    text: Color(0xFFF5E0E0), text2: Color(0xFF986868), text3: Color(0xFF483030),
    border: Color(0xFF201010), border2: Color(0xFF301818),
    green: Color(0xFF8F4040), green2: Color(0xFFC06060),
    accent: Color(0xFFCC7A7A),
  ),
];

// Global theme notifier
final ValueNotifier<AppTheme> currentTheme = ValueNotifier(allThemes[0]);
AppTheme get T => currentTheme.value;

// ═══════════════════════════════════
// LANGUAGE
// ═══════════════════════════════════
class AppLang {
  final String code, name, flag;
  const AppLang(this.code, this.name, this.flag);
}

const List<AppLang> allLanguages = [
  AppLang('ar', 'العربية', '🇸🇦'),
  AppLang('en', 'English', '🇬🇧'),
  AppLang('fr', 'Français', '🇫🇷'),
  AppLang('tr', 'Türkçe', '🇹🇷'),
  AppLang('ur', 'اردو', '🇵🇰'),
  AppLang('id', 'Bahasa', '🇮🇩'),
  AppLang('ms', 'Melayu', '🇲🇾'),
  AppLang('de', 'Deutsch', '🇩🇪'),
  AppLang('es', 'Español', '🇪🇸'),
  AppLang('bn', 'বাংলা', '🇧🇩'),
];

final ValueNotifier<AppLang> currentLang = ValueNotifier(allLanguages[0]);

// Translation map (key -> {langCode -> value})
const Map<String, Map<String, String>> _tr = {
  'app_name': {'ar':'مصحف','en':'Mushaf','fr':'Mushaf','tr':'Mushaf','ur':'مصحف','id':'Mushaf','ms':'Mushaf','de':'Mushaf','es':'Mushaf','bn':'মুসহাফ'},
  'prayer': {'ar':'الصلاة','en':'Prayer','fr':'Prière','tr':'Namaz','ur':'نماز','id':'Shalat','ms':'Solat','de':'Gebet','es':'Oración','bn':'নামাজ'},
  'quran': {'ar':'القرآن','en':'Quran','fr':'Coran','tr':'Kuran','ur':'قرآن','id':'Quran','ms':'Quran','de':'Quran','es':'Corán','bn':'কোরআন'},
  'azkar': {'ar':'الأذكار','en':'Azkar','fr':'Dhikr','tr':'Zikirler','ur':'اذکار','id':'Dzikir','ms':'Zikir','de':'Dhikr','es':'Dhikr','bn':'জিকর'},
  'tasbih': {'ar':'التسبيح','en':'Tasbih','fr':'Tasbih','tr':'Tesbih','ur':'تسبیح','id':'Tasbih','ms':'Tasbih','de':'Tasbih','es':'Tasbih','bn':'তসবিহ'},
  'asma': {'ar':'أسماء الله','en':'99 Names','fr':'99 Noms','tr':'99 İsim','ur':'اسماء الله','id':'99 Nama','ms':'99 Nama','de':'99 Namen','es':'99 Nombres','bn':'৯৯ নাম'},
  'support': {'ar':'ادعمنا','en':'Support','fr':'Soutien','tr':'Destek','ur':'سپورٹ','id':'Dukung','ms':'Sokong','de':'Support','es':'Apoya','bn':'সাপোর্ট'},
  'search_surah': {'ar':'ابحث عن سورة...','en':'Search surah...','fr':'Chercher sourate...','tr':'Sure ara...','ur':'سورہ تلاش...','id':'Cari surah...','ms':'Cari surah...','de':'Sure suchen...','es':'Buscar sura...','bn':'সূরা খুঁজুন...'},
  'verse_of_day': {'ar':'آية اليوم','en':'Verse of the Day','fr':'Verset du jour','tr':'Günün Ayeti','ur':'آج کی آیت','id':'Ayat Hari Ini','ms':'Ayat Hari Ini','de':'Vers des Tages','es':'Versículo del día','bn':'আজকের আয়াত'},
  'prayer_times': {'ar':'مواقيت الصلاة','en':'Prayer Times','fr':'Horaires de prière','tr':'Namaz Vakitleri','ur':'نماز کے اوقات','id':'Waktu Shalat','ms':'Waktu Solat','de':'Gebetszeiten','es':'Horarios de oración','bn':'নামাজের সময়'},
  'select_country': {'ar':'اختر الدولة','en':'Select Country','fr':'Choisir un pays','tr':'Ülke seç','ur':'ملک منتخب کریں','id':'Pilih negara','ms':'Pilih negara','de':'Land wählen','es':'Seleccionar país','bn':'দেশ নির্বাচন করুন'},
  'select_city': {'ar':'اختر المدينة','en':'Select City','fr':'Choisir une ville','tr':'Şehir seç','ur':'شہر منتخب کریں','id':'Pilih kota','ms':'Pilih bandar','de':'Stadt wählen','es':'Seleccionar ciudad','bn':'শহর নির্বাচন করুন'},
  'next_prayer': {'ar':'الصلاة القادمة','en':'Next Prayer','fr':'Prochaine prière','tr':'Sonraki Namaz','ur':'اگلی نماز','id':'Shalat Berikutnya','ms':'Solat Seterusnya','de':'Nächstes Gebet','es':'Próxima oración','bn':'পরবর্তী নামাজ'},
  'support_btn': {'ar':'ادعمني على Ko-fi ☕','en':'Support on Ko-fi ☕','fr':'Soutenir sur Ko-fi ☕','tr':'Ko-fi\'de Destekle ☕','ur':'Ko-fi پر سپورٹ کریں ☕','id':'Dukung di Ko-fi ☕','ms':'Sokong di Ko-fi ☕','de':'Ko-fi unterstützen ☕','es':'Apoyar en Ko-fi ☕','bn':'Ko-fi-তে সাপোর্ট করুন ☕'},
  'morning': {'ar':'الصباح','en':'Morning','fr':'Matin','tr':'Sabah','ur':'صبح','id':'Pagi','ms':'Pagi','de':'Morgen','es':'Mañana','bn':'সকাল'},
  'evening': {'ar':'المساء','en':'Evening','fr':'Soir','tr':'Akşam','ur':'شام','id':'Sore','ms':'Petang','de':'Abend','es':'Tarde','bn':'সন্ধ্যা'},
  'sleep': {'ar':'النوم','en':'Sleep','fr':'Sommeil','tr':'Uyku','ur':'سونا','id':'Tidur','ms':'Tidur','de':'Schlaf','es':'Sueño','bn':'ঘুম'},
  'fajr': {'ar':'الفجر','en':'Fajr','fr':'Fajr','tr':'İmsak','ur':'فجر','id':'Subuh','ms':'Subuh','de':'Fajr','es':'Fajr','bn':'ফজর'},
  'sunrise': {'ar':'الشروق','en':'Sunrise','fr':'Lever','tr':'Güneş','ur':'طلوع','id':'Syuruq','ms':'Syuruk','de':'Sonnenaufg.','es':'Salida','bn':'সূর্যোদয়'},
  'dhuhr': {'ar':'الظهر','en':'Dhuhr','fr':'Dhuhr','tr':'Öğle','ur':'ظہر','id':'Dzuhur','ms':'Zohor','de':'Dhuhr','es':'Dhuhr','bn':'যোহর'},
  'asr': {'ar':'العصر','en':'Asr','fr':'Asr','tr':'İkindi','ur':'عصر','id':'Ashar','ms':'Asar','de':'Asr','es':'Asr','bn':'আসর'},
  'maghrib': {'ar':'المغرب','en':'Maghrib','fr':'Maghrib','tr':'Akşam','ur':'مغرب','id':'Maghrib','ms':'Maghrib','de':'Maghrib','es':'Maghrib','bn':'মাগরিব'},
  'isha': {'ar':'العشاء','en':'Isha','fr':'Isha','tr':'Yatsı','ur':'عشاء','id':'Isya','ms':'Isyak','de':'Isha','es':'Isha','bn':'ইশা'},
};

String tr(String key) {
  final langCode = currentLang.value.code;
  return _tr[key]?[langCode] ?? _tr[key]?['ar'] ?? key;
}

// ═══════════════════════════════════
// DATA
// ═══════════════════════════════════
class SurahData {
  final int n;
  final String ar, en;
  final int a;
  final String t;
  const SurahData(this.n, this.ar, this.en, this.a, this.t);
}

const List<SurahData> surahList = [
  SurahData(1,'الفاتحة','Al-Fatihah',7,'مكية'),
  SurahData(2,'البقرة','Al-Baqarah',286,'مدنية'),
  SurahData(3,'آل عمران','Aal-E-Imran',200,'مدنية'),
  SurahData(4,'النساء','An-Nisa',176,'مدنية'),
  SurahData(5,'المائدة',"Al-Ma'idah",120,'مدنية'),
  SurahData(6,'الأنعام',"Al-An'am",165,'مكية'),
  SurahData(7,'الأعراف',"Al-A'raf",206,'مكية'),
  SurahData(8,'الأنفال','Al-Anfal',75,'مدنية'),
  SurahData(9,'التوبة','At-Tawbah',129,'مدنية'),
  SurahData(10,'يونس','Yunus',109,'مكية'),
  SurahData(11,'هود','Hud',123,'مكية'),
  SurahData(12,'يوسف','Yusuf',111,'مكية'),
  SurahData(13,'الرعد',"Ar-Ra'd",43,'مدنية'),
  SurahData(14,'إبراهيم','Ibrahim',52,'مكية'),
  SurahData(15,'الحجر','Al-Hijr',99,'مكية'),
  SurahData(16,'النحل','An-Nahl',128,'مكية'),
  SurahData(17,'الإسراء','Al-Isra',111,'مكية'),
  SurahData(18,'الكهف','Al-Kahf',110,'مكية'),
  SurahData(19,'مريم','Maryam',98,'مكية'),
  SurahData(20,'طه','Ta-Ha',135,'مكية'),
  SurahData(21,'الأنبياء','Al-Anbiya',112,'مكية'),
  SurahData(22,'الحج','Al-Hajj',78,'مدنية'),
  SurahData(23,'المؤمنون',"Al-Mu'minun",118,'مكية'),
  SurahData(24,'النور','An-Nur',64,'مدنية'),
  SurahData(25,'الفرقان','Al-Furqan',77,'مكية'),
  SurahData(26,'الشعراء',"Ash-Shu'ara",227,'مكية'),
  SurahData(27,'النمل','An-Naml',93,'مكية'),
  SurahData(28,'القصص','Al-Qasas',88,'مكية'),
  SurahData(29,'العنكبوت','Al-Ankabut',69,'مكية'),
  SurahData(30,'الروم','Ar-Rum',60,'مكية'),
  SurahData(31,'لقمان','Luqman',34,'مكية'),
  SurahData(32,'السجدة','As-Sajdah',30,'مكية'),
  SurahData(33,'الأحزاب','Al-Ahzab',73,'مدنية'),
  SurahData(34,'سبأ','Saba',54,'مكية'),
  SurahData(35,'فاطر','Fatir',45,'مكية'),
  SurahData(36,'يس','Ya-Sin',83,'مكية'),
  SurahData(37,'الصافات','As-Saffat',182,'مكية'),
  SurahData(38,'ص','Sad',88,'مكية'),
  SurahData(39,'الزمر','Az-Zumar',75,'مكية'),
  SurahData(40,'غافر','Ghafir',85,'مكية'),
  SurahData(41,'فصلت','Fussilat',54,'مكية'),
  SurahData(42,'الشورى','Ash-Shura',53,'مكية'),
  SurahData(43,'الزخرف','Az-Zukhruf',89,'مكية'),
  SurahData(44,'الدخان','Ad-Dukhan',59,'مكية'),
  SurahData(45,'الجاثية','Al-Jathiyah',37,'مكية'),
  SurahData(46,'الأحقاف','Al-Ahqaf',35,'مكية'),
  SurahData(47,'محمد','Muhammad',38,'مدنية'),
  SurahData(48,'الفتح','Al-Fath',29,'مدنية'),
  SurahData(49,'الحجرات','Al-Hujurat',18,'مدنية'),
  SurahData(50,'ق','Qaf',45,'مكية'),
  SurahData(51,'الذاريات','Adh-Dhariyat',60,'مكية'),
  SurahData(52,'الطور','At-Tur',49,'مكية'),
  SurahData(53,'النجم','An-Najm',62,'مكية'),
  SurahData(54,'القمر','Al-Qamar',55,'مكية'),
  SurahData(55,'الرحمن','Ar-Rahman',78,'مدنية'),
  SurahData(56,'الواقعة',"Al-Waqi'ah",96,'مكية'),
  SurahData(57,'الحديد','Al-Hadid',29,'مدنية'),
  SurahData(58,'المجادلة','Al-Mujadila',22,'مدنية'),
  SurahData(59,'الحشر','Al-Hashr',24,'مدنية'),
  SurahData(60,'الممتحنة','Al-Mumtahanah',13,'مدنية'),
  SurahData(61,'الصف','As-Saf',14,'مدنية'),
  SurahData(62,'الجمعة',"Al-Jumu'ah",11,'مدنية'),
  SurahData(63,'المنافقون','Al-Munafiqun',11,'مدنية'),
  SurahData(64,'التغابن','At-Taghabun',18,'مدنية'),
  SurahData(65,'الطلاق','At-Talaq',12,'مدنية'),
  SurahData(66,'التحريم','At-Tahrim',12,'مدنية'),
  SurahData(67,'الملك','Al-Mulk',30,'مكية'),
  SurahData(68,'القلم','Al-Qalam',52,'مكية'),
  SurahData(69,'الحاقة','Al-Haqqah',52,'مكية'),
  SurahData(70,'المعارج',"Al-Ma'arij",44,'مكية'),
  SurahData(71,'نوح','Nuh',28,'مكية'),
  SurahData(72,'الجن','Al-Jinn',28,'مكية'),
  SurahData(73,'المزمل','Al-Muzzammil',20,'مكية'),
  SurahData(74,'المدثر','Al-Muddaththir',56,'مكية'),
  SurahData(75,'القيامة','Al-Qiyamah',40,'مكية'),
  SurahData(76,'الإنسان','Al-Insan',31,'مدنية'),
  SurahData(77,'المرسلات','Al-Mursalat',50,'مكية'),
  SurahData(78,'النبأ','An-Naba',40,'مكية'),
  SurahData(79,'النازعات',"An-Nazi'at",46,'مكية'),
  SurahData(80,'عبس','Abasa',42,'مكية'),
  SurahData(81,'التكوير','At-Takwir',29,'مكية'),
  SurahData(82,'الانفطار','Al-Infitar',19,'مكية'),
  SurahData(83,'المطففين','Al-Mutaffifin',36,'مكية'),
  SurahData(84,'الانشقاق','Al-Inshiqaq',25,'مكية'),
  SurahData(85,'البروج','Al-Buruj',22,'مكية'),
  SurahData(86,'الطارق','At-Tariq',17,'مكية'),
  SurahData(87,'الأعلى',"Al-A'la",19,'مكية'),
  SurahData(88,'الغاشية','Al-Ghashiyah',26,'مكية'),
  SurahData(89,'الفجر','Al-Fajr',30,'مكية'),
  SurahData(90,'البلد','Al-Balad',20,'مكية'),
  SurahData(91,'الشمس','Ash-Shams',15,'مكية'),
  SurahData(92,'الليل','Al-Layl',21,'مكية'),
  SurahData(93,'الضحى','Ad-Duha',11,'مكية'),
  SurahData(94,'الشرح','Ash-Sharh',8,'مكية'),
  SurahData(95,'التين','At-Tin',8,'مكية'),
  SurahData(96,'العلق','Al-Alaq',19,'مكية'),
  SurahData(97,'القدر','Al-Qadr',5,'مكية'),
  SurahData(98,'البينة','Al-Bayyinah',8,'مدنية'),
  SurahData(99,'الزلزلة','Az-Zalzalah',8,'مدنية'),
  SurahData(100,'العاديات','Al-Adiyat',11,'مكية'),
  SurahData(101,'القارعة',"Al-Qari'ah",11,'مكية'),
  SurahData(102,'التكاثر','At-Takathur',8,'مكية'),
  SurahData(103,'العصر','Al-Asr',3,'مكية'),
  SurahData(104,'الهمزة','Al-Humazah',9,'مكية'),
  SurahData(105,'الفيل','Al-Fil',5,'مكية'),
  SurahData(106,'قريش','Quraysh',4,'مكية'),
  SurahData(107,'الماعون',"Al-Ma'un",7,'مكية'),
  SurahData(108,'الكوثر','Al-Kawthar',3,'مكية'),
  SurahData(109,'الكافرون','Al-Kafirun',6,'مكية'),
  SurahData(110,'النصر','An-Nasr',3,'مدنية'),
  SurahData(111,'المسد','Al-Masad',5,'مكية'),
  SurahData(112,'الإخلاص','Al-Ikhlas',4,'مكية'),
  SurahData(113,'الفلق','Al-Falaq',5,'مكية'),
  SurahData(114,'الناس','An-Nas',6,'مكية'),
];

class AsmaData {
  final int n;
  final String ar, transliteration, meaning, benefit;
  const AsmaData(this.n, this.ar, this.transliteration, this.meaning, this.benefit);
}

const List<AsmaData> asmaList = [
  AsmaData(1,'الله','Allah','الاسم الجامع لجميع صفات الكمال','القلب المعمور بذكره يجد السكينة والطمأنينة'),
  AsmaData(2,'الرحمن','Ar-Rahman','الرحمة الواسعة الشاملة للخلق أجمعين','من أكثر تلاوته ألان الله قلبه'),
  AsmaData(3,'الرحيم','Ar-Raheem','الرحمة الخاصة بالمؤمنين','تجلب رحمة الله ومغفرته'),
  AsmaData(4,'الملك','Al-Malik','المالك لكل شيء والمتصرف فيه','يورث الاعتزاز بالانتساب لله'),
  AsmaData(5,'القدوس','Al-Quddus','المنزه عن كل نقص وعيب','يطهر القلب من الذنوب'),
  AsmaData(6,'السلام','As-Salam','السالم من كل نقص، الموصل للسلامة','السلام والأمان في الحياة'),
  AsmaData(7,'المؤمن','Al-Mu\'min','المصدق لعباده، المؤمِّن من عذابه','الأمان والطمأنينة'),
  AsmaData(8,'المهيمن','Al-Muhaymin','الرقيب الحافظ على كل شيء','الحفظ والرعاية الإلهية'),
  AsmaData(9,'العزيز','Al-Aziz','القوي الغالب الذي لا يُقهر','العزة والقوة بالله'),
  AsmaData(10,'الجبار','Al-Jabbar','الذي يجبر الكسر ويعلو فوق خلقه','جبر الكسر وإصلاح الحال'),
  AsmaData(11,'المتكبر','Al-Mutakabbir','المتعالي بعظمته وكبريائه','التواضع لله وحده'),
  AsmaData(12,'الخالق','Al-Khaliq','الموجِد للأشياء من العدم','الإبداع والخلق'),
  AsmaData(13,'البارئ','Al-Bari','المبدع للخلق بلا مثال سابق','التميز والإبداع'),
  AsmaData(14,'المصور','Al-Musawwir','الذي يصور الخلق كيف يشاء','الجمال والإتقان'),
  AsmaData(15,'الغفار','Al-Ghaffar','كثير المغفرة للذنوب','المغفرة والرحمة'),
  AsmaData(16,'القهار','Al-Qahhar','الغالب على كل شيء','القدرة والغلبة'),
  AsmaData(17,'الوهاب','Al-Wahhab','كثير العطاء والمواهب','الجود والعطاء'),
  AsmaData(18,'الرزاق','Ar-Razzaq','المتولي للرزق بلا انقطاع','الرزق الوفير'),
  AsmaData(19,'الفتاح','Al-Fattah','فاتح أبواب الرحمة والرزق','الفرج بعد الضيق'),
  AsmaData(20,'العليم','Al-Alim','العالم بكل شيء ظاهره وباطنه','العلم النافع'),
  AsmaData(21,'القابض','Al-Qabid','القابض للأرزاق بحكمة','الزهد في الدنيا'),
  AsmaData(22,'الباسط','Al-Basit','الباسط للرزق والرحمة','الكرم والسعة'),
  AsmaData(23,'الخافض','Al-Khafid','الخافض لمن يستحق الخفض','التواضع والتذلل'),
  AsmaData(24,'الرافع','Ar-Rafi','الرافع لمن يشاء من خلقه','الرفعة والعلو'),
  AsmaData(25,'المعز','Al-Mu\'izz','المعطي العزة لمن يشاء','العزة والكرامة'),
  AsmaData(26,'المذل','Al-Mudhill','المذل لمن يستحق الذلة','العبرة والاتعاظ'),
  AsmaData(27,'السميع','As-Sami','السامع لكل الأصوات','الدعاء والتوسل'),
  AsmaData(28,'البصير','Al-Basir','المبصر لكل الأشياء','اليقين برؤية الله'),
  AsmaData(29,'الحكم','Al-Hakam','الحاكم العادل بين خلقه','العدل والإنصاف'),
  AsmaData(30,'العدل','Al-Adl','المتصف بالعدل المطلق','العدل في المعاملة'),
  AsmaData(31,'اللطيف','Al-Latif','اللطيف بعباده في قضائه','اللطف والرفق'),
  AsmaData(32,'الخبير','Al-Khabir','العليم بخفايا الأمور وأسرارها','الدقة والإتقان'),
  AsmaData(33,'الحليم','Al-Halim','الصبور على عباده','الحلم والصبر'),
  AsmaData(34,'العظيم','Al-Azim','المتصف بالعظمة المطلقة','تعظيم الله وإجلاله'),
  AsmaData(35,'الغفور','Al-Ghafur','واسع المغفرة لمن تاب','التوبة والإنابة'),
  AsmaData(36,'الشكور','Ash-Shakur','المثيب على القليل بالكثير','الشكر لله دائماً'),
  AsmaData(37,'العلي','Al-Ali','المتعالي فوق كل شيء','علو الهمة لله'),
  AsmaData(38,'الكبير','Al-Kabir','الكبير في ذاته وصفاته','تعظيم الله'),
  AsmaData(39,'الحفيظ','Al-Hafiz','الحافظ لكل شيء','الحفظ والأمان'),
  AsmaData(40,'المقيت','Al-Muqit','المتكفل بأقوات الخلق','الرزق والكفاية'),
  AsmaData(41,'الحسيب','Al-Hasib','الكافي لعباده والمحاسِب','الكفاية والحساب'),
  AsmaData(42,'الجليل','Al-Jalil','العظيم المتصف بصفات الجلال','الهيبة والإجلال'),
  AsmaData(43,'الكريم','Al-Karim','الواسع الكرم والعطاء','الكرم والجود'),
  AsmaData(44,'الرقيب','Ar-Raqib','المراقب لأعمال عباده','المراقبة والمحاسبة'),
  AsmaData(45,'المجيب','Al-Mujib','المستجيب لدعاء عباده','إجابة الدعاء'),
  AsmaData(46,'الواسع','Al-Wasi','الواسع الرحمة والعلم والقدرة','السعة والشمول'),
  AsmaData(47,'الحكيم','Al-Hakim','الحكيم في أفعاله وأحكامه','الحكمة والفهم'),
  AsmaData(48,'الودود','Al-Wadud','المحب لعباده المؤمنين','المحبة والمودة'),
  AsmaData(49,'المجيد','Al-Majid','المتصف بالمجد والشرف','المجد والشرف'),
  AsmaData(50,'الباعث','Al-Ba\'ith','الباعث للخلق يوم القيامة','اليقين بالبعث'),
  AsmaData(51,'الشهيد','Ash-Shahid','الشاهد على كل شيء','الاستحضار الدائم'),
  AsmaData(52,'الحق','Al-Haqq','الثابت الوجود المتحقق','التمسك بالحق'),
  AsmaData(53,'الوكيل','Al-Wakil','الكفيل بأرزاق عباده','التوكل على الله'),
  AsmaData(54,'القوي','Al-Qawi','الشديد القوة والبطش','الاستعانة بالله'),
  AsmaData(55,'المتين','Al-Matin','الشديد في قوته وأفعاله','المتانة والصلابة'),
  AsmaData(56,'الولي','Al-Wali','الناصر والمحب لعباده','الولاية والنصرة'),
  AsmaData(57,'الحميد','Al-Hamid','المستحق للحمد والثناء','الحمد والشكر'),
  AsmaData(58,'المحصي','Al-Muhsi','المحصي لكل شيء','الدقة في العمل'),
  AsmaData(59,'المبدئ','Al-Mubdi\'','الموجِد للأشياء أول مرة','البداية والانطلاق'),
  AsmaData(60,'المعيد','Al-Mu\'id','المعيد للخلق بعد الفناء','اليقين بالإعادة'),
  AsmaData(61,'المحيي','Al-Muhyi','الواهب للحياة','الحياة والبعث'),
  AsmaData(62,'المميت','Al-Mumit','المُميت للأحياء بأمره','ذكر الموت'),
  AsmaData(63,'الحي','Al-Hayy','الدائم الحياة لا يموت','الحياة الأبدية'),
  AsmaData(64,'القيوم','Al-Qayyum','القائم بذاته المقيم لغيره','الاعتماد على الله'),
  AsmaData(65,'الواجد','Al-Wajid','الغني عن كل شيء','الغنى بالله'),
  AsmaData(66,'الماجد','Al-Majid','المتصف بالمجد والكرم','الكرم والسخاء'),
  AsmaData(67,'الواحد','Al-Wahid','الفرد الذي لا شريك له','التوحيد الخالص'),
  AsmaData(68,'الأحد','Al-Ahad','المتوحد في ذاته وصفاته','الوحدانية المطلقة'),
  AsmaData(69,'الصمد','As-Samad','المقصود في الحوائج','اللجوء إليه وحده'),
  AsmaData(70,'القادر','Al-Qadir','القادر على كل شيء','القدرة الإلهية'),
  AsmaData(71,'المقتدر','Al-Muqtadir','الشديد القدرة','الاقتدار والتمكين'),
  AsmaData(72,'المقدم','Al-Muqaddim','المقدم لمن يشاء بفضله','السبق والتقدم'),
  AsmaData(73,'المؤخر','Al-Mu\'akhkhir','المؤخر لمن يشاء بعدله','الصبر والأناة'),
  AsmaData(74,'الأول','Al-Awwal','الأول الذي ليس قبله شيء','البداية الأزلية'),
  AsmaData(75,'الآخر','Al-Akhir','الآخر الذي ليس بعده شيء','النهاية الأبدية'),
  AsmaData(76,'الظاهر','Az-Zahir','الغالب الظاهر فوق كل شيء','الظهور والوضوح'),
  AsmaData(77,'الباطن','Al-Batin','المحيط بكل شيء علماً','الخفاء والإحاطة'),
  AsmaData(78,'الوالي','Al-Wali','المتولي لأمور خلقه','الولاية والرعاية'),
  AsmaData(79,'المتعالي','Al-Muta\'ali','المتنزه عن صفات الخلق','التعالي المطلق'),
  AsmaData(80,'البر','Al-Barr','المحسن لعباده البر بهم','البر والإحسان'),
  AsmaData(81,'التواب','At-Tawwab','القابل لتوبة عباده','التوبة والإنابة'),
  AsmaData(82,'المنتقم','Al-Muntaqim','المنتقم من الظالمين','العدل الإلهي'),
  AsmaData(83,'العفو','Al-Afuww','المتجاوز عن سيئات عباده','العفو والسماح'),
  AsmaData(84,'الرؤوف','Ar-Ra\'uf','الشديد الرأفة والرحمة','الرأفة والرحمة'),
  AsmaData(85,'مالك الملك','Malik Al-Mulk','مالك الملك يؤتيه من يشاء','السلطان الإلهي'),
  AsmaData(86,'ذو الجلال','Dhul-Jalal','صاحب العظمة والإكرام','الجلال والإكرام'),
  AsmaData(87,'المقسط','Al-Muqsit','العادل في قضائه وحكمه','العدل والإنصاف'),
  AsmaData(88,'الجامع','Al-Jami\'','الجامع للخلق ليوم الحساب','الجمع والتوحيد'),
  AsmaData(89,'الغني','Al-Ghani','الغني عن كل ما سواه','الاستغناء بالله'),
  AsmaData(90,'المغني','Al-Mughni','المغني من يشاء من فقره','الغنى والكفاية'),
  AsmaData(91,'المانع','Al-Mani\'','المانع لما يشاء بحكمة','الحماية الإلهية'),
  AsmaData(92,'الضار','Ad-Darr','المُضِر بمن يشاء','الاستعاذة بالله'),
  AsmaData(93,'النافع','An-Nafi\'','النافع لمن يشاء من عباده','طلب النفع من الله'),
  AsmaData(94,'النور','An-Nur','نور السموات والأرض','الاستنارة بنوره'),
  AsmaData(95,'الهادي','Al-Hadi','الهادي من يشاء إلى الحق','الهداية والرشاد'),
  AsmaData(96,'البديع','Al-Badi\'','المبدع للأشياء بلا مثال','الإبداع والابتكار'),
  AsmaData(97,'الباقي','Al-Baqi','الدائم الباقي لا يزول','البقاء الأبدي'),
  AsmaData(98,'الوارث','Al-Warith','الباقي بعد فناء الخلق','الإرث الإلهي'),
  AsmaData(99,'الرشيد','Ar-Rashid','الموصل إلى الغايات','الرشاد والتوفيق'),
];

class AzkarItem {
  final String text, benefit;
  final int count;
  const AzkarItem(this.text, this.benefit, this.count);
}

const Map<String, List<AzkarItem>> azkarData = {
  'sabah': [
    AzkarItem('أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ\nالرَّحْمَنِ الرَّحِيمِ مَالِكِ يَوْمِ الدِّينِ\nإِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\nاهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ\nصِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ','قراءة الفاتحة',1),
    AzkarItem('اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ لَكَ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لاَ يَغْفِرُ الذُّنُوبَ إِلاَّ أَنْتَ','سيد الاستغفار - من قاله موقناً فمات دخل الجنة',1),
    AzkarItem('اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي','الدعاء بالعافية',1),
    AzkarItem('اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ','ذكر الصباح',1),
    AzkarItem('سُبْحَانَ اللهِ وَبِحَمْدِهِ','من قالها مئة مرة حُطَّت خطاياه وإن كانت مثل زبد البحر',100),
    AzkarItem('لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيءٍ قَدِيرٌ','من قالها عشراً كان كمن أعتق أربعة أنفس من ولد إسماعيل',10),
    AzkarItem('حَسْبِيَ اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ، عَلَيْهِ تَوَكَّلْتُ، وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ','من قالها سبعاً كفاه الله ما أهمه',7),
  ],
  'masa': [
    AzkarItem('أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ\nاللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ','آية الكرسي - حفظ من الشيطان',1),
    AzkarItem('بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ','من قالها ثلاثاً لم تصبه فجأة بلاء',3),
    AzkarItem('اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ','ذكر المساء',1),
    AzkarItem('اللَّهُمَّ مَا أَمْسَى بِي مِنْ نِعْمَةٍ، أَوْ بِأَحَدٍ مِنْ خَلْقِكَ، فَمِنْكَ وَحْدَكَ لاَ شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ','شكر نعم المساء',1),
    AzkarItem('سُبْحَانَ اللهِ وَبِحَمْدِهِ','من قالها مئة مرة حُطَّت خطاياه وإن كانت مثل زبد البحر',100),
    AzkarItem('أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ','من قالها ثلاثاً حين يمسي لم تضره حُمَة تلك الليلة',3),
  ],
  'nawm': [
    AzkarItem('بِسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا','دعاء النوم',1),
    AzkarItem('اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ','دعاء وقاية العذاب',3),
    AzkarItem('سُبْحَانَ اللَّهِ','تسبيح قبل النوم',33),
    AzkarItem('الْحَمْدُ للَّهِ','تحميد قبل النوم',33),
    AzkarItem('اللَّهُ أَكْبَرُ','تكبير قبل النوم',34),
    AzkarItem('اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لاَ مَلْجَأَ وَلاَ مَنْجَا مِنْكَ إِلاَّ إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ','دعاء النوم الجامع',1),
  ],
};

class TasbihItem {
  final String ar, meaning;
  final int target;
  const TasbihItem(this.ar, this.meaning, this.target);
}

const List<TasbihItem> tasbihItems = [
  TasbihItem('سُبْحَانَ اللَّهِ', 'Subhan Allah', 33),
  TasbihItem('الْحَمْدُ لِلَّهِ', 'Alhamdulillah', 33),
  TasbihItem('اللَّهُ أَكْبَرُ', 'Allahu Akbar', 34),
  TasbihItem('لَا إِلَهَ إِلَّا اللَّهُ', 'La ilaha illallah', 100),
  TasbihItem('سُبْحَانَ اللَّهِ وَبِحَمْدِهِ', 'Subhan Allahi wa bihamdihi', 100),
  TasbihItem('اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ', 'Allahumma salli ala Muhammad', 100),
  TasbihItem('أَسْتَغْفِرُ اللَّهَ', 'Astaghfirullah', 100),
  TasbihItem('سُبْحَانَ اللَّهِ الْعَظِيمِ', 'Subhan Allah al-Azim', 100),
];

// ═══════════════════════════════════
// COUNTRIES & CITIES DATA
// ═══════════════════════════════════
const Map<String, List<String>> countryCities = {
  'Saudi Arabia': ['Makkah','Madinah','Riyadh','Jeddah','Dammam','Taif','Tabuk','Abha'],
  'UAE': ['Dubai','Abu Dhabi','Sharjah','Ajman','Ras Al Khaimah','Fujairah'],
  'Kuwait': ['Kuwait City','Hawalli','Ahmadi','Farwaniya','Jahra'],
  'Qatar': ['Doha','Al Rayyan','Al Wakrah','Al Khor','Dukhan'],
  'Bahrain': ['Manama','Muharraq','Riffa','Hamad Town','Isa Town'],
  'Oman': ['Muscat','Salalah','Sohar','Nizwa','Sur'],
  'Jordan': ['Amman','Irbid','Zarqa','Aqaba','Mafraq'],
  'Egypt': ['Cairo','Alexandria','Giza','Shubra El-Kheima','Port Said','Suez','Luxor','Aswan'],
  'Syria': ['Damascus','Aleppo','Homs','Hama','Latakia'],
  'Iraq': ['Baghdad','Basra','Mosul','Erbil','Najaf','Karbala'],
  'Lebanon': ['Beirut','Tripoli','Sidon','Tyre','Zahle'],
  'Palestine': ['Gaza','Ramallah','Nablus','Hebron','Jenin'],
  'Yemen': ['Sanaa','Aden','Taiz','Hodeidah','Ibb'],
  'Libya': ['Tripoli','Benghazi','Misrata','Zawiya','Derna'],
  'Tunisia': ['Tunis','Sfax','Sousse','Kairouan','Bizerte'],
  'Algeria': ['Algiers','Oran','Constantine','Annaba','Blida'],
  'Morocco': ['Casablanca','Rabat','Fes','Marrakech','Tangier','Agadir'],
  'Sudan': ['Khartoum','Omdurman','Port Sudan','Kassala','Wad Madani'],
  'Pakistan': ['Karachi','Lahore','Islamabad','Rawalpindi','Faisalabad','Peshawar'],
  'Bangladesh': ['Dhaka','Chittagong','Sylhet','Rajshahi','Khulna'],
  'Indonesia': ['Jakarta','Surabaya','Bandung','Medan','Semarang','Makassar'],
  'Malaysia': ['Kuala Lumpur','George Town','Johor Bahru','Ipoh','Kota Kinabalu'],
  'Turkey': ['Istanbul','Ankara','Izmir','Bursa','Adana','Konya'],
  'Iran': ['Tehran','Mashhad','Isfahan','Tabriz','Shiraz','Qom'],
  'Afghanistan': ['Kabul','Kandahar','Herat','Mazar-i-Sharif','Jalalabad'],
  'United Kingdom': ['London','Birmingham','Manchester','Leeds','Glasgow','Bradford'],
  'United States': ['New York','Los Angeles','Chicago','Houston','Detroit','Dearborn'],
  'France': ['Paris','Marseille','Lyon','Toulouse','Lille'],
  'Germany': ['Berlin','Hamburg','Munich','Cologne','Frankfurt'],
  'Canada': ['Toronto','Montreal','Vancouver','Calgary','Edmonton'],
  'Australia': ['Sydney','Melbourne','Brisbane','Perth','Adelaide'],
  'India': ['Delhi','Mumbai','Hyderabad','Lucknow','Kolkata','Bengaluru'],
  'Nigeria': ['Lagos','Kano','Ibadan','Abuja','Kaduna'],
  'Senegal': ['Dakar','Touba','Thiès','Kaolack'],
  'Somalia': ['Mogadishu','Hargeisa','Bosaso','Kismayo'],
  'Ethiopia': ['Addis Ababa','Dire Dawa','Harar','Jijiga'],
};

// ═══════════════════════════════════
// HIJRI UTILS
// ═══════════════════════════════════
String getHijriDate() {
  final now = DateTime.now();
  final a = (14 - now.month) ~/ 12;
  final y = now.year + 4800 - a;
  final m = now.month + 12 * a - 3;
  final jdn = now.day + (153*m+2)~/5 + 365*y + y~/4 - y~/100 + y~/400 - 32045;
  final l = jdn - 1948440 + 10632;
  final n = (l - 1) ~/ 10631;
  final l1 = l - 10631 * n + 354;
  final j = ((10985 - l1) ~/ 5316) * ((50*l1) ~/ 17719) + (l1 ~/ 5670) * ((43*l1) ~/ 15238);
  final l2 = l1 - ((30 - j) ~/ 15) * ((17719*j) ~/ 50) - (j ~/ 16) * ((15238*j) ~/ 43) + 29;
  final hMonth = (24 * l2) ~/ 709;
  final hDay = l2 - (709 * hMonth) ~/ 24;
  final hYear = 30 * n + j - 30;
  const months = ['محرم','صفر','ربيع الأول','ربيع الآخر','جمادى الأولى','جمادى الآخرة','رجب','شعبان','رمضان','شوال','ذو القعدة','ذو الحجة'];
  return '$hDay ${months[hMonth-1]} $hYear هـ';
}

// ═══════════════════════════════════
// RECITER LIST
// ═══════════════════════════════════
class ReciterInfo {
  final String id, name;
  const ReciterInfo(this.id, this.name);
}

const List<ReciterInfo> reciters = [
  ReciterInfo('ar.alafasy', 'مشاري العفاسي'),
  ReciterInfo('ar.abdulbasitmurattal', 'عبد الباسط - مرتل'),
  ReciterInfo('ar.abdullahbasfar', 'عبدالله بصفر'),
  ReciterInfo('ar.hudhaify', 'علي الحذيفي'),
  ReciterInfo('ar.mahermuaiqly', 'ماهر المعيقلي'),
  ReciterInfo('ar.minshawi', 'محمد صديق المنشاوي'),
  ReciterInfo('ar.muhammadayyoub', 'محمد أيوب'),
  ReciterInfo('ar.shaatree', 'أبو بكر الشاطري'),
  ReciterInfo('ar.ibrahimakhbar', 'إبراهيم الأخضر'),
  ReciterInfo('ar.saoodshuraym', 'سعود الشريم'),
];

// ═══════════════════════════════════
// APP WIDGET
// ═══════════════════════════════════
class MushafApp extends StatelessWidget {
  const MushafApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => ValueListenableBuilder<AppLang>(
        valueListenable: currentLang,
        builder: (_, lang, __) => MaterialApp(
          title: 'مصحف',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: theme.bg,
            colorScheme: ColorScheme.dark(primary: theme.gold),
            fontFamily: 'Cairo',
          ),
          home: const _HomePage(),
        ),
      ),
    );
  }
}

class _NavItem {
  final String icon, labelKey;
  const _NavItem(this.icon, this.labelKey);
}

class _HomePage extends StatefulWidget {
  const _HomePage();
  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _pageCtrl;
  late Animation<double> _pageAnim;

  final List<_NavItem> _navItems = const [
    _NavItem('🕌', 'prayer'),
    _NavItem('📖', 'quran'),
    _NavItem('🤲', 'azkar'),
    _NavItem('📿', 'tasbih'),
    _NavItem('☪️', 'asma'),
    _NavItem('💛', 'support'),
  ];

  @override
  void initState() {
    super.initState();
    _pageCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _pageAnim = CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut);
    _pageCtrl.forward();
  }

  @override
  void dispose() { _pageCtrl.dispose(); super.dispose(); }

  void _onNavTap(int i) {
    if (i == _selectedIndex) return;
    setState(() => _selectedIndex = i);
    _pageCtrl.forward(from: 0);
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0: return const PrayerPage();
      case 1: return const QuranPage();
      case 2: return const AzkarPage();
      case 3: return const TasbihPage();
      case 4: return const AsmaPage();
      case 5: return const SupportPage();
      default: return const PrayerPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: theme.bg,
          body: Column(
            children: [
              _TopBar(hijriDate: getHijriDate()),
              Expanded(
                child: FadeTransition(
                  opacity: _pageAnim,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).animate(_pageAnim),
                    child: _buildPage(),
                  ),
                ),
              ),
              _BottomNav(items: _navItems, selectedIndex: _selectedIndex, onTap: _onNavTap),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
// TOP BAR
// ═══════════════════════════════════
class _TopBar extends StatelessWidget {
  final String hijriDate;
  const _TopBar({required this.hijriDate});

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: T.bg2,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _ThemePicker(),
    );
  }

  void _showLangPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: T.bg2,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _LangPicker(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => Container(
        height: kToolbarHeight + MediaQuery.of(context).padding.top,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 12, right: 12),
        decoration: BoxDecoration(
          color: theme.bg.withOpacity(0.97),
          border: Border(bottom: BorderSide(color: theme.border2)),
        ),
        child: Row(
          children: [
            ShaderMask(
              shaderCallback: (b) => LinearGradient(colors: [theme.gold, theme.gold2]).createShader(b),
              child: const Text('مصحف', style: TextStyle(fontFamily: 'Amiri', fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700)),
            ),
            const Spacer(),
            // Hijri date
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.gold.withOpacity(0.06),
                border: Border.all(color: theme.border2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(hijriDate, style: TextStyle(fontSize: 10, color: theme.text2)),
            ),
            const SizedBox(width: 6),
            // Lang picker
            GestureDetector(
              onTap: () => _showLangPicker(context),
              child: ValueListenableBuilder<AppLang>(
                valueListenable: currentLang,
                builder: (_, lang, __) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.gold.withOpacity(0.08),
                    border: Border.all(color: theme.border2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('${lang.flag} ${lang.code.toUpperCase()}', style: TextStyle(fontSize: 10, color: theme.gold2, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Theme picker
            GestureDetector(
              onTap: () => _showThemePicker(context),
              child: Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [theme.gold, theme.gold2]),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.palette, color: Colors.black, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, current, __) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4, margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: T.border2, borderRadius: BorderRadius.circular(2)))),
            Text('اختر الثيم', style: TextStyle(color: T.gold2, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            ...allThemes.map((theme) => GestureDetector(
              onTap: () { currentTheme.value = theme; Navigator.pop(context); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: current.id == theme.id ? theme.gold.withOpacity(0.12) : T.bg3,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: current.id == theme.id ? theme.gold : T.border2),
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        _ColorDot(theme.gold), const SizedBox(width: 3),
                        _ColorDot(theme.bg3), const SizedBox(width: 3),
                        _ColorDot(theme.green2),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Text(theme.name, style: TextStyle(color: T.text, fontSize: 14, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    if (current.id == theme.id)
                      Icon(Icons.check_circle, color: theme.gold, size: 18),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  const _ColorDot(this.color);
  @override
  Widget build(BuildContext context) => Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

class _LangPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: currentLang,
      builder: (_, current, __) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4, margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: T.border2, borderRadius: BorderRadius.circular(2)))),
            Text('اختر اللغة', style: TextStyle(color: T.gold2, fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 3.2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: allLanguages.map((lang) => GestureDetector(
                onTap: () { currentLang.value = lang; Navigator.pop(context); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: current.code == lang.code ? T.gold.withOpacity(0.12) : T.bg3,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: current.code == lang.code ? T.gold : T.border2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(lang.flag, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(lang.name, style: TextStyle(color: current.code == lang.code ? T.gold2 : T.text2, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
// BOTTOM NAV
// ═══════════════════════════════════
class _BottomNav extends StatelessWidget {
  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.items, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => Container(
        decoration: BoxDecoration(color: theme.bg, border: Border(top: BorderSide(color: theme.border2))),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: List.generate(items.length, (i) => Expanded(
                child: _NavButton(item: items[i], isActive: i == selectedIndex, isSupport: i == 5, onTap: () => onTap(i)),
              )),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final _NavItem item;
  final bool isActive, isSupport;
  final VoidCallback onTap;
  const _NavButton({required this.item, required this.isActive, required this.isSupport, required this.onTap});
  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
        onTapCancel: () => _ctrl.reverse(),
        child: ScaleTransition(
          scale: _scale,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.item.icon,
                style: TextStyle(fontSize: widget.isActive ? 22 : 18),
              ),
              const SizedBox(height: 2),
              ValueListenableBuilder<AppLang>(
                valueListenable: currentLang,
                builder: (_, __, ___) => Text(
                  tr(widget.item.labelKey),
                  style: TextStyle(
                    fontSize: 9,
                    color: widget.isActive ? theme.gold : theme.text3,
                    fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.isActive)
                Container(
                  width: 4, height: 4,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(color: theme.gold, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
// PRAYER PAGE — Country+City dropdowns
// ═══════════════════════════════════
class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});
  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _prayerData;
  String _selectedCountry = '';
  String _selectedCity = '';
  String _displayLocation = '';
  Timer? _countdownTimer;
  String _nextPrayer = '';
  String _countdown = '';

  final List<Map<String, dynamic>> _prayers = [
    {'key': 'Fajr', 'labelKey': 'fajr', 'icon': '🌙'},
    {'key': 'Sunrise', 'labelKey': 'sunrise', 'icon': '🌅'},
    {'key': 'Dhuhr', 'labelKey': 'dhuhr', 'icon': '☀️'},
    {'key': 'Asr', 'labelKey': 'asr', 'icon': '🌤️'},
    {'key': 'Maghrib', 'labelKey': 'maghrib', 'icon': '🌆'},
    {'key': 'Isha', 'labelKey': 'isha', 'icon': '🌙'},
  ];

  List<String> get _sortedCountries => countryCities.keys.toList()..sort();
  List<String> get _citiesOfSelected => _selectedCountry.isEmpty ? [] : (countryCities[_selectedCountry] ?? []);

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchPrayers() async {
    if (_selectedCity.isEmpty || _selectedCountry.isEmpty) return;
    setState(() { _loading = true; _error = null; });
    try {
      final uri = Uri.parse('https://api.aladhan.com/v1/timingsByCity?city=${Uri.encodeComponent(_selectedCity)}&country=${Uri.encodeComponent(_selectedCountry)}&method=4');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      final data = json.decode(response.body);
      if (data['code'] == 200) {
        setState(() {
          _prayerData = data['data'];
          _displayLocation = '$_selectedCity، $_selectedCountry';
          _loading = false;
        });
        _startCountdown();
      } else {
        setState(() { _loading = false; _error = 'المدينة غير موجودة، حاول مرة أخرى'; });
      }
    } catch (e) {
      setState(() { _loading = false; _error = 'تعذر الاتصال بالإنترنت'; });
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  void _updateCountdown() {
    if (_prayerData == null) return;
    final timings = _prayerData!['timings'] as Map<String, dynamic>;
    final now = DateTime.now();
    DateTime? next;
    String nextName = '';
    for (final p in _prayers) {
      if (p['key'] == 'Sunrise') continue;
      final t = timings[p['key']] as String? ?? '';
      final parts = t.split(':');
      if (parts.length < 2) continue;
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1].split(' ')[0]) ?? 0;
      final dt = DateTime(now.year, now.month, now.day, h, m);
      if (dt.isAfter(now)) {
        if (next == null || dt.isBefore(next)) {
          next = dt;
          nextName = tr(p['labelKey'] as String);
        }
      }
    }
    if (next != null) {
      final diff = next.difference(now);
      final h = diff.inHours.toString().padLeft(2, '0');
      final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
      if (mounted) setState(() { _nextPrayer = nextName; _countdown = '$h:$m:$s'; });
    }
  }

  String _getCurrentPrayerKey() {
    if (_prayerData == null) return '';
    final timings = _prayerData!['timings'] as Map<String, dynamic>;
    final now = DateTime.now();
    String current = '';
    DateTime? lastPast;
    for (final p in _prayers) {
      final t = timings[p['key']] as String? ?? '';
      final parts = t.split(':');
      if (parts.length < 2) continue;
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1].split(' ')[0]) ?? 0;
      final dt = DateTime(now.year, now.month, now.day, h, m);
      if (!dt.isAfter(now) && (lastPast == null || dt.isAfter(lastPast))) {
        lastPast = dt; current = p['key'] as String;
      }
    }
    return current;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationCard(theme),
            const SizedBox(height: 12),
            if (_loading) Center(child: Padding(padding: const EdgeInsets.all(32), child: CircularProgressIndicator(color: theme.gold))),
            if (_error != null) _buildError(theme),
            if (_prayerData != null) ...[
              _buildNextPrayerBanner(theme),
              const SizedBox(height: 12),
              _buildPrayerGrid(theme),
            ],
            if (_prayerData == null && !_loading && _error == null) _buildEmptyState(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(AppTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('🕌', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            ValueListenableBuilder<AppLang>(
              valueListenable: currentLang,
              builder: (_, __, ___) => Text(tr('prayer_times'), style: TextStyle(color: theme.gold, fontWeight: FontWeight.w700, fontSize: 14)),
            ),
          ]),
          const SizedBox(height: 14),
          // Country dropdown
          _buildDropdownField(
            theme: theme,
            hint: tr('select_country'),
            icon: '🌍',
            value: _selectedCountry.isEmpty ? null : _selectedCountry,
            items: _sortedCountries,
            onChanged: (v) {
              setState(() {
                _selectedCountry = v ?? '';
                _selectedCity = '';
                _prayerData = null;
                _error = null;
              });
            },
          ),
          const SizedBox(height: 10),
          // City dropdown (only visible when country selected)
          if (_selectedCountry.isNotEmpty) ...[
            _buildDropdownField(
              theme: theme,
              hint: tr('select_city'),
              icon: '🏙️',
              value: _selectedCity.isEmpty ? null : _selectedCity,
              items: _citiesOfSelected,
              onChanged: (v) {
                setState(() {
                  _selectedCity = v ?? '';
                  _prayerData = null;
                  _error = null;
                });
                if (v != null && v.isNotEmpty) {
                  Future.delayed(const Duration(milliseconds: 300), _fetchPrayers);
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required AppTheme theme,
    required String hint,
    required String icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.bg4,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: value != null ? theme.gold.withOpacity(0.4) : theme.border2),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: value,
              hint: Text(hint, style: TextStyle(color: theme.text3, fontSize: 13)),
              isExpanded: true,
              dropdownColor: theme.bg3,
              underline: const SizedBox(),
              iconSize: 20,
              icon: Icon(Icons.keyboard_arrow_down, color: theme.text3),
              style: TextStyle(color: theme.text, fontSize: 14, fontFamily: 'Cairo'),
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: TextStyle(color: theme.text, fontSize: 13)),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPrayerBanner(AppTheme theme) {
    return _AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.gold.withOpacity(0.15), theme.green.withOpacity(0.12)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.gold.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            const Text('⏰', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr('next_prayer'), style: TextStyle(color: theme.text2, fontSize: 11)),
                  Text(_nextPrayer, style: TextStyle(color: theme.gold2, fontSize: 18, fontWeight: FontWeight.w700)),
                  Text(_countdown, style: TextStyle(color: theme.green2, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_displayLocation, style: TextStyle(color: theme.gold, fontSize: 12, fontWeight: FontWeight.w700), textAlign: TextAlign.end),
                const SizedBox(height: 2),
                Text(_prayerData!['date']?['readable'] as String? ?? '', style: TextStyle(color: theme.text3, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerGrid(AppTheme theme) {
    final timings = _prayerData!['timings'] as Map<String, dynamic>;
    final currentKey = _getCurrentPrayerKey();
    return Column(
      children: _prayers.map((p) {
        final isCurrent = p['key'] == currentKey;
        final time = (timings[p['key']] as String? ?? '').split(' ')[0];
        return _PrayerRow(icon: p['icon'] as String, name: tr(p['labelKey'] as String), time: time, isCurrent: isCurrent);
      }).toList(),
    );
  }

  Widget _buildEmptyState(AppTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Text('🕌', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(tr('prayer_times'), style: TextStyle(fontFamily: 'Amiri', fontSize: 20, color: theme.gold2)),
            const SizedBox(height: 6),
            Text(tr('select_country') + ' ← ' + tr('select_city'), textAlign: TextAlign.center, style: TextStyle(color: theme.text2, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildError(AppTheme theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Text(_error!, style: const TextStyle(color: Color(0xFFE57373))),
    );
  }
}

class _PrayerRow extends StatefulWidget {
  final String icon, name, time;
  final bool isCurrent;
  const _PrayerRow({required this.icon, required this.name, required this.time, required this.isCurrent});
  @override
  State<_PrayerRow> createState() => _PrayerRowState();
}

class _PrayerRowState extends State<_PrayerRow> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => FadeTransition(
        opacity: _anim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isCurrent ? theme.gold.withOpacity(0.07) : theme.bg3,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: widget.isCurrent ? theme.gold.withOpacity(0.4) : theme.border2),
          ),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: widget.isCurrent ? theme.gold.withOpacity(0.12) : theme.bg4,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: widget.isCurrent ? theme.gold.withOpacity(0.3) : theme.border2),
                ),
                child: Center(child: Text(widget.icon, style: const TextStyle(fontSize: 18))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    if (widget.isCurrent)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: theme.gold, borderRadius: BorderRadius.circular(4)),
                        child: const Text('الآن', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w800)),
                      ),
                    Text(widget.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: widget.isCurrent ? theme.gold2 : theme.text)),
                  ],
                ),
              ),
              Text(widget.time, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: widget.isCurrent ? theme.gold : theme.text2)),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
// QURAN PAGE
// ═══════════════════════════════════
class QuranPage extends StatefulWidget {
  const QuranPage({super.key});
  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  String _search = '';
  SurahData? _selectedSurah;
  List<dynamic>? _ayahs;
  bool _loadingAyahs = false;
  String? _loadError;
  // Verse of the day
  Map<String, dynamic>? _verseOfDay;
  bool _loadingVerse = false;
  String _selectedReciter = 'ar.alafasy';

  List<SurahData> get _filtered => surahList.where((s) =>
    _search.isEmpty || s.ar.contains(_search) || s.en.toLowerCase().contains(_search.toLowerCase())
  ).toList();

  @override
  void initState() {
    super.initState();
    _loadVerseOfDay();
  }

  Future<void> _loadVerseOfDay() async {
    setState(() => _loadingVerse = true);
    try {
      final rng = Random();
      final surah = surahList[rng.nextInt(surahList.length)];
      final ayahNum = rng.nextInt(surah.a) + 1;
      final r = await http.get(Uri.parse('https://api.alquran.cloud/v1/ayah/${surah.n}:$ayahNum')).timeout(const Duration(seconds: 8));
      final data = json.decode(r.body);
      if (data['code'] == 200) {
        setState(() {
          _verseOfDay = {'text': data['data']['text'], 'surah': surah.ar, 'ayah': ayahNum, 'surahN': surah.n};
          _loadingVerse = false;
        });
      } else {
        setState(() => _loadingVerse = false);
      }
    } catch (_) {
      setState(() => _loadingVerse = false);
    }
  }

  Future<void> _loadSurah(SurahData surah) async {
    setState(() { _selectedSurah = surah; _loadingAyahs = true; _ayahs = null; _loadError = null; });
    try {
      // Fetch Arabic text + audio edition
      final r = await http.get(Uri.parse('https://api.alquran.cloud/v1/surah/${surah.n}/editions/quran-simple,${_selectedReciter}')).timeout(const Duration(seconds: 15));
      final data = json.decode(r.body);
      if (data['code'] == 200) {
        final editions = data['data'] as List;
        final textAyahs = (editions[0]['ayahs'] as List);
        final audioAyahs = editions.length > 1 ? (editions[1]['ayahs'] as List) : null;
        final merged = List.generate(textAyahs.length, (i) {
          final base = Map<String, dynamic>.from(textAyahs[i]);
          if (audioAyahs != null && i < audioAyahs.length) {
            base['audio'] = audioAyahs[i]['audio'];
          }
          return base;
        });
        setState(() { _ayahs = merged; _loadingAyahs = false; });
      } else {
        setState(() { _loadingAyahs = false; _loadError = 'تعذر تحميل السورة'; });
      }
    } catch (e) {
      setState(() { _loadingAyahs = false; _loadError = 'تعذر الاتصال بالإنترنت'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedSurah != null) {
      return _SurahView(
        surah: _selectedSurah!,
        ayahs: _ayahs,
        loading: _loadingAyahs,
        loadError: _loadError,
        selectedReciter: _selectedReciter,
        onReciterChanged: (r) {
          setState(() => _selectedReciter = r);
          if (_selectedSurah != null) _loadSurah(_selectedSurah!);
        },
        onBack: () => setState(() { _selectedSurah = null; _ayahs = null; _loadError = null; }),
      );
    }

    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(color: theme.bg, border: Border(bottom: BorderSide(color: theme.border2))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('📖', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Text(tr('quran'), style: TextStyle(fontFamily: 'Amiri', fontSize: 20, color: theme.gold2)),
                ]),
                const SizedBox(height: 8),
                _SearchField(hint: tr('search_surah'), onChanged: (v) => setState(() => _search = v), theme: theme),
              ],
            ),
          ),
          // Verse of the day
          if (_verseOfDay != null || _loadingVerse)
            _VerseOfDayBanner(
              verse: _verseOfDay,
              loading: _loadingVerse,
              theme: theme,
              onRefresh: _loadVerseOfDay,
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) {
                final s = _filtered[i];
                return _SurahListItem(surah: s, onTap: () => _loadSurah(s));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Verse of the Day Banner
class _VerseOfDayBanner extends StatelessWidget {
  final Map<String, dynamic>? verse;
  final bool loading;
  final AppTheme theme;
  final VoidCallback onRefresh;
  const _VerseOfDayBanner({required this.verse, required this.loading, required this.theme, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 2),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.gold.withOpacity(0.12), theme.bg3],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.gold.withOpacity(0.3)),
      ),
      child: loading
        ? Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: theme.gold)))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tr('verse_of_day'), style: TextStyle(color: theme.gold, fontSize: 12, fontWeight: FontWeight.w700)),
                  GestureDetector(
                    onTap: onRefresh,
                    child: Icon(Icons.refresh, color: theme.text3, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                verse!['text'] as String? ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Amiri', fontSize: 18, color: theme.text, height: 1.9),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                '— ${verse!['surah']} (${verse!['ayah']})',
                style: TextStyle(color: theme.text2, fontSize: 11),
              ),
            ],
          ),
    );
  }
}

class _SurahListItem extends StatefulWidget {
  final SurahData surah;
  final VoidCallback onTap;
  const _SurahListItem({required this.surah, required this.onTap});
  @override
  State<_SurahListItem> createState() => _SurahListItemState();
}

class _SurahListItemState extends State<_SurahListItem> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          color: _pressed ? theme.gold.withOpacity(0.05) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: theme.bg3, borderRadius: BorderRadius.circular(8), border: Border.all(color: theme.border2)),
                child: Center(child: Text(widget.surah.n.toString(), style: TextStyle(fontSize: 11, color: theme.text3, fontWeight: FontWeight.w700))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.surah.ar, style: TextStyle(fontFamily: 'Amiri', fontSize: 17, color: theme.text)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: (widget.surah.t == 'مكية' ? theme.gold : const Color(0xFF7ecece)).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(widget.surah.t, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: widget.surah.t == 'مكية' ? theme.gold : const Color(0xFF7ecece))),
                        ),
                        const SizedBox(width: 6),
                        Text('${widget.surah.a} آية', style: TextStyle(fontSize: 11, color: theme.text3)),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_left, color: theme.text3, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurahView extends StatefulWidget {
  final SurahData surah;
  final List<dynamic>? ayahs;
  final bool loading;
  final String? loadError;
  final String selectedReciter;
  final ValueChanged<String> onReciterChanged;
  final VoidCallback onBack;
  const _SurahView({required this.surah, required this.ayahs, required this.loading, this.loadError, required this.selectedReciter, required this.onReciterChanged, required this.onBack});
  @override
  State<_SurahView> createState() => _SurahViewState();
}

class _SurahViewState extends State<_SurahView> {
  String? _playingAudio;
  bool _showReciterSelector = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [theme.bg2, theme.bg3], begin: Alignment.topRight, end: Alignment.bottomLeft),
              border: Border(bottom: BorderSide(color: theme.border2)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack,
                      child: Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(color: theme.bg3, borderRadius: BorderRadius.circular(8), border: Border.all(color: theme.border2)),
                        child: Icon(Icons.arrow_forward_ios, color: theme.text2, size: 14),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.surah.ar, style: TextStyle(fontFamily: 'Amiri', fontSize: 26, color: theme.gold2)),
                          Text('${widget.surah.en} • ${widget.surah.a} آية • ${widget.surah.t}', style: TextStyle(fontSize: 11, color: theme.text2)),
                        ],
                      ),
                    ),
                    // Reciter button
                    GestureDetector(
                      onTap: () => setState(() => _showReciterSelector = !_showReciterSelector),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.gold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.gold.withOpacity(0.3)),
                        ),
                        child: Row(children: [
                          Icon(Icons.mic, color: theme.gold, size: 14),
                          const SizedBox(width: 4),
                          Text('القارئ', style: TextStyle(color: theme.gold, fontSize: 11)),
                        ]),
                      ),
                    ),
                  ],
                ),
                if (_showReciterSelector) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: reciters.length,
                      itemBuilder: (ctx, i) {
                        final r = reciters[i];
                        final isSelected = r.id == widget.selectedReciter;
                        return GestureDetector(
                          onTap: () { widget.onReciterChanged(r.id); setState(() => _showReciterSelector = false); },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? theme.gold.withOpacity(0.15) : theme.bg4,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: isSelected ? theme.gold : theme.border2),
                            ),
                            child: Text(r.name, style: TextStyle(color: isSelected ? theme.gold2 : theme.text2, fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: widget.loading
              ? Center(child: CircularProgressIndicator(color: T.gold))
              : widget.loadError != null
                ? Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('😔', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 12),
                      Text(widget.loadError!, style: TextStyle(color: T.text2, fontSize: 14)),
                    ],
                  ))
                : widget.ayahs == null
                  ? Center(child: Text('تعذر تحميل السورة', style: TextStyle(color: T.text2)))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 32),
                      itemCount: (widget.ayahs?.length ?? 0) + 1,
                      itemBuilder: (ctx, i) {
                        if (i == 0) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            alignment: Alignment.center,
                            child: Text('بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ', style: TextStyle(fontFamily: 'Amiri', fontSize: 22, color: T.gold2)),
                          );
                        }
                        final ayah = widget.ayahs![i - 1];
                        final audioUrl = ayah['audio'] as String?;
                        final isPlaying = _playingAudio == audioUrl;
                        return _AyahItem(
                          ayah: ayah,
                          index: i - 1,
                          audioUrl: audioUrl,
                          isPlaying: isPlaying,
                          onPlay: () {
                            setState(() => _playingAudio = isPlaying ? null : audioUrl);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class _AyahItem extends StatefulWidget {
  final dynamic ayah;
  final int index;
  final String? audioUrl;
  final bool isPlaying;
  final VoidCallback onPlay;
  const _AyahItem({required this.ayah, required this.index, this.audioUrl, required this.isPlaying, required this.onPlay});
  @override
  State<_AyahItem> createState() => _AyahItemState();
}

class _AyahItemState extends State<_AyahItem> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    Future.delayed(Duration(milliseconds: widget.index * 30), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final text = widget.ayah['text'] as String? ?? '';
    final num = widget.ayah['numberInSurah'] as int? ?? 0;
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => FadeTransition(
        opacity: _fade,
        child: GestureDetector(
          onTap: widget.onPlay,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: widget.isPlaying ? theme.gold.withOpacity(0.08) : theme.bg2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.isPlaying ? theme.gold.withOpacity(0.4) : theme.border2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: widget.onPlay,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isPlaying ? theme.gold : theme.bg4,
                          border: Border.all(color: widget.isPlaying ? theme.gold : theme.border2),
                        ),
                        child: Icon(
                          widget.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: widget.isPlaying ? Colors.black : theme.text3,
                          size: 14,
                        ),
                      ),
                    ),
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: theme.bg4, border: Border.all(color: theme.border2)),
                      child: Center(child: Text(num.toString(), style: TextStyle(fontSize: 10, color: theme.gold, fontWeight: FontWeight.w700))),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(text, textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Amiri', fontSize: 22, color: theme.text, height: 2.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
// AZKAR PAGE - Fixed counts display
// ═══════════════════════════════════
class AzkarPage extends StatefulWidget {
  const AzkarPage({super.key});
  @override
  State<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  String _tab = 'sabah';
  final Map<String, List<int>> _counts = {};
  final Map<String, List<bool>> _done = {};

  @override
  void initState() {
    super.initState();
    _initCounts();
  }

  void _initCounts() {
    for (final key in azkarData.keys) {
      final items = azkarData[key]!;
      _counts[key] = List.filled(items.length, 0);
      _done[key] = List.filled(items.length, false);
    }
  }

  void _tap(String tab, int index) {
    HapticFeedback.lightImpact();
    setState(() {
      final items = azkarData[tab]!;
      final current = _counts[tab]![index];
      final target = items[index].count;
      if (current < target) {
        _counts[tab]![index] = current + 1;
        if (_counts[tab]![index] >= target) _done[tab]![index] = true;
      }
    });
  }

  void _reset(String tab) {
    setState(() {
      final items = azkarData[tab]!;
      _counts[tab] = List.filled(items.length, 0);
      _done[tab] = List.filled(items.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = azkarData[_tab]!;
    final done = _done[_tab]!.where((d) => d).length;
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => Column(
        children: [
          // Tabs
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              children: [
                _TabChip(label: '🌅 ${tr('morning')}', isActive: _tab == 'sabah', theme: theme, onTap: () { HapticFeedback.selectionClick(); setState(() => _tab = 'sabah'); }),
                const SizedBox(width: 6),
                _TabChip(label: '🌆 ${tr('evening')}', isActive: _tab == 'masa', theme: theme, onTap: () { HapticFeedback.selectionClick(); setState(() => _tab = 'masa'); }),
                const SizedBox(width: 6),
                _TabChip(label: '🌙 ${tr('sleep')}', isActive: _tab == 'nawm', theme: theme, onTap: () { HapticFeedback.selectionClick(); setState(() => _tab = 'nawm'); }),
              ],
            ),
          ),
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text('$done / ${items.length}', style: TextStyle(color: theme.text3, fontSize: 12)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: done / items.length),
                        duration: const Duration(milliseconds: 400),
                        builder: (_, v, __) => LinearProgressIndicator(
                          value: v,
                          backgroundColor: theme.border2,
                          valueColor: AlwaysStoppedAnimation(theme.green2),
                          minHeight: 5,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _reset(_tab),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(border: Border.all(color: theme.border2), borderRadius: BorderRadius.circular(5)),
                    child: Text('إعادة', style: TextStyle(color: theme.text3, fontSize: 11)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 32),
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                final item = items[i];
                final count = _counts[_tab]![i];
                final isDone = _done[_tab]![i];
                return _ZikrCard(
                  item: item,
                  count: count,
                  isDone: isDone,
                  onTap: () => _tap(_tab, i),
                  onMinus: () { setState(() { if (_counts[_tab]![i] > 0) { _counts[_tab]![i]--; _done[_tab]![i] = false; } }); },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final AppTheme theme;
  final VoidCallback onTap;
  const _TabChip({required this.label, required this.isActive, required this.theme, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? theme.gold.withOpacity(0.12) : theme.bg3,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? theme.gold : theme.border2),
      ),
      child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isActive ? theme.gold : theme.text2)),
    ),
  );
}

class _ZikrCard extends StatefulWidget {
  final AzkarItem item;
  final int count;
  final bool isDone;
  final VoidCallback onTap, onMinus;
  const _ZikrCard({required this.item, required this.count, required this.isDone, required this.onTap, required this.onMinus});
  @override
  State<_ZikrCard> createState() => _ZikrCardState();
}

class _ZikrCardState extends State<_ZikrCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _pulse = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_ZikrCard old) {
    super.didUpdateWidget(old);
    if (widget.count != old.count) _pulseCtrl.forward().then((_) => _pulseCtrl.reverse());
  }

  @override
  void dispose() { _pulseCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) {
        final progress = widget.item.count > 0 ? widget.count / widget.item.count : 0.0;
        return ScaleTransition(
          scale: _pulse,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: theme.bg2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.isDone ? theme.green.withOpacity(0.4) : theme.border2),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 300),
                    builder: (ctx, v, _) => LinearProgressIndicator(
                      value: v,
                      backgroundColor: theme.border2,
                      valueColor: AlwaysStoppedAnimation(widget.isDone ? theme.green2 : theme.gold),
                      minHeight: 3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Count badge - shows the required count
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.bg3,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: theme.border2),
                            ),
                            child: Text(
                              widget.item.count == 1 ? 'مرة واحدة' : '${widget.item.count} مرات',
                              style: TextStyle(fontSize: 10, color: theme.gold, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(widget.item.text, textDirection: TextDirection.rtl, style: TextStyle(fontFamily: 'Amiri', fontSize: 19, color: theme.text, height: 2)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.gold.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(6),
                          border: Border(right: BorderSide(color: theme.gold, width: 2)),
                        ),
                        child: Text(widget.item.benefit, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 12, color: theme.text2, height: 1.6)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                  child: Row(
                    children: [
                      Text(
                        'المتبقي: ${widget.item.count - widget.count}',
                        style: TextStyle(fontSize: 11, color: theme.text3),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: widget.onMinus,
                            child: Container(
                              width: 30, height: 30,
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: theme.border2), color: theme.bg3),
                              child: Icon(Icons.remove, color: theme.text2, size: 14),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(widget.count.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: theme.gold2)),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: widget.isDone ? theme.green2 : theme.gold,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                widget.isDone ? '✓' : 'تسبيح',
                                style: TextStyle(color: widget.isDone ? Colors.white : Colors.black, fontWeight: FontWeight.w800, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════
// TASBIH PAGE
// ═══════════════════════════════════
class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});
  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> with TickerProviderStateMixin {
  int _selected = 0;
  int _count = 0;
  int _total = 0;
  late AnimationController _tapCtrl;
  late Animation<double> _tapAnim;
  late AnimationController _completeCtrl;
  late Animation<double> _completeAnim;

  @override
  void initState() {
    super.initState();
    _tapCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _tapAnim = Tween<double>(begin: 1.0, end: 0.92).animate(CurvedAnimation(parent: _tapCtrl, curve: Curves.easeInOut));
    _completeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _completeAnim = CurvedAnimation(parent: _completeCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() { _tapCtrl.dispose(); _completeCtrl.dispose(); super.dispose(); }

  void _onTap() {
    HapticFeedback.lightImpact();
    _tapCtrl.forward().then((_) => _tapCtrl.reverse());
    final target = tasbihItems[_selected].target;
    setState(() {
      _count++;
      _total++;
      if (_count == target) _completeCtrl.forward().then((_) => _completeCtrl.reset());
    });
  }

  void _reset() {
    setState(() => _count = 0);
    _completeCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) {
        final item = tasbihItems[_selected];
        final target = item.target;
        final progress = (_count % target) / target;
        final isDone = _count > 0 && _count % target == 0;
        final roundsDone = _count ~/ target;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(tr('tasbih'), style: TextStyle(fontFamily: 'Amiri', fontSize: 22, color: theme.gold2)),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: theme.bg3, borderRadius: BorderRadius.circular(12), border: Border.all(color: theme.border2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('اختر الذكر', style: TextStyle(fontSize: 11, color: theme.gold, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    DropdownButton<int>(
                      value: _selected,
                      isExpanded: true,
                      dropdownColor: theme.bg3,
                      underline: const SizedBox(),
                      style: TextStyle(fontFamily: 'Amiri', fontSize: 16, color: theme.text),
                      items: List.generate(tasbihItems.length, (i) => DropdownMenuItem(value: i, child: Text(tasbihItems[i].ar))),
                      onChanged: (v) { if (v != null) { setState(() { _selected = v; _count = 0; }); _completeCtrl.reset(); } },
                    ),
                    Text('الهدف: $target مرة', style: TextStyle(fontSize: 11, color: theme.text3)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200, height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progress),
                      duration: const Duration(milliseconds: 300),
                      builder: (ctx, v, _) => CustomPaint(size: const Size(200, 200), painter: _RingPainter(progress: v, isDone: isDone, theme: theme)),
                    ),
                    ScaleTransition(
                      scale: isDone ? _completeAnim : const AlwaysStoppedAnimation(1.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(isDone ? '✓' : '$_count', key: ValueKey(_count), style: TextStyle(fontSize: isDone ? 48 : 44, fontWeight: FontWeight.w900, color: isDone ? theme.green2 : theme.gold2)),
                          ),
                          Text('/ $target', style: TextStyle(fontSize: 12, color: theme.text3)),
                          if (roundsDone > 0)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: theme.green.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                              child: Text('${roundsDone}x', style: TextStyle(color: theme.green2, fontSize: 12, fontWeight: FontWeight.w700)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ScaleTransition(
                scale: _tapAnim,
                child: GestureDetector(
                  onTap: _onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 64,
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDone ? [theme.green, theme.green2] : [theme.gold, theme.gold2],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [BoxShadow(color: (isDone ? theme.green : theme.gold).withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 6))],
                    ),
                    child: Center(child: Text(isDone ? 'أحسنت! اضغط للتكرار' : 'اضغط للتسبيح', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black))),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _OutlineButton(label: '− تقليل', theme: theme, onTap: () { if (_count > 0) setState(() => _count--); }),
                  const SizedBox(width: 12),
                  _OutlineButton(label: 'إعادة', theme: theme, onTap: _reset),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: theme.gold.withOpacity(0.07), borderRadius: BorderRadius.circular(10), border: Border.all(color: theme.gold.withOpacity(0.2))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('إجمالي اليوم: ', style: TextStyle(color: theme.text2, fontSize: 13)),
                    Text('$_total', style: TextStyle(color: theme.gold, fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final bool isDone;
  final AppTheme theme;
  const _RingPainter({required this.progress, required this.isDone, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;
    const strokeWidth = 12.0;
    canvas.drawCircle(center, radius, Paint()..color = theme.border2..style = PaintingStyle.stroke..strokeWidth = strokeWidth);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, 2 * pi * progress, false,
      Paint()..color = isDone ? theme.green2 : theme.gold..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress || old.isDone != isDone;
}

// ═══════════════════════════════════
// ASMA PAGE
// ═══════════════════════════════════
class AsmaPage extends StatefulWidget {
  const AsmaPage({super.key});
  @override
  State<AsmaPage> createState() => _AsmaPageState();
}

class _AsmaPageState extends State<AsmaPage> {
  String _search = '';
  AsmaData? _selected;

  List<AsmaData> get _filtered => asmaList.where((a) =>
    _search.isEmpty || a.ar.contains(_search) || a.transliteration.toLowerCase().contains(_search.toLowerCase())
  ).toList();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(color: theme.bg, border: Border(bottom: BorderSide(color: theme.border2))),
            child: Column(
              children: [
                Row(children: [
                  const Text('☪️', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(tr('asma'), style: TextStyle(fontFamily: 'Amiri', fontSize: 20, color: theme.gold2)),
                    Text('٩٩ اسماً من أسماء الله', style: TextStyle(fontSize: 11, color: theme.text2)),
                  ]),
                ]),
                const SizedBox(height: 8),
                _SearchField(hint: 'ابحث عن اسم...', onChanged: (v) => setState(() => _search = v), theme: theme),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.0, crossAxisSpacing: 6, mainAxisSpacing: 6),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) => _AsmaCard(asma: _filtered[i], index: i, onTap: () => setState(() => _selected = _filtered[i])),
            ),
          ),
          if (_selected != null)
            _AsmaModal(asma: _selected!, onClose: () => setState(() => _selected = null)),
        ],
      ),
    );
  }
}

class _AsmaCard extends StatefulWidget {
  final AsmaData asma;
  final int index;
  final VoidCallback onTap;
  const _AsmaCard({required this.asma, required this.index, required this.onTap});
  @override
  State<_AsmaCard> createState() => _AsmaCardState();
}

class _AsmaCardState extends State<_AsmaCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    Future.delayed(Duration(milliseconds: widget.index * 25), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => FadeTransition(
        opacity: _anim,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(_anim),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
            onTapCancel: () => setState(() => _pressed = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.identity()..scale(_pressed ? 0.95 : 1.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.bg2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _pressed ? theme.gold.withOpacity(0.35) : theme.border2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.asma.n.toString(), style: TextStyle(fontSize: 9, color: theme.text3, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(widget.asma.ar, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Amiri', fontSize: 16, color: theme.gold2)),
                  const SizedBox(height: 2),
                  Text(widget.asma.transliteration, textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: theme.text2), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AsmaModal extends StatefulWidget {
  final AsmaData asma;
  final VoidCallback onClose;
  const _AsmaModal({required this.asma, required this.onClose});
  @override
  State<_AsmaModal> createState() => _AsmaModalState();
}

class _AsmaModalState extends State<_AsmaModal> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _slide = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => GestureDetector(
        onTap: widget.onClose,
        child: Container(
          color: Colors.black.withOpacity(0.75),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(_slide),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: theme.bg2, borderRadius: const BorderRadius.vertical(top: Radius.circular(22)), border: Border(top: BorderSide(color: theme.border2))),
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 36, height: 4, margin: const EdgeInsets.only(top: 12), decoration: BoxDecoration(color: theme.border2, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 8),
                      Text('#${widget.asma.n}', style: TextStyle(fontSize: 11, color: theme.text3, fontWeight: FontWeight.w700)),
                      Text(widget.asma.ar, style: TextStyle(fontFamily: 'Amiri', fontSize: 40, color: theme.gold2)),
                      Text(widget.asma.transliteration, style: TextStyle(fontSize: 14, color: theme.text2, fontStyle: FontStyle.italic)),
                      Container(height: 1, margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, theme.gold, Colors.transparent]))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(widget.asma.meaning, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: theme.text, height: 1.8)),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: theme.gold.withOpacity(0.06), borderRadius: BorderRadius.circular(10), border: Border.all(color: theme.gold.withOpacity(0.15))),
                        child: Text(widget.asma.benefit, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: theme.text2, height: 1.7)),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: widget.onClose,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(border: Border.all(color: theme.border2), borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text('إغلاق', style: TextStyle(color: theme.text2))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
// SUPPORT PAGE - Redesigned beautifully
// ═══════════════════════════════════
class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: currentTheme,
      builder: (_, theme, __) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Hero section - redesigned
            _AnimatedCard(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: theme.gold.withOpacity(0.35)),
                  gradient: LinearGradient(
                    colors: [theme.bg3, Color.lerp(theme.bg3, theme.gold, 0.06)!],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(top: -20, left: -20, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: theme.gold.withOpacity(0.04)))),
                    Positioned(bottom: -30, right: -30, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: theme.gold.withOpacity(0.03)))),
                    Padding(
                      padding: const EdgeInsets.all(26),
                      child: Column(
                        children: [
                          Container(
                            width: 72, height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [theme.gold, theme.gold2], begin: Alignment.topRight, end: Alignment.bottomLeft),
                              boxShadow: [BoxShadow(color: theme.gold.withOpacity(0.4), blurRadius: 20, spreadRadius: 2)],
                            ),
                            child: const Center(child: Text('☕', style: TextStyle(fontSize: 32))),
                          ),
                          const SizedBox(height: 16),
                          ShaderMask(
                            shaderCallback: (b) => LinearGradient(colors: [theme.gold, theme.gold2]).createShader(b),
                            child: const Text('ادعمنا', style: TextStyle(fontFamily: 'Amiri', fontSize: 32, color: Colors.white, fontWeight: FontWeight.w900)),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'كل تبرع منك يساعدنا على تطوير التطبيق\nوتقديم تجربة أفضل للمسلمين حول العالم',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: theme.text2, fontSize: 14, height: 1.8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Hadith card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.bg3,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.border2),
              ),
              child: Column(
                children: [
                  Container(
                    width: 32, height: 3,
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, theme.gold, Colors.transparent]), borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '«مَنْ دَلَّ عَلَى خَيْرٍ فَلَهُ مِثْلُ أَجْرِ فَاعِلِهِ»',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Amiri', fontSize: 18, color: theme.text, height: 1.8),
                  ),
                  const SizedBox(height: 6),
                  Text('رواه مسلم', style: TextStyle(fontSize: 12, color: theme.text3)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Ko-fi button — launches ko-fi.com
            GestureDetector(
              onTap: () async {
                // Open ko-fi
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(children: [
                      Icon(Icons.favorite, color: theme.gold, size: 18),
                      const SizedBox(width: 8),
                      const Text('جزاك الله خيراً على دعمك 🤍'),
                    ]),
                    backgroundColor: theme.bg3,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [theme.gold, theme.gold2], begin: Alignment.topRight, end: Alignment.bottomLeft),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: theme.gold.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 6))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('☕', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 10),
                    ValueListenableBuilder<AppLang>(
                      valueListenable: currentLang,
                      builder: (_, __, ___) => Text(tr('support_btn'), style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Feature highlights
            _FeatureCard(icon: '⚡', title: 'محدّث باستمرار', body: 'نعمل على إضافة مزايا جديدة بانتظام', theme: theme),
            const SizedBox(height: 8),
            _FeatureCard(icon: '🌐', title: 'متعدد اللغات', body: 'التطبيق متاح بـ ${allLanguages.length} لغات للمسلمين حول العالم', theme: theme),
            const SizedBox(height: 8),
            _FeatureCard(icon: '🤍', title: 'في ميزان حسناتكم', body: 'كل تبرع صدقة جارية تُكتب لكم', theme: theme),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String icon, title, body;
  final AppTheme theme;
  const _FeatureCard({required this.icon, required this.title, required this.body, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.bg3,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border2),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: theme.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: theme.gold.withOpacity(0.2))),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: theme.gold2, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(body, style: TextStyle(color: theme.text2, fontSize: 12, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════
class _GoldButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GoldButton({required this.label, required this.icon, required this.onTap});
  @override
  State<_GoldButton> createState() => _GoldButtonState();
}

class _GoldButtonState extends State<_GoldButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(_ctrl);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: T.gold,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: T.gold.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 3))],
          ),
          child: Row(children: [
            Icon(widget.icon, color: Colors.black, size: 16),
            const SizedBox(width: 4),
            Text(widget.label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14)),
          ]),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final AppTheme theme;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.theme, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: theme.border2), borderRadius: BorderRadius.circular(9), color: theme.bg3),
      child: Text(label, style: TextStyle(color: theme.text2, fontSize: 13)),
    ),
  );
}

class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final AppTheme theme;
  const _SearchField({required this.hint, required this.onChanged, required this.theme});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: theme.bg3, borderRadius: BorderRadius.circular(9), border: Border.all(color: theme.border2)),
    child: TextField(
      textDirection: TextDirection.rtl,
      style: TextStyle(color: theme.text, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: theme.text3, fontSize: 14),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        prefixIcon: Icon(Icons.search, color: theme.text3, size: 18),
      ),
      onChanged: onChanged,
    ),
  );
}

class _AnimatedCard extends StatefulWidget {
  final Widget child;
  const _AnimatedCard({required this.child});
  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _anim,
    child: SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(_anim),
      child: widget.child,
    ),
  );
}
