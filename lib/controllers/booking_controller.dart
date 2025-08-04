// controllers/booking_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/booking_model.dart';
import '../models/property_model.dart';
import 'auth_controller.dart';

class BookingController extends GetxController {
  final _box = GetStorage();
  final bookings = <Booking>[].obs;
  
  AuthController get authController => Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  void loadBookings() {
    try {
      // Mock bookings data with different statuses and times
      final mockBookings = [
        // Booking that can be cancelled (more than 24 hours)
        Booking(
          id: 'SM001',
          propertyId: '1',
          userId: authController.currentUser.value?.id ?? '',
          checkIn: DateTime.now().add(Duration(days: 7)), // 7 days from now
          checkOut: DateTime.now().add(Duration(days: 10)),
          adults: 2,
          children: 0,
          totalPrice: 897.0,
          status: 'Confirmed',
          property: Property(
            id: '1',
            title: 'Luxury Beach Villa',
            location: 'Miami Beach, FL',
            pricePerNight: 299.0,
            rating: 4.8,
            category: 'Villas',
            images: ['https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800'],
            description: 'Beautiful beachfront villa',
            amenities: ['WiFi', 'Pool', 'AC'],
          ),
        ),
        // Booking that cannot be cancelled (less than 24 hours)
        Booking(
          id: 'SM002',
          propertyId: '3',
          userId: authController.currentUser.value?.id ?? '',
          checkIn: DateTime.now().add(Duration(hours: 12)), // 12 hours from now
          checkOut: DateTime.now().add(Duration(days: 3)),
          adults: 1,
          children: 0,
          totalPrice: 450.0,
          status: 'Confirmed',
          property: Property(
            id: '3',
            title: 'Cozy Mountain Cabin',
            location: 'Aspen, Colorado',
            pricePerNight: 150.0,
            rating: 4.7,
            category: 'Cabins',
            images: ['https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800'],
            description: 'Rustic cabin nestled in the mountains',
            amenities: ['WiFi', 'Fireplace', 'Kitchen', 'Parking'],
          ),
        ),
        // Cancelled booking
        Booking(
          id: 'SM003',
          propertyId: '2',
          userId: authController.currentUser.value?.id ?? '',
          checkIn: DateTime.now().add(Duration(days: 14)),
          checkOut: DateTime.now().add(Duration(days: 17)),
          adults: 2,
          children: 1,
          totalPrice: 567.0,
          status: 'Cancelled',
          property: Property(
            id: '2',
            title: 'Downtown Apartment',
            location: 'New York, NY',
            pricePerNight: 189.0,
            rating: 4.5,
            category: 'Apartments',
            images: ['https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800'],
            description: 'Modern apartment in the heart of downtown',
            amenities: ['WiFi', 'AC', 'Kitchen', 'Gym'],
          ),
        ),
      ];
      bookings.value = mockBookings;
    } catch (e) {
      print('Error loading bookings: $e');
      bookings.value = [];
    }
  }

  Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      
      final newBooking = Booking(
        id: 'SM${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        propertyId: bookingData['property'].id,
        userId: authController.currentUser.value?.id ?? '',
        checkIn: bookingData['checkIn'],
        checkOut: bookingData['checkOut'],
        adults: bookingData['adults'],
        children: bookingData['children'],
        totalPrice: bookingData['total'] * 1.22, // Including fees
        status: 'Confirmed',
        property: bookingData['property'],
      );
      
      bookings.insert(0, newBooking);
      return true;
    } catch (e) {
      print('Error creating booking: $e');
      return false;
    }
  }

  void cancelBooking(String bookingId) {
    try {
      final bookingIndex = bookings.indexWhere((b) => b.id == bookingId);
      if (bookingIndex != -1) {
        final booking = bookings[bookingIndex];
        final updatedBooking = Booking(
          id: booking.id,
          propertyId: booking.propertyId,
          userId: booking.userId,
          checkIn: booking.checkIn,
          checkOut: booking.checkOut,
          adults: booking.adults,
          children: booking.children,
          totalPrice: booking.totalPrice,
          status: 'Cancelled',
          property: booking.property,
        );
        bookings[bookingIndex] = updatedBooking;
      }
    } catch (e) {
      print('Error cancelling booking: $e');
    }
  }

  bool canCancelBooking(String bookingId) {
    final booking = bookings.firstWhereOrNull((b) => b.id == bookingId);
    if (booking == null || booking.status.toLowerCase() != 'confirmed') {
      return false;
    }
    
    final now = DateTime.now();
    final hoursUntilCheckIn = booking.checkIn.difference(now).inHours;
    return hoursUntilCheckIn >= 24;
  }
}
