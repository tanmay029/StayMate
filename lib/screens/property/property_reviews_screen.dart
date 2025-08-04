import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../../models/property_model.dart';
import '../../models/review_model.dart';
import '../../controllers/booking_controller.dart';

class PropertyReviewsScreen extends StatelessWidget {
  final bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    final Property property = Get.arguments;
    final reviews = bookingController.getReviewsForProperty(property.id);
    final averageRating = bookingController.getAverageRatingForProperty(
      property.id,
    );
    final categoryAverages = bookingController.getCategoryAveragesForProperty(
      property.id,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Reviews')),
      body:
          reviews.isEmpty
              ? _buildNoReviews()
              : Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              averageRating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RatingBarIndicator(
                                    rating: averageRating,
                                    itemBuilder:
                                        (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                    itemCount: 5,
                                    itemSize: 24.0,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${reviews.length} review${reviews.length != 1 ? 's' : ''}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        if (categoryAverages.isNotEmpty) ...[
                          SizedBox(height: 20),
                          Divider(),
                          SizedBox(height: 12),
                          Text(
                            'Rating Breakdown',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          ...categoryAverages.entries
                              .map(
                                (entry) =>
                                    _buildCategoryBar(entry.key, entry.value),
                              )
                              .toList(),
                        ],
                      ],
                    ),
                  ),

                  // Reviews List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        return ReviewCard(review: reviews[index]);
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildNoReviews() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rate_review_outlined, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No Reviews Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to share your experience!',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(String category, double rating) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(category, style: TextStyle(fontSize: 14)),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: LinearProgressIndicator(
                    value: rating / 5.0,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(Get.context!).primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 30,
                  child: Text(
                    rating.toStringAsFixed(1),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    review.guestName.split(' ').map((n) => n[0]).take(2).join(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review.guestName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color, 
                            ),
                          ),
                          if (review.isVerifiedStay) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'Verified Stay',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        DateFormat('MMMM yyyy').format(review.createdAt),
                        style: TextStyle(
                          color:
                              Theme.of(
                                context,
                              ).textTheme.bodySmall?.color, 
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    RatingBarIndicator(
                      rating: review.overallRating,
                      itemBuilder:
                          (context, index) =>
                              Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 16.0,
                    ),
                    SizedBox(height: 2),
                    Text(
                      review.overallRating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color, // Fixed
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12),

            // Review text
            if (review.reviewText.isNotEmpty)
              Text(
                review.reviewText,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Theme.of(context).textTheme.bodyMedium?.color, // Fixed
                ),
              ),

            
            if (review.categoryRatings.isNotEmpty) ...[
              SizedBox(height: 12),
              ExpansionTile(
                tilePadding: EdgeInsets.zero, 
                childrenPadding: EdgeInsets.zero, 
                title: Text(
                  'Detailed Ratings',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children:
                          review.categoryRatings.entries.map((entry) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.color,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      RatingBarIndicator(
                                        rating: entry.value,
                                        itemBuilder:
                                            (context, index) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                        itemCount: 5,
                                        itemSize: 12.0,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        entry.value.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
