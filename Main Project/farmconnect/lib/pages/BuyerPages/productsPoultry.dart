import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:farmconnect/pages/Cart/cartProvider.dart';

class PoultryProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Poultry Products",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: 'Poultry')
            .where('isApproved', isEqualTo: 'Approved')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final poultryProducts = snapshot.data!.docs;

          if (poultryProducts.isEmpty) {
            return Center(
              child: Text(
                "No products available at the moment.\n\nPlease check back later,\n as we are updating our stocks.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: poultryProducts.length,
            itemBuilder: (context, index) {
              final product = poultryProducts[index];
              final productName = product['productName'];
              final productDescription = product['productDescription'];
              final productPrice = double.tryParse(product['productPrice'] ?? '0.0');
              final productImage = product['productImage'];
              final productId = product['productId'];
              final productStock = product['stock'] ?? 0;

              bool isProductInCart = cartProvider.cartItems
                  .any((item) => item['productId'] == productId);

              bool isOutOfStock = productStock == 0;

              return Card(
                elevation: 5,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Image.network(
                              productImage,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              productDescription,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Price: ₹${productPrice?.toStringAsFixed(2) ?? 'N/A'}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (isOutOfStock) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Out of Stock"),
                                    ),
                                  );
                                } else if (isProductInCart) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("$productName is already in the cart"),
                                    ),
                                  );
                                } else {
                                  cartProvider.addToCart({
                                    'productName': productName,
                                    'productDescription': productDescription,
                                    'productPrice': productPrice,
                                    'productImage': productImage,
                                    'productId': productId,
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Added $productName to the cart"),
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  isOutOfStock ? Colors.grey : Colors.orange,
                                ),
                              ),
                              child: Text(
                                isOutOfStock ? "Out of Stock" : "Add to Cart",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
