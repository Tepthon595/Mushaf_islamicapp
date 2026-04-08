// lib/services/audio_service.dart
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranAudioService {
  final AudioPlayer _player = AudioPlayer();
  
  // حالة التكرار
  bool isRepeating = false;
  bool isPaused = false;
  int currentRepeatCount = 0;
  int targetRepeatCount = 1;
  int currentAyahIndex = 0;

  // Stream لتحديث الواجهة بالآية الحالية أو التقدم
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  // دالة التكرار المتقدمة (المنطق الأساسي)
  Future<void> startRepeatSession({
    required List<String> audioUrls,
    required int startFrom,
    required int endAt,
    required int repeatTimes,
  }) async {
    isRepeating = true;
    targetRepeatCount = repeatTimes;
    
    for (int r = 0; r < repeatTimes; r++) {
      currentRepeatCount = r + 1;
      
      for (int i = startFrom; i <= endAt; i++) {
        if (!isRepeating) break; // توقف كلي
        
        currentAyahIndex = i;
        await _player.setUrl(audioUrls[i]);
        await _player.play();
        
        // الانتظار حتى تنتهي الآية الحالية
        await _player.playerStateStream.firstWhere(
          (state) => state.processingState == ProcessingState.completed
        );
        
        // حفظ آخر آية تم الوصول إليها (حفظ الحالة)
        _saveLastState(i, r);
      }
      if (!isRepeating) break;
    }
    isRepeating = false;
  }

  void pause() {
    isPaused = true;
    _player.pause();
  }

  void resume() {
    isPaused = false;
    _player.play();
  }

  void stop() {
    isRepeating = false;
    _player.stop();
  }

  // حفظ الحالة في الذاكرة المحلية
  Future<void> _saveLastState(int ayah, int repeat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_ayah', ayah);
    await prefs.setInt('last_repeat', repeat);
  }
}
