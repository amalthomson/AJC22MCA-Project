import 'package:farmconnect/features/user_auth/presentation/pages/Cart/paymentService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'cartProvider.dart';

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
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
      PaymentService.handlePaymentSuccess(context, response);
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, PaymentService.handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, PaymentService.handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _startPayment() {
    PaymentService.startPayment(context);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Cart"),
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
              onPressed: _startPayment,
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
