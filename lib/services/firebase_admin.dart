import 'dart:io';
import 'dart:convert';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:path/path.dart' as path;

class FirebaseAdminService {
  static FirebaseAdminService? _instance;
  late App _app;

  FirebaseAdminService._();

  static FirebaseAdminService get instance {
    _instance ??= FirebaseAdminService._();
    return _instance!;
  }

  Future<void> initialize() async {
    try {
      // Read the service account JSON file
      final credentialsFile = File(path.join(Directory.current.path, 'config', 'service-account.json'));
      if (!await credentialsFile.exists()) {
        throw Exception('Firebase credentials file not found. Please place your service-account.json file in the config directory.');
      }

      final credentialsJson = await credentialsFile.readAsString();
      final cert = ServiceAccount.fromJson(json.decode(credentialsJson));

      _app = FirebaseAdmin.instance.initializeApp(
        AppOptions(
          credential: cert,
          projectId: 'mediamosaic',
        ),
      );
      print('Firebase Admin SDK initialized successfully');
    } catch (e) {
      print('Error initializing Firebase Admin SDK: $e');
      rethrow;
    }
  }

  // Admin SDK Authentication Methods
  Future<UserRecord> getUserById(String uid) async {
    try {
      return await _app.auth().getUser(uid);
    } catch (e) {
      print('Error getting user by ID: $e');
      rethrow;
    }
  }

  Future<UserRecord> getUserByEmail(String email) async {
    try {
      return await _app.auth().getUserByEmail(email);
    } catch (e) {
      print('Error getting user by email: $e');
      rethrow;
    }
  }

  Future<void> setCustomUserClaims(String uid, Map<String, dynamic> claims) async {
    try {
      await _app.auth().setCustomUserClaims(uid, claims);
    } catch (e) {
      print('Error setting custom claims: $e');
      rethrow;
    }
  }

  Future<String> createCustomToken(String uid, [Map<String, dynamic>? claims]) async {
    try {
      return await _app.auth().createCustomToken(uid, claims);
    } catch (e) {
      print('Error creating custom token: $e');
      rethrow;
    }
  }

  Future<void> revokeRefreshTokens(String uid) async {
    try {
      await _app.auth().revokeRefreshTokens(uid);
    } catch (e) {
      print('Error revoking refresh tokens: $e');
      rethrow;
    }
  }

  Future<ListUsersResult> listUsers([int? maxResults, String? pageToken]) async {
    try {
      return await _app.auth().listUsers(maxResults, pageToken);
    } catch (e) {
      print('Error listing users: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _app.auth().deleteUser(uid);
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  Future<void> testConnection() async {
    try {
      // Try to list users (limit to 1) to test the connection
      final users = await listUsers(1);
      print('Firebase Admin SDK connection test successful');
      print('Found ${users.users.length} users');
    } catch (e) {
      print('Firebase Admin SDK connection test failed: $e');
      rethrow;
    }
  }
} 