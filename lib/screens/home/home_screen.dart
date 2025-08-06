// screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/property_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../../controllers/tutorial_controller.dart';
import '../../widgets/property_card.dart';
import '../../widgets/tutorial_overlay.dart';
import '../../widgets/highlighted_widget.dart';

class HomeScreen extends StatelessWidget {
  final propertyController = Get.put(PropertyController());
  final authController = Get.find<AuthController>();
  final favoritesController = Get.put(FavoritesController());
  final tutorialController = Get.put(TutorialController());
  final searchController = TextEditingController();

  // Keys for tutorial highlighting
  final searchBarKey = GlobalKey();
  final filterChipsKey = GlobalKey();
  final favoritesButtonKey = GlobalKey();
  final bookingsTabKey = GlobalKey();
  final propertyCardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return TutorialOverlay(
      child: Scaffold(
        appBar: AppBar(
          leading: HighlightedWidget(
            highlightId: "favorites_button",
            widgetKey: favoritesButtonKey,
            child: IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () => Get.toNamed('/favorites'),
              tooltip: 'Favorites',
            ),
          ),
          title: Text('StayMate'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            // Tutorial restart button (only show after tutorial is completed)
            Obx(() {
              if (!tutorialController.showTutorial.value && 
                  !tutorialController.isTutorialActive.value) {
                return PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'tutorial',
                      child: Row(
                        children: [
                          Icon(Icons.help_outline, color: Get.theme.primaryColor),
                          SizedBox(width: 8),
                          Text('Show Tutorial'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'tutorial') {
                      tutorialController.startTutorial();
                    }
                  },
                );
              }
              return SizedBox.shrink();
            }),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => _showLogoutDialog(),
              tooltip: 'Logout',
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar with highlighting
            HighlightedWidget(
              highlightId: "search_bar",
              widgetKey: searchBarKey,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search properties...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: propertyController.searchProperties,
                ),
              ),
            ),

            // Filter chips with highlighting
            HighlightedWidget(
              highlightId: "filter_chips",
              widgetKey: filterChipsKey,
              child: Container(
                height: 60,
                child: Obx(
                  () => ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      'All',
                      'Apartments',
                      'Villas',
                      'Hotels',
                      'Cabins',
                      'Houses',
                    ]
                        .map(
                          (category) => Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: FilterChip(
                              label: Text(category),
                              selected:
                                  propertyController.selectedCategory.value ==
                                      category,
                              onSelected: (_) =>
                                  propertyController.filterByCategory(category),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),

            // Property list with improved highlighting for tutorial
            Expanded(
              child: Obx(
                () {
                  if (propertyController.filteredProperties.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No properties found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filters',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: propertyController.filteredProperties.length,
                    itemBuilder: (context, index) {
                      final property = propertyController.filteredProperties[index];
                      
                      // Highlight ONLY the first property card for tutorial with better spacing
                      if (index == 0) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: HighlightedWidget(
                            highlightId: "property_card",
                            widgetKey: propertyCardKey,
                            child: PropertyCard(property: property),
                          ),
                        );
                      }
                      
                      // Regular property cards without highlighting
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: PropertyCard(property: property),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: HighlightedWidget(
                highlightId: "bookings_tab",
                widgetKey: bookingsTabKey,
                child: Icon(Icons.bookmark),
              ),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                break; // Already on home
              case 1:
                Get.offNamed('/bookings');
                break;
              case 2:
                Get.offNamed('/profile');
                break;
              case 3:
                Get.offNamed('/settings');
                break;
            }
          },
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('Logout'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to logout?'),
            SizedBox(height: 8),
            Obx(
              () => Text(
                'Logged in as: ${authController.userDisplayName}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
