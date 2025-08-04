import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/property_model.dart';
import '../../controllers/booking_controller.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final bookingController = Get.put(BookingController());
  
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> bookingData = Get.arguments;
    final Property property = bookingData['property'];
    final DateTime checkIn = bookingData['checkIn'];
    final DateTime checkOut = bookingData['checkOut'];
    final int adults = bookingData['adults'];
    final int children = bookingData['children'];
    final double total = bookingData['total'];
    
    final nights = checkOut.difference(checkIn).inDays;

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Confirmation'),
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
                        property.images.first,
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
              ),
            ),
            
            SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildDetailRow('Check-in', DateFormat('MMM dd, yyyy').format(checkIn)),
                    _buildDetailRow('Check-out', DateFormat('MMM dd, yyyy').format(checkOut)),
                    _buildDetailRow('Nights', '$nights nights'),
                    _buildDetailRow('Guests', '$adults adults${children > 0 ? ', $children children' : ''}'),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Breakdown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildPriceRow('\$${property.pricePerNight.toStringAsFixed(2)} x $nights nights', 
                                  '\$${total.toStringAsFixed(2)}'),
                    _buildPriceRow('Service fee', '\$${(total * 0.1).toStringAsFixed(2)}'),
                    _buildPriceRow('Taxes', '\$${(total * 0.12).toStringAsFixed(2)}'),
                    Divider(),
                    _buildPriceRow('Total', '\$${(total * 1.22).toStringAsFixed(2)}', 
                                  isTotal: true),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _proceedToPayment(bookingData),
                child: Text('Proceed to Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToPayment(Map<String, dynamic> bookingData) {
    Get.toNamed('/payment', arguments: bookingData);
  }
}
