import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int numberOfBuyers = 0;
  int numberOfFarmers = 0;
  int pendingProducts = 0;
  int approvedProducts = 0;
  int rejectedProducts = 0;

  @override
  void initState() {
    super.initState();
    fetchUserCounts();
    fetchProductCounts();
  }

  Future<void> fetchUserCounts() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    final buyerQuery = await usersCollection.where('role', isEqualTo: 'Buyer').get();
    numberOfBuyers = buyerQuery.docs.length;

    final farmerQuery = await usersCollection.where('role', isEqualTo: 'Farmer').get();
    numberOfFarmers = farmerQuery.docs.length;

    setState(() {});
  }

  Future<void> fetchProductCounts() async {
    final productsCollection = FirebaseFirestore.instance.collection('products');

    final pendingQuery = await productsCollection.where('isApproved', isEqualTo: 'no').get();
    pendingProducts = pendingQuery.docs.length;

    final approvedQuery = await productsCollection.where('isApproved', isEqualTo: 'approved').get();
    approvedProducts = approvedQuery.docs.length;

    final rejectedQuery = await productsCollection.where('isApproved', isEqualTo: 'rejected').get();
    rejectedProducts = rejectedQuery.docs.length;

    setState(() {});
  }

  Future<void> _refreshData() async {
    await fetchUserCounts();
    await fetchProductCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          "Admin Dashboard",
          style: TextStyle(
            color: Colors.green,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _refreshData();
            },
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16.0),
              children: [
                InkWell(
                  child: AdminDashboardTile(
                    title: "Buyers",
                    count: numberOfBuyers,
                    tileColor: Colors.blue,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/buyer_details');
                  },
                ),
                InkWell(
                  child: AdminDashboardTile(
                    title: "Farmers",
                    count: numberOfFarmers,
                    tileColor: Colors.green,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/farmer_details');
                  },
                ),
                InkWell(
                  child: AdminDashboardTile(
                    title: "Pending Products",
                    count: pendingProducts,
                    tileColor: Colors.deepOrange,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/pendingapproval');
                  },
                ),
                InkWell(
                  child: AdminDashboardTile(
                    title: "Approved Products",
                    count: approvedProducts,
                    tileColor: Colors.cyanAccent,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/approvedproducts');
                  },
                ),
                InkWell(
                  child: AdminDashboardTile(
                    title: "Rejected Products",
                    count: rejectedProducts,
                    tileColor: Colors.purpleAccent,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/rejectedproducts');
                  },
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: DashboardCard(
                title: "Sign Out",
                icon: Icons.logout,
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/login");
                },
                backgroundColor: Colors.red,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminDashboardTile extends StatelessWidget {
  final String title;
  final int count;
  final Color tileColor;

  const AdminDashboardTile({
    required this.title,
    required this.count,
    required this.tileColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: tileColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  DashboardCard({
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      color: backgroundColor,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36,
                color: textColor,
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
