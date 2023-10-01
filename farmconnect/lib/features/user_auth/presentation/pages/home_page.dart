import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/update_details.dart';

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
            var displayName = userData?["name"] ?? "User"; // Fetch the display name

            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/bgImage.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  SizedBox(height: 100),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/icons/dp.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                displayName, // Display the display name here
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/update_password");
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Reset Password",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/update_details");
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  DashboardCard(
                    title: "View Orders",
                    icon: Icons.shopping_cart,
                    onPressed: () {
                      // Add action for viewing orders
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
