import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class User {
  final String username;
  final String accessToken;
  final String? refreshToken;

  User({
    required this.username,
    required this.accessToken,
    this.refreshToken,
  });
}

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;
  String? get username => _user?.username;
  String? get accessToken => _user?.accessToken;
  String? get refreshToken => _user?.refreshToken;

 Future<void> login(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final username = responseData['username'];
      final accessToken = responseData['token'];
      // Remove the line that assigns 'refreshToken'

      if (username != null && accessToken != null) {
        _user = User(
          username: username,
          accessToken: accessToken,
          // Remove the line that assigns 'refreshToken'
        );
        notifyListeners();
      } else {
        throw Exception('Failed to get user data');
      }
    } else {
      throw Exception('Failed to login');
    }
  } catch (error) {
    print('Login failed: $error');
    throw error;
  }
}

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/logout/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${_user?.accessToken}',
      },
      body: jsonEncode(<String, String>{
        'refresh_token': _user?.refreshToken ?? '',
      }),
    );

    if (response.statusCode == 200) {
      _user = null;
      notifyListeners();
    } else {
      throw Exception('Failed to logout');
    }
  }
}
