import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:farmconnect/features/user_auth/presentation/pages/common/colors.dart';

class UpdateDetailsPage extends StatefulWidget {
  @override
  _UpdateDetailsPageState createState() => _UpdateDetailsPageState();
}

class _UpdateDetailsPageState extends State<UpdateDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    // Call retrieveUserData in initState to populate the text fields and profile image when the page is loaded.
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
          // Check if the required fields exist in the document.
          Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            setState(() {
              _profileImageUrl = userData['profileImageUrl'] ?? '';
              nameController.text = userData['name'] ?? '';
              phoneNumberController.text = userData['phone'] ?? '';
              streetController.text = userData['street'] ?? '';
              townController.text = userData['town'] ?? '';
              districtController.text = userData['district'] ?? '';
              stateController.text = userData['state'] ?? '';
              pincodeController.text = userData['pincode'] ?? '';
            });
          }
        }
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }

  Future<void> _updateProfilePicture() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final imageName = 'profile_images/${FirebaseAuth.instance.currentUser?.uid}.png';

      try {
        await firebase_storage.FirebaseStorage.instance.ref(imageName).putFile(file);

        final downloadURL =
        await firebase_storage.FirebaseStorage.instance.ref(imageName).getDownloadURL();

        setState(() {
          _profileImageUrl = downloadURL;
        });
      } catch (e) {
        print('Failed to upload profile picture: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Update Details"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _updateProfilePicture,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : null,
                    child: Icon(Icons.camera_alt),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: streetController,
                  decoration: InputDecoration(
                    labelText: 'Street',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: townController,
                  decoration: InputDecoration(
                    labelText: 'Town',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: districtController,
                  decoration: InputDecoration(
                    labelText: 'District',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: stateController,
                  decoration: InputDecoration(
                    labelText: 'State',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: pincodeController,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final String name = nameController.text;
                    final String phone = phoneNumberController.text;
                    final String street = streetController.text;
                    final String town = townController.text;
                    final String district = districtController.text;
                    final String state = stateController.text;
                    final String pincode = pincodeController.text;

                    try {
                      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                      await FirebaseFirestore.instance.collection('users').doc(userId).update({
                        'profileImageUrl': _profileImageUrl,
                        'name': name,
                        'phone': phone,
                        'street': street,
                        'town': town,
                        'district': district,
                        'state': state,
                        'pincode': pincode,
                      });

                      Navigator.pop(context);
                    } catch (e) {
                      print('Error updating user data: $e');
                    }
                  },
                  child: Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    streetController.dispose();
    townController.dispose();
    districtController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    super.dispose();
  }
}
