import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/buyerProfile.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/Cart/cartPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'productsDairy.dart';
import 'productsFruit.dart';
import 'productsPoultry.dart';
import 'productsVegetable.dart';

class ProductSearch extends SearchDelegate<String> {
  final Future<List<String>> productList;

  ProductSearch(this.productList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: productList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<String> products = snapshot.data!;
          List<String> searchResults = products
              .where((product) => product.toLowerCase().contains(query.toLowerCase()))
              .toList();

          if (searchResults.isEmpty) {
            return Center(child: Text('No products matching the search.'));
          }

          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              String productName = searchResults[index];

              return Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: GestureDetector(
                    onTap: () {
                      _showProductDetailsDialog(context, productName);
                    },
                    child: Text(
                      productName,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20.0,
                    color: Colors.blue,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void _showProductDetailsDialog(BuildContext context, String productName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('productName', isEqualTo: productName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot productSnapshot = querySnapshot.docs.first;

        if (productSnapshot.exists &&
            (productSnapshot.data() as Map<String, dynamic>).containsKey('productName') &&
            (productSnapshot.data() as Map<String, dynamic>).containsKey('productPrice') &&
            (productSnapshot.data() as Map<String, dynamic>).containsKey('productImage')) {
          String productName = productSnapshot['productName'];
          double price = double.parse(productSnapshot['productPrice']);
          String imageUrl = productSnapshot['productImage'];

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Price: \₹${price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 16.0),
                      Image.network(
                        imageUrl,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Implement logic to add the product to the cart
                              // For simplicity, you can print a message for now
                              print('Added $productName to the cart');
                              Navigator.pop(context); // Close the dialog
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            child: Text('Add to Cart', style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Close', style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          print('Missing fields in the product document');
        }
      } else {
        print('Product not found');
      }
    } catch (error) {
      print('Error fetching product details: $error');
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}