import 'package:just_audio/just_audio.dart';

class QuranAudioService {
  final AudioPlayer _player = AudioPlayer();
  int? currentPlayingAyahIndex;

  // تشغيل آية معينة
  Future<void> playAyah(String url, int index, Function onComplete) async {
    try {
      currentPlayingAyahIndex = index;
      await _player.setUrl(url);
      _player.play();
      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          onComplete(); // استدعاء الدالة لتشغيل الآية التالية تلقائياً
        }
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void stop() => _player.stop();
  void pause() => _player.pause();
  void resume() => _player.play();
}

