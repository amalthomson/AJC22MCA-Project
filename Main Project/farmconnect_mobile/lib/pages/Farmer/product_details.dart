import 'package:farmconnect/pages/Buyer/reviews_ratings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmconnect/pages/Cart/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetail extends StatelessWidget {
  final String productId;

  ProductDetail({required this.productId});

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
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Product Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      Text(
                        'Expiry Date: ${product['expiryDate']}',
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
                ),
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
              ignoreGestures: true,
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