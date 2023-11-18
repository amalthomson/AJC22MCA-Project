import 'package:farmconnect/features/user_auth/presentation/pages/Cart/cartProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ProductSearch extends SearchDelegate<String> {
  final Future<List<String>> productList;

  ProductSearch(this.productList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.black, // Change this to your desired color
      brightness: Brightness.dark,
    );
  }

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
    final cartProvider = Provider.of<CartProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      cartProvider.setUserId(user.uid);
    }

    return Container(
      color: Colors.black, // Set the background color of the page to black
      child: FutureBuilder<List<String>>(
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
                  color: Colors.white, // Set the background color of the card
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: GestureDetector(
                      onTap: () {
                        _showProductDetailsDialog(context, productName, cartProvider);
                      },
                      child: Text(
                        productName,
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    trailing: Icon(
                      Icons.add_shopping_cart,
                      size: 20.0,
                      color: Colors.blue,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.arrow_circle_down,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showProductDetailsDialog(BuildContext context, String productName, CartProvider cartProvider) async {
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
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Price: \₹${price.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
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
                              bool isProductInCart = cartProvider.cartItems
                                  .any((item) => item['productId'] == productSnapshot.id);

                              if (isProductInCart) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("$productName is already in the cart"),
                                  ),
                                );
                              } else {
                                cartProvider.addToCart({
                                  'productName': productName,
                                  'productPrice': price,
                                  'productImage': imageUrl,
                                  'productId': productSnapshot.id,
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Added $productName to the cart"),
                                  ),
                                );
                              }

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
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            child: Text('Close', style: TextStyle(color: Colors.white)),
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
