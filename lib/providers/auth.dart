import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _tokenExpiryDate;
  String _userId;

  Future<void> _authenticate(
      {String email, String password, String urlSegment}) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBaKJZ9sucebzQnVSnWEztBWlTk3lc-26Q';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null){
        // this is firebase specific behaviour as it actully returns a status code 200 with error in the response body
        throw HttpException(responseData['error']['message']);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp({String email, String password}) async {
    return _authenticate(
        email: email, password: password, urlSegment: 'signUp');
  }

  Future<void> logIn({String email, String password}) async {
    // edit signup code to enable login
    return _authenticate(
        email: email, password: password, urlSegment: 'signInWithPassword');
  }
}
