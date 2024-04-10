import 'package:farmconnect/pages/Farmer/CategoryProductsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Background color
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where('isApproved', whereIn: ['Approved', 'Pending', 'Rejected'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return Center(
              child: Text(
                "You have no products.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          final Set<String> categories = Set<String>();

          for (final product in products) {
            final category = product['category'];
            categories.add(category);
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: categories.length,
              physics: NeverScrollableScrollPhysics(), // Disable scrolling
              itemBuilder: (context, index) {
                final category = categories.elementAt(index);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductsPage(category: category),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.blueGrey[800], // Custom background color
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.category, size: 50, color: Colors.white), // Custom icon color
                        SizedBox(height: 10),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
        },
      ),
    );
  }
}
