import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _googleSignIn = googleSignIn;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Authentication failed');
    }
  }

  @override
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed');
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      // 1. Authentication (Identity) - v7 syntax replaces signIn() with authenticate()
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();
      if (googleUser == null) return null;

      // 2. Authorization (Permissions) - v7 syntax requires explicit scope requests for access tokens
      final clientAuth = await googleUser.authorizationClient.authorizeScopes([
        'email',
        'profile',
      ]);

      // Obtain the ID token (we use await in case your specific dart version treats it as a Future)
      final googleAuth = await googleUser.authentication;

      // 3. Create a new Firebase credential combining both tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: clientAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to send reset email');
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
