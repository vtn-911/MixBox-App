import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'api_service.dart';

class AuthResult {
  final UserModel user;
  final String token;

  AuthResult({required this.user, required this.token});

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}

class AuthService {
  static Future<AuthResult> login(String email, String password) async {
    final response = await ApiService.post('/api/auth/login', {
      'email': email,
      'password': password,
    });
    final data = response['data'];
    final userJson = data['user'];
    final user = UserModel.fromJson(userJson);
    final token = data['token'];
    return AuthResult(user: user, token: token);
  }

  static Future<AuthResult> register(
    String fullname,
    String email,
    String password,
    File? file,
  ) async {
    final response = await ApiService.postMultipart(
      endpoint: '/api/auth/register',
      fields: {'full_name': fullname, 'email': email, 'password': password},
      file: file,
      fileField: 'avatar',
    );
    final data = jsonDecode(response.body);
    return AuthResult.fromJson(data['data']);
  }

  static const String tokenKey = 'token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);
    return token != null && token.isNotEmpty;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }
}
