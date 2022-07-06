import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/exceptions/Http_exception.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        DateTime.now().isAfter(_expiryDate as DateTime) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlPath) async {
    final Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/$urlPath?key=AIzaSyAsFdhxhKwoP1q4k4K4_nezRWCwbUHEzDg');
    try {
      final http.Response response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final Map body = json.decode(response.body);
      if (body['error'] != null) {
        throw HttpException(body['error']['message']);
      }
      _token = body['idToken'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            body['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'accounts:signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'accounts:signInWithPassword');
  }
}
