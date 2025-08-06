// screens/favorites/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favorites_controller.dart';
import '../../widgets/property_card.dart';

class FavoritesScreen extends StatelessWidget {
  final favoritesController = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text('Favorites (${favoritesController.favoriteCount})'),
        ),
        actions: [
          Obx(
            () =>
                favoritesController.favoriteProperties.isNotEmpty
                    ? PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: 'clear',
                              child: Row(
                                children: [
                                  Icon(Icons.clear_all, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Clear All'),
                                ],
                              ),
                            ),
                          ],
                      onSelected: (value) {
                        if (value == 'clear') {
                          _showClearAllDialog();
                        }
                      },
                    )
                    : SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (favoritesController.favoriteProperties.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            favoritesController.loadFavorites();
          },
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: favoritesController.favoriteProperties.length,
            itemBuilder: (context, index) {
              final property = favoritesController.favoriteProperties[index];
              return PropertyCard(property: property);
            },
          ),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4, // New favorites tab index
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
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
              Get.offNamed('/settings');
              break;
            case 4:
              // Already on favorites
              break;
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Get.theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              size: 80,
              color: Get.theme.primaryColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start adding properties to your favorites\nby tapping the heart icon',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Get.offAllNamed('/home'),
            icon: Icon(Icons.explore),
            label: Text('Explore Properties'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Clear All Favorites'),
          ],
        ),
        content: Text(
          'Are you sure you want to remove all properties from your favorites? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              favoritesController.clearAllFavorites();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
