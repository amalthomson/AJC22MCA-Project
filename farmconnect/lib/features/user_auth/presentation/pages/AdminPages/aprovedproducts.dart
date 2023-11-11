import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/pendingapproval.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/rejectedproducts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovedProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Approved Products"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('isApproved', isEqualTo: 'Approved')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return Center(
              child: Text("No approved products found."),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final subcategory = product['subCategory'];
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
                      subcategory, // Use subcategory instead of productName
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.currency_rupee,
                          color: Colors.green,
                          size: 28,
                        ),
                        title: Text(
                          "Price",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          productPrice,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.description,
                          color: Colors.green,
                          size: 28,
                        ),
                        title: Text(
                          "Description",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          productDescription,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.category,
                          color: Colors.green,
                          size: 28,
                        ),
                        title: Text(
                          "Category",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          category,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      FarmerDetailsWidget(userId: userId),
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
}
