import 'package:farmconnect/pages/Cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'fruits.dart';
import 'vegetable.dart';
import 'dairy.dart';
import 'poultry.dart';
import 'wishlist.dart';

class NonOrganicHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white), // Set back arrow color to white
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red), // Set Wishlist icon color to red
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Wishlist()),
                    );
                  },
                ),
              ),
            ],
            bottom: TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              tabs: [
                Tab(
                  child: Hero(
                    tag: 'fruits_tab',
                    child: FaIcon(FontAwesomeIcons.seedling),
                  ),
                ),
                Tab(
                  child: Hero(
                    tag: 'vegetables_tab',
                    child: FaIcon(FontAwesomeIcons.leaf),
                  ),
                ),
                Tab(
                  child: Hero(
                    tag: 'dairy_tab',
                    child: FaIcon(FontAwesomeIcons.store),
                  ),
                ),
                Tab(
                  child: Hero(
                    tag: 'poultry_tab',
                    child: Icon(Icons.egg),
                  ),
                ),
              ],
            ),
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
      ),
    );
  }
}
