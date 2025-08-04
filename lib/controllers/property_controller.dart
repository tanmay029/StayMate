// controllers/property_controller.dart
import 'package:get/get.dart';
import '../models/property_model.dart';

class PropertyController extends GetxController {
  final properties = <Property>[].obs;
  final filteredProperties = <Property>[].obs;
  final selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadProperties();
  }

  void loadProperties() {
    // Enhanced mock data with 10 total properties
    properties.value = [
      // Original Properties
      Property(
        id: '1',
        title: 'Luxury Beach Villa',
        location: 'Miami Beach, FL',
        pricePerNight: 299.0,
        rating: 4.8,
        category: 'Villas',
        images: [
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        ],
        description: 'Beautiful beachfront villa with stunning ocean views and private beach access.',
        amenities: ['WiFi', 'Pool', 'AC', 'Kitchen', 'Parking'],
      ),
      Property(
        id: '2',
        title: 'Downtown Apartment',
        location: 'New York, NY',
        pricePerNight: 189.0,
        rating: 4.5,
        category: 'Apartments',
        images: [
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        ],
        description: 'Modern apartment in the heart of downtown with city skyline views.',
        amenities: ['WiFi', 'AC', 'Kitchen', 'Gym'],
      ),
      
      // 8 New Properties
      Property(
        id: '3',
        title: 'Cozy Mountain Cabin',
        location: 'Aspen, Colorado',
        pricePerNight: 150.0,
        rating: 4.7,
        category: 'Cabins',
        images: [
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
        ],
        description: 'Rustic cabin nestled in the mountains with wood stove and picturesque views.',
        amenities: ['WiFi', 'Fireplace', 'Kitchen', 'Parking'],
      ),
      Property(
        id: '4',
        title: 'Modern City Loft',
        location: 'San Francisco, CA',
        pricePerNight: 220.0,
        rating: 4.6,
        category: 'Apartments',
        images: [
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        ],
        description: 'Bright loft with minimalist design in the city center close to public transportation.',
        amenities: ['WiFi', 'AC', 'Elevator', 'Gym'],
      ),
      // Property(
      //   id: '5',
      //   title: 'Beachfront Bungalow',
      //   location: 'Malibu, California',
      //   pricePerNight: 350.0,
      //   rating: 4.9,
      //   category: 'Villas',
      //   images: [
      //     'https://images.unsplash.com/photo-1501183638714-1c7a40b735d0?w=800',
      //   ],
      //   description: 'Private bungalow right on the beach, perfect for sunset views and relaxation.',
      //   amenities: ['WiFi', 'Pool', 'AC', 'Beach Access'],
      // ),
      // Property(
      //   id: '6',
      //   title: 'Historic Downtown Hotel',
      //   location: 'Boston, MA',
      //   pricePerNight: 180.0,
      //   rating: 4.2,
      //   category: 'Hotels',
      //   images: [
      //     'https://images.unsplash.com/photo-1486308510493-cb45f3d1c0e7?w=800',
      //   ],
      //   description: 'Charming hotel in a historic building located in the heart of downtown.',
      //   amenities: ['WiFi', 'AC', 'Breakfast', 'Parking'],
      // ),
      // Property(
      //   id: '7',
      //   title: 'Luxury Penthouse Suite',
      //   location: 'Chicago, IL',
      //   pricePerNight: 400.0,
      //   rating: 4.9,
      //   category: 'Apartments',
      //   images: [
      //     'https://images.unsplash.com/photo-1576675788399-02f02a79fb06?w=800',
      //   ],
      //   description: 'Spacious penthouse with panoramic city views and modern amenities.',
      //   amenities: ['WiFi', 'AC', 'Gym', 'Parking'],
      // ),
      Property(
        id: '8',
        title: 'Secluded Forest Retreat',
        location: 'Portland, Oregon',
        pricePerNight: 130.0,
        rating: 4.8,
        category: 'Cabins',
        images: [
          'https://images.unsplash.com/photo-1500534623283-312aade485b7?w=800',
        ],
        description: 'Quiet cabin surrounded by forest nature, ideal for relaxing and hiking.',
        amenities: ['WiFi', 'Fireplace', 'Kitchen'],
      ),
      Property(
        id: '9',
        title: 'Charming Country House',
        location: 'Nashville, Tennessee',
        pricePerNight: 170.0,
        rating: 4.4,
        category: 'Houses',
        images: [
          'https://images.unsplash.com/photo-1523217582562-09d0def993a6?w=800',
        ],
        description: 'Lovely country house with large garden and barbecue facilities.',
        amenities: ['WiFi', 'Parking', 'Kitchen', 'Garden'],
      ),
      Property(
        id: '10',
        title: 'Downtown Studio Apartment',
        location: 'Austin, Texas',
        pricePerNight: 140.0,
        rating: 4.3,
        category: 'Apartments',
        images: [
          'https://images.unsplash.com/photo-1494526585095-c41746248156?w=800',
        ],
        description: 'Compact and affordable studio in the city with all essentials.',
        amenities: ['WiFi', 'AC', 'Kitchen'],
      ),
    ];
    filteredProperties.value = properties;
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category == 'All') {
      filteredProperties.value = properties;
    } else {
      filteredProperties.value = properties.where((p) => p.category == category).toList();
    }
  }

  void searchProperties(String query) {
    if (query.isEmpty) {
      filteredProperties.value = properties;
    } else {
      filteredProperties.value = properties
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()) ||
                      p.location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
