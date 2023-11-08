import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RejectedProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        title: Text("Rejected Products"),
        backgroundColor: Colors.blueGrey[900], // Set app bar background color
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('isApproved', isEqualTo: 'rejected') // Filter rejected products
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return Center(
              child: Text("No rejected products found."),
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
              final remark = product['remark'] ?? ''; // New line to get "remark" field

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
                      ListTile(
                        leading: Icon(
                          Icons.note,
                          color: Colors.green,
                          size: 28,
                        ),
                        title: Text(
                          "Remark",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          remark,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      //FarmerDetailsWidget(userId: userId),
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.green,
                  size: 28,
                ),
                title: Text(
                  "Farmer",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  farmerName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
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
