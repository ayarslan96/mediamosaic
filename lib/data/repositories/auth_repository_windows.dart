import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final SharedPreferences _prefs;

  AuthRepository(this._prefs);

  Future<bool> signIn(String email, String password) async {
    // Simple authentication for Windows
    if (email.isNotEmpty && password.isNotEmpty) {
      await _prefs.setString('user_email', email);
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await _prefs.remove('user_email');
  }

  bool get isAuthenticated => _prefs.getString('user_email') != null;
} 