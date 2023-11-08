import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({Key? key}) : super(key: key);

  @override
  _FarmerDashboardState createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  String? _imageUrl;
  String? _selectedCategory;
  List<String> categories = ["Dairy", "Fruit", "Vegetable", "Poultry"];
  String? uploadStatus;

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
                  // Sign out of Firebase Authentication
                  await _auth.signOut();

                  // Sign out of Google Sign-In
                  await googleSignIn.signOut();

                  // Navigate to the login page
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
            // Add Products Tab
            SingleChildScrollView(
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: GestureDetector(
                        onTap: _uploadProduct,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.blue, width: 2.0),
                              ),
                              child: _imageUrl != null
                                  ? CircleAvatar(
                                radius: 75,
                                backgroundImage: NetworkImage(_imageUrl!),
                              )
                                  : Icon(
                                Icons.add_a_photo,
                                size: 75,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    _buildTextField(productNameController, 'Product Name'),
                    SizedBox(height: 16.0),
                    _buildTextField(productDescriptionController, 'Product Description'),
                    SizedBox(height: 16.0),
                    _buildTextField(productPriceController, 'Product Price', TextInputType.number),
                    SizedBox(height: 16.0),
                    _buildCategoryDropdown(),
                    SizedBox(height: 30.0),
                    _buildUploadButton(),
                    if (uploadStatus != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          uploadStatus!,
                          style: TextStyle(color: Colors.green, fontSize: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // My Products Tab
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .where('isApproved', whereIn: ['approved', 'no', 'rejected'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data!.docs;

                if (products.isEmpty) {
                  return Center(
                    child: Text("You have no products."),
                  );
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final productName = product['productName'];
                    final productDescription = product['productDescription'];
                    final category = product['category'];
                    final isApproved = product['isApproved'];
                    final productImage = product['productImage'] ?? ''; // Get product image URL
                    final remark = product['remark']; // Get the remark field

                    String status = 'Pending Approval';
                    if (isApproved == 'approved') {
                      status = 'Approved';
                    } else if (isApproved == 'rejected') {
                      status = 'Rejected';
                    }

                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(productImage), // Display product image
                            radius: 30,
                          ),
                          title: Text(
                            productName,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            ListTile(
                              title: Text("Description: $productDescription",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text("Category: $category",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListTile(
                              title: GestureDetector(
                                child: Text("Status: $status",
                                  style: TextStyle(
                                    color: Colors.blue, // Make the status clickable
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline, // Add an underline
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Remark"),
                                        content: Text(remark != null ? remark : "No remark available"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Close"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Profile Tab
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
                      SizedBox(height: 12),
                      Card(
                        elevation: 5,
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/farmer_page');
                          },
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
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 8.0,
                              ),
                              child: Text(
                                "Reset Password",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
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
                      SizedBox(height: 150),
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

  Future<void> _uploadProduct() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final imageName = 'product_images/${DateTime.now().millisecondsSinceEpoch}.png';

      try {
        await firebase_storage.FirebaseStorage.instance.ref(imageName).putFile(file);
        final downloadURL =
        await firebase_storage.FirebaseStorage.instance.ref(imageName).getDownloadURL();

        setState(() {
          _imageUrl = downloadURL;
        });

        setState(() {
          uploadStatus = 'Image uploaded successfully';
        });
      } catch (e) {
        setState(() {
          uploadStatus = 'Failed to upload product image: $e';
        });
        print('Failed to upload product image: $e');
      }
    }
  }

  Future<void> _updateDatabase() async {
    if (_imageUrl != null) {
      await FirebaseFirestore.instance.collection('products').add({
        'productName': productNameController.text,
        'productDescription': productDescriptionController.text,
        'productPrice': productPriceController.text,
        'productImage': _imageUrl,
        'category': _selectedCategory,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'isApproved': 'no',
        'remark': 'Approval Pending', // Set the initial value of "remark" to "null"
      });

      productNameController.clear();
      productDescriptionController.clear();
      productPriceController.clear();
      _selectedCategory = null;

      setState(() {
        uploadStatus = 'Product uploaded successfully';
      });

      // Show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added successfully'),
          duration: Duration(seconds: 3), // You can adjust the duration
          backgroundColor: Colors.green, // Set the background color to green
        ),
      );
      // Navigate to the "added_product" page
      Navigator.pushNamed(context, "/added_product");
    }
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      [TextInputType inputType = TextInputType.text]) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: inputType,
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButton<String>(
              hint: Text(
                'Select Category',
                style: TextStyle(
                  color: Colors.white, // Set text color to white
                ),
              ),
              value: _selectedCategory,
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.blue, fontSize: 16),
              underline: Container(
                height: 0,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _updateDatabase,
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Upload Product',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();
    super.dispose();
  }
}
