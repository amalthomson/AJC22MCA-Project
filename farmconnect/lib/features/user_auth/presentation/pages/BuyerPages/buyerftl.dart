import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class BuyerFTLPage extends StatefulWidget {
  @override
  _BuyerFTLPageState createState() => _BuyerFTLPageState();
}

class _BuyerFTLPageState extends State<BuyerFTLPage> {
  TextEditingController _streetController = TextEditingController();
  TextEditingController _townController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  String? _profileImageUrl;
  String? _userId;
  String? _selectedGender;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          'profileImageUrl': _profileImageUrl, // Include the profile image URL in the update
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Details updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushNamed(context, "/buyer_home");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "FarmConnect",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  // Centered CircleAvatar and Profile Picture Upload Button
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!)
                              : null,
                          child: InkWell(
                            onTap: () async {
                              final imagePicker = ImagePicker();
                              final pickedFile = await imagePicker.pickImage(
                                  source: ImageSource.gallery);

                              if (pickedFile != null) {
                                final file = File(pickedFile.path);
                                final imageName = 'profile_images/$_userId.png';

                                try {
                                  await firebase_storage
                                      .FirebaseStorage.instance
                                      .ref(imageName)
                                      .putFile(file);

                                  final downloadURL =
                                  await firebase_storage
                                      .FirebaseStorage.instance
                                      .ref(imageName)
                                      .getDownloadURL();

                                  setState(() {
                                    _profileImageUrl = downloadURL;
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Failed to upload profile picture.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          items: _genderOptions.map((gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(
                                gender,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            hintText: 'Select gender',
                            border: OutlineInputBorder(),
                            fillColor: Colors.white.withOpacity(0.9),
                            filled: true,
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _streetController,
                          decoration: InputDecoration(
                            labelText: 'Street',
                            hintText: 'Enter your street',
                            border: OutlineInputBorder(),
                            fillColor: Colors.white.withOpacity(0.9),
                            filled: true,
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your street';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _townController,
                    decoration: InputDecoration(
                      labelText: 'City/Town',
                      hintText: 'Enter your city/town',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white.withOpacity(0.9),
                      filled: true,
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your city/town';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _districtController,
                    decoration: InputDecoration(
                      labelText: 'District',
                      hintText: 'Enter your district',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white.withOpacity(0.9),
                      filled: true,
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your district';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _stateController,
                    decoration: InputDecoration(
                      labelText: 'State',
                      hintText: 'Enter your state',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white.withOpacity(0.9),
                      filled: true,
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your state';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _pincodeController,
                    decoration: InputDecoration(
                      labelText: 'Pincode',
                      hintText: 'Enter your pincode',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white.withOpacity(0.9),
                      filled: true,
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your pincode';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _updateUserData,
                      child: Text('Save Details'),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
