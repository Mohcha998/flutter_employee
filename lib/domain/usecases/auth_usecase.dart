import '../../data/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUsecase {
  final AuthRepository repository;
  AuthUsecase(this.repository);

  Future<String?> login(String email, String password) async {
    final token = await repository.login(email, password);
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);
    }
    return token;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}
