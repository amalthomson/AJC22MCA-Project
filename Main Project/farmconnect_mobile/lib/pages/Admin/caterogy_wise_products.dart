import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/pages/Admin/product_details.dart';
import 'package:farmconnect/widgets/admin_grid_card.dart';

class CategoryWiseProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 35.0),
              child: Icon(
                Icons.warehouse,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8,),
            Text(
              "Products Category",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
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
      backgroundColor: Colors.blueGrey[900],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
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

          final Set<String> categories = Set<String>();

          for (final product in products) {
            final category = product['category'];
            categories.add(category);
          }

          final List<Color> colors = [Colors.green.shade100, Colors.blue.shade100, Colors.orange.shade100];
          final List<IconData> icons = [Icons.shopping_cart, Icons.view_list, Icons.food_bank];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.0),
                Icon(
                  Icons.warehouse,
                  size: 80.0,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: categories.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true, // Wrap GridView with SingleChildScrollView
                  itemBuilder: (context, index) {
                    final category = categories.elementAt(index);
                    final colorIndex = index % colors.length; // Use modulo to loop through colors
                    final iconIndex = index % icons.length; // Use modulo to loop through icons
                    return GridCard( // Use AdminGridCard
                      title: category,
                      gradientColors: [colors[colorIndex], colors[colorIndex].withOpacity(0.9)],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProducts(category: category),
                          ),
                        );
                      },
                      icon: icons[iconIndex],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
