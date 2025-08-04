// screens/booking/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/booking_controller.dart';

class PaymentScreen extends StatelessWidget {
  final bookingController = Get.find<BookingController>();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final nameController = TextEditingController();
  
  final RxBool isProcessing = false.obs;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> bookingData = Get.arguments;
    final double totalAmount = bookingData['total'] * 1.22; // Including fees and taxes

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Amount Card
            Card(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '\$${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 16),
            
            // Credit Card Form
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.credit_card, color: Theme.of(context).primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Credit/Debit Card',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: cardNumberController,
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        hintText: '1234 5678 9012 3456',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Cardholder Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: expiryController,
                            decoration: InputDecoration(
                              labelText: 'MM/YY',
                              hintText: '12/25',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: cvvController,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              hintText: '123',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Security Info
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your payment information is secure and encrypted',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Pay Now Button
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isProcessing.value ? null : () => _processPayment(bookingData),
                child: isProcessing.value
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
                          Text('Processing...'),
                        ],
                      )
                    : Text('Pay Now - \$${totalAmount.toStringAsFixed(2)}'),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _processPayment(Map<String, dynamic> bookingData) async {
    if (!_validateForm()) return;
    
    isProcessing.value = true;
    
    try {
      // Mock payment processing
      await Future.delayed(Duration(seconds: 3));
      
      // Create booking
      final success = await bookingController.createBooking(bookingData);
      
      if (success) {
        Get.offAllNamed('/booking-success', arguments: bookingData);
      } else {
        Get.snackbar('Error', 'Payment failed. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      isProcessing.value = false;
    }
  }

  bool _validateForm() {
    if (cardNumberController.text.length < 16) {
      Get.snackbar('Error', 'Please enter a valid card number');
      return false;
    }
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter cardholder name');
      return false;
    }
    if (expiryController.text.length != 5) {
      Get.snackbar('Error', 'Please enter valid expiry date (MM/YY)');
      return false;
    }
    if (cvvController.text.length < 3) {
      Get.snackbar('Error', 'Please enter valid CVV');
      return false;
    }
    return true;
  }
}
