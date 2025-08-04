// screens/booking/booking_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/booking_model.dart';
import '../../controllers/booking_controller.dart';

class BookingDetailScreen extends StatelessWidget {
  final bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    final Booking booking = Get.arguments;
    final bool canCancel = _canCancelBooking(booking);
    final int hoursLeft = _getHoursUntilBooking(booking);

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(booking.status),
                      color: _getStatusColor(booking.status),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Status',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          booking.status,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(booking.status),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getStatusColor(booking.status).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'ID: ${booking.id}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(booking.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Property Info Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            booking.property.images.first,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: Icon(Icons.image, size: 40),
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      booking.property.location,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text('${booking.property.rating}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Booking Details Card
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
                    _buildDetailRow(
                      'Check-in Date',
                      DateFormat('EEEE, MMM dd, yyyy').format(booking.checkIn),
                      Icons.calendar_month,
                    ),
                    _buildDetailRow(
                      'Check-out Date',
                      DateFormat('EEEE, MMM dd, yyyy').format(booking.checkOut),
                      Icons.calendar_month,
                    ),
                    _buildDetailRow(
                      'Duration',
                      '${booking.checkOut.difference(booking.checkIn).inDays} nights',
                      Icons.access_time,
                    ),
                    _buildDetailRow(
                      'Guests',
                      '${booking.adults} adults${booking.children > 0 ? ', ${booking.children} children' : ''}',
                      Icons.people,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Price Breakdown Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildPriceRow(
                      'Room Rate',
                      '\$${(booking.totalPrice / 1.22).toStringAsFixed(2)}',
                    ),
                    _buildPriceRow(
                      'Service Fee',
                      '\$${((booking.totalPrice / 1.22) * 0.1).toStringAsFixed(2)}',
                    ),
                    _buildPriceRow(
                      'Taxes',
                      '\$${((booking.totalPrice / 1.22) * 0.12).toStringAsFixed(2)}',
                    ),
                    Divider(thickness: 1),
                    _buildPriceRow(
                      'Total Amount',
                      '\$${booking.totalPrice.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Cancellation Info Card
            if (booking.status.toLowerCase() == 'confirmed')
              Card(
                color: canCancel 
                    ? Colors.orange.withOpacity(0.1) 
                    : Colors.red.withOpacity(0.1),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            canCancel ? Icons.info_outline : Icons.warning_outlined,
                            color: canCancel ? Colors.orange : Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Cancellation Policy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        canCancel
                            ? 'You can cancel this booking up to 24 hours before check-in. Time remaining: ${hoursLeft} hours.'
                            : 'Cancellation is no longer available. Less than 24 hours remaining until check-in.',
                        style: TextStyle(
                          color: canCancel ? Colors.orange[700] : Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 24),

            // Action Buttons
            if (booking.status.toLowerCase() == 'confirmed')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.toNamed('/property-detail', arguments: booking.property),
                      child: Text('View Property'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: canCancel ? () => _showCancelDialog(booking) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canCancel ? Colors.red : Colors.grey,
                      ),
                      child: Text(
                        canCancel ? 'Cancel Booking' : 'Cannot Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            else if (booking.status.toLowerCase() == 'cancelled')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.toNamed('/property-detail', arguments: booking.property),
                  child: Text('View Property Again'),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.toNamed('/property-detail', arguments: booking.property),
                  child: Text('View Property'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
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
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Get.theme.primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }

  bool _canCancelBooking(Booking booking) {
    if (booking.status.toLowerCase() != 'confirmed') return false;
    
    final now = DateTime.now();
    final hoursUntilCheckIn = booking.checkIn.difference(now).inHours;
    return hoursUntilCheckIn >= 24;
  }

  int _getHoursUntilBooking(Booking booking) {
    final now = DateTime.now();
    return booking.checkIn.difference(now).inHours;
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.access_time;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  void _showCancelDialog(Booking booking) {
    Get.dialog(
      AlertDialog(
        title: Text('Cancel Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to cancel this booking?'),
            SizedBox(height: 8),
            Text(
              'Booking: ${booking.property.title}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'Check-in: ${DateFormat('MMM dd, yyyy').format(booking.checkIn)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              bookingController.cancelBooking(booking.id);
              Get.snackbar(
                'Booking Cancelled',
                'Your booking has been cancelled successfully.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: Duration(seconds: 3),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Cancel Booking', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
