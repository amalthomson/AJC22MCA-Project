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
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  DateTime? _selectedDate;
  String? _imageUrl;
  String? _selectedCategory;
  String? _selectedProductName;
  List<String> categories = [];
  Map<String, List<String>> productNames = {};
  String? uploadStatus;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final categoriesSnapshot = await FirebaseFirestore.instance.collection('categories').get();
    setState(() {
      categories = categoriesSnapshot.docs.map((doc) => doc['categoryName'].toString()).toList();
    });
  }

  Future<void> _fetchProductNames(String category) async {
    final productNamesSnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(category)
        .get();

    final productsList = productNamesSnapshot['productNames'].cast<String>();
    setState(() {
      productNames[category] = productsList;
    });
  }

  Future<void> _uploadProduct() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final imageName = 'product_images/${DateTime.now().millisecondsSinceEpoch}.png';

      try {
        await firebase_storage.FirebaseStorage.instance.ref(imageName).putFile(file);
        final downloadURL = await firebase_storage.FirebaseStorage.instance.ref(imageName).getDownloadURL();

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

  Future<void> _updateDatabase() async {
    final user = FirebaseAuth.instance.currentUser;

    if (_imageUrl != null &&
        user != null &&
        _selectedCategory != null &&
        _selectedProductName != null) {
      final stock = int.tryParse(stockController.text) ?? 0;

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final farmName = userDoc['farmName'];
      final uid = user.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: _selectedCategory)
          .where('productName', isEqualTo: _selectedProductName)
          .where('userId', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final existingProductId = querySnapshot.docs[0].id;
        final existingStock = querySnapshot.docs[0]['stock'] ?? 0;
        final updatedStock = existingStock + stock;

        await FirebaseFirestore.instance.collection('products').doc(existingProductId).update({
          'stock': updatedStock,
        });
      } else {
        final productId = '${DateTime.now().millisecondsSinceEpoch}_${user.uid}'; // Concatenate userId with productId

        await FirebaseFirestore.instance.collection('products').doc(productId).set({
          'productId': productId,
          'productName': productNameController.text,
          'productDescription': productDescriptionController.text,
          'productPrice': productPriceController.text,
          'stock': stock,
          'productImage': _imageUrl,
          'category': _selectedCategory,
          'productName': _selectedProductName,
          'userId': uid,
          'farmName': farmName,
          'isApproved': 'Pending',
          'remark': 'Approval Pending',
          'expiryDate': _selectedDate.toString().substring(0, 10),
        });
      }

      productNameController.clear();
      productDescriptionController.clear();
      productPriceController.clear();
      stockController.clear();
      _selectedDate = null;
      _selectedCategory = null;
      _selectedProductName = null;

      setState(() {
        uploadStatus = 'Product uploaded successfully';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added successfully'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, "/added_product");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
                "Add Products",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),
          ),
        ),
      backgroundColor: Colors.black,
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
              SizedBox(height: 15.0),
              _buildCategoryDropdown(),
              SizedBox(height: 15.0),
              _buildProductDropdown(),
              SizedBox(height: 15.0),
              _buildTextField(productPriceController, 'Product Price in Rupees of 1 KG', TextInputType.number),
              SizedBox(height: 15.0),
              _buildTextField(stockController, 'Stock in Kilograms', TextInputType.number),
              SizedBox(height: 15.0),
              _buildTextField(productDescriptionController, 'Product Description'),
              SizedBox(height: 15.0),
              _buildDatePicker(),
              SizedBox(height: 15.0),
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
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: inputType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field cannot be empty';
        }
        if (inputType == TextInputType.number) {
          int? numericValue = int.tryParse(value);
          if (numericValue == null) {
            return 'Please enter a valid number';
          }
          if (labelText.contains('Price')) {
            if (numericValue < 1 || numericValue > 999) {
              return 'Price must be in the range of 1 to 999';
            }
          } else if (labelText.contains('Stock')) {
            if (numericValue < 1 || numericValue > 99) {
              return 'Stock must be in the range of 1 to 99';
            }
          }
        } else if (inputType == TextInputType.text && labelText.contains('Description')) {
          if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
            return 'Description must contain only letters and spaces';
          }
          if (value.length < 3) {
            return 'Description must contain at least 3 characters';
          }
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  _selectedProductName = null;
                  if (_selectedCategory != null) {
                    _fetchProductNames(_selectedCategory!);
                  }
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

  Widget _buildProductDropdown() {
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
                'Select Product',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              value: _selectedProductName,
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.blue, fontSize: 16),
              underline: Container(
                height: 0,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedProductName = newValue;
                });
              },
              items: _selectedCategory != null && productNames.containsKey(_selectedCategory!)
                  ? productNames[_selectedCategory!]!
                  .map<DropdownMenuItem<String>>((String product) {
                return DropdownMenuItem<String>(
                  value: product,
                  child: Text(product),
                );
              }).toList()
                  : [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Expiry Date',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null && pickedDate != _selectedDate) {
              setState(() {
                _selectedDate = pickedDate;
              });
            }
          },
          child: Text(
            _selectedDate == null
                ? 'Choose Date'
                : 'Selected Date: ${_selectedDate!.toString().substring(0, 10)}',
          ),
        ),
      ],
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
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();
    stockController.dispose();
    super.dispose();
  }
}
