// models/property_model.dart
class Property {
  final String id;
  final String title;
  final String location;
  final double pricePerNight;
  final double rating;
  final String category;
  final List<String> images;
  final String description;
  final List<String> amenities;

  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.pricePerNight,
    required this.rating,
    required this.category,
    required this.images,
    required this.description,
    required this.amenities,
  });
}
