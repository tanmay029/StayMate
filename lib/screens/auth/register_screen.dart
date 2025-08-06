// screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final authController = Get.find<AuthController>();
  
  // Password visibility states
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Full Name Field
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
              
              // Email Field
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
              
              // Password Field with Eye Icon
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible 
                          ? Icons.visibility 
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
              
              SizedBox(height: 16),
              
              // Confirm Password Field with Eye Icon
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible 
                          ? Icons.visibility 
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: !_isConfirmPasswordVisible,
              ),
              
              SizedBox(height: 24),
              
              // Create Account Button
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () => _handleRegister(),
                  child: authController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Create Account'),
                ),
              )),
              
              SizedBox(height: 16),
              
              // OR Divider
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Google Sign Up Button
              Obx(() => SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: authController.isLoading.value
                      ? null
                      : () => _handleGoogleSignIn(),
                  icon: Icon(Icons.g_mobiledata, size: 24),
                  label: Text('Sign up with Google'),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (!_validateForm()) return;

    // Just call register - AuthController will handle navigation to welcome page
    await authController.register(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }

  void _handleGoogleSignIn() async {
    // Just call signInWithGoogle - AuthController will handle navigation to welcome page
    await authController.signInWithGoogle();
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
    if (passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return false;
    }
    return true;
  }
}
