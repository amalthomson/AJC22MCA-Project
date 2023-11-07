import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/dairy_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/fruits_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/poultry_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/vegetables_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return DefaultTabController(
      length: 6, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Buyer Dashboard",
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.lightBlue[900],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.red,
              onPressed: () => _signOut(context),
              // onPressed: () {
              //   FirebaseAuth.instance.signOut();
              //   Navigator.pushNamed(context, "/login");
              // },
            ),
          ],
          bottom: TabBar(
            isScrollable: true, // Enable scrolling for the TabBar
            tabs: [
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Dairy Products',
              ),
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Poultry Products',
              ),
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Fruits',
              ),
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Vegetables',
              ),
              Tab(
                icon: Icon(Icons.shopping_cart),
                text: 'Cart',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Profile',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DairyProductsPage(),
            PoultryProductsPage(),
            FruitsProductsPage(),
            VegetableProductsPage(),
// Display Vegetables content

            // Cart
            Center(
              child: Text("Cart Content"),
            ),

            // Profile
            StreamBuilder(
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
                var email = FirebaseAuth.instance.currentUser?.email;
                var profileImageUrl = userData?["profileImageUrl"] ?? "";

                return Container(
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.blue, // Customize the background color
                          child: ClipOval(
                            child: profileImageUrl != null
                                ? Image.network(
                              profileImageUrl,
                              fit: BoxFit.cover,
                              width: 160, // Adjust the image size
                              height: 160,
                            )
                                : Icon(
                              Icons.person,
                              size: 120,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Column(
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
                          Text(
                            displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Email: $email",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/update_google");
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 8.0,
                              ),
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
