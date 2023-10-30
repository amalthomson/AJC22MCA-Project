import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController farmNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  String? _imageUrl;
  String? _selectedCategory;
  List<String> categories = ["Dairy", "Fruit", "Vegetable", "Poultry"];
  String? uploadStatus;

  Future<void> _uploadProduct() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final imageName = 'product_images/${DateTime.now().millisecondsSinceEpoch}.png';

      try {
        await firebase_storage.FirebaseStorage.instance.ref(imageName).putFile(file);
        final downloadURL =
        await firebase_storage.FirebaseStorage.instance.ref(imageName).getDownloadURL();

        setState(() {
          _imageUrl = downloadURL;
        });

        setState(() {
          uploadStatus = 'Image uploaded successfully';
        });
      } catch (e) {
        setState(() {
          uploadStatus = 'Failed to upload product image: $e';
        });
        print('Failed to upload product image: $e');
      }
    }
  }

  // Function to handle database update
  Future<void> _updateDatabase() async {
    if (_imageUrl != null) {
      await FirebaseFirestore.instance.collection('products').add({
        'productName': productNameController.text,
        'productDescription': productDescriptionController.text,
        'farmName': farmNameController.text,
        'productPrice': productPriceController.text,
        'productImage': _imageUrl,
        'category': _selectedCategory,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'isApproved': 'no',
      });

      productNameController.clear();
      productDescriptionController.clear();
      farmNameController.clear();
      productPriceController.clear();
      _selectedCategory = null;

      setState(() {
        uploadStatus = 'Product uploaded successfully';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1D1F),
        title: Text(
          'FarmConnect',
          style: TextStyle(
            color: Colors.green,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFF141414),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: _uploadProduct,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 2.0),
                        ),
                        child: _imageUrl != null
                            ? CircleAvatar(
                          radius: 75,
                          backgroundImage: NetworkImage(_imageUrl!),
                        )
                            : Icon(
                          Icons.add_a_photo,
                          size: 75,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              _buildTextField(productNameController, 'Product Name'),
              SizedBox(height: 16.0),
              _buildTextField(productDescriptionController, 'Product Description'),
              SizedBox(height: 16.0),
              _buildTextField(farmNameController, 'Farm Name'),
              SizedBox(height: 16.0),
              _buildTextField(productPriceController, 'Product Price', TextInputType.number),
              SizedBox(height: 16.0),
              _buildCategoryDropdown(),
              SizedBox(height: 30.0),
              _buildUploadButton(),
              if (uploadStatus != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    uploadStatus!,
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      [TextInputType inputType = TextInputType.text]) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: inputType,
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButton<String>(
              hint: Text(
                'Select Category',
                style: TextStyle(
                  color: Colors.white, // Set text color to white
                ),
              ),
              value: _selectedCategory,
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.blue, fontSize: 16),
              underline: Container(
                height: 0,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _updateDatabase, // Change this to _updateDatabase
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Upload Product',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    farmNameController.dispose();
    productPriceController.dispose();
    super.dispose();
  }
}
