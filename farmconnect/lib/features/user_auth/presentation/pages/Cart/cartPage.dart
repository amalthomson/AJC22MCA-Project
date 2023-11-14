import 'package:farmconnect/features/user_auth/presentation/pages/Cart/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartItems[index];

          return ListTile(
            title: Text(cartItem['productName']),
            subtitle: Text("Price: ₹${cartItem['productPrice']?.toStringAsFixed(2) ?? 'N/A'}"),
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () {
                cartProvider.removeFromCart(index);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          cartProvider.clearCart();
          Navigator.pop(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Clear Cart',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
