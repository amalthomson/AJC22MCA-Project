import 'package:farmconnect/features/user_auth/presentation/pages/FarmerPages/addproducts.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/FarmerPages/farmer_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/FarmerPages/myproducts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({Key? key}) : super(key: key);

  @override
  _FarmerDashboardState createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  // final TextEditingController productNameController = TextEditingController();
  // final TextEditingController productDescriptionController = TextEditingController();
  // final TextEditingController productPriceController = TextEditingController();
  // List<String> categories = ["Dairy", "Fruit", "Vegetable", "Poultry"];
  // String? uploadStatus;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Add Products",
                icon: Icon(Icons.add),
              ),
              Tab(
                text: "My Products",
                icon: Icon(Icons.store),
              ),
              Tab(
                text: "Profile",
                icon: Icon(Icons.person),
              ),
            ],
            indicatorColor: Colors.green,
          ),
        ),
        backgroundColor: Colors.black,
        body: TabBarView(
          children: <Widget>[
            AddProducts(),
            MyProductsPage(),
            FarmerPage(),
          ],
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   productNameController.dispose();
  //   productDescriptionController.dispose();
  //   productPriceController.dispose();
  //   super.dispose();
  // }
}
