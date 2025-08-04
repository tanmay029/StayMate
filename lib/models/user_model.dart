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
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
