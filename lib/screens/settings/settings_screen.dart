import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Obx(() => SwitchListTile(
                  title: Text('Dark Mode'),
                  subtitle: Text(
                    themeController.isDarkMode.value 
                        ? 'Using dark theme' 
                        : 'Using light theme'
                  ),
                  secondary: Icon(
                    themeController.isDarkMode.value 
                        ? Icons.dark_mode 
                        : Icons.light_mode,
                    color: Theme.of(context).primaryColor,
                  ),
                  value: themeController.isDarkMode.value,
                  onChanged: (value) {
                    themeController.changeThemeMode(value);
                  },
                )),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // App Info Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'App Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Version'),
                  subtitle: Text('1.0.0'),
                  leading: Icon(Icons.info_outline),
                ),
                ListTile(
                  title: Text('Privacy Policy'),
                  leading: Icon(Icons.privacy_tip_outlined),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Get.snackbar('Coming Soon', 'This feature will be available soon'),
                ),
                ListTile(
                  title: Text('Terms of Service'),
                  leading: Icon(Icons.description_outlined),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Get.snackbar('Coming Soon', 'This feature will be available soon'),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Support Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Support',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Help Center'),
                  leading: Icon(Icons.help_outline),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Get.snackbar('Coming Soon', 'This feature will be available soon'),
                ),
                ListTile(
                  title: Text('Contact Us'),
                  leading: Icon(Icons.contact_support_outlined),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Get.snackbar('Coming Soon', 'This feature will be available soon'),
                ),
                ListTile(
                  title: Text('Rate App'),
                  leading: Icon(Icons.star_outline),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Get.snackbar('Thank You!', 'Thanks for your feedback'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
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
              Get.offNamed('/bookings');
              break;
            case 2:
              Get.offNamed('/profile');
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }
}
