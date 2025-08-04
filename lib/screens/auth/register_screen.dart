// screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_validateForm()) {
                      final success = await authController.register(
                        fullNameController.text,
                        emailController.text,
                        phoneController.text,
                        passwordController.text,
                      );
                      if (success) {
                        Get.offAllNamed('/home');
                      }
                    }
                  },
                  child: Text('Create Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    if (fullNameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your full name');
      return false;
    }
    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return false;
    }
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number');
      return false;
    }
    if (passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return false;
    }
    return true;
  }
}
