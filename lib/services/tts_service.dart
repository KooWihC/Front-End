import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'tts_player.dart';

class TTSService {
  final TTSPlayer _ttsPlayer = TTSPlayer();
  AutoRefreshingAuthClient? _client;

  Future<void> _authenticate() async {
    final jsonString = await rootBundle.loadString('assets/river-hold-451408-v5-0022d89b944f.json'); // ✅ 경로 수정
    final jsonData = jsonDecode(jsonString);

    final credentials = ServiceAccountCredentials.fromJson(jsonData);
    final client = http.Client();

    _client = await clientViaServiceAccount(
      credentials,
      ['https://www.googleapis.com/auth/cloud-platform'],
    );
  }

  Future<void> speak(String text) async {
    try {
      print("🔊 TTS 요청: $text"); // 요청 로그 확인
      await _authenticate(); // 인증 확인
      final String url = "https://texttospeech.googleapis.com/v1/text:synthesize";

      final Map<String, dynamic> requestPayload = {
        "input": {"text": text},
        "voice": {"languageCode": "ko-KR","name": "ko-KR-Wavenet-C", "ssmlGender": "MALE"},
        "audioConfig": {"audioEncoding": "MP3"}
      };

      final response = await _client!.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String audioContent = responseData["audioContent"];
        Uint8List audioBytes = base64Decode(audioContent);
        await _ttsPlayer.playAudio(audioBytes);
      } else {
        print("❌ TTS 요청 실패: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("⚠️ TTS 실행 중 오류 발생: $e");
    }
  }
}