import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FarmerFTLPage extends StatefulWidget {
  @override
  _FarmerFTLPageState createState() => _FarmerFTLPageState();
}

class _FarmerFTLPageState extends State<FarmerFTLPage> {
  TextEditingController _streetController = TextEditingController();
  TextEditingController _townController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  String? _profileImageUrl;
  String? _userId;
  String? _selectedGender;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  List<String> _genderOptions = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });

      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      setState(() {
        _profileImageUrl = userData['profileImageUrl'];
        _streetController.text = userData['street'];
        _townController.text = userData['town'];
        _districtController.text = userData['district'];
        _stateController.text = userData['state'];
        _pincodeController.text = userData['pincode'];
        _selectedGender = userData['gender'];
      });
    }
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .update({
          'street': _streetController.text,
          'town': _townController.text,
          'district': _districtController.text,
          'state': _stateController.text,
          'pincode': _pincodeController.text,
          'ftl': 'no',
          'gender': _selectedGender,
          'profileImageUrl': _profileImageUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Details updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushNamed(context, "/farmer_home");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update details.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final file = File(pickedImage.path);
      final imageName = 'profile_images/$_userId.png';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        automaticallyImplyLeading: false,
        title: Text(
          "Update Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.blue,
                            backgroundImage: _profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : null,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.blue,
                                      size: 36,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          items: _genderOptions.map((gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(
                                gender,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            hintText: 'Select gender',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            prefixIcon: Icon(Icons.person, color: Colors.blue),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Select One";
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _streetController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            hintText: 'Enter your street',
                            prefixIcon: Icon(Icons.home, color: Colors.blue),
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
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your street';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _townController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            hintText: 'Enter your city/town',
                            prefixIcon: Icon(Icons.location_city, color: Colors.blue),
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
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _districtController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            hintText: 'Enter your district',
                            prefixIcon: Icon(Icons.map, color: Colors.blue),
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
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _stateController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            hintText: 'Enter your state',
                            prefixIcon: Icon(Icons.other_houses, color: Colors.blue),
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
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _pincodeController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            hintText: 'Enter your pincode',
                            prefixIcon: Icon(Icons.location_on, color: Colors.blue),
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
                        SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: _updateUserData,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Text(
                              'Save Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
