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
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  String? _imageUrl;
  String? _selectedCategory;
  String? _selectedSubCategory;
  List<String> categories = ["Dairy", "Fruit", "Vegetable", "Poultry"];
  Map<String, List<String>> subCategories = {
    "Dairy": ["Milk", "Cheese", "Curd"],
    "Fruit": ["Apple", "Orange", "Mango"],
    "Vegetable": ["Potato", "Onion", "Chilly"],
    "Poultry": ["Chicken", "Egg"],
  };
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
    final user = FirebaseAuth.instance.currentUser;

    if (_imageUrl != null && user != null) {
      await FirebaseFirestore.instance.collection('products').add({
        'productDescription': productDescriptionController.text,
        'productPrice': productPriceController.text,
        'productImage': _imageUrl,
        'category': _selectedCategory,
        'subCategory': _selectedSubCategory,
        'userId': user.uid,
        'isApproved': 'Pending',
        'remark': 'Approval Pending',
      });

      productDescriptionController.clear();
      productPriceController.clear();
      _selectedCategory = null;
      _selectedSubCategory = null;

      setState(() {
        uploadStatus = 'Product uploaded successfully';
      });

      // Show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added successfully'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to the "added_product" page
      Navigator.pushNamed(context, "/added_product");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Add New Products",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
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
              SizedBox(height: 30.0),
              _buildCategoryDropdown(),
              SizedBox(height: 30.0),
              _buildSubCategoryDropdown(),
              SizedBox(height: 30.0),
              _buildTextField(productDescriptionController, 'Product Description'),
              SizedBox(height: 30.0),
              _buildTextField(productPriceController, 'Product Price', TextInputType.number),
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
                  color: Colors.white,
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

  Widget _buildSubCategoryDropdown() {
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
                'Select Subcategory',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              value: _selectedSubCategory,
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.blue, fontSize: 16),
              underline: Container(
                height: 0,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSubCategory = newValue;
                });
              },
              items: _selectedCategory != null
                  ? subCategories[_selectedCategory]!
                  .map<DropdownMenuItem<String>>((String subCategory) {
                return DropdownMenuItem<String>(
                  value: subCategory,
                  child: Text(subCategory),
                );
              }).toList()
                  : [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _updateDatabase,
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
    productDescriptionController.dispose();
    productPriceController.dispose();
    super.dispose();
  }
}
