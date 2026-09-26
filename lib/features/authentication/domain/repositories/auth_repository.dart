import 'package:firebase_auth/firebase_auth.dart';

// WHAT: The contract (interface) for authentication.
// WHY: Clean architecture dictates the UI/BLoC should only talk to interfaces, not the actual Firebase implementation. This makes testing easy.
abstract class AuthRepository {
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> registerWithEmail(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Stream<User?> get authStateChanges;
}