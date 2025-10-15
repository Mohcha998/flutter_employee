import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:8000/api';

class AuthRepository {
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access']; // return access token
    }
    return null;
  }
}
