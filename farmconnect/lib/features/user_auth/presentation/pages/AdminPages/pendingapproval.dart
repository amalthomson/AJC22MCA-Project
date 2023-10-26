import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PendingApprovalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        title: Text("Pending Approval Products"),
        backgroundColor: Colors.blueGrey[900], // Set app bar background color
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('isApproved', isEqualTo: 'no')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
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

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(productImage),
                      radius: 30,
                    ),
                    title: Text(
                      productName,
                      style: TextStyle(
                        color: Colors.green, // Change text color to green
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    childrenPadding: EdgeInsets.all(16),
                    children: [
                      buildDetailItem(Icons.attach_money, "Price", productPrice),
                      buildDetailItem(Icons.description, "Description", productDescription),
                      buildDetailItem(Icons.category, "Category", category),
                      // Fetch and display farmer details
                      FarmerDetailsWidget(userId: userId),
                      // Add approve/reject buttons
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
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
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildDetailItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black, // Set icon color to black
        size: 28,
      ),
      title: Text(
        "$label: $value",
        style: TextStyle(
          color: Colors.black, // Set text color to black
          fontSize: 16,
        ),
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
                leading: Icon(
                  Icons.person,
                  color: Colors.black, // Set icon color to black
                  size: 28,
                ),
                title: Text(
                  "Farmer: $farmerName",
                  style: TextStyle(
                    color: Colors.black, // Set text color to black
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        }
        return Text("No farmer details found");
      },
    );
  }
}
