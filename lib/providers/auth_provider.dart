import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knjizara/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isAuthenticated = false;
  bool _isGuest = false;

  UserModel? _user;

  bool get isAuthenticated => _isAuthenticated;
  bool get isGuest => _isGuest;
  UserModel? get user => _user;
  bool get isAdmin => _user?.role == UserRole.admin;

  // registracija

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try{
      final userCredential =
        await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        final uid = userCredential.user!.uid;

        await _firestore.collection('users').doc(uid).set({
          'name': name,
          'email': email.trim(),
          'role': 'user',
        });

        _user = UserModel(
          id: uid,
          name: name,
          email: userCredential.user!.email!,
          role: UserRole.user,
        );

        _isAuthenticated = true;
        _isGuest = false;

        notifyListeners();
      } on FirebaseAuthException catch (e) {
        throw e.message ?? 'Greška pri registraciji';
      }
  }

  // login

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try{
      final userCredential =
        await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
      );

      final uid = userCredential.user!.uid;

      final userDoc =
        await _firestore.collection('users').doc(uid).get();

      final data = userDoc.data();

      _user = UserModel(
        id: uid,
        name: data?['name'] ?? 'Korisnik',
        email: userCredential.user!.email!,
        role: data?['role'] == 'admin'
          ? UserRole.admin
          : UserRole.user,
      );
    
      _isAuthenticated = true;
      _isGuest = false;

      notifyListeners();
    }on FirebaseAuthException catch (e) {
      throw e.message ?? 'Greška pri prijavi';
    }
  }

  // guest login

  void loginAsGuest() {
    _isAuthenticated = true;
    _isGuest = true;
    _user = null;
    notifyListeners();
  }

  // logout

  Future<void> logout() async {
    await _auth.signOut();
    _isAuthenticated = false;
    _isGuest = false;
    _user = null;
    notifyListeners();
  }

  // automatsko logovanje

  Future<void> initAuth() async {
  final currentUser = _auth.currentUser;

  if (currentUser == null) {
    _isAuthenticated = false;
    _isGuest = false;
    _user = null;
    notifyListeners();
    return;
  }

  try {
    final userDoc = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    final data = userDoc.data();

    final role = data?['role'] ?? 'user';

    _user = UserModel(
      id: currentUser.uid,
      name: data?['name'] ?? 'Korisnik',
      email: currentUser.email!,
      role: role == 'admin'
          ? UserRole.admin
          : UserRole.user,
    );

    _isAuthenticated = true;
    _isGuest = false;

    notifyListeners();
  } catch (e) {
    await _auth.signOut();
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }
}

}
