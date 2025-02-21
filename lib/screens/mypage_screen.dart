
import 'package:flutter/material.dart';
import '../services/user_service.dart'; // 위에서 작성한 파일 import
import 'mycollection_screen.dart';  // DiaryPage 위젯을 import (이미 사용 중인 것으로 가정)
import '../services/storage_service.dart';
import 'login_screen.dart';

class MyPageScreen extends StatefulWidget {
  //final String token; // 로그인 시 전달받은 JWT 토큰
  //const MyPageScreen({super.key, required this.token});
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // secureStorage에서 'jwt_token' 키로 저장된 토큰을 읽어옵니다.
      token = await secureStorage.read(key: 'jwt_token');
      if (token == null) {
        throw Exception("토큰이 없습니다. 다시 로그인 해주세요.");
      }
      final data = await UserService.fetchUserData(token!);
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        barrierDismissible: false, // 사용자가 다이얼로그를 닫지 못하도록 함
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              '알림',
              textAlign: TextAlign.center,
            ),
            content: Text(
              '사용자 정보를 불러오지 못했습니다: $e',
              textAlign: TextAlign.center,
            ),
          );
        },
      );

// AlertDialog 표시 후 2초 후에 자동으로 다이얼로그를 닫고 로그인 화면으로 이동
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // 다이얼로그 닫기
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      });
    }
  }
  Future<void> _handleLogout() async {
    await secureStorage.delete(key: 'jwt_token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            //print("뒤로가기");
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "마이페이지",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              // 프로필 섹션
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // API로부터 받아온 사용자 아이디 (name)
                      Text(
                        userData != null ? userData!["name"] : "이름 없음",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // API로부터 받아온 회원가입 날짜 (created_at)
                      Text(
                        userData != null ? "가입일: ${userData!["created_at"]}" : "",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              // 감상한 작품수 & VTS 참여 섹션 (내용 그대로 유지)
              Row(
                children: [
                  Expanded(
                    child: infoCard("337", "감상한 작품수"),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: infoCard("337", "VTS 참여"),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              // 설정 버튼 리스트
              settingButton(
                "감상 일기",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DiaryPage()),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              settingButton(
                  "학습 진도",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          '알림',
                          textAlign: TextAlign.center,
                        ),
                        content: const Text(
                          '서비스 준비중 입니다.',
                          textAlign: TextAlign.center,
                        ),
                        actionsAlignment: MainAxisAlignment.center, // 액션 버튼들을 가운데 정렬
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 다이얼로그 닫기
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                }
              ),
              SizedBox(height: screenHeight * 0.02),
              settingButton(
                  "알림 설정",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            '알림',
                            textAlign: TextAlign.center,
                          ),
                          content: const Text(
                            '서비스 준비중 입니다.',
                            textAlign: TextAlign.center,
                          ),
                          actionsAlignment: MainAxisAlignment.center, // 액션 버튼들을 가운데 정렬
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  }
              ),
              SizedBox(height: screenHeight * 0.02),
              settingButton(
                  "접근성 설정",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            '알림',
                            textAlign: TextAlign.center,
                          ),
                          content: const Text(
                            '서비스 준비중 입니다.',
                            textAlign: TextAlign.center,
                          ),
                          actionsAlignment: MainAxisAlignment.center, // 액션 버튼들을 가운데 정렬
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  }
              ),
              // 로그아웃 버튼 (빨간색)
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // 배경색 빨간색
                  foregroundColor: Colors.white, // 텍스트 색상 흰색
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleLogout,
                child: const Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1E40AF),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget settingButton(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1E40AF),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3B82F6),
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}