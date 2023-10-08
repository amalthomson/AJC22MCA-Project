import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/colors.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/update_details.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleHomePage extends StatelessWidget {
  const GoogleHomePage({Key? key});

  // Function to sign out both Firebase and Google accounts
  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      Navigator.popAndPushNamed(context, "/login");
    } catch (error) {
      print("Error signing out: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        title: Text("Buyer Dashboard", style: TextStyle(color: Colors.green, fontSize: 20,
            fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[900],
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
                  SizedBox(height: 20), // Added spacing
                  // Profile Image
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
                          color: Colors.white, // Fallback icon color
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Added spacing
                  Card(
                    elevation: 5,
                    color: Colors
                        .transparent, // Set background color to transparent
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/update_details");
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 8.0),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 150),
                  DashboardCard(
                    title: "Sign Out",
                    icon: Icons.logout,
                    onPressed: () => _signOut(context), // Sign out function
                    backgroundColor: Colors.red, textColor: Colors.white, // Add the backgroundColor parameter here
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
