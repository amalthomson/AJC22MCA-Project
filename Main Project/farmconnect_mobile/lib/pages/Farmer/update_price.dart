import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdatePricePage extends StatefulWidget {
  @override
  _UpdatePricePageState createState() => _UpdatePricePageState();
}

class _UpdatePricePageState extends State<UpdatePricePage> {
  String? _selectedCategory;
  String? _selectedProduct;
  double _currentPrice = 0.0;
  double _newPrice = 0.0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Update Price',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        elevation: 0, // Remove app bar shadow
      ),
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
              _buildPriceTextField(),
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
                _currentPrice = 0.0; // Reset current price
              });
            },
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            dropdownColor: Colors.blueGrey[800],
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

                  await _fetchCurrentPrice();
                },
                items: products.map((product) {
                  return DropdownMenuItem<String>(
                    value: product,
                    child: Text(product, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                dropdownColor: Colors.blueGrey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              ),
              SizedBox(height: 10.0),
              Text(
                'Current Price: ₹$_currentPrice',
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

  Future<void> _fetchCurrentPrice() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: _selectedCategory)
          .where('productName', isEqualTo: _selectedProduct)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _currentPrice = double.parse(querySnapshot.docs[0]['productPrice'].toString());
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
      print('Error fetching current price: $e');
    }
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'New Price',
        hintText: 'Enter the new price',
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.grey),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a price';
        }
        final price = double.tryParse(value);
        if (price == null || price < 1 || price > 999) {
          return 'Please enter a valid price between 1 and 999';
        }
        return null;
      },
      style: TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          _newPrice = double.tryParse(value) ?? 0.0;
        });
      },
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _updatePrice();
        }
      },
      child: Text('Update Price', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _updatePrice() async {
    if (_selectedCategory != null && _selectedProduct != null && _newPrice >= 0) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: _selectedCategory)
            .where('productName', isEqualTo: _selectedProduct)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final productId = querySnapshot.docs[0].id;

          await FirebaseFirestore.instance.collection('products').doc(productId).update({
            'productPrice': _newPrice.toString(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Price updated successfully'),
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
        print('Error updating price: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update price: $e'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a category, product, and enter a valid price'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
