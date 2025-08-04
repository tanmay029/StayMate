import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/booking_model.dart';
import '../models/property_model.dart';
import '../models/review_model.dart';
import 'auth_controller.dart';

class BookingController extends GetxController {
  final _box = GetStorage();
  final bookings = <Booking>[].obs;
  final reviews = <Review>[].obs;
  
  AuthController get authController => Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadBookings();
    loadReviews();
  }

  void loadBookings() {
    try {
      final mockBookings = [
        Booking(
          id: 'SM001',
          propertyId: '1',
          userId: authController.currentUser.value?.id ?? '',
          checkIn: DateTime.now().add(Duration(days: 7)),
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
        
        Booking(
          id: 'SM002',
          propertyId: '3',
          userId: authController.currentUser.value?.id ?? '',
          checkIn: DateTime.now().add(Duration(hours: 12)),
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
        
        Booking(
          id: 'SM004',
          propertyId: '5',
          userId: authController.currentUser.value?.id ?? '',
          checkIn: DateTime.now().subtract(Duration(days: 10)),
          checkOut: DateTime.now().subtract(Duration(days: 7)),
          adults: 2,
          children: 0,
          totalPrice: 1050.0,
          status: 'Completed',
          property: Property(
            id: '5',
            title: 'Beachfront Bungalow',
            location: 'Malibu, California',
            pricePerNight: 350.0,
            rating: 4.9,
            category: 'Villas',
            images: ['https://images.unsplash.com/photo-1501183638714-1c7a40b735d0?w=800'],
            description: 'Private bungalow right on the beach, perfect for sunset views and relaxation.',
            amenities: ['WiFi', 'Pool', 'AC', 'Beach Access'],
          ),
        ),
      ];
      bookings.value = mockBookings;
    } catch (e) {
      print('Error loading bookings: $e');
      bookings.value = [];
    }
  }

  void loadReviews() {
    
    final savedReviewsData = _box.read('reviews');
    List<Review> savedReviews = [];
    if (savedReviewsData != null) {
      savedReviews = (savedReviewsData as List)
          .map((reviewJson) => Review.fromJson(reviewJson))
          .toList();
    }

    
    final dummyReviews = [
      
      Review(
        id: 'DR001',
        userId: 'guest1',
        propertyId: '1',
        bookingId: 'booking1',
        overallRating: 5.0,
        categoryRatings: {
          'Cleanliness': 5.0,
          'Accuracy': 5.0,
          'Check-in': 4.5,
          'Communication': 5.0,
          'Location': 5.0,
          'Value': 4.0,
        },
        reviewText: 'Absolutely stunning beachfront villa! The ocean views were breathtaking and the private beach access was amazing. Perfect for a romantic getaway. The host was very responsive and the check-in process was smooth. Highly recommend!',
        photos: [],
        createdAt: DateTime.now().subtract(Duration(days: 15)),
        guestName: 'Sarah M.',
        isVerifiedStay: true,
      ),
      Review(
        id: 'DR002',
        userId: 'guest2',
        propertyId: '1',
        bookingId: 'booking2',
        overallRating: 4.5,
        categoryRatings: {
          'Cleanliness': 4.0,
          'Accuracy': 5.0,
          'Check-in': 4.0,
          'Communication': 5.0,
          'Location': 5.0,
          'Value': 4.0,
        },
        reviewText: 'Great location right on the beach. The villa was spacious and well-equipped. Only minor issue was some sand tracked inside, but that\'s expected for beachfront properties. Would definitely stay again!',
        photos: [],
        createdAt: DateTime.now().subtract(Duration(days: 8)),
        guestName: 'Michael R.',
        isVerifiedStay: true,
      ),
      
    ];

    
    reviews.value = [...savedReviews, ...dummyReviews];
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
        totalPrice: bookingData['total'] * 1.22,
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

  bool canReviewBooking(String bookingId) {
    final booking = bookings.firstWhereOrNull((b) => b.id == bookingId);
    if (booking == null || booking.status.toLowerCase() != 'completed') {
      return false;
    }
    
    final existingReview = reviews.firstWhereOrNull((r) => r.bookingId == bookingId);
    return existingReview == null;
  }

  bool hasReviewed(String bookingId) {
    return reviews.any((review) => review.bookingId == bookingId);
  }

  Review? getReviewForBooking(String bookingId) {
    return reviews.firstWhereOrNull((review) => review.bookingId == bookingId);
  }

  Future<bool> submitReview({
    required String bookingId,
    required double overallRating,
    required Map<String, double> categoryRatings,
    required String reviewText,
    List<String> photos = const [],
  }) async {
    try {
      final booking = bookings.firstWhereOrNull((b) => b.id == bookingId);
      if (booking == null) return false;

      final review = Review(
        id: 'R${DateTime.now().millisecondsSinceEpoch}',
        userId: authController.currentUser.value?.id ?? '',
        propertyId: booking.propertyId,
        bookingId: bookingId,
        overallRating: overallRating,
        categoryRatings: categoryRatings,
        reviewText: reviewText,
        photos: photos,
        createdAt: DateTime.now(),
        guestName: authController.currentUser.value?.fullName ?? 'Anonymous',
        isVerifiedStay: true,
      );

      reviews.add(review);
      
      
      final reviewsJson = reviews.map((r) => r.toJson()).toList();
      _box.write('reviews', reviewsJson);

      return true;
    } catch (e) {
      print('Error submitting review: $e');
      return false;
    }
  }

  
  List<Review> getReviewsForProperty(String propertyId) {
    return reviews.where((review) => review.propertyId == propertyId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); 
  }

  double getAverageRatingForProperty(String propertyId) {
    final propertyReviews = getReviewsForProperty(propertyId);
    if (propertyReviews.isEmpty) return 0.0;
    
    final totalRating = propertyReviews.fold<double>(
      0.0, 
      (sum, review) => sum + review.overallRating
    );
    return totalRating / propertyReviews.length;
  }

  Map<String, double> getCategoryAveragesForProperty(String propertyId) {
    final propertyReviews = getReviewsForProperty(propertyId);
    if (propertyReviews.isEmpty) return {};

    final categoryTotals = <String, double>{};
    final categoryKeys = ['Cleanliness', 'Accuracy', 'Check-in', 'Communication', 'Location', 'Value'];

    for (final key in categoryKeys) {
      categoryTotals[key] = 0.0;
    }

    for (final review in propertyReviews) {
      review.categoryRatings.forEach((category, rating) {
        categoryTotals[category] = (categoryTotals[category] ?? 0.0) + rating;
      });
    }

    final categoryAverages = <String, double>{};
    categoryTotals.forEach((category, total) {
      categoryAverages[category] = total / propertyReviews.length;
    });

    return categoryAverages;
  }
}
