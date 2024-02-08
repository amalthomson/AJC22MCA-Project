import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmconnect/pages/Cart/cartProvider.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  ProductDetailPage({required this.productId});

  Future<DocumentSnapshot> getProductDetails(String productId) async {
    return await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getProductDetails(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Product not found'));
          }

          final product = snapshot.data!.data() as Map<String, dynamic>;

          // Improved type checking for productPrice
          final dynamic productPrice = product['productPrice'];
          final price = productPrice is num
              ? productPrice.toStringAsFixed(2)
              : productPrice is String
              ? double.tryParse(productPrice)?.toStringAsFixed(2) ?? 'N/A'
              : 'N/A';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(product['productImage']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['productName'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product['productDescription'],
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '₹$price',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      if (user != null) {
                        // Add to Cart
                        cartProvider.addToCart({
                          'productName': product['productName'],
                          'productDescription': product['productDescription'],
                          'productPrice': productPrice,
                          'productImage': product['productImage'],
                          'productId': productId,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added ${product['productName']} to the cart'),
                          ),
                        );
                      } else {
                        // Handle case when user is not logged in
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please log in to add to cart'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: FutureBuilder<bool>(
                    future: isProductInWishlist(user?.uid, productId),
                    builder: (context, snapshot) {
                      bool isProductInWishlist = snapshot.data ?? false;
                      return ElevatedButton(
                        onPressed: () async {
                          if (user != null) {
                            await toggleWishlistStatus(user.uid, productId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isProductInWishlist
                                      ? '${product['productName']} removed from Wishlist'
                                      : '${product['productName']} added to Wishlist',
                                ),
                              ),
                            );
                          } else {
                            // Handle case when user is not logged in
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please log in to add to wishlist'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: isProductInWishlist ? Colors.grey : Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              isProductInWishlist ? 'Remove from Wishlist' : 'Add to Wishlist',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> isProductInWishlist(String? userId, String productId) async {
    if (userId == null) {
      return false;
    }

    final docSnapshot = await FirebaseFirestore.instance
        .collection('wishlist')
        .doc(userId)
        .collection('items')
        .doc(productId)
        .get();

    return docSnapshot.exists;
  }

  Future<void> toggleWishlistStatus(String userId, String productId) async {
    final docRef = FirebaseFirestore.instance
        .collection('wishlist')
        .doc(userId)
        .collection('items')
        .doc(productId);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Product exists in the wishlist, remove it
      await docRef.delete();
    } else {
      // Product doesn't exist in the wishlist, add it
      await addToWishlist(userId, await getProductDetails(productId));
    }
  }

  Future<void> addToWishlist(String userId, DocumentSnapshot product) async {
    final productId = product['productId'];
    await FirebaseFirestore.instance
        .collection('wishlist')
        .doc(userId)
        .collection('items')
        .doc(productId)
        .set({
      'productName': product['productName'],
      'productDescription': product['productDescription'],
      'productPrice': product['productPrice'],
      'productImage': product['productImage'],
      'productId': productId,
    });
  }
}
