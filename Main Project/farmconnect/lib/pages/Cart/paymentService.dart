import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/pages/Cart/cartProvider.dart';
import 'package:farmconnect/pages/Cart/orderConfirmationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  static void handlePaymentSuccess(BuildContext context, PaymentSuccessResponse response) async {
    await _storePaymentDetails(context, response.paymentId!);
    _sendPaymentNotificationEmail(context);
    _navigateToOrderConfirmation(context, response.paymentId!);
  }

  static Future<void> _storePaymentDetails(BuildContext context, String paymentId) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    double totalAmount = cartProvider.totalAmount() ?? 0.0;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userUid = user?.uid ?? '';
      String customerName = user?.displayName ?? 'Guest';
      String customerEmail = user?.email ?? 'guest@example.com';
      String customerPhone = user?.phoneNumber ?? 'N/A';

      List<Map<String, dynamic>> productsList = cartProvider.cartItems.map((item) {
        double productPrice = item['productPrice'] ?? 0.0;
        double totalPrice = productPrice * item['quantity'];
        return {
          'productId': item['productId'],
          'productName': item['productName'],
          'quantity': item['quantity'],
          'unitPrice': productPrice,
          'totalPrice': totalPrice,
          'productImage': item['productImage'], // Include productImage in the order details
        };
      }).toList();

      // Store payment details in "payments" collection
      DocumentReference paymentReference = await FirebaseFirestore.instance.collection('payments').add({
        'paymentId': paymentId,
        'amount': totalAmount,
        'timestamp': FieldValue.serverTimestamp(),
        'userUid': userUid,
        'customerName': customerName,
        'customerEmail': customerEmail,
        'customerPhone': customerPhone,
        'products': productsList,
      });

      // Store order details in "orders" collection
      await FirebaseFirestore.instance.collection('orders').doc(paymentReference.id).set({
        'orderId': paymentReference.id,
        'paymentId': paymentId,
        'amount': totalAmount,
        'timestamp': FieldValue.serverTimestamp(),
        'userUid': userUid,
        'customerName': customerName,
        'customerEmail': customerEmail,
        'customerPhone': customerPhone,
        'products': productsList,
        // You can include additional order details if needed
      });

      cartProvider.clearCart();
    } catch (e) {
      print("Error storing payment and order details: $e");
    }
  }



  static void handlePaymentError(PaymentFailureResponse response) {
    print("Payment error: ${response.message}");
  }

  static void handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet: ${response.walletName}");
  }

  static void _navigateToOrderConfirmation(BuildContext context, String paymentId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationPage(paymentId: paymentId),
      ),
    );
  }

  static void _sendPaymentNotificationEmail(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    String customerEmail = user?.email ?? 'guest@example.com';

    try {
      sendNotificationEmail(customerEmail, true);
    } catch (e) {
      print("Error sending payment notification email: $e");
    }
  }

  static void sendNotificationEmail(String recipient, bool isActive) async {
    final smtpServer = gmail('namalthomson2024b@mca.ajce.in', 'Amal664422');
    final message = Message()
      ..from = Address('admin@farmconnect.com', 'Admin FarmConnect')
      ..recipients.add(recipient)
      ..subject = 'Payment Successful and Order Placed'
      ..html = '''
      <html>
        <head>
          <style>
            body {
              font-family: 'Helvetica Neue', Arial, sans-serif;
              background-color: #f9f9f9;
              color: #333;
              margin: 0;
              padding: 0;
            }
            .container {
              max-width: 600px;
              margin: 0 auto;
              border-radius: 10px;
              overflow: hidden;
              box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            .header {
              color: #fff;
              text-align: center;
              padding: 20px;
            }
            h1 {
              color: #fff;
            }
            .content {
              padding: 30px;
              background-color: #ffffff; /* White */
            }
            p {
              line-height: 1.6;
              color: #333; /* Dark gray for better visibility on white */
            }
            .footer {
              background-color: #f9f9f9;
              padding: 20px;
              text-align: center;
              color: #888;
              font-style: italic;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1>Payment Successful and Order Placed</h1>
            </div>
            <div class="content">
              <p>Dear Customer,</p>
              <p>Your payment was successful, and your order has been placed.</p>
              <p>Thank you for shopping with us!</p>
            </div>
            <div class="footer">Best regards, Admin FarmConnect</div>
          </div>
        </body>
      </html>
    ''';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport}');
    } on MailerException catch (e) {
      print('Message not sent. ${e.message}');
    }
  }

  static void startPayment(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    double totalAmount = cartProvider.totalAmount() ?? 0.0;

    var options = {
      'key': 'rzp_test_x1IywbsCJ3R5CZ',
      'amount': (totalAmount * 100).toInt(),
      'name': 'FarmConnect',
      'description': 'Payment for your order',
      'prefill': {
        'contact': '9469664422',
        'email': 'farmconnectadm@gmail.com',
      },
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      Razorpay _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
        handlePaymentSuccess(context, response);
      });
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
        handlePaymentError(response);
      });
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (response) {
        handleExternalWallet(response);
      });

      _razorpay.open(options);
    } catch (e) {
      print("Error in starting Razorpay payment: $e");
    }
  }
}
