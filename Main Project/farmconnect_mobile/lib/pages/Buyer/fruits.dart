import 'package:farmconnect/pages/Buyer/product_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:farmconnect/pages/Cart/cart_provider.dart';

class FruitsProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      cartProvider.setUserId(user.uid);
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          "Fruits",
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
            .where('category', isEqualTo: 'Fruit')
            .where('isApproved', isEqualTo: 'Approved')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final fruitProducts = snapshot.data!.docs;

          if (fruitProducts.isEmpty) {
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
            itemCount: fruitProducts.length,
            itemBuilder: (context, index) {
              final product = fruitProducts[index];
              final productName = product['productName'];
              final farmName = product['farmName'];
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(productId: productId),
                            ),
                          );
                        },
                        child: Image.network(
                          productImage,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
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
                          SizedBox(height: 10),
                          Text(
                            farmName,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Price: ₹${productPrice?.toStringAsFixed(2) ?? 'N/A'}/KG",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Expiry Date: ${product['expiryDate']}',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                      'farmName': farmName,
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
                                    isOutOfStock ? Colors.grey : Colors.green,
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
                              FutureBuilder<bool>(
                                future: isProductInWishlist(user!.uid, productId),
                                builder: (context, snapshot) {
                                  bool isProductInWishlist = snapshot.data ?? false;
                                  return IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: isProductInWishlist ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () async {
                                      await toggleWishlistStatus(user.uid, productId);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isProductInWishlist
                                                ? "$productName removed from Wishlist"
                                                : "$productName added to Wishlist",
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
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

  Future<bool> isProductInWishlist(String userId, String productId) async {
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

  Future<DocumentSnapshot> getProductDetails(String productId) async {
    // Fetch product details from the products collection
    return await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();
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
      'farmName': product['farmName'],
      'productDescription': product['productDescription'],
      'productPrice': product['productPrice'],
      'productImage': product['productImage'],
      'productId': productId,
    });
  }
}
