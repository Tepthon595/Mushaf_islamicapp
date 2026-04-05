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
// THEME & COLORS
// ═══════════════════════════════════
class AppColors {
  static const bg     = Color(0xFF080808);
  static const bg2    = Color(0xFF111111);
  static const bg3    = Color(0xFF181818);
  static const bg4    = Color(0xFF1F1F1F);
  static const gold   = Color(0xFFC9A84C);
  static const gold2  = Color(0xFFE8CC7A);
  static const gold3  = Color(0xFFF5E4A8);
  static const text   = Color(0xFFF0E8D8);
  static const text2  = Color(0xFF9A8868);
  static const text3  = Color(0xFF4A4030);
  static const border = Color(0xFF1E1A10);
  static const border2= Color(0xFF2A2416);
  static const green  = Color(0xFF2E7D4F);
  static const green2 = Color(0xFF3DA366);
  static const red    = Color(0xFFE57373);
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
// HIJRI UTILS
// ═══════════════════════════════════
String getHijriDate() {
  final now = DateTime.now();
  final gregorianYear = now.year;
  final gregorianMonth = now.month;
  final gregorianDay = now.day;
  // JDN calculation
  final a = (14 - gregorianMonth) ~/ 12;
  final y = gregorianYear + 4800 - a;
  final m = gregorianMonth + 12 * a - 3;
  final jdn = gregorianDay + (153*m+2)~/5 + 365*y + y~/4 - y~/100 + y~/400 - 32045;
  // Convert JDN to Hijri
  final l = jdn - 1948440 + 10632;
  final n = (l - 1) ~/ 10631;
  final l1 = l - 10631 * n + 354;
  final j = ((10985 - l1) ~/ 5316) * ((50*l1) ~/ 17719) + (l1 ~/ 5670) * ((43*l1) ~/ 15238);
  final l2 = l1 - ((30 - j) ~/ 15) * ((17719*j) ~/ 50) - (j ~/ 16) * ((15238*j) ~/ 43) + 29;
  final hMonth = (24 * l2) ~/ 709;
  final hDay = l2 - (709 * hMonth) ~/ 24;
  final hYear = 30 * n + j - 30;
  final months = ['محرم','صفر','ربيع الأول','ربيع الآخر','جمادى الأولى','جمادى الآخرة','رجب','شعبان','رمضان','شوال','ذو القعدة','ذو الحجة'];
  return '$hDay ${months[hMonth-1]} $hYear هـ';
}

// ═══════════════════════════════════
// APP WIDGET
// ═══════════════════════════════════
class MushafApp extends StatelessWidget {
  const MushafApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مصحف',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(primary: AppColors.gold),
        fontFamily: 'Cairo',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ═══════════════════════════════════
// HOME SCREEN
// ═══════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _navAnimController;
  late AnimationController _pageTransitionController;
  late Animation<double> _pageAnim;
  int _prevIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem('🕌', 'الصلاة'),
    _NavItem('📖', 'القرآن'),
    _NavItem('🤲', 'الأذكار'),
    _NavItem('📿', 'التسبيح'),
    _NavItem('☪️', 'الأسماء'),
    _NavItem('💛', 'ادعمنا'),
  ];

  @override
  void initState() {
    super.initState();
    _navAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pageTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _pageAnim = CurvedAnimation(parent: _pageTransitionController, curve: Curves.easeOut);
    _pageTransitionController.forward();
  }

  @override
  void dispose() {
    _navAnimController.dispose();
    _pageTransitionController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.lightImpact();
    _pageTransitionController.reset();
    setState(() {
      _prevIndex = _selectedIndex;
      _selectedIndex = index;
    });
    _pageTransitionController.forward();
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Column(
          children: [
            // TOP BAR
            _TopBar(hijriDate: getHijriDate()),
            // CONTENT
            Expanded(
              child: FadeTransition(
                opacity: _pageAnim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.02),
                    end: Offset.zero,
                  ).animate(_pageAnim),
                  child: _buildPage(),
                ),
              ),
            ),
            // BOTTOM NAV
            _BottomNav(
              items: _navItems,
              selectedIndex: _selectedIndex,
              onTap: _onNavTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final String icon, label;
  const _NavItem(this.icon, this.label);
}

// ═══════════════════════════════════
// TOP BAR
// ═══════════════════════════════════
class _TopBar extends StatelessWidget {
  final String hijriDate;
  const _TopBar({required this.hijriDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16, right: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF050505).withOpacity(0.97),
        border: const Border(bottom: BorderSide(color: AppColors.border2)),
      ),
      child: Row(
        children: [
          // Logo
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [AppColors.gold, AppColors.gold2],
            ).createShader(b),
            child: const Text(
              'مصحف',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          // Hijri date badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.06),
              border: Border.all(color: AppColors.border2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              hijriDate,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.text2,
              ),
            ),
          ),
        ],
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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF050505),
        border: Border(top: BorderSide(color: AppColors.border2)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(items.length, (i) {
              final isActive = i == selectedIndex;
              final isSupport = i == 5;
              return Expanded(
                child: _NavButton(
                  item: items[i],
                  isActive: isActive,
                  isSupport: isSupport,
                  onTap: () => onTap(i),
                ),
              );
            }),
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
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(_NavButton old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) {
      _ctrl.forward().then((_) => _ctrl.reverse());
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scale,
            child: Text(
              widget.item.icon,
              style: TextStyle(
                fontSize: widget.isActive ? 22 : 20,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.item.label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: widget.isActive ? AppColors.gold : AppColors.text3,
            ),
          ),
          if (widget.isActive)
            Container(
              width: 4, height: 4,
              margin: const EdgeInsets.only(top: 2),
              decoration: const BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════
// PRAYER PAGE
// ═══════════════════════════════════
class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});
  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  final _cityController = TextEditingController();
  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _prayerData;
  String _city = '';
  Timer? _countdownTimer;
  String _nextPrayer = '';
  String _countdown = '';

  final List<Map<String, dynamic>> _prayers = [
    {'key': 'Fajr', 'name': 'الفجر', 'icon': '🌙'},
    {'key': 'Sunrise', 'name': 'الشروق', 'icon': '🌅'},
    {'key': 'Dhuhr', 'name': 'الظهر', 'icon': '☀️'},
    {'key': 'Asr', 'name': 'العصر', 'icon': '🌤️'},
    {'key': 'Maghrib', 'name': 'المغرب', 'icon': '🌆'},
    {'key': 'Isha', 'name': 'العشاء', 'icon': '🌙'},
  ];

  @override
  void dispose() {
    _cityController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchPrayers() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) return;
    setState(() { _loading = true; _error = null; });
    try {
      final uri = Uri.parse('https://api.aladhan.com/v1/timingsByCity?city=$city&country=&method=4');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      final data = json.decode(response.body);
      if (data['code'] == 200) {
        setState(() {
          _prayerData = data['data'];
          _city = city;
          _loading = false;
        });
        _startCountdown();
      } else {
        setState(() { _loading = false; _error = 'المدينة غير موجودة'; });
      }
    } catch (e) {
      setState(() { _loading = false; _error = 'تعذر الاتصال'; });
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
          nextName = p['name'] as String;
        }
      }
    }
    if (next != null) {
      final diff = next.difference(now);
      final h = diff.inHours.toString().padLeft(2, '0');
      final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
      setState(() {
        _nextPrayer = nextName;
        _countdown = '$h:$m:$s';
      });
    }
  }

  String _getCurrentPrayer() {
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
      if (!dt.isAfter(now)) {
        if (lastPast == null || dt.isAfter(lastPast)) {
          lastPast = dt;
          current = p['key'] as String;
        }
      }
    }
    return current;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search card
          _buildSearchCard(),
          const SizedBox(height: 12),
          if (_loading)
            const Center(child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: AppColors.gold),
            )),
          if (_error != null)
            _buildError(),
          if (_prayerData != null) ...[
            _buildNextPrayerBanner(),
            const SizedBox(height: 12),
            _buildPrayerGrid(),
          ],
          if (_prayerData == null && !_loading && _error == null)
            _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🕌', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text('مواقيت الصلاة', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.bg4,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border2),
                  ),
                  child: TextField(
                    controller: _cityController,
                    style: const TextStyle(color: AppColors.text, fontSize: 14),
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      hintText: 'اسم المدينة...',
                      hintStyle: TextStyle(color: AppColors.text3, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    onSubmitted: (_) => _fetchPrayers(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _GoldButton(
                label: 'بحث',
                icon: Icons.search,
                onTap: _fetchPrayers,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextPrayerBanner() {
    return _AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gold.withOpacity(0.15), AppColors.green.withOpacity(0.12)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            const Text('⏰', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الصلاة القادمة', style: TextStyle(color: AppColors.text2, fontSize: 11)),
                  Text(_nextPrayer, style: const TextStyle(color: AppColors.gold2, fontSize: 18, fontWeight: FontWeight.w700)),
                  Text(_countdown, style: const TextStyle(color: AppColors.green2, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_city, style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  _prayerData!['date']?['readable'] as String? ?? '',
                  style: const TextStyle(color: AppColors.text3, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerGrid() {
    final timings = _prayerData!['timings'] as Map<String, dynamic>;
    final currentKey = _getCurrentPrayer();
    return Column(
      children: _prayers.map((p) {
        final isCurrent = p['key'] == currentKey;
        final time = (timings[p['key']] as String? ?? '').split(' ')[0];
        return _PrayerRow(
          icon: p['icon'] as String,
          name: p['name'] as String,
          time: time,
          isCurrent: isCurrent,
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Text('🕌', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            const Text('مواقيت الصلاة', style: TextStyle(fontFamily: 'Amiri', fontSize: 20, color: AppColors.gold2)),
            const SizedBox(height: 6),
            const Text('أدخل اسم مدينتك للحصول على مواقيت الصلاة', textAlign: TextAlign.center, style: TextStyle(color: AppColors.text2, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Text(_error!, style: const TextStyle(color: AppColors.red)),
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
    return FadeTransition(
      opacity: _anim,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: widget.isCurrent ? AppColors.gold.withOpacity(0.07) : AppColors.bg3,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: widget.isCurrent ? AppColors.gold.withOpacity(0.4) : AppColors.border2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: widget.isCurrent ? AppColors.gold.withOpacity(0.12) : AppColors.bg4,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: widget.isCurrent ? AppColors.gold.withOpacity(0.3) : AppColors.border2),
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
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('الآن', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w800)),
                    ),
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: widget.isCurrent ? AppColors.gold2 : AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: widget.isCurrent ? AppColors.gold : AppColors.text2,
              ),
            ),
          ],
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

  List<SurahData> get _filtered => surahList.where((s) =>
    _search.isEmpty || s.ar.contains(_search) || s.en.toLowerCase().contains(_search.toLowerCase())
  ).toList();

  Future<void> _loadSurah(SurahData surah) async {
    setState(() { _selectedSurah = surah; _loadingAyahs = true; _ayahs = null; });
    try {
      final r = await http.get(Uri.parse('https://api.alquran.cloud/v1/surah/${surah.n}'));
      final data = json.decode(r.body);
      setState(() {
        _ayahs = data['data']['ayahs'];
        _loadingAyahs = false;
      });
    } catch (_) {
      setState(() { _loadingAyahs = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedSurah != null) {
      return _SurahView(
        surah: _selectedSurah!,
        ayahs: _ayahs,
        loading: _loadingAyahs,
        onBack: () => setState(() { _selectedSurah = null; _ayahs = null; }),
      );
    }

    return Column(
      children: [
        // Header + search
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          decoration: const BoxDecoration(
            color: AppColors.bg,
            border: Border(bottom: BorderSide(color: AppColors.border2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('📖', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  const Text('القرآن الكريم', style: TextStyle(fontFamily: 'Amiri', fontSize: 20, color: AppColors.gold2)),
                ],
              ),
              const SizedBox(height: 8),
              _SearchField(
                hint: 'ابحث عن سورة...',
                onChanged: (v) => setState(() => _search = v),
              ),
            ],
          ),
        ),
        // Surah list
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
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _pressed ? AppColors.gold.withOpacity(0.05) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Number badge
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: AppColors.bg3,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border2),
              ),
              child: Center(
                child: Text(
                  widget.surah.n.toString(),
                  style: const TextStyle(fontSize: 11, color: AppColors.text3, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.surah.ar, style: const TextStyle(fontFamily: 'Amiri', fontSize: 17, color: AppColors.text)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: (widget.surah.t == 'مكية' ? AppColors.gold : const Color(0xFF7ecece)).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          widget.surah.t,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: widget.surah.t == 'مكية' ? AppColors.gold : const Color(0xFF7ecece),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.surah.a} آية',
                        style: const TextStyle(fontSize: 11, color: AppColors.text3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_left, color: AppColors.text3, size: 18),
          ],
        ),
      ),
    );
  }
}

class _SurahView extends StatelessWidget {
  final SurahData surah;
  final List<dynamic>? ayahs;
  final bool loading;
  final VoidCallback onBack;
  const _SurahView({required this.surah, required this.ayahs, required this.loading, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Surah header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F0A03), Color(0xFF1A0F05)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            border: Border(bottom: BorderSide(color: AppColors.border2)),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.bg3,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border2),
                  ),
                  child: const Icon(Icons.arrow_forward_ios, color: AppColors.text2, size: 14),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(surah.ar, style: const TextStyle(fontFamily: 'Amiri', fontSize: 26, color: AppColors.gold2)),
                    Text('${surah.en} • ${surah.a} آية • ${surah.t}',
                      style: const TextStyle(fontSize: 11, color: AppColors.text2)),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
            : ayahs == null
              ? const Center(child: Text('تعذر تحميل السورة', style: TextStyle(color: AppColors.text2)))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 32),
                  itemCount: ayahs!.length + 1,
                  itemBuilder: (ctx, i) {
                    if (i == 0) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        child: const Text(
                          'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                          style: TextStyle(fontFamily: 'Amiri', fontSize: 22, color: AppColors.gold2),
                        ),
                      );
                    }
                    final ayah = ayahs![i - 1];
                    return _AyahItem(ayah: ayah, index: i - 1);
                  },
                ),
        ),
      ],
    );
  }
}

class _AyahItem extends StatefulWidget {
  final dynamic ayah;
  final int index;
  const _AyahItem({required this.ayah, required this.index});
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
    Future.delayed(Duration(milliseconds: widget.index * 30), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final text = widget.ayah['text'] as String? ?? '';
    final num = widget.ayah['numberInSurah'] as int? ?? 0;
    return FadeTransition(
      opacity: _fade,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bg2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold.withOpacity(0.2)),
              ),
              child: Center(
                child: Text(num.toString(), style: const TextStyle(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontFamily: 'Amiri', fontSize: 20, color: AppColors.text, height: 2.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
// AZKAR PAGE
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
        if (_counts[tab]![index] >= target) {
          _done[tab]![index] = true;
        }
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

  final Map<String, String> _tabLabels = {
    'sabah': '🌅 الصباح',
    'masa': '🌆 المساء',
    'nawm': '🌙 النوم',
  };

  @override
  Widget build(BuildContext context) {
    final items = azkarData[_tab]!;
    final done = _done[_tab]!.where((d) => d).length;
    return Column(
      children: [
        // Tabs
        SizedBox(
          height: 56,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            itemCount: _tabLabels.length,
            itemBuilder: (ctx, i) {
              final key = _tabLabels.keys.toList()[i];
              final isActive = _tab == key;
              return GestureDetector(
                onTap: () { HapticFeedback.selectionClick(); setState(() => _tab = key); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.gold.withOpacity(0.12) : AppColors.bg3,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isActive ? AppColors.gold : AppColors.border2),
                  ),
                  child: Text(
                    _tabLabels[key]!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive ? AppColors.gold : AppColors.text2,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text('$done / ${items.length}', style: const TextStyle(color: AppColors.text3, fontSize: 12)),
              const Spacer(),
              GestureDetector(
                onTap: () => _reset(_tab),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text('إعادة', style: TextStyle(color: AppColors.text3, fontSize: 11)),
                ),
              ),
            ],
          ),
        ),
        // Azkar list
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
                onMinus: () {
                  setState(() {
                    if (_counts[_tab]![i] > 0) {
                      _counts[_tab]![i]--;
                      _done[_tab]![i] = false;
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
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
    _pulse = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_ZikrCard old) {
    super.didUpdateWidget(old);
    if (widget.count != old.count) {
      _pulseCtrl.forward().then((_) => _pulseCtrl.reverse());
    }
  }

  @override
  void dispose() { _pulseCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final progress = widget.item.count > 0 ? widget.count / widget.item.count : 0.0;
    return ScaleTransition(
      scale: _pulse,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.bg2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isDone ? AppColors.green.withOpacity(0.4) : AppColors.border2,
          ),
        ),
        child: Column(
          children: [
            // Progress bar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 300),
                builder: (ctx, v, _) => LinearProgressIndicator(
                  value: v,
                  backgroundColor: AppColors.border2,
                  valueColor: AlwaysStoppedAnimation(widget.isDone ? AppColors.green2 : AppColors.gold),
                  minHeight: 3,
                ),
              ),
            ),
            // Text
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.bg3,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.border2),
                    ),
                    child: Text(
                      'x${widget.item.count}',
                      style: const TextStyle(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.text,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 19, color: AppColors.text, height: 2),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                      border: Border(right: BorderSide(color: AppColors.gold, width: 2)),
                    ),
                    child: Text(
                      widget.item.benefit,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontSize: 12, color: AppColors.text2, height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
            // Footer controls
            Container(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Row(
                children: [
                  Text(
                    'المتبقي: ${widget.item.count - widget.count}',
                    style: const TextStyle(fontSize: 11, color: AppColors.text3),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onMinus,
                        child: Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border2),
                            color: AppColors.bg3,
                          ),
                          child: const Icon(Icons.remove, color: AppColors.text2, size: 14),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.count.toString(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.gold2),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: widget.isDone ? AppColors.green2 : AppColors.gold,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            widget.isDone ? '✓' : 'تسبيح',
                            style: TextStyle(
                              color: widget.isDone ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
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
    _tapAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _tapCtrl, curve: Curves.easeInOut),
    );
    _completeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _completeAnim = CurvedAnimation(parent: _completeCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _tapCtrl.dispose();
    _completeCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    HapticFeedback.lightImpact();
    _tapCtrl.forward().then((_) => _tapCtrl.reverse());
    final target = tasbihItems[_selected].target;
    setState(() {
      _count++;
      _total++;
      if (_count == target) {
        _completeCtrl.forward().then((_) => _completeCtrl.reset());
      }
    });
  }

  void _reset() {
    setState(() => _count = 0);
    _completeCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
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
          // Title
          const Text('التسبيح', style: TextStyle(fontFamily: 'Amiri', fontSize: 22, color: AppColors.gold2)),
          const SizedBox(height: 16),
          // Selector
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bg3,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اختر الذكر', style: TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<int>(
                    value: _selected,
                    isExpanded: true,
                    dropdownColor: AppColors.bg3,
                    underline: const SizedBox(),
                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 16, color: AppColors.text),
                    items: List.generate(tasbihItems.length, (i) => DropdownMenuItem(
                      value: i,
                      child: Text(tasbihItems[i].ar),
                    )),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() { _selected = v; _count = 0; });
                        _completeCtrl.reset();
                      }
                    },
                  ),
                ),
                Text('الهدف: $target مرة', style: const TextStyle(fontSize: 11, color: AppColors.text3)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Ring counter
          SizedBox(
            width: 200, height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ring
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 300),
                  builder: (ctx, v, _) => CustomPaint(
                    size: const Size(200, 200),
                    painter: _RingPainter(progress: v, isDone: isDone),
                  ),
                ),
                ScaleTransition(
                  scale: isDone ? _completeAnim : const AlwaysStoppedAnimation(1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          isDone ? '✓' : '$_count',
                          key: ValueKey(_count),
                          style: TextStyle(
                            fontSize: isDone ? 48 : 44,
                            fontWeight: FontWeight.w900,
                            color: isDone ? AppColors.green2 : AppColors.gold2,
                          ),
                        ),
                      ),
                      Text('/ $target', style: const TextStyle(fontSize: 12, color: AppColors.text3)),
                      if (roundsDone > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('${roundsDone}x', style: const TextStyle(color: AppColors.green2, fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // TAP BUTTON
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
                    colors: isDone
                      ? [AppColors.green, AppColors.green2]
                      : [AppColors.gold, AppColors.gold2],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: (isDone ? AppColors.green : AppColors.gold).withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    isDone ? 'أحسنت! اضغط للتكرار' : 'اضغط للتسبيح',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _OutlineButton(label: '− تقليل', onTap: () { if (_count > 0) setState(() => _count--); }),
              const SizedBox(width: 12),
              _OutlineButton(label: 'إعادة', onTap: _reset),
            ],
          ),
          const SizedBox(height: 12),
          // Total today
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.gold.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('إجمالي اليوم: ', style: TextStyle(color: AppColors.text2, fontSize: 13)),
                Text('$_total', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final bool isDone;
  const _RingPainter({required this.progress, required this.isDone});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;
    final strokeWidth = 12.0;
    final bgPaint = Paint()
      ..color = AppColors.border2
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final fgPaint = Paint()
      ..color = isDone ? AppColors.green2 : AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress || old.isDone != isDone;
}

// ═══════════════════════════════════
// ASMA UL HUSNA PAGE
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          decoration: const BoxDecoration(
            color: AppColors.bg,
            border: Border(bottom: BorderSide(color: AppColors.border2)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('☪️', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('أسماء الله الحسنى', style: TextStyle(fontFamily: 'Amiri', fontSize: 20, color: AppColors.gold2)),
                      Text('٩٩ اسماً من أسماء الله', style: TextStyle(fontSize: 11, color: AppColors.text2)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _SearchField(hint: 'ابحث عن اسم...', onChanged: (v) => setState(() => _search = v)),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: _filtered.length,
            itemBuilder: (ctx, i) {
              final asma = _filtered[i];
              return _AsmaCard(asma: asma, index: i, onTap: () => setState(() => _selected = asma));
            },
          ),
        ),
        if (_selected != null)
          _AsmaModal(asma: _selected!, onClose: () => setState(() => _selected = null)),
      ],
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
    Future.delayed(Duration(milliseconds: widget.index * 25), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
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
              color: AppColors.bg2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _pressed ? AppColors.gold.withOpacity(0.35) : AppColors.border2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.asma.n.toString(),
                  style: const TextStyle(fontSize: 9, color: AppColors.text3, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.asma.ar,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Amiri', fontSize: 16, color: AppColors.gold2),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.asma.transliteration,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 9, color: AppColors.text2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
    return GestureDetector(
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
                decoration: const BoxDecoration(
                  color: AppColors.bg2,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  border: Border(top: BorderSide(color: AppColors.border2)),
                ),
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36, height: 4,
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(color: AppColors.border2, borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '#${widget.asma.n}',
                      style: const TextStyle(fontSize: 11, color: AppColors.text3, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      widget.asma.ar,
                      style: const TextStyle(fontFamily: 'Amiri', fontSize: 40, color: AppColors.gold2),
                    ),
                    Text(
                      widget.asma.transliteration,
                      style: const TextStyle(fontSize: 14, color: AppColors.text2, fontStyle: FontStyle.italic),
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, AppColors.gold, Colors.transparent],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        widget.asma.meaning,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15, color: AppColors.text, height: 1.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                      ),
                      child: Text(
                        widget.asma.benefit,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, color: AppColors.text2, height: 1.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text('إغلاق', style: TextStyle(color: AppColors.text2)),
                        ),
                      ),
                    ),
                  ],
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
// SUPPORT PAGE
// ═══════════════════════════════════
class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Hero
          _AnimatedCard(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1200), Color(0xFF0F0A03)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.gold.withOpacity(0.25)),
              ),
              child: Column(
                children: [
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [AppColors.gold, AppColors.gold2],
                    ).createShader(b),
                    child: const Text('💛', style: TextStyle(fontSize: 48)),
                  ),
                  const SizedBox(height: 12),
                  const Text('ادعمنا', style: TextStyle(fontFamily: 'Amiri', fontSize: 28, color: AppColors.gold2)),
                  const SizedBox(height: 8),
                  const Text(
                    'كل تبرع منك يساعدنا على تطوير التطبيق وتقديم تجربة أفضل للمسلمين حول العالم',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.text2, fontSize: 14, height: 1.7),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Hadith
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bg3,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border2),
              gradient: LinearGradient(
                colors: [AppColors.bg3, AppColors.gold.withOpacity(0.03)],
              ),
            ),
            child: Column(
              children: [
                const Text(
                  '«مَنْ دَلَّ عَلَى خَيْرٍ فَلَهُ مِثْلُ أَجْرِ فَاعِلِهِ»',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Amiri', fontSize: 18, color: AppColors.text, height: 1.8),
                ),
                const SizedBox(height: 6),
                const Text('رواه مسلم', style: TextStyle(fontSize: 12, color: AppColors.text3)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Ko-fi button
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('جزاك الله خيراً على دعمك 🤍'),
                  backgroundColor: AppColors.bg3,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('☕', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text('ادعمنا على Ko-fi', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Messages
          const _SupportMessage(emoji: '🤍', text: 'جزاكم الله خيراً على دعمكم'),
          const SizedBox(height: 8),
          const _SupportMessage(emoji: '⚖️', text: 'كل تبرع يُكتب في ميزان حسناتكم'),
          const SizedBox(height: 8),
          const _SupportMessage(emoji: '🌙', text: 'نعمل بجد لجعل هذا التطبيق مفيداً لكم'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SupportMessage extends StatelessWidget {
  final String emoji, text;
  const _SupportMessage({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border2),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: AppColors.text2, fontSize: 13)),
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
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 3))],
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: Colors.black, size: 16),
              const SizedBox(width: 4),
              Text(widget.label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border2),
          borderRadius: BorderRadius.circular(9),
          color: AppColors.bg3,
        ),
        child: Text(label, style: const TextStyle(color: AppColors.text2, fontSize: 13)),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.border2),
      ),
      child: TextField(
        textDirection: TextDirection.rtl,
        style: const TextStyle(color: AppColors.text, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.text3, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          prefixIcon: const Icon(Icons.search, color: AppColors.text3, size: 18),
        ),
        onChanged: onChanged,
      ),
    );
  }
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
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(_anim),
        child: widget.child,
      ),
    );
  }
}
