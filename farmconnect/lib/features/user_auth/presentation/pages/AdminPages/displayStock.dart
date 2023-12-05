import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StockByProductNamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'Products Stock',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Set the back button color to white
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('isApproved', isEqualTo: 'Approved') // Only show approved products
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return Center(
              child: Text(
                "No approved products available.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            );
          }

          final Map<String, List<DocumentSnapshot>> productsByProductName = {};

          for (final product in products) {
            final productName = product['productName'];

            if (!productsByProductName.containsKey(productName)) {
              productsByProductName[productName] = [];
            }

            productsByProductName[productName]!.add(product);
          }

          return ListView.builder(
            itemCount: productsByProductName.length,
            itemBuilder: (context, index) {
              final productName = productsByProductName.keys.elementAt(index);
              final productItems = productsByProductName[productName]!;

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ExpansionTile(
                  title: Text(
                    '$productName',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  children: productItems.map((product) {
                    final productDescription = product['productDescription'];
                    final productPrice = product['productPrice'];
                    final stock = product['stock'];
                    final productImage = product['productImage'];

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(productImage ?? ''),
                          radius: 30,
                        ),
                        title: Text(
                          "Product Price: ₹$productPrice.00",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product Description: $productDescription",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Stock: $stock KG",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
