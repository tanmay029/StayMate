
// models/user_model.dart
class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final bool isGuest;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.isGuest = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'isGuest': isGuest,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      isGuest: json['isGuest'] ?? false,
    );
  }
}
