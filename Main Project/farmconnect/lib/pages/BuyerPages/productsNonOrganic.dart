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
          title: Text('Non-Organic Products'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Fruits'),
              Tab(text: 'Vegetables'),
              Tab(text: 'Dairy'),
              Tab(text: 'Poultry'),
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
      ),
    );
  }
}
