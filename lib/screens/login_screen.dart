// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'mypage_screen.dart';
//
// void main() {
//   runApp(const ArtChatApp());
// }
//
// class ArtChatApp extends StatelessWidget {
//   const ArtChatApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const LoginScreen(),
//     );
//   }
// }
//
// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'ArtChemy',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1E40AF),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 const Text(
//                   '작품 감상의 새로운 경험',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 buildInputField('아이디'),
//                 const SizedBox(height: 20),
//                 buildInputField('비밀번호', isPassword: true),
//                 const SizedBox(height: 30),
//                 buildButton(
//                   '로그인',
//                   const Color(0xFF1E40AF),
//                   Colors.white,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const MyPageScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 buildButton(
//                   '회원가입',
//                   Colors.white,
//                   const Color(0xFF1E40AF),
//                   border: true,
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'or',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 buildKakaoButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildInputField(String label, {bool isPassword = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1E40AF),
//           ),
//         ),
//         const SizedBox(height: 5),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: Color(0xFF1E40AF), width: 2),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: TextField(
//               obscureText: isPassword,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget buildButton(String text, Color bgColor, Color textColor, {bool border = false, VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         decoration: BoxDecoration(
//           color: border ? Colors.white : bgColor,
//           border: border ? Border.all(color: bgColor, width: 2) : null,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: textColor,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildKakaoButton() {
//     return GestureDetector(
//       onTap: () {
//         // 카카오 로그인 로직 구현
//         print('카카오 로그인 클릭');
//       },
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFEE500),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SvgPicture.asset(
//               'assets/kakao_icon.svg',
//               height: 20,
//               width: 20,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(width: 8),
//             const Text(
//               '카카오 로그인',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_screen.dart';
import '../services/auth_service.dart'; // auth_service.dart 파일 import
import '../services/storage_service.dart';
import 'signup_screen.dart';

void main() {
  runApp(const ArtChatApp());
}

class ArtChatApp extends StatelessWidget {
  const ArtChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

// LoginScreen을 StatefulWidget으로 전환하여 텍스트 입력값을 관리합니다.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 아이디(또는 이름)와 비밀번호를 위한 TextEditingController 생성
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 로그인 버튼을 눌렀을 때 호출되는 함수
  void _handleLogin() async {
    final name = _idController.text;
    final password = _passwordController.text;
    final token = await AuthService.login(name, password);
    if (token != null) {
      // secure storage에 토큰 저장
      await secureStorage.write(key: 'jwt_token', value: token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(token: token),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패. 다시 시도해주세요.')),
      );
    }
  }

  // 회원가입 버튼을 눌렀을 때 호출되는 함수
  // void _handleRegister() async {
  //   final name = _idController.text;
  //   final password = _passwordController.text;
  //   final success = await AuthService.register(name, password);
  //   if (success) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('회원가입 성공. 로그인 해주세요.')),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('회원가입 실패. 다시 시도해주세요.')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드가 올라올 때 화면 밀림 방지
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView( // 화면이 작을 때 스크롤 가능하도록 함
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
                  const SizedBox(height: 30),
                  buildButton(
                    '로그인',
                    const Color(0xFF1E40AF),
                    Colors.white,
                    onTap: _handleLogin,
                  ),
                  const SizedBox(height: 10),
                  buildButton(
                    '회원가입',
                    Colors.white,
                    const Color(0xFF1E40AF),
                    border: true,
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen())
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'or',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildKakaoButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TextField에 텍스트 입력값을 제어하기 위해 controller를 받도록 수정
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
            SvgPicture.asset(
              'assets/kakao_icon.svg',
              height: 20,
              width: 20,
              fit: BoxFit.contain,
            ),
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
}