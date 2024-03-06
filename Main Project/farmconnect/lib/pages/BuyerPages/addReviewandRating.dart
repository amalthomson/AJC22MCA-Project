import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddReviewAndRating extends StatefulWidget {
  final String productId; // Assuming you have a unique identifier for the product

  AddReviewAndRating({required this.productId});

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewAndRating> {
  late BuildContext _context;
  TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0; // Initial rating

  @override
  Widget build(BuildContext context) {
    _context = context; // Store the context during build

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Rating: $_rating'),
            Slider(
              value: _rating,
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
              min: 0,
              max: 5,
              divisions: 5,
              label: _rating.toString(),
            ),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Enter your review',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addReviewToDatabase();
              },
              child: Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }

  void _addReviewToDatabase() async {
    if (_reviewController.text.isNotEmpty) {
      // Add the review and rating to the Firestore database
      await FirebaseFirestore.instance.collection('reviews').add({
        'productId': widget.productId,
        'rating': _rating,
        'review': _reviewController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Navigate back to the previous screen or any other desired navigation logic
      Navigator.pop(_context);
    } else {
      // Show an error message if the review text is empty
      ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
        content: Text('Please enter a review before submitting.'),
      ));
    }
  }
}
