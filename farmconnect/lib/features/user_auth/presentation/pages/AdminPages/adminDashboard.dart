import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int numberOfBuyers = 0;
  int numberOfFarmers = 0;
  int farmerApprovalPending = 0;
  int farmerApprovalRejected = 0;
  int pendingProducts = 0;
  int approvedProducts = 0;
  int rejectedProducts = 0;
  int numberOfPayments = 0;

  @override
  void initState() {
    super.initState();
    fetchUserCounts();
    fetchProductCounts();
    fetchPaymentCounts();
  }

  Future<void> fetchPaymentCounts() async {
    final paymentsCollection = FirebaseFirestore.instance.collection('payments');
    final paymentQuery = await paymentsCollection.get();
    numberOfPayments = paymentQuery.docs.length;
    setState(() {});
  }

  Future<void> fetchUserCounts() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final buyerQuery = await usersCollection.where('role', isEqualTo: 'Buyer').get();
    numberOfBuyers = buyerQuery.docs.length;

    final farmerApprovedQuery = await usersCollection
        .where('role', isEqualTo: 'Farmer')
        .where('isAdminApproved', isEqualTo: 'approved')
        .get();
    numberOfFarmers = farmerApprovedQuery.docs.length;

    final farmerPendingQuery = await usersCollection
        .where('role', isEqualTo: 'Farmer')
        .where('isAdminApproved', isEqualTo: 'pending')
        .get();
    farmerApprovalPending = farmerPendingQuery.docs.length;

    final farmerRejectedQuery = await usersCollection
        .where('role', isEqualTo: 'Farmer')
        .where('isAdminApproved', isEqualTo: 'rejected')
        .get();
    farmerApprovalRejected = farmerRejectedQuery.docs.length;

    setState(() {});
  }

  Future<void> fetchProductCounts() async {
    final productsCollection = FirebaseFirestore.instance.collection('products');
    final pendingQuery = await productsCollection.where('isApproved', isEqualTo: 'Pending').get();
    pendingProducts = pendingQuery.docs.length;
    final approvedQuery = await productsCollection.where('isApproved', isEqualTo: 'Approved').get();
    approvedProducts = approvedQuery.docs.length;
    final rejectedQuery = await productsCollection.where('isApproved', isEqualTo: 'Rejected').get();
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
            icon: Icon(Icons.logout),
            color: Colors.red,
            onPressed: () async {
              final FirebaseAuth _auth = FirebaseAuth.instance;
              final GoogleSignIn googleSignIn = GoogleSignIn();
              try {
                await _auth.signOut();
                await googleSignIn.signOut();
                Navigator.pushNamed(context, "/login");
              } catch (error) {
                print("Error signing out: $error");
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            color: Colors.green,
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
                    title: "Farmers",
                    count: numberOfFarmers,
                    tileColor: Colors.blue,
                    iconData: Icons.people,
                    gradientColors: [Colors.blue.shade300, Colors.blue.shade900],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/farmer_details');
                  },
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/buyer_details');
                  },
                  child: AdminDashboardTile(
                    title: "Buyers",
                    count: numberOfBuyers,
                    tileColor: Colors.blue,
                    iconData: Icons.shopping_cart,
                    gradientColors: [Colors.blue.shade300, Colors.blue.shade900],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/farmer_approval_pending');
                  },
                  child: AdminDashboardTile(
                    title: "Farmer Approval\n       Pending",
                    count: farmerApprovalPending,
                    tileColor: Colors.orange,
                    iconData: Icons.pending,
                    gradientColors: [Colors.orange.shade300, Colors.orange.shade900],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/farmer_approval_rejected');
                  },
                  child: AdminDashboardTile(
                    title: "Farmer Approval\n       Rejected",
                    count: farmerApprovalRejected,
                    tileColor: Colors.red,
                    iconData: Icons.cancel,
                    gradientColors: [Colors.red.shade300, Colors.red.shade900],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/pendingapproval');
                  },
                  child: AdminDashboardTile(
                    title: " Pending\nApproval",
                    count: pendingProducts,
                    tileColor: Colors.orange,
                    iconData: Icons.timer,
                    gradientColors: [Colors.orange.shade300, Colors.orange.shade900],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/approvedproducts');
                  },
                  child: AdminDashboardTile(
                    title: "Approved\nProducts",
                    count: approvedProducts,
                    tileColor: Colors.green,
                    iconData: Icons.check_circle,
                    gradientColors: [Colors.green.shade300, Colors.green.shade900],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/rejectedproducts');
                  },
                  child: AdminDashboardTile(
                    title: "Rejected\nProducts",
                    count: rejectedProducts,
                    tileColor: Colors.red,
                    iconData: Icons.cancel,
                    gradientColors: [Colors.red.shade300, Colors.red.shade900],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/products_categoryWise');
                  },
                  child: AdminDashboardTile(
                    title: "    Products\nCategory Wise",
                    count: 4,
                    tileColor: Colors.red,
                    iconData: Icons.shopping_cart,
                    gradientColors: [Colors.blue, Colors.blue],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/paymentSuccessful');
                  },
                  child: AdminDashboardTile(
                    title: " Payments\nSuccessful",
                    count: numberOfPayments,
                    tileColor: Colors.red,
                    iconData: Icons.payments,
                    gradientColors: [Colors.blue, Colors.blue],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/testing');
                  },
                  child: AdminDashboardTile(
                    title: "Testing",
                    count: 0,
                    tileColor: Colors.grey,
                    iconData: Icons.sms_failed_rounded,
                    gradientColors: [Colors.grey, Colors.grey],
                  ),
                ),
              ],
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
  final IconData iconData; // Icon data for the tile
  final List<Color> gradientColors; // List of colors for gradient

  const AdminDashboardTile({
    required this.title,
    required this.count,
    required this.tileColor,
    required this.iconData,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0), // Rounded edges
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors, // Use the provided gradient colors
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData, // Use the provided icon data
              color: Colors.white,
              size: 40.0,
            ),
            SizedBox(height: 10.0),
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
      ),
    );
  }
}


