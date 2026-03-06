import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Constructor to listen to auth changes
  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign Up
  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signUp(email, password);
      _setLoading(false);
      return true; // Success
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false; // Failed
    }
  }

  // Sign In
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    try {
      User? user = await _authService.signIn(email, password);

      // Email Verification Check (Rubric Requirement)
      if (user != null && !user.emailVerified) {
        _errorMessage = "Please verify your email address before logging in.";
        await _authService.signOut(); // Force logout
        _setLoading(false);
        return false;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null; // Clear errors on new action
    notifyListeners();
  }
}
