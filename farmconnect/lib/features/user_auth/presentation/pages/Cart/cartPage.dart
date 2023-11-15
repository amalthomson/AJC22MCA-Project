import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/Cart/cartProvider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Cart"),
        actions: [
          cartItems.isNotEmpty
              ? ElevatedButton(
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
          )
              : SizedBox.shrink(),
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
                  // Product Image
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
                  // Product Details
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
                            // "-" Button
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
                  // Remove Button
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
                // Add your logic to proceed to payment
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
