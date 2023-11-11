import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "My Products",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where('isApproved', whereIn: ['Approved', 'no', 'Rejected'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return Center(
              child: Text("You have no products."),
            );
          }

          final Map<String, Map<String, List<DocumentSnapshot>>> productsByCategory = {};

          for (final product in products) {
            final category = product['category'];
            final subCategory = product['subCategory'];

            if (!productsByCategory.containsKey(category)) {
              productsByCategory[category] = {};
            }

            if (!productsByCategory[category]!.containsKey(subCategory)) {
              productsByCategory[category]![subCategory] = [];
            }

            productsByCategory[category]![subCategory]!.add(product);
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
                  title: Text('Category: $category'),
                  children: categoryMap.keys.map((subcategory) {
                    final subcategoryProducts = categoryMap[subcategory]!;

                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ExpansionTile(
                          title: Text('Subcategory: $subcategory'),
                          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          children: subcategoryProducts.map((product) {
                            final productDescription = product['productDescription'];
                            final isApproved = product['isApproved'];
                            final productImage = product['productImage'] ?? '';
                            final remark = product['remark'];

                            String status = 'Pending Approval';
                            if (isApproved == 'approved') {
                              status = 'Approved';
                            } else if (isApproved == 'rejected') {
                              status = 'Rejected';
                            }

                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: ExpansionTile(
                                  title: Text(productDescription),
                                  tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(productImage),
                                    radius: 30,
                                  ),
                                  children: [
                                    ListTile(
                                      title: GestureDetector(
                                        child: Text("Status: $status",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Remark"),
                                                content: Text(remark != null ? remark : "No remark available"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("Close"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
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
