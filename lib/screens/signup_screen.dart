import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    final name = _idController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmController.text;

    if (password != confirmPassword) {
      // 비밀번호가 일치하지 않으면 에러 다이얼로그 표시
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('오류', textAlign: TextAlign.center),
          content: const Text('비밀번호가 일치하지 않습니다.', textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
      return;
    }

    // 회원가입 API 호출 (AuthService.register)
    final success = await AuthService.register(name, password);
    if (success) {
      // 회원가입 성공 AlertDialog (2초 후 자동 닫힘 후 로그인 화면으로 이동)
      showDialog(
        context: context,
        barrierDismissible: false, // 사용자가 다이얼로그를 직접 닫지 못하게 함
        builder: (context) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop(); // AlertDialog 닫기
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
            );
          });
          return AlertDialog(
            title: const Text('회원가입 완료', textAlign: TextAlign.center),
            content: const Text('회원가입이 성공적으로 완료되었습니다!', textAlign: TextAlign.center),
          );
        },
      );
    } else {
      // 회원가입 실패 AlertDialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('회원가입 실패', textAlign: TextAlign.center),
          content: const Text('회원가입에 실패하였습니다. 다시 시도해주세요.', textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  Widget buildInputField(String label, {bool isPassword = false, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E40AF),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF1E40AF), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: Colors.black,
              ),
              obscureText: isPassword,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButton(String text, Color bgColor, Color textColor, {bool border = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: border ? Colors.white : bgColor,
          border: border ? Border.all(color: bgColor, width: 2) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildKakaoButton() {
    return GestureDetector(
      onTap: () {
        // 카카오 로그인 로직 구현
        print('카카오 로그인 클릭');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE500),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SvgPicture.asset('assets/kakao_icon.svg', ...) 사용 시,
            // 해당 자산이 pubspec.yaml에 등록되어 있어야 합니다.
            const SizedBox(width: 8),
            const Text(
              '카카오 로그인',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ArtChemy',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '작품 감상의 새로운 경험',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),
                  buildInputField('아이디', controller: _idController),
                  const SizedBox(height: 20),
                  buildInputField('비밀번호', isPassword: true, controller: _passwordController),
                  const SizedBox(height: 20),
                  buildInputField('비밀번호 확인', isPassword: true, controller: _confirmController),
                  const SizedBox(height: 30),
                  buildButton(
                    '회원가입',
                    const Color(0xFF1E40AF),
                    Colors.white,
                    onTap: _handleSignup,
                  ),
                  const SizedBox(height: 10),
                  buildButton(
                    '뒤로 가기',
                    Colors.white,
                    const Color(0xFF1E40AF),
                    border: true,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}