import 'package:flutter/material.dart';
import 'dart:async';

import 'analysis_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String imagePath;

  const LoadingScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final List<Map<String, String>> quizData = [
    {"question": "이 작품을 그린 화가는 누구일까요?", "answer": "빈센트 반 고흐", "info": "고흐는 '별이 빛나는 밤'을 정신병원에서 그렸어요!"},
    {"question": "이 그림이 그려진 연도는?", "answer": "1889년", "info": "이 작품은 고흐가 프랑스에서 머무르던 시절의 작품이에요."},
    {"question": "이 작품의 주요 색상은?", "answer": "파랑과 노랑", "info": "고흐는 감정을 표현하기 위해 색채를 강하게 사용했어요!"},
    {"question": "이 작품의 소재는 무엇인가요?", "answer": "밤하늘과 마을", "info": "이 그림은 고흐가 창밖 풍경을 보고 그린 작품이에요!"}
  ];

  late Map<String, String> currentQuiz1;
  late Map<String, String> currentQuiz2;
  int step = 0;

  @override
  void initState() {
    super.initState();
    _startQuiz();

    Timer(Duration(seconds: 30), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AnalysisScreen(imagePath: widget.imagePath)),
        );
      }
    });
  }

  void _startQuiz() {
    setState(() {
      var selectedQuizzes = quizData..shuffle();
      currentQuiz1 = selectedQuizzes[0];
      currentQuiz2 = selectedQuizzes[1];
      step = 0;
    });

    Timer(Duration(seconds: 5), () {
      setState(() => step = 1);
      Timer(Duration(seconds: 5), () {
        setState(() => step = 2);
        Timer(Duration(seconds: 5), () {
          setState(() => step = 3);
          Timer(Duration(seconds: 5), () {
            setState(() => step = 4);
            Timer(Duration(seconds: 5), () {
              setState(() => step = 5);
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 📢 퀴즈 안내 문구 (추가)
            const Text(
              "AI 분석이 끝날 때까지 퀴즈를 풀어보아요!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // 🖼️ 명화 이미지
            Image.asset('assets/recommand_img.png', height: 300),

            const SizedBox(height: 24),

            // ❓ 퀴즈 질문, 정답, 정보 (가운데 정렬 + 박스 추가)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: Text(
                  step == 0 ? currentQuiz1["question"]! :
                  step == 1 ? currentQuiz1["answer"]! :
                  step == 2 ? currentQuiz1["info"]! :
                  step == 3 ? currentQuiz2["question"]! :
                  step == 4 ? currentQuiz2["answer"]! :
                  currentQuiz2["info"]!,
                  key: ValueKey(step),
                  textAlign: TextAlign.center, // ✅ 텍스트 중앙 정렬
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 📢 "AI가 분석 중입니다..." (아래로 이동)
            const Text(
              "AI가 분석 중입니다...",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),

            const SizedBox(height: 24),

            // ⏳ 로딩 애니메이션
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
