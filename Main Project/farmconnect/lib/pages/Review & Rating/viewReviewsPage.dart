import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ViewReviewsPage extends StatelessWidget {
  final String category;
  final String productName;

  ViewReviewsPage({required this.category, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Reviews",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey[900],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Product: $productName',
              style: TextStyle(
                fontSize: 28.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            _buildAverageRating(),
            SizedBox(height: 20.0),
            _buildReviewsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAverageRating() {
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
              'Average Rating: No Ratings Yet',
              style: TextStyle(
                fontSize: 24.0,
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

          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: averageRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 48,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      unratedColor: Colors.grey[400],
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    SizedBox(width: 8),
                    Text(
                      '(${averageRating.toStringAsFixed(1)})',
                      style: TextStyle(
                        fontSize: 36.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Center(
                  child: Text(
                    'Reviews & Ratings: $totalReviews',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildReviewsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('category', isEqualTo: category)
          .where('productName', isEqualTo: productName)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No Reviews and Ratings added Yet',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.red,
              ),
            ),
          );
        } else {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var reviewData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                var rating = reviewData['rating'] ?? 0.0;
                var reviewText = reviewData['reviewText'] ?? '';

                return Card(
                  color: Colors.blueGrey[800],
                  margin: EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 32,
                              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                              unratedColor: Colors.grey[400],
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            SizedBox(width: 8),
                            Text(
                              '|',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '(${rating.toStringAsFixed(1)})',
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Review: $reviewText',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
