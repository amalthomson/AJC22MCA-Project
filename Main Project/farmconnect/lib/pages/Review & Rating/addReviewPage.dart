import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReviewPage extends StatefulWidget {
  final String category;
  final String productName;

  AddReviewPage({required this.category, required this.productName});

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  double _rating = 0;
  String _reviewText = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Review",
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
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Product: ${widget.productName}',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              _buildRatingSlider(),
              SizedBox(height: 20.0),
              _buildReviewTextField(),
              SizedBox(height: 20.0),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating: $_rating',
          style: TextStyle(
            fontSize: 36.0,
            color: Colors.white,
          ),
        ),
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
        decoration: InputDecoration(
          labelText: 'Add New Review',
          hintText: 'Enter your review here',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.grey[400]),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.black,
          contentPadding: EdgeInsets.all(15.0),
          errorStyle: TextStyle(color: Colors.redAccent),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your review';
          }
          return null;
        },
        style: TextStyle(color: Colors.white),
        onChanged: (value) {
          setState(() {
            _reviewText = value;
          });
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            User? currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null) {
              bool isBuyer = await _checkUserIsBuyer(currentUser.uid);
              if (isBuyer) {
                _submitReview(currentUser.uid);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Only buyers are allowed to add reviews'),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          }
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
    );
  }

  Future<bool> _checkUserIsBuyer(String userId) async {
    return true;
  }

  Future<void> _submitReview(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('reviews').add({
        'category': widget.category,
        'productName': widget.productName,
        'rating': _rating,
        'reviewText': _reviewText,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Review submitted successfully'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      print('Error submitting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit review: $e'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
