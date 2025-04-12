import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Future<bool> signIn(String email, String password);
  Future<void> signOut();
  bool get isAuthenticated;
}

class WindowsAuthService implements AuthService {
  final SharedPreferences _prefs;
  bool _isAuthenticated = false;

  WindowsAuthService(this._prefs);

  @override
  Future<bool> signIn(String email, String password) async {
    // For testing purposes, accept any non-empty credentials
    if (email.isNotEmpty && password.isNotEmpty) {
      await _prefs.setString('user_email', email);
      _isAuthenticated = true;
      return true;
    }
    return false;
  }

  @override
  Future<void> signOut() async {
    await _prefs.remove('user_email');
    _isAuthenticated = false;
  }

  @override
  bool get isAuthenticated => _isAuthenticated;
}

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<bool> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  bool get isAuthenticated => _auth.currentUser != null;
} 