// screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authController = Get.find<AuthController>();
  
  // Password visibility state
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              
              SizedBox(height: 24),
              Text(
                'Welcome to StayMate',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              
              SizedBox(height: 48),
              
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
              
              SizedBox(height: 24),
              
              // Sign In Button
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () => _handleEmailLogin(),
                  child: authController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Sign In'),
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
              
              // Google Sign In Button
              Obx(() => SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: authController.isLoading.value
                      ? null
                      : () => _handleGoogleSignIn(),
                  icon: Icon(Icons.g_mobiledata, size: 24),
                  label: Text('Sign in with Google'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )),
              
              SizedBox(height: 16),
              
              // Navigation Links
              TextButton(
                onPressed: () => Get.toNamed('/register'),
                child: Text('Don\'t have an account? Sign Up'),
              ),
              TextButton(
                onPressed: () => Get.toNamed('/forgot-password'),
                child: Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleEmailLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    // Just call login - AuthController will handle navigation to welcome page
    await authController.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }

  void _handleGoogleSignIn() async {
    // Just call signInWithGoogle - AuthController will handle navigation to welcome page
    await authController.signInWithGoogle();
  }
}
