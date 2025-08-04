import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/booking_model.dart';
import '../../controllers/booking_controller.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final bookingController = Get.find<BookingController>();
  final reviewController = TextEditingController();
  
  double overallRating = 0.0;
  final Map<String, double> categoryRatings = {
    'Cleanliness': 0.0,
    'Accuracy': 0.0,
    'Check-in': 0.0,
    'Communication': 0.0,
    'Location': 0.0,
    'Value': 0.0,
  };
  
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final Booking booking = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Write a Review'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        booking.property.images.first,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: Icon(Icons.image),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.property.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            booking.property.location,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Overall Rating',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: RatingBar.builder(
                initialRating: overallRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    overallRating = rating;
                  });
                },
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                _getRatingText(overallRating),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _getRatingColor(overallRating),
                ),
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Rate Your Experience',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            
            ...categoryRatings.keys.map((category) => 
              _buildCategoryRating(category)
            ).toList(),

            SizedBox(height: 24),

            Text(
              'Write Your Review',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share your experience with future guests...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting || overallRating == 0 
                    ? null 
                    : () => _submitReview(booking),
                child: isSubmitting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Submitting...'),
                        ],
                      )
                    : Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRating(String category) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: RatingBar.builder(
              initialRating: categoryRatings[category]!,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 24,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  categoryRatings[category] = rating;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingText(double rating) {
    if (rating == 0) return 'Tap to rate';
    if (rating <= 1) return 'Poor';
    if (rating <= 2) return 'Fair';
    if (rating <= 3) return 'Good';
    if (rating <= 4) return 'Very Good';
    return 'Excellent';
  }

  Color _getRatingColor(double rating) {
    if (rating == 0) return Colors.grey;
    if (rating <= 2) return Colors.red;
    if (rating <= 3) return Colors.orange;
    if (rating <= 4) return Colors.blue;
    return Colors.green;
  }

  void _submitReview(Booking booking) async {
    if (overallRating == 0) {
      Get.snackbar('Error', 'Please provide an overall rating');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final success = await bookingController.submitReview(
      bookingId: booking.id,
      overallRating: overallRating,
      categoryRatings: categoryRatings,
      reviewText: reviewController.text,
    );

    setState(() {
      isSubmitting = false;
    });

    if (success) {
      Get.back();
      Get.snackbar(
        'Review Submitted',
        'Thank you for your feedback!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else {
      Get.snackbar('Error', 'Failed to submit review. Please try again.');
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}
