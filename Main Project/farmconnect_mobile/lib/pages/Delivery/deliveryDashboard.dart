import 'package:farmconnect/pages/Delivery/ordersDelivered.dart';
import 'package:farmconnect/pages/Delivery/ordersPlaced.dart';
import 'package:farmconnect/pages/Delivery/ordersShipped.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DeliveryDashboard extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      Navigator.pushReplacementNamed(context, "/login");
    } catch (error) {
      print("Error signing out: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Delivery Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.grey[900],
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => _signOut(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Hero(
                  tag: 'order_placed',
                  child: Icon(Icons.add_shopping_cart),
                ),
                text: 'Orders Placed',
              ),
              Tab(
                icon: Hero(
                  tag: 'order_shipped',
                  child: Icon(Icons.local_shipping),
                ),
                text: 'Orders Shipped',
              ),
              Tab(
                icon: Hero(
                  tag: 'order_delivered',
                  child: Icon(Icons.person),
                ),
                text: 'Orders Delivered',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderPlaced(),
            OrderShipped(),
            OrderDelivered(),
          ],
        ),
      ),
    );
  }
}
