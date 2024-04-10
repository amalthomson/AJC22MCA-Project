import 'package:farmconnect/pages/Admin//products_approvals.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovedProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Icon(
                Icons.store,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8,),
            Text(
              "Approved Products",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true, // Center the title horizontally
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.blueGrey[900]!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: 5.0,
          ),
        ),
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
              child: Container(
                margin: EdgeInsets.all(16.0), // Add margin
                child: Text(
                  "No approved products found.",
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                    fontSize: 18,
                  ),
                ),
              ),
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
                      productName, // Use subcategory instead of productName
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
