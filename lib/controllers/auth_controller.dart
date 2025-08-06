// controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final _box = GetStorage();
  
  final isLoggedIn = false.obs;
  final currentFirebaseUser = Rxn<firebase_auth.User>();
  final currentUser = Rxn<User>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToAuthState();
  }

  void _listenToAuthState() {
    _authService.authStateChanges.listen((firebase_auth.User? firebaseUser) {
      if (firebaseUser != null) {
        currentFirebaseUser.value = firebaseUser;
        isLoggedIn.value = true;
        
        // Convert Firebase User to your custom User model
        currentUser.value = User(
          id: firebaseUser.uid,
          fullName: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          phone: '',
        );
        
        _saveUserToStorage(firebaseUser);
      } else {
        currentFirebaseUser.value = null;
        currentUser.value = null;
        isLoggedIn.value = false;
        _clearUserFromStorage();
      }
    });
  }

  // Add this method to your controllers/auth_controller.dart

Future<bool> loginAsGuest() async {
  try {
    isLoading.value = true;
    
    // Create a temporary guest user
    currentUser.value = User(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      fullName: 'Guest User',
      email: 'guest@staymate.com',
      phone: '',
      isGuest: true, // Add this field to your User model
    );
    
    isLoggedIn.value = true;
    
    Get.snackbar(
      'Welcome!', 
      'You\'re browsing as a guest. Sign up to unlock all features!',
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
    );
    
    // Navigate to welcome page (or directly to home if you prefer)
    Get.offAllNamed(Routes.WELCOME);
    return true;
    
  } catch (e) {
    Get.snackbar('Error', 'Failed to continue as guest: ${e.toString()}');
    return false;
  } finally {
    isLoading.value = false;
  }
}


  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      
      final result = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (result != null) {
        Get.snackbar('Success', 'Account created successfully!');
        // Always go to welcome page after registration
        Get.offAllNamed(Routes.WELCOME);
        return true;
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      
      final result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result != null) {
        Get.snackbar('Success', 'Logged in successfully!');
        // Always go to welcome page after login
        Get.offAllNamed(Routes.WELCOME);
        return true;
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      isLoading.value = true;
      
      final result = await _authService.signInWithGoogle();
      
      if (result != null) {
        Get.snackbar('Success', 'Signed in with Google successfully!');
        // Always go to welcome page after Google sign-in
        Get.offAllNamed(Routes.WELCOME);
        return true;
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;
      return await _authService.sendPasswordResetEmail(email);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout: ${e.toString()}');
    }
  }

  void _saveUserToStorage(firebase_auth.User user) {
    final userData = {
      'uid': user.uid,
      'email': user.email ?? '',
      'displayName': user.displayName ?? '',
      'photoURL': user.photoURL ?? '',
    };
    _box.write('firebase_user', userData);
  }

  void _clearUserFromStorage() {
    _box.remove('firebase_user');
  }

  // Helper methods to get user info safely
  String get userDisplayName {
    return currentUser.value?.fullName ?? 
           currentFirebaseUser.value?.displayName ?? 
           currentFirebaseUser.value?.email ?? 
           'User';
  }

  String get userEmail {
    return currentUser.value?.email ?? 
           currentFirebaseUser.value?.email ?? 
           '';
  }
}


