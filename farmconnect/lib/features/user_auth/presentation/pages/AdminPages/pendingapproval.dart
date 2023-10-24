import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PendingApprovalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Approval Products"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('isApproved', isEqualTo: 'no')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return Center(
              child: Text("No pending approval products found."),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final productName = product['productName'];
              final productPrice = product['productPrice'];
              final productDescription = product['productDescription'];
              final category = product['category'];
              final productImage = product['productImage'] ?? '';
              final userId = product['userId'];

              return ExpansionTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(productImage), // Display the product image
                ),
                title: Text(productName),
                children: [
                  ListTile(
                    title: Text("Price: $productPrice"),
                  ),
                  ListTile(
                    title: Text("Description: $productDescription"),
                  ),
                  ListTile(
                    title: Text("Category: $category"),
                  ),
                  // Fetch and display farmer details
                  FarmerDetailsWidget(userId: userId),
                  // Add approve/reject buttons
                  ButtonBar(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Approve the product
                          FirebaseFirestore.instance
                              .collection('products')
                              .doc(product.id)
                              .update({'isApproved': 'approved'});
                        },
                        child: Text('Approve'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Reject the product
                          FirebaseFirestore.instance
                              .collection('products')
                              .doc(product.id)
                              .update({'isApproved': 'rejected'});
                        },
                        child: Text('Reject'),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class FarmerDetailsWidget extends StatelessWidget {
  final String userId;

  FarmerDetailsWidget({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text("Error fetching farmer details");
        }
        if (snapshot.hasData) {
          final farmerData = snapshot.data!.data();
          final farmerName = farmerData!['name'];
          final farmerEmail = farmerData['email'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text("Farmer: $farmerName"),
              ),
              ListTile(
                title: Text("Farmer Email: $farmerEmail"),
              ),
            ],
          );
        }
        return Text("No farmer details found");
      },
    );
  }
}
