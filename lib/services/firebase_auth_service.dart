import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class FirebaseAuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  firebase_auth.User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<firebase_auth.UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      firebase_auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await result.user?.updateDisplayName(fullName);
      await result.user?.reload();

      return result;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    }
  }

  // Sign in with email and password
  Future<firebase_auth.UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    }
  }

  // Google Sign In
  Future<firebase_auth.UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Create a new credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      Get.snackbar('Error', 'Google Sign-In failed: ${e.toString()}');
      return null;
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Handle Firebase Auth exceptions
  void _handleAuthException(firebase_auth.FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'weak-password':
        message = 'The password provided is too weak.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists for that email.';
        break;
      case 'user-not-found':
        message = 'No user found for that email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided.';
        break;
      case 'invalid-email':
        message = 'The email address is not valid.';
        break;
      case 'user-disabled':
        message = 'This user account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many requests. Try again later.';
        break;
      default:
        message = 'An error occurred: ${e.message}';
    }
    Get.snackbar('Authentication Error', message);
  }
}
