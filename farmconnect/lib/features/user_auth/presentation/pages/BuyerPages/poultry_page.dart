import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PoultryProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Poultry Products"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: 'Poultry')
            .where('isApproved', isEqualTo: 'approved')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final poultryProducts = snapshot.data!.docs;

          if (poultryProducts.isEmpty) {
            return Center(
              child: Text("No poultry products found."),
            );
          }

          return ListView.builder(
            itemCount: poultryProducts.length,
            itemBuilder: (context, index) {
              final product = poultryProducts[index];
              final productName = product['productName'];
              final productPrice = double.tryParse(product['productPrice'] ?? '0.0');
              final productImage = product['productImage'];

              return Card(
                elevation: 5,
                margin: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Image.network(
                      productImage,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        productName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Price: \₹${productPrice!.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
