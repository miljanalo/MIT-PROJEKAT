import 'package:flutter/material.dart';
import 'package:knjizara/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isGuest = false;

  UserModel? _user;

  bool get isAuthenticated => _isAuthenticated;
  bool get isGuest => _isGuest;
  UserModel? get user => _user;
  bool get isAdmin => _user?.role == UserRole.admin;

  void register({
  required String name,
  required String email,
  required String password,
  }) {
    _isAuthenticated = true;
    _isGuest = false;
    _user = UserModel(
      name: name,
      email: email,
    );
    notifyListeners();
  }

  void login({
    required String email,
    required String password,
  }) {
    if (email == 'admin@knjizara.rs' && password == 'admin123') {
      _user = UserModel(
        name: 'Admin',
        email: email,
        role: UserRole.admin,
      );
    } else {
      _user = UserModel(
        name: 'Korisnik',
        email: email,
        role: UserRole.user,
      );
    }
    _isAuthenticated = true;
    _isGuest = false;
    notifyListeners();
  }

  void loginAsGuest() {
    _isAuthenticated = true;
    _isGuest = true;
    _user = null;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _isGuest = false;
    _user = null;
    notifyListeners();
  }
  
}
