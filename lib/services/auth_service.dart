import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_concepts/services/mock_api.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final http.Client _client = MockApi.getClient();
  bool _isLoggedIn = false;

  // Getter to check logged-in status
  bool get isLoggedIn => _isLoggedIn;

  // Login using the mock HTTP client
  Future<bool> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('https://api.example.com/login'),
        headers: {'content-type': 'application/json; charset=utf-8'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        _isLoggedIn = true;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    _isLoggedIn = false;
  }
}
