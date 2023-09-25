import 'package:flutter/material.dart';

class UpdateDetailsPage extends StatefulWidget {
  @override
  _UpdateDetailsPageState createState() => _UpdateDetailsPageState();
}

class _UpdateDetailsPageState extends State<UpdateDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

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
              controller: dobController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Here, you can insert the user details into the database
                // You can use Firebase Firestore or any other database of your choice
                // Retrieve values from controllers (nameController, dobController, etc.)
                final String name = nameController.text;
                final String dob = dobController.text;
                final String address = addressController.text;
                final String phoneNumber = phoneNumberController.text;

                // Insert the user details into the database
                // You can implement this part based on your chosen database
                // For example, if you're using Firebase Firestore:
                // FirebaseFirestore.instance.collection('users').doc(userId).set({
                //   'name': name,
                //   'dob': dob,
                //   'address': address,
                //   'phoneNumber': phoneNumber,
                // });

                // After inserting the data, you can navigate back to the previous page
                Navigator.pop(context);
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
    // Dispose of controllers when they are no longer needed to prevent memory leaks
    nameController.dispose();
    dobController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}
