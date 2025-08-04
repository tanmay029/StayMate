// controllers/theme_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  
  final isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _loadThemeFromBox();
    _updateSystemUI();
  }

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  void saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void changeThemeMode(bool isDark) {
    isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    saveThemeToBox(isDark);
    _updateSystemUI();
    
    // Add a nice feedback
    Get.snackbar(
      isDark ? 'Dark Mode' : 'Light Mode',
      isDark ? 'Dark theme activated' : 'Light theme activated',
      duration: Duration(seconds: 1),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
    );
  }

  void _updateSystemUI() {
    if (isDarkMode.value) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF1C1C1E),
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    }
  }
}
