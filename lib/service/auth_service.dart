import '../models/user_model.dart';
import 'api_service.dart';

class AuthResult {
  final UserModel user;
  final String token;

  AuthResult({required this.user, required this.token});
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
}
