import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReviewAndRating extends StatefulWidget {
  final String productId;

  AddReviewAndRating({required this.productId});

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewAndRating> {
  late BuildContext _context;
  TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;

  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    var productDoc = await FirebaseFirestore.instance.collection('products').doc(productId).get();
    return productDoc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Add Review',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              _buildSectionTitle('Rating'),
              SizedBox(height: 10.0),
              _buildRatingStars(),
              SizedBox(height: 60.0),
              _buildSectionTitle('Review'),
              SizedBox(height: 10.0),
              _buildReviewTextField(),
              SizedBox(height: 20.0),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildRatingStars() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'Rating: $_rating',
            style: TextStyle(
              fontSize: 36.0,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 10),
        RatingBar.builder(
          initialRating: _rating,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 72,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          unratedColor: Colors.grey[400], // Color of unselected stars
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber, // Color of selected stars
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        ),
      ],
    );
  }

  Widget _buildReviewTextField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: _reviewController,
        decoration: InputDecoration(
          labelText: 'Enter your review',
          labelStyle: TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.black,
        ),
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your review';
          }
          return null;
        },
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: ElevatedButton(
          onPressed: () {
            _addReviewToDatabase();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 3.0,
          ),
          child: Text(
            'Submit Review',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }

  void _addReviewToDatabase() async {
    if (_reviewController.text.isNotEmpty) {
      try {
        var productDetails = await getProductDetails(widget.productId);
        if (productDetails != null) {
          var productName = productDetails['productName'];
          var productCategory = productDetails['category'];
          await FirebaseFirestore.instance.collection('reviews').add({
            'productId': widget.productId,
            'productName': productName,
            'category': productCategory,
            'rating': _rating,
            'reviewText': _reviewController.text,
            'timestamp': FieldValue.serverTimestamp(),
          });
          Navigator.pop(_context);
        } else {
          ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
            content: Text('Failed to retrieve product details.'),
          ));
        }
      } catch (error) {
        print('Error fetching product details: $error');
      }
    } else {
      ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
        content: Text('Please enter a review before submitting.'),
      ));
    }
  }
}
