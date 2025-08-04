// screens/booking/booking_success_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> bookingData = Get.arguments;
    final property = bookingData['property'];
    final checkIn = bookingData['checkIn'];
    final checkOut = bookingData['checkOut'];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              
              SizedBox(height: 32),
              
              Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 16),
              
              Text(
                'Great! Your booking has been confirmed. We\'ve sent you a confirmation email with all the details.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 32),
              
              // Booking Summary Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              property.images.first,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
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
                                  property.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  property.location,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 20),
                      Divider(),
                      SizedBox(height: 12),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Check-in', style: TextStyle(color: Colors.grey[600])),
                              Text(
                                DateFormat('MMM dd, yyyy').format(checkIn),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Check-out', style: TextStyle(color: Colors.grey[600])),
                              Text(
                                DateFormat('MMM dd, yyyy').format(checkOut),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 16),
                      
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.confirmation_number, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Booking ID: SM${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 32),
              
              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed('/bookings'),
                  child: Text('View My Bookings'),
                ),
              ),
              
              SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.offAllNamed('/home'),
                  child: Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
