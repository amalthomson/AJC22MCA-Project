import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FarmerFTLPage extends StatefulWidget {
  @override
  _FarmerFTLPageState createState() => _FarmerFTLPageState();
}

class _FarmerFTLPageState extends State<FarmerFTLPage> {
  TextEditingController _addressController = TextEditingController();
  String? _profileImageUrl;
  String? _userId;
  String? ftl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        _addressController.text = userData['address'];

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
          'address': _addressController.text,
          'ftl' : 'no'
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Address updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushNamed(context, "/buyer_home");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update address.'),
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
        title: Text('Update Details'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction, // Add autovalidateMode
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                // backgroundImage: _profileImageUrl != null
                //     ? NetworkImage(_profileImageUrl!)
                //     : AssetImage('assets/default_profile_image.png'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter your address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserData,
                child: Text('Save Details'),
              ),
              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     _navigateToNextPage();
              //   },
              //   child: Text('Skip'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
