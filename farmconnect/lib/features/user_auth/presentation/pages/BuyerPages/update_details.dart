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
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : null,
                      ),
                      Positioned(
                        bottom: 0, // Adjust this value to move the icon vertically within the circle
                        right: 0, // Adjust this value to move the icon horizontally within the circle
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(8), // Padding around the camera icon
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9), // Match the background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50), // Match the border radius
                    borderSide: BorderSide(color: Colors.blue), // Match the border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  prefixIcon: Icon(
                    Icons.person, // Add the desired icon
                    color: Colors.blue,
                  ),
                  // Add other properties like prefixIcon if needed
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  if (!RegExp(r"^[a-zA-Z]+(?: [a-zA-Z]+)*$").hasMatch(value)) {
                    return 'Enter a valid name';
                  }
                  return null;
                },
                // Add other properties like onChanged if needed
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: phoneNumberController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.phone, // Set the keyboard type to phone
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  prefixIcon: Icon(
                    Icons.phone, // Add the desired icon
                    color: Colors.blue,
                  ),
                  // Add other properties like prefixIcon if needed
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Phone Number cannot be empty';
                  }
                  if (!RegExp(r"^[6789]\d{9}$").hasMatch(val)) {
                    return 'Enter a valid 10-digit phone number starting with 6, 7, 8, or 9';
                  }
                  if (RegExp(r"^(\d)\1*$").hasMatch(val)) {
                    return 'Avoid using all identical digits';
                  }
                  if (RegExp(r"0123456789|9876543210").hasMatch(val)) {
                    return 'Avoid using sequential digits';
                  }
                  return null;
                },
                // Add other properties like onChanged if needed
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: streetController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  prefixIcon: Icon(
                    Icons.location_on, // Add the desired icon
                    color: Colors.blue,
                  ),
                  // Add other properties like hintText or labelText if needed
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Street is required';
                  }
                  // Add custom validation logic if needed
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: townController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  prefixIcon: Icon(
                    Icons.location_city, // Add the desired icon
                    color: Colors.blue,
                  ),
                  // Add other properties like hintText or labelText if needed
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city/town';
                  }
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Invalid city/town name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: districtController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  prefixIcon: Icon(
                    Icons.location_city, // Add the desired icon (location_city is just an example)
                    color: Colors.blue,
                  ),
                  // Add other properties like hintText or labelText if needed
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your district';
                  }
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Invalid District name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: stateController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  prefixIcon: Icon(
                    Icons.map, // Add the desired icon
                    color: Colors.blue,
                  ),
                  // Add other properties like hintText or labelText if needed
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your state';
                  }
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Invalid State name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: pincodeController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  prefixIcon: Icon(
                    Icons.pin, // Add the desired icon
                    color: Colors.blue,
                  ),
                  // Add other properties like hintText or labelText if needed
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pincode';
                  }
                  if (value.length != 6) {
                    return 'Pincode must be exactly 6 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Pincode should contain only numeric digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
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
