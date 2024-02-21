import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmconnect/pages/Cart/cartPage.dart'; // Import your CartPage

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';

    Future<void> clearWishlist() async {
      // Delete all products in the user's Wishlist
      await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(userId)
          .collection('items')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    }

    Future<void> removeProductFromWishlist(String productId) async {
      // Remove a specific product from the user's Wishlist
      await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(userId)
          .collection('items')
          .doc(productId)
          .delete();

      // Show snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Product removed from Wishlist"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey[900],
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                clearWishlist();
              },
              child: Text('Clear Wishlist', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Background color
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('wishlist')
            .doc(userId)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? true)) {
            return Center(
              child: Text(
                'Your wishlist is empty.',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          }

          final wishlistItems = snapshot.data?.docs;

          return ListView.builder(
            itemCount: wishlistItems?.length,
            itemBuilder: (context, index) {
              final wishlistItem = wishlistItems?[index];
              final productName = wishlistItem?['productName'];
              final productPrice = wishlistItem?['productPrice'] ?? 'N/A';
              final productImage = wishlistItem?['productImage'];
              final productId = wishlistItem?.id;

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  productName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red, // Adjust the color as needed
                                  ),
                                  onPressed: () {
                                    removeProductFromWishlist(productId!);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Price: ₹$productPrice/KG',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()), // Navigate to CartPage
          );
        },
        child: Icon(Icons.shopping_cart),
        backgroundColor: Colors.green,
      ),
    );
  }
}
