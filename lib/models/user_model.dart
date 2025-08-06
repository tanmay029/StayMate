import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  // Factory constructor for creating User from Firebase User
  factory User.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      fullName: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      phone: '', // Firebase Auth doesn't store phone by default
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
