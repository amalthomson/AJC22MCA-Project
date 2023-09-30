import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Dashboard"),
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            var userData = snapshot.data?.data();
            var userEmail = FirebaseAuth.instance.currentUser?.email;

            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/bgImage.jpg'), // Background image
                  fit: BoxFit.cover, // Adjust the fit as needed
                ),
              ),
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white, // Border color
                        width: 4.0, // Border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60, // Adjust the radius to fit the available space
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/dp.png',
                          fit: BoxFit.cover, // Scale the image to fit
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Welcome,",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.white, // Text color
                    ),
                  ),
                  Text(
                    "${userEmail ?? 'User'}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: Colors.white, // Text color
                    ),
                  ),
                  SizedBox(height: 30),
                  DashboardCard(
                    title: "Edit Profile",
                    icon: Icons.edit,
                    onPressed: () {
                      // Navigate to the Edit Profile page
                      Navigator.pushNamed(context, "/edit_profile");
                    },
                  ),
                  SizedBox(height: 16),
                  DashboardCard(
                    title: "View Orders",
                    icon: Icons.shopping_cart,
                    onPressed: () {
                      // Add action for viewing orders
                    },
                  ),
                  SizedBox(height: 16),
                  DashboardCard(
                    title: "Update Details",
                    icon: Icons.update,
                    onPressed: () {
                      Navigator.pushNamed(context, "/update_details");
                      // Add action for settings
                    },
                  ),
                  SizedBox(height: 16),
                  DashboardCard(
                    title: "Sign Out",
                    icon: Icons.logout,
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamed(context, "/login");
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  DashboardCard({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 36,
                color: Colors.blue,
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
