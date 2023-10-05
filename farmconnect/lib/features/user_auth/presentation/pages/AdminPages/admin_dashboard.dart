import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/colors.dart';


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

  @override
  void initState() {
    super.initState();
    fetchUserCounts();
  }

  Future<void> fetchUserCounts() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Fetch the count of users with role "Buyer"
    final buyerQuery = await usersCollection.where('role', isEqualTo: 'Buyer').get();
    numberOfBuyers = buyerQuery.docs.length;

    // Fetch the count of users with role "Farmer"
    final farmerQuery = await usersCollection.where('role', isEqualTo: 'Farmer').get();
    numberOfFarmers = farmerQuery.docs.length;

    setState(() {}); // Update the UI with the fetched counts
  }

  Future<void> _refreshData() async {
    // Fetch updated data from the database
    await fetchUserCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Admin Dashboard"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh the data when the button is pressed
              _refreshData();
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        children: [
          InkWell(
            child: AdminDashboardTile(
              title: "Buyers",
              count: numberOfBuyers,
            ),
            onTap: (){
              Navigator.pushNamed(context, '/buyer_details');
            },
          ),
          InkWell(
            child: AdminDashboardTile(
              title: "Farmers",
              count: numberOfFarmers,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/farmer_details');
            },
          ),
          // Add other tiles (Pending Requests) here
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Center the button
      floatingActionButton: DashboardCard(
        title: "Sign Out",
        icon: Icons.logout,
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushNamed(context, "/login");
        },
        backgroundColor: Colors.red, // Set the button background color to red
        textColor: Colors.white, // Set the text color to white
      ),
    );
  }
}

class AdminDashboardTile extends StatelessWidget {
  final String title;
  final int count;

  const AdminDashboardTile({
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            count.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
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
  final Color backgroundColor; // Button background color
  final Color textColor; // Text color

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
      bottom: 20, // Adjust the position as needed
      left: 0,
      right: 0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        color: backgroundColor, // Set the background color
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
                  color: textColor, // Set the text color
                ),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor, // Set the text color
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
