import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

export 'auth_repository_impl.dart'
    if (dart.library.io) 'auth_repository_windows.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(SharedPreferences prefs) 
    : _authService = WindowsAuthService(prefs);

  Future<bool> signIn(String email, String password) async {
    return _authService.signIn(email, password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  bool get isAuthenticated => _authService.isAuthenticated;
} 