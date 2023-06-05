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

  static String? get accessToken => _instance?._user?.accessToken;
  String? get refreshToken => _user?.refreshToken;

  static AuthProvider? _instance;

  AuthProvider() {
    _instance = this;
  }

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
      final accessToken = responseData['access'];
      final refreshToken = responseData['refresh'];

      if (accessToken != null) {
        _user = User(
          username: username, 
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        notifyListeners();
      } else {
        throw Exception('Failed to get access token');
      }
    } else {
      throw Exception('Failed to login');
    }
  } catch (error) {
    print('Login failed: $error');
    rethrow;
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
