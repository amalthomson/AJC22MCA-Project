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
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Icon(
                Icons.lock_person,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8,),
            Text(
              "Add Users to Blockchain",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true, // Center the title horizontally
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.blueGrey[900]!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: 5.0,
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey[900],
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
                  hint: Text(
                    'Select a farmer',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: selectedFarmerId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFarmerId = newValue;
                      _populateFarmerData(newValue);
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  items: farmers.map<DropdownMenuItem<String>>((DocumentSnapshot document) {
                    return DropdownMenuItem<String>(
                      value: document.id,
                      child: Text(
                        document['name'],
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 16.0),
            _buildTextField(_fuidController, 'FarmConnect ID'),
            SizedBox(height: 10.0),
            _buildTextField(_nameController, 'Name'),
            SizedBox(height: 10.0),
            _buildTextField(_farmnameController, 'Farm Name'),
            SizedBox(height: 10.0),
            _buildTextField(_emailController, 'Email'),
            SizedBox(height: 10.0),
            _buildTextField(_phoneController, 'Phone'),
            SizedBox(height: 10.0),
            _buildTextField(_aadharController, 'Aadhar'),
            SizedBox(height: 10.0),
            _buildTextField(_addressController, 'Address'),
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
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text(
                'Add User',
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), // Set text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
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
