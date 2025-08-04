// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/theme_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/booking_controller.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';
import 'themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize all controllers before runApp
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(BookingController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final authController = Get.find<AuthController>();

    return GetMaterialApp(
      title: 'StayMate',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeController.theme,
      initialRoute:
          // authController.isLoggedIn.value ? Routes.HOME : Routes.LOGIN,
          Routes.HOME,
      getPages: AppPages.routes,
    );
  }
}
