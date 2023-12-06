import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerPage extends StatelessWidget {
  const FarmerPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
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
            var displayName = userData?["name"] ?? "User";
            var profileImageUrl = userData?["profileImageUrl"];

            return Container(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: profileImageUrl != null
                            ? Image.network(
                          profileImageUrl,
                          fit: BoxFit.cover,
                        )
                            : Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 12),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              displayName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Column(
                    children: [
                      DashboardCard(
                        title: "Reset Password",
                        icon: Icons.lock,
                        onPressed: () {
                          Navigator.pushNamed(context, "/update_password");
                        },
                        buttonColor: Colors.red,
                      ),
                      SizedBox(height: 20),
                      DashboardCard(
                        title: "Edit Profile",
                        icon: Icons.edit,
                        onPressed: () {
                          Navigator.pushNamed(context, "/update_details");
                        },
                        buttonColor: Colors.blue,
                      ),
                      // SizedBox(height: 20),
                      // DashboardCard(
                      //   title: "Orders",
                      //   icon: Icons.shopping_cart,
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, "/orders");
                      //   },
                      //   buttonColor: Colors.green,
                      // ),
                    ],
                  ),
                  SizedBox(height: 150),
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
  final Color buttonColor;

  DashboardCard({
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: buttonColor,
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
                color: Colors.white,
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
