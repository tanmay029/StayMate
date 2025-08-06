import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:staymate/controllers/favorites_controller.dart';
import '../../models/property_model.dart';
import '../../controllers/booking_controller.dart';

class PropertyDetailScreen extends StatefulWidget {
  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final Property property = Get.arguments;
  final PageController _pageController = PageController();
  final bookingController = Get.find<BookingController>();

  int _currentPage = 0;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int adults = 2;
  int children = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              Obx(() {
                final favoritesController = Get.put(FavoritesController());
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      favoritesController.toggleFavorite(property);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child: Icon(
                          favoritesController.isFavorite(property.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          key: ValueKey(
                            favoritesController.isFavorite(property.id),
                          ),
                          color:
                              favoritesController.isFavorite(property.id)
                                  ? Colors.red
                                  : Colors.grey[600],
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: property.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        property.images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported, size: 50),
                          );
                        },
                      );
                    },
                  ),
                  if (property.images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            property.images.asMap().entries.map((entry) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _currentPage == entry.key
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.4),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        property.location,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Spacer(),
                      RatingBarIndicator(
                        rating: property.rating,
                        itemBuilder:
                            (context, index) =>
                                Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 16.0,
                      ),
                      SizedBox(width: 4),
                      Text('${property.rating}'),
                    ],
                  ),
                  SizedBox(height: 16),

                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(property.description),
                  SizedBox(height: 16),

                  Text(
                    'Amenities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        property.amenities
                            .map((amenity) => Chip(label: Text(amenity)))
                            .toList(),
                  ),
                  SizedBox(height: 24),

                  Obx(() {
                    final reviews = bookingController.getReviewsForProperty(
                      property.id,
                    );
                    final averageRating = bookingController
                        .getAverageRatingForProperty(property.id);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reviews',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (reviews.isNotEmpty)
                              TextButton(
                                onPressed:
                                    () => Get.toNamed(
                                      '/property-reviews',
                                      arguments: property,
                                    ),
                                child: Text('View all ${reviews.length}'),
                              ),
                          ],
                        ),
                        SizedBox(height: 8),

                        if (reviews.isEmpty)
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.rate_review_outlined,
                                  color: Colors.grey[500],
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'No reviews yet - be the first to review!',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          Row(
                            children: [
                              Text(
                                averageRating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              RatingBarIndicator(
                                rating: averageRating,
                                itemBuilder:
                                    (context, index) =>
                                        Icon(Icons.star, color: Colors.amber),
                                itemCount: 5,
                                itemSize: 20.0,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '(${reviews.length} review${reviews.length != 1 ? 's' : ''})',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),

                          ...reviews
                              .take(2)
                              .map(
                                (review) => Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              review.guestName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                              ),
                                            ),
                                            Spacer(),
                                            RatingBarIndicator(
                                              rating: review.overallRating,
                                              itemBuilder:
                                                  (context, index) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                              itemCount: 5,
                                              itemSize: 14.0,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          review.reviewText.length > 150
                                              ? '${review.reviewText.substring(0, 150)}...'
                                              : review.reviewText,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium?.color,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          DateFormat(
                                            'MMMM yyyy',
                                          ).format(review.createdAt),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ],
                    );
                  }),

                  SizedBox(height: 24),

                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Book Your Stay',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(true),
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Check-in',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          checkInDate?.toString().split(
                                                ' ',
                                              )[0] ??
                                              'Select date',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(false),
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Check-out',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          checkOutDate?.toString().split(
                                                ' ',
                                              )[0] ??
                                              'Select date',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Adults'),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed:
                                        adults > 1
                                            ? () => setState(() => adults--)
                                            : null,
                                    icon: Icon(Icons.remove),
                                  ),
                                  Text('$adults'),
                                  IconButton(
                                    onPressed: () => setState(() => adults++),
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Children'),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed:
                                        children > 0
                                            ? () => setState(() => children--)
                                            : null,
                                    icon: Icon(Icons.remove),
                                  ),
                                  Text('$children'),
                                  IconButton(
                                    onPressed: () => setState(() => children++),
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          if (checkInDate != null && checkOutDate != null)
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total Price'),
                                    Text(
                                      '\$${_calculateTotal().toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                              ],
                            ),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _canBook() ? _bookNow : null,
                              child: Text('Book Now'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(bool isCheckIn) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = date;
        } else {
          checkOutDate = date;
        }
      });
    }
  }

  bool _canBook() {
    return checkInDate != null &&
        checkOutDate != null &&
        checkOutDate!.isAfter(checkInDate!);
  }

  double _calculateTotal() {
    if (checkInDate != null && checkOutDate != null) {
      final nights = checkOutDate!.difference(checkInDate!).inDays;
      return nights * property.pricePerNight;
    }
    return 0;
  }

  void _bookNow() {
    Get.toNamed(
      '/booking-confirmation',
      arguments: {
        'property': property,
        'checkIn': checkInDate,
        'checkOut': checkOutDate,
        'adults': adults,
        'children': children,
        'total': _calculateTotal(),
      },
    );
  }
}
