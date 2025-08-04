// screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Obx(() {
        final user = authController.currentUser.value;
        if (user == null) return Center(child: CircularProgressIndicator());

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          user.fullName.split(' ').map((n) => n[0]).take(2).join(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        user.fullName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Profile Options
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit Profile'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Get.toNamed('/edit-profile'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.lock),
                      title: Text('Change Password'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Get.toNamed('/change-password'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notifications'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Get.snackbar('Coming Soon', 'This feature will be available soon'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.help),
                      title: Text('Help & Support'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Get.snackbar('Coming Soon', 'This feature will be available soon'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.privacy_tip),
                      title: Text('Privacy Policy'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Get.snackbar('Coming Soon', 'This feature will be available soon'),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Logout Button
              Card(
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => _showLogoutDialog(),
                ),
              ),
              
              SizedBox(height: 20),
              
              // App Version
              Text(
                'StayMate v1.0.0',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/home');
              break;
            case 1:
              Get.toNamed('/bookings');
              break;
            case 2:
              // Already on profile
              break;
            case 3:
              Get.toNamed('/settings');
              break;
          }
        },
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
