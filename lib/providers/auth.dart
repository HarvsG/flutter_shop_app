import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _tokenExpiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    if (token != null) {
      print('isAuth got T') ;
      return true;
    } else {
      print('isAuth got F') ;
      return false;
    }
  }

  String get token {
    if (_tokenExpiryDate != null && _tokenExpiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String get userId {
    // if (_userId != null) {
      return _userId;
    // } else {
    //   return null;
    // }
  }

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
      if (responseData['error'] != null) {
        // this is firebase specific behaviour as it actully returns a status code 200 with error in the response body
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _tokenExpiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn']))) ;
      _autoLogout();
      notifyListeners();
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

  void logOut(){
    _token = null;
    _userId = null;
    _tokenExpiryDate = null;
    if (_authTimer != null){
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }
  void _autoLogout() {
    if (_authTimer != null){
      _authTimer.cancel();
    }
    final timetoexpiry = _tokenExpiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: 5), logOut);
  }
}
