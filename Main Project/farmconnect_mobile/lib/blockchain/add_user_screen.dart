import 'package:farmconnect/blockchain/web3client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  void _addUser() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String aadhar = _aadharController.text;
    String address = _addressController.text;
    String dob = _dobController.text;
    String gender = _genderController.text;

    // Call addUser method from UserServices
    await Provider.of<UserServices>(context, listen: false).addUser(
      name: name,
      email: email,
      phone: phone,
      aadhar: aadhar,
      address: address,
      dob: dob,
      gender: gender,
    );

    // Clear text fields after adding user
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _aadharController.clear();
    _addressController.clear();
    _dobController.clear();
    _genderController.clear();

    // Navigate back to user list screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _aadharController,
              decoration: InputDecoration(labelText: 'Aadhar'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addUser, // Call _addUser method
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _aadharController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    super.dispose();
  }
}
