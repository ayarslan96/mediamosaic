// This is a stub implementation of FirebaseAuth for platforms that don't support it
class FirebaseAuth {
  static final FirebaseAuth _instance = FirebaseAuth._();
  static FirebaseAuth get instance => _instance;

  FirebaseAuth._();

  User? get currentUser => null;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError('Firebase Auth is not supported on this platform');
  }

  Future<void> signOut() async {
    // No-op
  }
}

class User {
  final String? email;
  User({this.email});
}

class UserCredential {
  final User? user;
  UserCredential({this.user});
} 