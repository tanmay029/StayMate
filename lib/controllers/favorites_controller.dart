import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/property_model.dart';
import 'property_controller.dart';

class FavoritesController extends GetxController {
  final _box = GetStorage();
  final favoritePropertyIds = <String>[].obs;
  final favoriteProperties = <Property>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    final savedFavorites = _box.read('favorite_properties') ?? <String>[];
    favoritePropertyIds.value = List<String>.from(savedFavorites);
    _updateFavoriteProperties();
  }

  void _updateFavoriteProperties() {
    try {
      final propertyController = Get.find<PropertyController>();
      favoriteProperties.value = propertyController.properties
          .where((property) => favoritePropertyIds.contains(property.id))
          .toList();
    } catch (e) {
      print('Error updating favorite properties: $e');
      favoriteProperties.value = [];
    }
  }

  bool isFavorite(String propertyId) {
    return favoritePropertyIds.contains(propertyId);
  }

  void toggleFavorite(Property property) {
    if (isFavorite(property.id)) {
      _removeFavorite(property.id);
    } else {
      _addFavorite(property.id);
    }
    _saveFavorites();
    _updateFavoriteProperties();
  }

  void _addFavorite(String propertyId) {
    if (!favoritePropertyIds.contains(propertyId)) {
      favoritePropertyIds.add(propertyId);
      Get.snackbar(
        'Added to Favorites',
        'Property has been added to your favorites',
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      );
    }
  }

  void _removeFavorite(String propertyId) {
    favoritePropertyIds.remove(propertyId);
    Get.snackbar(
      'Removed from Favorites',
      'Property has been removed from your favorites',
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
    );
  }

  void _saveFavorites() {
    _box.write('favorite_properties', favoritePropertyIds.toList());
  }

  void clearAllFavorites() {
    favoritePropertyIds.clear();
    favoriteProperties.clear();
    _saveFavorites();
    Get.snackbar(
      'Favorites Cleared',
      'All favorites have been removed',
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: Duration(seconds: 2),
    );
  }

  int get favoriteCount => favoritePropertyIds.length;
}
