import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyerDashboard extends StatelessWidget {
  const BuyerDashboard({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),
      body: StreamBuilder(
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
          var profileImageUrl = userData?["profileImageUrl"] ?? ""; // Replace with your field name

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
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
              Card(
                elevation: 5,
                color: Colors.lightBlue[900],
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/buyer_profile");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
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
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: BuyerDashboardTile(
                      title: "Poultry",
                      onPressed: () {
                        Navigator.pushNamed(context, "/poultry_page");
                      },
                    ),
                  ),
                  Flexible(
                    child: BuyerDashboardTile(
                      title: "Dairy",
                      onPressed: () {
                        Navigator.pushNamed(context, "/dairy_page");
                        // Add your action here
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: BuyerDashboardTile(
                      title: "Fruits",
                      onPressed: () {
                        Navigator.pushNamed(context, "/fruits_page");// Add your action here
                      },
                    ),
                  ),
                  Flexible(
                    child: BuyerDashboardTile(
                      title: "Vegetables",
                      onPressed: () {
                        Navigator.pushNamed(context, "/vegetables_page");// Add your action here
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class BuyerDashboardTile extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  BuyerDashboardTile({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.lightBlue[900],
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shop,
                size: 30,
                color: Colors.blue,
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
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
