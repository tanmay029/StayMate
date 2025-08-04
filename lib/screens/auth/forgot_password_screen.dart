import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                'Reset Your Password',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24),
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading.value ? null : _sendResetLink,
                  child: isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Send Reset Link'),
                ),
              )),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Back to Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendResetLink() async {
    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }

    isLoading.value = true;
    
    // Mock API call
    await Future.delayed(Duration(seconds: 2));
    
    isLoading.value = false;
    
    Get.dialog(
      AlertDialog(
        title: Text('Reset Link Sent'),
        content: Text(
          'A password reset link has been sent to ${emailController.text}. Please check your email and follow the instructions to reset your password.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); 
              Get.back(); 
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
