import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/Cart/cartProvider.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/Cart/orderConfirmationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  static void handlePaymentSuccess(BuildContext context, PaymentSuccessResponse response) async {
    await _storePaymentDetails(context, response.paymentId!);
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
        };
      }).toList();

      await FirebaseFirestore.instance.collection('payments').add({
        'paymentId': paymentId,
        'amount': totalAmount,
        'timestamp': FieldValue.serverTimestamp(),
        'userUid': userUid,
        'customerName': customerName,
        'customerEmail': customerEmail,
        'customerPhone': customerPhone,
        'products': productsList,
      });

      cartProvider.clearCart();
    } catch (e) {
      print("Error storing payment details: $e");
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
