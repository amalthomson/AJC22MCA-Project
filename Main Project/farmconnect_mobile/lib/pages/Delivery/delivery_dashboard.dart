import 'package:farmconnect/pages/Delivery/profile.dart';
import 'package:farmconnect/widgets/delivery_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/pages/Delivery/orders_delivered.dart';
import 'package:farmconnect/pages/Delivery/orders_placed.dart';
import 'package:farmconnect/pages/Delivery/orders_shipped.dart';

class DeliveryDashboard extends StatefulWidget {
  @override
  _DeliveryDashboardState createState() => _DeliveryDashboardState();
}

class _DeliveryDashboardState extends State<DeliveryDashboard> {
  int _selectedIndex = 0; // Index of the selected tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Row(
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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          OrderPlaced(),
          OrderShipped(),
          OrderDelivered(),
          DeliveryProfile(),
        ],
      ),
      bottomNavigationBar: DeliveryCustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          Icon(Icons.view_list, size: 30),
          Icon(Icons.local_shipping, size: 30),
          Icon(Icons.done_all, size: 30),
          Icon(Icons.person, size: 30),
        ],
      ),
    );
  }
}
