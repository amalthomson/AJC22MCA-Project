import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateStockPage extends StatefulWidget {
  @override
  _UpdateStockPageState createState() => _UpdateStockPageState();
}

class _UpdateStockPageState extends State<UpdateStockPage> {
  String? _selectedCategory;
  String? _selectedProduct;
  int _currentStock = 0;
  int _newStock = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Stock",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey[900], // Appbar color
      ),
      backgroundColor: Colors.black, // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCategoryDropdown(),
              SizedBox(height: 20.0),
              _buildProductDropdown(),
              SizedBox(height: 20.0),
              _buildStockTextField(),
              SizedBox(height: 20.0),
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('products').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No products available', style: TextStyle(color: Colors.white));
        } else {
          List<String> categories = snapshot.data!.docs.map((doc) => doc['category'].toString()).toSet().toList();
          return DropdownButton<String>(
            hint: Text('Select Category', style: TextStyle(color: Colors.white)),
            value: _selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
                _selectedProduct = null; // Reset product selection when category changes
                _currentStock = 0; // Reset current stock
              });
            },
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            dropdownColor: Colors.blueGrey[800], // Dropdown background color
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          );
        }
      },
    );
  }

  Widget _buildProductDropdown() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('products').where('category', isEqualTo: _selectedCategory).get(),
      builder: (context, snapshot) {
        if (_selectedCategory == null) {
          return SizedBox.shrink(); // Don't show product dropdown until category is selected
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No products available for the selected category', style: TextStyle(color: Colors.white));
        } else {
          List<String> products = snapshot.data!.docs.map((doc) => doc['productName'].toString()).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                hint: Text('Select Product', style: TextStyle(color: Colors.white)),
                value: _selectedProduct,
                onChanged: (String? newValue) async {
                  setState(() {
                    _selectedProduct = newValue;
                  });

                  // Fetch and set the current stock when a product is selected
                  await _fetchCurrentStock();
                },
                items: products.map((product) {
                  return DropdownMenuItem<String>(
                    value: product,
                    child: Text(product, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                dropdownColor: Colors.blueGrey[800], // Dropdown background color
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              ),
              SizedBox(height: 10.0),
              Text(
                'Current Stock: $_currentStock KG',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Future<void> _fetchCurrentStock() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: _selectedCategory)
          .where('productName', isEqualTo: _selectedProduct)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _currentStock = int.parse(querySnapshot.docs[0]['stock'].toString());
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product not found'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error fetching current stock: $e');
    }
  }

  Widget _buildStockTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'New Stock Quantity',
        hintText: 'Enter the new stock quantity (1-99)',
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a stock quantity';
        }
        final stock = int.tryParse(value);
        if (stock == null || stock < 1 || stock > 99) {
          return 'Please enter a valid stock quantity between 1 and 99';
        }
        return null;
      },
      style: TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          _newStock = int.tryParse(value) ?? 0;
        });
      },
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _updateStock();
        }
      },
      child: Text('Update Stock'),
    );
  }

  Future<void> _updateStock() async {
    if (_selectedCategory != null && _selectedProduct != null && _newStock > 0) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: _selectedCategory)
            .where('productName', isEqualTo: _selectedProduct)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final productId = querySnapshot.docs[0].id;
          final existingStock = querySnapshot.docs[0]['stock'] ?? 0;
          final updatedStock = existingStock + _newStock;

          await FirebaseFirestore.instance.collection('products').doc(productId).update({
            'stock': updatedStock,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Stock updated successfully'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product not found'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error updating stock: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update stock: $e'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a category, product, and enter a valid stock quantity'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
