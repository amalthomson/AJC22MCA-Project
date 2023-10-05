import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: AdminDashboard(),
  ));
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int numberOfBuyers = 0;
  int numberOfFarmers = 0;
  int numberOfPendingRequests = 0; // New
  int numberOfRequestApprovals = 0; // New

  @override
  void initState() {
    super.initState();
    fetchUserCounts();
  }

  Future<void> fetchUserCounts() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    final buyerQuery = await usersCollection.where('role', isEqualTo: 'Buyer').get();
    numberOfBuyers = buyerQuery.docs.length;

    final farmerQuery = await usersCollection.where('role', isEqualTo: 'Farmer').get();
    numberOfFarmers = farmerQuery.docs.length;

    // Fetch the count of pending requests (customize as needed)
    final pendingRequestsQuery = await FirebaseFirestore.instance.collection('requests').where('status', isEqualTo: 'Pending').get();
    numberOfPendingRequests = pendingRequestsQuery.docs.length;

    // Fetch the count of request approvals (customize as needed)
    final requestApprovalsQuery = await FirebaseFirestore.instance.collection('requests').where('status', isEqualTo: 'Approved').get();
    numberOfRequestApprovals = requestApprovalsQuery.docs.length;

    setState(() {});
  }

  Future<void> _refreshData() async {
    await fetchUserCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Admin Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
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
        child: GridView.count(
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
                title: "      User\nVerification",
                count: numberOfPendingRequests,
                tileColor: Colors.orange,
              ),
              onTap: () {
                // Handle navigation for "User Verification"
                // Navigator.pushNamed(context, '/user_verification');
              },
            ),
            InkWell(
              child: AdminDashboardTile(
                title: "   Product\nVerification",
                count: numberOfRequestApprovals,
                tileColor: Colors.red,
              ),
              onTap: () {
                // Handle navigation for "Product Verification"
                // Navigator.pushNamed(context, '/product_verification');
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: DashboardCard(
        title: "Sign Out",
        icon: Icons.logout,
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushNamed(context, "/login");
        },
        backgroundColor: Colors.red,
        textColor: Colors.white,
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
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Card(
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
      ),
    );
  }
}