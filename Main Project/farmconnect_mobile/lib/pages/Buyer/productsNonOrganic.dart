import 'package:farmconnect/pages/Buyer/wishlistPage.dart';
import 'package:farmconnect/pages/Cart/cartPage.dart';
import 'package:flutter/material.dart';
import 'productsFruit.dart';
import 'productsVegetable.dart';
import 'productsDairy.dart';
import 'productsPoultry.dart';

class NonOrganicProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title: Text(
            "Non-Organic Products",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white), // Set back arrow color
          bottom: TabBar(
            labelColor: Colors.white, // Set tab text color
            unselectedLabelColor: Colors.white.withOpacity(0.6),
            tabs: [
              Tab(
                child: Hero(
                  tag: 'fruits_tab',
                  child: Icon(Icons.local_florist),
                ),
              ),
              Tab(
                child: Hero(
                  tag: 'vegetables_tab',
                  child: Icon(Icons.local_grocery_store),
                ),
              ),
              Tab(
                child: Hero(
                  tag: 'dairy_tab',
                  child: Icon(Icons.local_mall),
                ),
              ),
              Tab(
                child: Hero(
                  tag: 'poultry_tab',
                  child: Icon(Icons.local_pizza),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FruitsProductsPage(),
            VegetableProductsPage(),
            DairyProductsPage(),
            PoultryProductsPage(),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                // Navigate to CartPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
              child: Icon(Icons.shopping_cart, color: Colors.white),
              backgroundColor: Colors.green,
            ),
            SizedBox(width: 16.0),
            FloatingActionButton(
              onPressed: () {
                // Navigate to WishlistPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WishlistPage()),
                );
              },
              child: Icon(Icons.favorite, color: Colors.white),
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
