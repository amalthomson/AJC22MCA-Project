import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LowStockProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Column(
        children: [
          SizedBox(height: 20),
          Icon(
            Icons.store,
            size: 80,
            color: Colors.white,
          ),
          SizedBox(height: 20), // Add some space between icon and list view
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .where('isApproved', isEqualTo: 'Approved')
                  .where('stock', isLessThan: 10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data!.docs;

                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      "No low stock products.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final productName = product['productName'];
                    final stock = product['stock'];
                    final productPrice = product['productPrice'];
                    final productImage = product['productImage'];
                    final category = product['category'];
                    final expiryDate = product['expiryDate'];

                    return Container(
                      child: Card(
                        color: Colors.blueGrey[800],
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.network(
                              productImage ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            productName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Category: $category',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Price: ₹$productPrice.00',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'Stock: $stock KG',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                'Expiry Date: $expiryDate',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
