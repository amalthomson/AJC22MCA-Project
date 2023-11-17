import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/Cart/cartProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await _storePaymentDetails(response.paymentId!);
    _navigateToOrderConfirmation(response.paymentId!);
  }

  Future<void> _storePaymentDetails(String paymentId) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    double totalAmount = cartProvider.totalAmount() ?? 0.0;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userUid = user?.uid ?? '';

      // Get customer information from the user profile or any other source
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

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment error: ${response.message}");
    // Add your error handling logic here
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet: ${response.walletName}");
    // Add your logic here (if needed)
  }

  void _navigateToOrderConfirmation(String paymentId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationPage(paymentId: paymentId),
      ),
    );
  }

  void _startPayment() {
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
      _razorpay.open(options);
    } catch (e) {
      print("Error in starting Razorpay payment: $e");
      // Handle error (e.g., show an error dialog)
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Cart"),
        actions: [
          if (cartItems.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                cartProvider.clearCart();
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Clear Cart',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
        child: Text(
          "Your cart is empty.",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: cartProvider.uniqueProductCount,
        itemBuilder: (context, index) {
          final product = cartProvider.uniqueProducts[index];
          final productCount = cartProvider.productCount(product['productId']);

          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(product['productImage'] ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['productName'],
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "Price: ₹${product['productPrice']?.toStringAsFixed(2) ?? 'N/A'}",
                          style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                cartProvider.decreaseQuantity(product['productId']);
                              },
                            ),
                            SizedBox(width: 10,),
                            Text(
                              "${product['quantity']}",
                              style: TextStyle(fontSize: 22),
                            ),
                            SizedBox(width: 10,),
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                cartProvider.increaseQuantity(product['productId']);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_shopping_cart),
                    onPressed: () {
                      cartProvider.removeFromCart(product['productId']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total: ₹${cartProvider.totalAmount()?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _startPayment();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Text(
                  'Proceed to Payment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      )
          : SizedBox.shrink(),
    );
  }
}

class OrderConfirmationPage extends StatelessWidget {
  final String paymentId;

  OrderConfirmationPage({required this.paymentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
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
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 8.0),
              Text(
                'Your order has been placed successfully.',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              Text(
                'Order Details:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 8.0),
              Text(
                'Payment ID: $paymentId',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              // Add more order details here, e.g., items, total amount, etc.
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // Add logic to navigate to the home page or any other desired page
                  Navigator.popUntil(context, (route) => route.isFirst);
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
    );
  }
}







