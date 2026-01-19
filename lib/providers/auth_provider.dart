import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isGuest = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isGuest => _isGuest;

  void login() {
    _isAuthenticated = true;
    _isGuest = false;
    notifyListeners();
  }

  void loginAsGuest() {
    _isAuthenticated = true;
    _isGuest = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _isGuest = false;
    notifyListeners();
  }
}
