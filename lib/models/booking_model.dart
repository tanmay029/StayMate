// models/booking_model.dart
import 'package:staymate/models/property_model.dart';

class Booking {
  final String id;
  final String propertyId;
  final String userId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int children;
  final double totalPrice;
  final String status;
  final Property property;

  Booking({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.children,
    required this.totalPrice,
    required this.status,
    required this.property,
  });
}
