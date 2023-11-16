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

final TextEditingController _searchController = TextEditingController();

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({Key? key}) : super(key: key);

  @override
  _BuyerDashboardState createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  late Future<List<String>> productList;

  Future<List<String>> getProductList() async {
    List<String> productList = [];

    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('products').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Assuming you have a field named 'productName' in your Firestore documents
        String productName = documentSnapshot['productName'];
        productList.add(productName);
      }
    } catch (error) {
      print("Error fetching product list: $error");
    }

    return productList;
  }

  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      Navigator.popAndPushNamed(context, "/login");
    } catch (error) {
      print("Error signing out: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    productList = getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CartPage()));
          },
          child: Icon(Icons.shopping_cart),
        ),
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Buyer Dashboard",
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.lightBlue[900],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ProductSearch(productList),
                );
              },
            ),
            ElevatedButton(
              onPressed: () => _signOut(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Dairy',
              ),
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Poultry',
              ),
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Fruits',
              ),
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Vegetables',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Profile',
              ),
            ],
          ),
        ),
        body: FutureBuilder<List<String>>(
          future: productList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return TabBarView(
                children: [
                  DairyProductsPage(),
                  PoultryProductsPage(),
                  FruitsProductsPage(),
                  VegetableProductsPage(),
                  BuyerProfilePage(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

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

              return ListTile(
                title: GestureDetector(
                  onTap: () {
                    _showProductDetailsDialog(context, productName);
                  },
                  child: Text(productName),
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
      // Fetch product details from Firestore based on the productName
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('productName', isEqualTo: productName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot productSnapshot = querySnapshot.docs.first;

        // Ensure the required fields exist in the document before accessing them
        if (productSnapshot.exists &&
            (productSnapshot.data() as Map<String, dynamic>).containsKey('productName') &&
            (productSnapshot.data() as Map<String, dynamic>).containsKey('productPrice') &&
            (productSnapshot.data() as Map<String, dynamic>).containsKey('productImage')) {
          // Product found, extract details
          String productName = productSnapshot['productName'];
          // Convert productPrice to double
          double price = double.parse(productSnapshot['productPrice']);
          String imageUrl = productSnapshot['productImage'];

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(productName),
                content: Column(
                  children: [
                    Text('Price: \$${price.toStringAsFixed(2)}'),
                    Image.network(
                      imageUrl,
                      height: 100,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Implement logic to add the product to the cart
                      // For simplicity, you can print a message for now
                      print('Added $productName to the cart');
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text('Add to Cart'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        } else {
          // Handle missing fields in the document
          print('Missing fields in the product document');
        }
      } else {
        // Product not found in Firestore
        print('Product not found');
        // You can display an error message or handle this case as appropriate
      }
    } catch (error) {
      print('Error fetching product details: $error');
      // Handle the error (e.g., display an error message to the user)
    }
  }




  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
