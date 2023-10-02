import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateDetailsPage extends StatefulWidget {
  @override
  _UpdateDetailsPageState createState() => _UpdateDetailsPageState();
}

class _UpdateDetailsPageState extends State<UpdateDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Call retrieveUserData in initState to populate the text fields when the page is loaded.
    retrieveUserData();
  }

  Future<void> retrieveUserData() async {
    try {
      // Ensure the user is signed in before attempting to retrieve data.
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

        // Check if the user document exists.
        if (userSnapshot.exists) {
          // Check if 'name' and 'phone' fields exist in the document.
          Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            String name = userData['name'] ?? '';
            String phone = userData['phone'] ?? '';
            String address = userData['address'] ?? '';

            setState(() {
              nameController.text = name;
              phoneNumberController.text = phone;
              addressController.text = address;// Set the phone value
            });
          }
        }
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text;
                final String phone = phoneNumberController.text;
                final String address = addressController.text;// Get the phone value

                try {
                  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                  await FirebaseFirestore.instance.collection('users').doc(userId).update({
                    'name': name,
                    'phone': phone, // Update 'phone' instead of 'phoneNumber'
                    'address' : address,
                  });

                  Navigator.pop(context);
                } catch (e) {
                  print('Error updating user data: $e');
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}
