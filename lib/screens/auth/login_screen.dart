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
                child: Icon(Icons.home_rounded, color: Colors.white, size: 50),
              ),

              SizedBox(height: 24),
              Text(
                'Welcome to StayMate',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        authController.isLoading.value
                            ? null
                            : () => _handleEmailLogin(),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        authController.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
              ),

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
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed:
                        authController.isLoading.value
                            ? null
                            : () => _handleGoogleSignIn(),
                    icon: Icon(Icons.g_mobiledata, size: 24),
                    label: Text('Sign in with Google'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12),

              // Guest Login Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed:
                        authController.isLoading.value
                            ? null
                            : () => _handleGuestLogin(),
                    icon: Icon(Icons.person_outline, color: Colors.grey[600]),
                    label: Text(
                      'Continue as Guest',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      backgroundColor: Colors.grey[50],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Navigation Links
              TextButton(
                onPressed: () => Get.toNamed('/register'),
                child: Text('Don\'t have an account? Sign Up'),
              ),
              TextButton(
                onPressed: () => Get.toNamed('/forgot-password'),
                child: Text('Forgot Password?'),
              ),

              // Guest Login Information
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Guest users can browse properties but need to sign up to make bookings.',
                        style: TextStyle(color: Colors.blue[700], fontSize: 12),
                      ),
                    ),
                  ],
                ),
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

  void _handleGuestLogin() async {
    // Show confirmation dialog for guest login
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.person_outline, color: Get.theme.primaryColor),
            SizedBox(width: 8),
            Text('Guest Mode'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Continue as a guest?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            Text(
              'As a guest, you can:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            _buildFeatureItem('✓ Browse all properties', Colors.green),
            _buildFeatureItem('✓ View property details', Colors.green),
            _buildFeatureItem('✓ Search and filter', Colors.green),
            _buildFeatureItem('✓ Check dummy bookings already done', Colors.green),
            SizedBox(height: 8),
            // Text(
            //   'To unlock full features:',
            //   style: TextStyle(fontWeight: FontWeight.w500),
            // ),
            // SizedBox(height: 8),
            // _buildFeatureItem('✗ Make bookings', Colors.orange),
            // _buildFeatureItem('✗ Save favorites', Colors.orange),
            // _buildFeatureItem('✗ Write reviews', Colors.orange),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Continue as Guest'),
          ),
        ],
      ),
    );

    if (result == true) {
      // Call guest login method in AuthController
      await authController.loginAsGuest();
    }
  }

  Widget _buildFeatureItem(String text, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            text.substring(0, 1),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(text.substring(2), style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
