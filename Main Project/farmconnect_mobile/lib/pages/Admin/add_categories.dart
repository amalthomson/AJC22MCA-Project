import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategoriesAndProducts extends StatefulWidget {
  @override
  _AddCategoriesAndProductsState createState() => _AddCategoriesAndProductsState();
}

class _AddCategoriesAndProductsState extends State<AddCategoriesAndProducts> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final _categoryFormKey = GlobalKey<FormState>();
  final _productFormKey = GlobalKey<FormState>();

  Future<void> _addCategory() async {
    if (_categoryFormKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('categories').doc(categoryController.text).set({
        'categoryName': categoryController.text,
        'productNames': [], // Initialize an empty array for product names
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category added successfully'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      categoryController.clear();
    }
  }

  Future<void> _addProduct() async {
    if (_productFormKey.currentState!.validate() && _selectedCategory != null) {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(_selectedCategory!)
          .update({
        'productNames': FieldValue.arrayUnion([productNameController.text]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added successfully'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      productNameController.clear();
    }
  }

  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 1.0),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8,),
            Text(
              "Add Category & Products",
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryTextField(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addCategory,
              child: Text('Add Category', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 48),
            _buildProductTextField(),
            SizedBox(height: 24),
            _buildCategoryDropdown(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTextField() {
    return Form(
      key: _categoryFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        controller: categoryController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Category Name',
          hintText: 'Enter a category name',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Category name cannot be empty';
          } else if (value.startsWith(' ') || value.contains(RegExp(r'\d'))) {
            return 'Invalid category name';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildProductTextField() {
    return Form(
      key: _productFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        controller: productNameController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Product Name',
          hintText: 'Enter a product name',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Product name cannot be empty';
          } else if (value.startsWith(' ') || value.contains(RegExp(r'\d'))) {
            return 'Invalid product name';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        List<String> categories = snapshot.data!.docs.map((doc) => doc['categoryName'].toString()).toList();

        return DropdownButton<String>(
          hint: Text('Select Category', style: TextStyle(color: Colors.white)),
          value: _selectedCategory,
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
          items: categories.map<DropdownMenuItem<String>>((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category, style: TextStyle(color: Colors.black)),
            );
          }).toList(),
        );
      },
    );
  }
}

