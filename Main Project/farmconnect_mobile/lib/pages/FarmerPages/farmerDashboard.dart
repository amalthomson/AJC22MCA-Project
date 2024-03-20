import 'package:farmconnect/pages/FarmerPages/LowStockProductsPage.dart';
import 'package:farmconnect/pages/FarmerPages/addproducts.dart';
import 'package:farmconnect/pages/FarmerPages/agriculturalNewsPage.dart';
import 'package:farmconnect/pages/FarmerPages/farmer_page.dart';
import 'package:farmconnect/pages/FarmerPages/myproducts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({Key? key}) : super(key: key);

  @override
  _FarmerDashboardState createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Farmer Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blueGrey[900],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.red,
              onPressed: () async {
                final FirebaseAuth _auth = FirebaseAuth.instance;
                final GoogleSignIn googleSignIn = GoogleSignIn();

                try {
                  await _auth.signOut();
                  await googleSignIn.signOut();
                  Navigator.pushReplacementNamed(context, "/login");
                } catch (error) {
                  print("Error signing out: $error");
                }
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Add Products",
                icon: Icon(Icons.add),
              ),
              Tab(
                text: "My Products",
                icon: Icon(Icons.store),
              ),
              Tab(
                text: "Low Stock Products",
                icon: Icon(Icons.store),
              ),
              Tab(
                text: "Agri News",
                icon: Icon(Icons.info),
              ),
              Tab(
                text: "Profile",
                icon: Icon(Icons.person),
              ),
            ],
            indicatorColor: Colors.green,
            unselectedLabelColor: Colors.white, // Set the color of unselected tabs
            labelColor: Colors.green, // Set the color of the selected tab
          ),
        ),
        backgroundColor: Colors.black,
        body: TabBarView(
          children: <Widget>[
            AddProducts(),
            MyProductsPage(),
            LowStockProductsPage(),
            AgriculturalNewsPage(),
            FarmerPage(),
          ],
        ),
      ),
    );
  }
}
