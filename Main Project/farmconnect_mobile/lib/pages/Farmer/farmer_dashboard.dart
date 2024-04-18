import 'package:farmconnect/widgets/farmer_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/pages/Farmer/low_stock_products.dart';
import 'package:farmconnect/pages/Farmer/add_products.dart';
import 'package:farmconnect/pages/Farmer/agricultural_news.dart';
import 'package:farmconnect/pages/Farmer/profile.dart';
import 'package:farmconnect/pages/Farmer/my_products.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({Key? key}) : super(key: key);

  @override
  _FarmerDashboardState createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MyProductsPage(),
    LowStockProductsPage(),
    AddProducts(),
    AgriculturalNewsPage(),
    FarmerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/icons/appLogoDark.png'),
            ),
            SizedBox(width: 8),
            Text(
              "FarmConnect",
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: FarmerCustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          Icons.warehouse,
          Icons.storage,
          Icons.add_shopping_cart,
          Icons.info,
          Icons.person,
        ],
      ),
    );
  }
}
