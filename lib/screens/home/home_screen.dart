// screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/property_controller.dart';
import '../../widgets/property_card.dart';

class HomeScreen extends StatelessWidget {
  final propertyController = Get.put(PropertyController());
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StayMate'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Get.toNamed('/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
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
          
          // Categories - Updated with new categories
          Container(
            height: 60,
            child: Obx(() => ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: ['All', 'Apartments', 'Villas', 'Hotels', 'Cabins', 'Houses']
                  .map((category) => Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: FilterChip(
                          label: Text(category),
                          selected: propertyController.selectedCategory.value == category,
                          onSelected: (_) => propertyController.filterByCategory(category),
                        ),
                      ))
                  .toList(),
            )),
          ),
          
          // Properties List
          Expanded(
            child: Obx(() => ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: propertyController.filteredProperties.length,
              itemBuilder: (context, index) {
                final property = propertyController.filteredProperties[index];
                return PropertyCard(property: property);
              },
            )),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Get.toNamed('/bookings');
              break;
            case 2:
              Get.toNamed('/profile');
              break;
            case 3:
              Get.toNamed('/settings');
              break;
          }
        },
      ),
    );
  }
}
