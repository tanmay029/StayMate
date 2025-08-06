// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'controllers/theme_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/property_controller.dart';
import 'controllers/booking_controller.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/tutorial_controller.dart'; // Add this
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';
import 'themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await GetStorage.init();
  
  // Initialize controllers
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(PropertyController());
  Get.put(BookingController());
  Get.put(FavoritesController());
  Get.put(TutorialController()); // Add this
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final authController = Get.find<AuthController>();
    final tutorialController = Get.find<TutorialController>();
    
    return Obx(() => GetMaterialApp(
      title: 'StayMate',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeController.theme,
      initialRoute: _getInitialRoute(authController, tutorialController),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ));
  }

  String _getInitialRoute(AuthController authController, TutorialController tutorialController) {
    if (!authController.isLoggedIn.value) {
      return Routes.LOGIN;
    } else if (tutorialController.showTutorial.value) {
      return Routes.WELCOME;
    } else {
      return Routes.HOME;
    }
  }
}
