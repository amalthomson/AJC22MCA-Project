import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryWiseProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'Product Categories',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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

          final Map<String, Map<String, List<DocumentSnapshot>>> productsByCategory = {};

          for (final product in products) {
            final category = product['category'];
            final productName = product['productName'];

            if (!productsByCategory.containsKey(category)) {
              productsByCategory[category] = {};
            }

            if (!productsByCategory[category]!.containsKey(productName)) {
              productsByCategory[category]![productName] = [];
            }

            productsByCategory[category]![productName]!.add(product);
          }

          return ListView.builder(
            itemCount: productsByCategory.length,
            itemBuilder: (context, index) {
              final category = productsByCategory.keys.elementAt(index);
              final categoryMap = productsByCategory[category]!;

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ExpansionTile(
                  title: Text(
                    'Category: $category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Updated category color
                    ),
                  ),
                  children: categoryMap.keys.map((productName) {
                    final productItems = categoryMap[productName]!;

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(productItems[0]['productImage'] ?? ''),
                              radius: 30,
                            ),
                            SizedBox(width: 16),
                            Text(
                              'Product Name: $productName',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        children: productItems.map((product) {
                          final productDescription = product['productDescription'];
                          final productPrice = product['productPrice'];
                          final stock = product['stock'];

                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Product Price: ₹$productPrice.00",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Product Description: $productDescription",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Stock: $stock KG",
                                    style: TextStyle(
                                      fontSize: 20,
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
