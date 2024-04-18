import 'package:farmconnect/blockchain/list_user.dart';
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
        centerTitle: true,
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
                  items: farmers.map<DropdownMenuItem<String>>((
                      DocumentSnapshot document) {
                    return DropdownMenuItem<String>(
                      value: document.id,
                      child: Text(
                        document['name'],
                        style: TextStyle(color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 16.0),
            _buildTextField(_fuidController, 'FarmConnect ID', _validateID),
            SizedBox(height: 10.0),
            _buildTextField(_nameController, 'Name', _validateName),
            SizedBox(height: 10.0),
            _buildTextField(_farmnameController, 'Farm Name', _validateFarmName),
            SizedBox(height: 10.0),
            _buildTextField(_emailController, 'Email', _validateEmail),
            SizedBox(height: 10.0),
            _buildTextField(_phoneController, 'Phone', _validatePhone),
            SizedBox(height: 10.0),
            _buildTextField(_aadharController, 'Aadhar', _validateAadhaar),
            SizedBox(height: 10.0),
            _buildTextField(_addressController, 'Address', _validateAddress),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_validateForm()) {
                  userServices.addUser(
                    fuid: _fuidController.text,
                    name: _nameController.text,
                    farmname: _farmnameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    aadhar: _aadharController.text,
                    address: _addressController.text,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserListScreen(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text(
                'Add User',
                style: TextStyle(color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      String? Function(String?)? validator) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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

  String? _validateID(String? value) {
    if (value == null || value.isEmpty) {
      return 'ID must not be empty';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name must not be empty';
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return 'Name must contain only alphabets';
    }
    return null;
  }

  String? _validateFarmName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Farm name must not be empty';
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return 'Farm name must contain only alphabets';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email must not be empty';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value!.isEmpty) {
      return 'Phone Number cannot be empty';
    }
    if (!RegExp(r"^[6789]\d{9}$").hasMatch(value)) {
      return 'Enter a valid 10-digit phone number starting with 6, 7, 8, or 9';
    }
    if (RegExp(r"^(\d)\1*$").hasMatch(value)) {
      return 'Avoid using all identical digits';
    }
    if (RegExp(r"0123456789|9876543210").hasMatch(value)) {
      return 'Avoid using sequential digits';
    }
    return null;
  }

  String? _validateAadhaar(String? value) {
    if (value == null || value.isEmpty) {
      return 'Aadhaar number must not be empty';
    }
    if (value.length != 12) {
      return 'Aadhaar number must be 12 digits long';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Aadhaar number must contain only digits';
    }
    if (RegExp(r'^[0]+$').hasMatch(value) || RegExp(r'^[1]+$').hasMatch(value)) {
      return 'Invalid Aadhaar number';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address must not be empty';
    }
    return null;
  }

  bool _validateForm() {
    if (_fuidController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _farmnameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _aadharController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return false;
    }
    return true;
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
