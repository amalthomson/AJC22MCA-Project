import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/pages/Farmer/products_categorywise.dart';
import 'package:farmconnect/widgets/grid_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> categoryData = [
    {"category": "Dairy", "icon": Icons.ac_unit, "gradientColors": [Colors.red, Colors.orange]},
    {"category": "Fruits", "icon": Icons.line_style, "gradientColors": [Colors.blue, Colors.green]},
    {"category": "Organic", "icon": Icons.ac_unit, "gradientColors": [Colors.purple, Colors.indigo]},
    {"category": "Poultry", "icon": Icons.list, "gradientColors": [Colors.green, Colors.grey]},
    {"category": "Vegetables", "icon": Icons.line_style, "gradientColors": [Colors.yellow, Colors.orange]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Column(
        children: [
          SizedBox(height: 20), // Add some space between app bar and icon
          FaIcon(
            FontAwesomeIcons.warehouse,
            size: 80,
            color: Colors.white,
          ),
          SizedBox(height: 20),  // Add some space between icon and grid view
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .where('isApproved', whereIn: ['Approved', 'Pending', 'Rejected'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data!.docs;

                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      "You have no products.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                final Map<String, List<Map<String, dynamic>>> categoryMap = {};

                for (final product in products) {
                  final category = product['category'];
                  categoryMap.putIfAbsent(category, () => []);
                  categoryMap[category]!.add(product.data() as Map<String, dynamic>);
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: categoryMap.length,
                    physics: NeverScrollableScrollPhysics(), // Disable scrolling
                    itemBuilder: (context, index) {
                      final category = categoryMap.keys.elementAt(index);
                      final categoryInfo = categoryData[index % categoryData.length];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryProductsPage(category: category),
                            ),
                          );
                        },
                        child: GridCard(
                          title: category,
                          gradientColors: categoryInfo["gradientColors"], // Get gradient colors
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryProductsPage(category: category),
                              ),
                            );
                          },
                          icon: categoryInfo["icon"], // Get icon
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
