import 'package:farmconnect/blockchain/web3client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _fuidController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _farmnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? selectedFarmerId;

  @override
  Widget build(BuildContext context) {
    final userServices = Provider.of<UserServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'Farmer')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final farmers = snapshot.data!.docs;
                return DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Select a farmer'),
                  value: selectedFarmerId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFarmerId = newValue;
                      _populateFarmerData(newValue);
                    });
                  },
                  items: farmers.map<DropdownMenuItem<String>>((DocumentSnapshot document) {
                    return DropdownMenuItem<String>(
                      value: document.id,
                      child: Text(document['name']),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _fuidController,
              decoration: InputDecoration(labelText: 'FarmConnect ID'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _farmnameController,
              decoration: InputDecoration(labelText: 'Farm Name'),
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                userServices.addUser(
                  fuid: _fuidController.text,
                  name: _nameController.text,
                  farmname: _farmnameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  aadhar: _aadharController.text,
                  address: _addressController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }

  void _populateFarmerData(String? farmerId) {
    if (farmerId != null) {
      FirebaseFirestore.instance.collection('users').doc(farmerId).get().then((DocumentSnapshot document) {
        if (document.exists) {
          final data = document.data() as Map<String, dynamic>;
          _fuidController.text = data['uid'] ?? '';
          _nameController.text = data['name'] ?? '';
          _farmnameController.text = data['farmName'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _aadharController.text = data['aadhaar'] ?? '';
          _addressController.text = data['district'] ?? '';
        }
      }).catchError((error) {
        print('Error retrieving farmer data: $error');
      });
    }
  }

  @override
  void dispose() {
    _fuidController.dispose();
    _nameController.dispose();
    _farmnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _aadharController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
