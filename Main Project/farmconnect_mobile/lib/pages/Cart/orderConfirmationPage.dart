import 'package:farmconnect/pages/Buyer/buyerDashboard.dart';
import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String paymentId;

  OrderConfirmationPage({required this.paymentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'Order Confirmation',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100.0,
              ),
              SizedBox(height: 16.0),
              Text(
                'Thank You for Your Order!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8.0),
              Text(
                'Your order has been placed successfully.',
                style: TextStyle(fontSize: 18, color: Colors.grey[700],),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              Text(
                'Order Details:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8.0),
              Text(
                'Payment ID: $paymentId',
                style: TextStyle(fontSize: 18, color: Colors.grey[700],),
              ),
              // Add more order details here, e.g., items, total amount, etc.
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BuyerDashboard()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Continue Shopping',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
