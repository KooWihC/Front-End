import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

class TTSPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAudio(Uint8List audioBytes) async {
    try {
      print("🎵 오디오 재생 시작...");
      await _audioPlayer.play(BytesSource(audioBytes));
      print("✅ 오디오 재생 성공!");
    } catch (e) {
      print("⚠️ 오디오 재생 오류: $e");
    }
  }
}
