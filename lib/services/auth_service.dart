// auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // 로그인
  static Future<String?> login(String name, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        print('로그인 실패: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('로그인 요청 중 오류 발생: $e');
      return null;
    }
  }

  // 회원가입
  static Future<bool> register(String name, String password) async {
    final url = Uri.parse('$baseUrl/auth/signup');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'password': password}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('회원가입 실패: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('회원가입 요청 중 오류 발생: $e');
      return false;
    }
  }

  // 내 정보 조회
  static Future<void> fetchUserInfo(String token) async {
    final url = Uri.parse('$baseUrl/user/get');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('사용자 정보: $data');
      // 받아온 사용자 정보를 활용하는 로직
    } else {
      print('사용자 정보 불러오기 실패: ${response.statusCode} ${response.body}');
    }
  }
}