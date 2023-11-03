import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerDashboard extends StatelessWidget {
  const FarmerDashboard({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Farmer Dashboard",
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
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
          var profileImageUrl = userData?["profileImageUrl"] ?? "";

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
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
              SizedBox(height: 12),
              Card(
                elevation: 5,
                color: Colors.blueGrey[900],
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/farmer_page');
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
                    child: DashboardTile(
                      title: "Add Products",
                      icon: Icons.add,
                      onPressed: () {
                        Navigator.pushNamed(context, "/add_products");
                      },
                    ),
                  ),
                  Flexible(
                    child: DashboardTile(
                      title: "My Products",
                      icon: Icons.store,
                      onPressed: () {
                        Navigator.pushNamed(context, "/myproducts");
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
                    child: DashboardTile(
                      title: "Buy Products",
                      icon: Icons.shopping_cart,
                      onPressed: () {
                        // Add your action here
                      },
                    ),
                  ),
                  Flexible(
                    child: DashboardTile(
                      title: "Orders",
                      icon: Icons.assignment,
                      onPressed: () {
                        // Add your action here
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

class DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  DashboardTile({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.blueGrey[900],
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.green,
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
