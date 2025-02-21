import 'package:flutter/material.dart';
import 'dart:io';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../services/tts_service.dart';

class VtsScreen extends StatefulWidget {
  final String imagePath;

  const VtsScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _VtsScreenState createState() => _VtsScreenState();
}

class _VtsScreenState extends State<VtsScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TTSService _ttsService = TTSService(); // ✅ TTSService 인스턴스 생성

  bool _isListening = false;
  String _text = "";

  List<Map<String, String>> conversation = [
    {"question": "이 작품에서 무엇이 보이나요?", "response": ""}
  ];

  Future<void> _startVoiceRecognition() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('STT 상태: $status'),
      onError: (error) => print('STT 오류: $error'),
    );

    if (available) {
      setState(() => _isListening = true);

      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
      );
    }
  }

  void _stopVoiceRecognition() {
    _speech.stop();
    setState(() {
      _isListening = false;

      if (_text.isNotEmpty) {
        // 사용자의 STT 결과를 질문으로 변경
        conversation.last["question"] = _text;

        // AI 응답 추가 (임시로 "인공지능의 답변입니다.")
        String aiResponse = "인공지능의 답변입니다.";
        conversation.last["response"] = aiResponse;

        // ✅ TTS 인스턴스를 사용하여 AI 응답 읽기
        _ttsService.speak(aiResponse);

        // 새로운 질문 추가
        conversation.add({"question": "이 작품에서 무엇이 보이나요?", "response": ""});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'VTS 대화',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 상단 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(widget.imagePath),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // ✅ 대화 블록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: conversation.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    // 질문 (왼쪽 정렬)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildMessageBlock(conversation[index]["question"]!),
                    ),
                    const SizedBox(height: 6),

                    // 응답 (오른쪽 정렬)
                    if (conversation[index]["response"]!.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildResponseBlock(conversation[index]["response"]!),
                      ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),

          // ✅ 마이크 버튼
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Center(
              child: GestureDetector(
                onTap: _isListening ? _stopVoiceRecognition : _startVoiceRecognition,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening ? Colors.red : const Color(0xFF1E40AF),
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 56,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 질문 블록 (왼쪽 정렬)
  Widget _buildMessageBlock(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF1E40AF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // ✅ 응답 블록 (오른쪽 정렬)
  Widget _buildResponseBlock(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(left: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}
