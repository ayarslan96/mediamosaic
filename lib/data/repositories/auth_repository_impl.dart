import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SharedPreferences _prefs;

  AuthRepository(this._prefs);

  Future<bool> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  bool get isAuthenticated => _auth.currentUser != null;
} 