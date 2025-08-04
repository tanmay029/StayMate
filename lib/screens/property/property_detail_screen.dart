// screens/property/property_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/property_model.dart';

class PropertyDetailScreen extends StatefulWidget {
  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final Property property = Get.arguments;
  final PageController _pageController = PageController();
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
                        children: property.images.asMap().entries.map((entry) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == entry.key
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
          
          // Rest of your code remains the same...
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
                      Text(property.location, style: TextStyle(color: Colors.grey)),
                      Spacer(),
                      RatingBarIndicator(
                        rating: property.rating,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
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
                    children: property.amenities
                        .map((amenity) => Chip(label: Text(amenity)))
                        .toList(),
                  ),
                  SizedBox(height: 24),
                  
                  // Booking Section
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Book Your Stay',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          
                          // Date Selection
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Check-in', style: TextStyle(fontSize: 12)),
                                        Text(
                                          checkInDate?.toString().split(' ')[0] ?? 'Select date',
                                          style: TextStyle(fontWeight: FontWeight.bold),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Check-out', style: TextStyle(fontSize: 12)),
                                        Text(
                                          checkOutDate?.toString().split(' ')[0] ?? 'Select date',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          
                          // Guest Selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Adults'),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: adults > 1 ? () => setState(() => adults--) : null,
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
                                    onPressed: children > 0 ? () => setState(() => children--) : null,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    return checkInDate != null && checkOutDate != null && 
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
    Get.toNamed('/booking-confirmation', arguments: {
      'property': property,
      'checkIn': checkInDate,
      'checkOut': checkOutDate,
      'adults': adults,
      'children': children,
      'total': _calculateTotal(),
    });
  }
}
