import 'package:farmconnect/pages/Review%20&%20Rating/addReview.dart';
import 'package:farmconnect/pages/Review%20&%20Rating/viewReviewsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmconnect/pages/Cart/cartProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
      backgroundColor: Colors.black,
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
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product['productDescription'],
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '₹${price ?? 'N/A'}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _buildRatingAndReviews(product['category'], product['productName']),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddReview(
                            category: product['category'],
                            productName: product['productName'],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rate_review, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Add Review and Ratings',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewReviewsPage(
                            category: product['category'],
                            productName: product['productName'],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'View Reviews and Ratings',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
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
      await docRef.delete();
    } else {
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

Widget _buildRatingAndReviews(String category, String productName) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('reviews')
        .where('category', isEqualTo: category)
        .where('productName', isEqualTo: productName)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white));
      } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(
          child: Text(
            'No Reviews Yet',
            style: TextStyle(
              fontSize: 32.0,
              color: Colors.grey,
            ),
          ),
        );
      } else {
        var totalRatings = 0.0;
        var totalReviews = snapshot.data!.docs.length;

        for (var doc in snapshot.data!.docs) {
          var reviewData = doc.data() as Map<String, dynamic>;
          var rating = (reviewData['rating'] ?? 0).toDouble();
          totalRatings += rating;
        }

        var averageRating = totalRatings / totalReviews;

        return Row(
          children: [
            RatingBar.builder(
              initialRating: averageRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, index) {
                return Icon(
                  index < averageRating.floor()
                      ? Icons.star
                      : (index + 0.5).floor() == averageRating.floor()
                      ? Icons.star_half
                      : Icons.star_border,
                  color: Colors.amber,
                );
              },
              onRatingUpdate: (rating) {
                // You can use this callback to handle rating updates
              },
            ),
            SizedBox(width: 8),
            Text(
              '${averageRating.toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '|',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '$totalReviews Ratings',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ],
        );
      }
    },
  );
}