// // // // import 'package:farmconnect/pages/BuyerPages/buyerProfile.dart';
// // // // import 'package:farmconnect/pages/BuyerPages/productSearch.dart';
// // // // import 'package:farmconnect/pages/BuyerPages/wishlistPage.dart';
// // // // import 'package:farmconnect/pages/Cart/cartPage.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:google_sign_in/google_sign_in.dart';
// // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // import 'productsDairy.dart';
// // // // import 'productsFruit.dart';
// // // // import 'productsPoultry.dart';
// // // // import 'productsVegetable.dart';
// // // //
// // // // final TextEditingController _searchController = TextEditingController();
// // // //
// // // // class BuyerDashboard extends StatefulWidget {
// // // //   const BuyerDashboard({Key? key}) : super(key: key);
// // // //
// // // //   @override
// // // //   _BuyerDashboardState createState() => _BuyerDashboardState();
// // // // }
// // // //
// // // // class _BuyerDashboardState extends State<BuyerDashboard> {
// // // //   late Future<List<String>> productList;
// // // //
// // // //   Future<List<String>> getProductList() async {
// // // //     List<String> productList = [];
// // // //
// // // //     try {
// // // //       QuerySnapshot querySnapshot =
// // // //       await FirebaseFirestore.instance.collection('products').get();
// // // //
// // // //       for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
// // // //         String productName = documentSnapshot['productName'];
// // // //         productList.add(productName);
// // // //       }
// // // //     } catch (error) {
// // // //       print("Error fetching product list: $error");
// // // //     }
// // // //
// // // //     return productList;
// // // //   }
// // // //
// // // //   Future<void> _signOut(BuildContext context) async {
// // // //     final FirebaseAuth _auth = FirebaseAuth.instance;
// // // //     final GoogleSignIn googleSignIn = GoogleSignIn();
// // // //     try {
// // // //       await _auth.signOut();
// // // //       await googleSignIn.signOut();
// // // //       Navigator.pushReplacementNamed(context, "/login");
// // // //       //Navigator.popAndPushNamed(context, "/login");
// // // //     } catch (error) {
// // // //       print("Error signing out: $error");
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     productList = getProductList();
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return DefaultTabController(
// // // //       length: 5,
// // // //       child: Scaffold(
// // // //         floatingActionButton: Row(
// // // //           mainAxisAlignment: MainAxisAlignment.end,
// // // //           children: [
// // // //             FloatingActionButton(
// // // //               onPressed: () {
// // // //                 Navigator.push(
// // // //                   context,
// // // //                   MaterialPageRoute(builder: (context) => CartPage()),
// // // //                 );
// // // //               },
// // // //               child: Icon(Icons.shopping_cart, color: Colors.white),
// // // //               backgroundColor: Colors.green,
// // // //             ),
// // // //             SizedBox(width: 16.0),
// // // //             FloatingActionButton(
// // // //               onPressed: () {
// // // //                 Navigator.push(
// // // //                   context,
// // // //                   MaterialPageRoute(builder: (context) => WishlistPage()),
// // // //                 );
// // // //               },
// // // //               child: Icon(Icons.favorite, color: Colors.white),
// // // //               backgroundColor: Colors.red,
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         backgroundColor: Colors.black,
// // // //         appBar: AppBar(
// // // //           automaticallyImplyLeading: false,
// // // //           title: Text(
// // // //             "Buyer Dashboard",
// // // //             style: TextStyle(
// // // //               color: Colors.white,
// // // //               fontSize: 20,
// // // //               fontWeight: FontWeight.bold,
// // // //             ),
// // // //           ),
// // // //           backgroundColor: Colors.grey[900],
// // // //           actions: <Widget>[
// // // //             Container(
// // // //               margin: EdgeInsets.only(right: 16.0), // Adjust margin as needed
// // // //               child: InkWell(
// // // //                 onTap: () {
// // // //                   showSearch(
// // // //                     context: context,
// // // //                     delegate: ProductSearch(productList),
// // // //                   );
// // // //                 },
// // // //                 child: Padding(
// // // //                   padding: const EdgeInsets.all(8.0),
// // // //                   child: Icon(
// // // //                     Icons.search,
// // // //                     size: 30.0, // Adjust icon size as needed
// // // //                     color: Colors.white,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             ElevatedButton(
// // // //               onPressed: () => _signOut(context),
// // // //               style: ButtonStyle(
// // // //                 backgroundColor: MaterialStateProperty.all(Colors.red),
// // // //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
// // // //                   RoundedRectangleBorder(
// // // //                     borderRadius: BorderRadius.circular(10.0),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               child: Row(
// // // //                 mainAxisSize: MainAxisSize.min,
// // // //                 children: [
// // // //                   Icon(
// // // //                     Icons.logout,
// // // //                     color: Colors.white,
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ],
// // // //           bottom: TabBar(
// // // //             //isScrollable: true,
// // // //             unselectedLabelColor: Colors.white,
// // // //             labelColor: Colors.green,
// // // //             indicatorColor: Colors.white,
// // // //             indicatorWeight: 3.0,
// // // //             tabs: [
// // // //               Tab(
// // // //                 icon: Icon(Icons.category_sharp),
// // // //                 text: 'Fruits',
// // // //               ),
// // // //               Tab(
// // // //                 icon: Icon(Icons.category_sharp),
// // // //                 text: 'Vegetables',
// // // //               ),
// // // //               Tab(
// // // //                 icon: Icon(Icons.category_sharp),
// // // //                 text: 'Dairy',
// // // //               ),
// // // //               Tab(
// // // //                 icon: Icon(Icons.category_sharp),
// // // //                 text: 'Poultry',
// // // //               ),
// // // //               Tab(
// // // //                 icon: Icon(Icons.person),
// // // //                 text: 'Profile',
// // // //               ),
// // // //             ],
// // // //             labelPadding: EdgeInsets.symmetric(horizontal: 12.0), // Adjust padding as needed
// // // //           ),
// // // //         ),
// // // //         body: FutureBuilder<List<String>>(
// // // //           future: productList,
// // // //           builder: (context, snapshot) {
// // // //             if (snapshot.connectionState == ConnectionState.waiting) {
// // // //               return Center(child: CircularProgressIndicator());
// // // //             } else if (snapshot.hasError) {
// // // //               return Center(child: Text('Error: ${snapshot.error}'));
// // // //             } else {
// // // //               return TabBarView(
// // // //                 children: [
// // // //                   FruitsProductsPage(),
// // // //                   VegetableProductsPage(),
// // // //                   DairyProductsPage(),
// // // //                   PoultryProductsPage(),
// // // //                   BuyerProfilePage(),
// // // //                 ],
// // // //               );
// // // //             }
// // // //           },
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // //
// // //
// // // import 'package:farmconnect/pages/BuyerPages/buyerProfile.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'productsDairy.dart';
// // // import 'productsFruit.dart';
// // // import 'productsPoultry.dart';
// // // import 'productsVegetable.dart';
// // //
// // // class BuyerDashboard extends StatefulWidget {
// // //   const BuyerDashboard({Key? key}) : super(key: key);
// // //
// // //   @override
// // //   _BuyerDashboardState createState() => _BuyerDashboardState();
// // // }
// // //
// // // class _BuyerDashboardState extends State<BuyerDashboard> {
// // //   late List<String> productList;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     productList = [];
// // //   }
// // //
// // //   void _loadProductList() async {
// // //     // Fetch your product list from the database or any other source
// // //     // and update the state accordingly
// // //     // For now, let's assume you have a list of products: ['Fruits', 'Vegetables', 'Dairy', 'Poultry']
// // //     setState(() {
// // //       productList = ['Fruits', 'Vegetables', 'Dairy', 'Poultry'];
// // //     });
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return DefaultTabController(
// // //       length: 2,
// // //       child: Scaffold(
// // //         backgroundColor: Colors.black,
// // //         appBar: AppBar(
// // //           automaticallyImplyLeading: false,
// // //           title: Text(
// // //             "Buyer Dashboard",
// // //             style: TextStyle(
// // //               color: Colors.white,
// // //               fontSize: 20,
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //           backgroundColor: Colors.grey[900],
// // //           actions: <Widget>[
// // //             ElevatedButton(
// // //               onPressed: () {
// // //                 // Handle sign out logic
// // //               },
// // //               style: ButtonStyle(
// // //                 backgroundColor: MaterialStateProperty.all(Colors.red),
// // //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
// // //                   RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(10.0),
// // //                   ),
// // //                 ),
// // //               ),
// // //               child: Row(
// // //                 mainAxisSize: MainAxisSize.min,
// // //                 children: [
// // //                   Icon(
// // //                     Icons.logout,
// // //                     color: Colors.white,
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //           bottom: TabBar(
// // //             unselectedLabelColor: Colors.white,
// // //             labelColor: Colors.green,
// // //             indicatorColor: Colors.white,
// // //             indicatorWeight: 3.0,
// // //             tabs: [
// // //               Tab(
// // //                 text: 'Products',
// // //               ),
// // //               Tab(
// // //                 text: 'Profile',
// // //               ),
// // //             ],
// // //             labelPadding: EdgeInsets.symmetric(horizontal: 12.0),
// // //           ),
// // //         ),
// // //         body: TabBarView(
// // //           children: [
// // //             // Products Tab
// // //             Column(
// // //               children: [
// // //                 ElevatedButton(
// // //                   onPressed: () {
// // //                     // Handle navigation to Organic Products page
// // //                   },
// // //                   child: Text('Organic Products'),
// // //                 ),
// // //                 ElevatedButton(
// // //                   onPressed: () {
// // //                     // Load the product list and navigate to Normal Products page
// // //                     _loadProductList();
// // //                     Navigator.push(
// // //                       context,
// // //                       MaterialPageRoute(builder: (context) => NormalProductsPage(productList)),
// // //                     );
// // //                   },
// // //                   child: Text('Normal Products'),
// // //                 ),
// // //               ],
// // //             ),
// // //
// // //             // Profile Tab
// // //             BuyerProfilePage(),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class NormalProductsPage extends StatelessWidget {
// // //   final List<String> productList;
// // //
// // //   NormalProductsPage(this.productList);
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return DefaultTabController(
// // //       length: productList.length,
// // //       child: Scaffold(
// // //         appBar: AppBar(
// // //           title: Text('Normal Products'),
// // //           bottom: TabBar(
// // //             tabs: productList.map((product) {
// // //               return Tab(
// // //                 text: product,
// // //               );
// // //             }).toList(),
// // //           ),
// // //         ),
// // //         body: TabBarView(
// // //           children: [
// // //             FruitsProductsPage(),
// // //             VegetableProductsPage(),
// // //             DairyProductsPage(),
// // //             PoultryProductsPage(),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // import 'package:farmconnect/pages/BuyerPages/buyerProfile.dart';
// // import 'package:farmconnect/pages/BuyerPages/wishlistPage.dart';
// // import 'package:farmconnect/pages/Cart/cartPage.dart';
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'productsDairy.dart';
// // import 'productsFruit.dart';
// // import 'productsPoultry.dart';
// // import 'productsVegetable.dart';
// //
// // class BuyerDashboard extends StatefulWidget {
// //   const BuyerDashboard({Key? key}) : super(key: key);
// //
// //   @override
// //   _BuyerDashboardState createState() => _BuyerDashboardState();
// // }
// //
// // class _BuyerDashboardState extends State<BuyerDashboard> {
// //   late List<String> productList;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     productList = [];
// //   }
// //
// //   void _loadProductList() async {
// //     // Fetch your product list from the database or any other source
// //     // and update the state accordingly
// //     // For now, let's assume you have a list of products: ['Fruits', 'Vegetables', 'Dairy', 'Poultry']
// //     setState(() {
// //       productList = ['Fruits', 'Vegetables', 'Dairy', 'Poultry'];
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //       length: 2,
// //       child: Scaffold(
// //         backgroundColor: Colors.black,
// //         appBar: AppBar(
// //           automaticallyImplyLeading: false,
// //           title: Text(
// //             "Buyer Dashboard",
// //             style: TextStyle(
// //               color: Colors.white,
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           backgroundColor: Colors.grey[900],
// //           actions: <Widget>[
// //             ElevatedButton(
// //               onPressed: () {
// //                 // Handle sign out logic
// //               },
// //               style: ButtonStyle(
// //                 backgroundColor: MaterialStateProperty.all(Colors.red),
// //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
// //                   RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10.0),
// //                   ),
// //                 ),
// //               ),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Icon(
// //                     Icons.logout,
// //                     color: Colors.white,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //           bottom: TabBar(
// //             unselectedLabelColor: Colors.white,
// //             labelColor: Colors.green,
// //             indicatorColor: Colors.white,
// //             indicatorWeight: 3.0,
// //             tabs: [
// //               Tab(
// //                 text: 'Products',
// //               ),
// //               Tab(
// //                 text: 'Profile',
// //               ),
// //             ],
// //             labelPadding: EdgeInsets.symmetric(horizontal: 12.0),
// //           ),
// //         ),
// //         body: TabBarView(
// //           children: [
// //             // Products Tab
// //             Column(
// //               children: [
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     // Handle navigation to Organic Products page
// //                   },
// //                   child: Text('Organic Products'),
// //                 ),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     // Load the product list and navigate to Normal Products page
// //                     _loadProductList();
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => NormalProductsPage(productList)),
// //                     );
// //                   },
// //                   child: Text('Normal Products'),
// //                 ),
// //               ],
// //             ),
// //
// //             // Profile Tab
// //             BuyerProfilePage(),
// //           ],
// //         ),
// //         floatingActionButton: Column(
// //           mainAxisAlignment: MainAxisAlignment.end,
// //           children: [
// //             FloatingActionButton(
// //               onPressed: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => CartPage()),
// //                 );
// //               },
// //               child: Icon(Icons.shopping_cart, color: Colors.white),
// //               backgroundColor: Colors.green,
// //             ),
// //             SizedBox(height: 16.0),
// //             FloatingActionButton(
// //               onPressed: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => WishlistPage()),
// //                 );
// //               },
// //               child: Icon(Icons.favorite, color: Colors.white),
// //               backgroundColor: Colors.red,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class NormalProductsPage extends StatelessWidget {
// //   final List<String> productList;
// //
// //   NormalProductsPage(this.productList);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //       length: productList.length,
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: Text('Normal Products'),
// //           bottom: TabBar(
// //             tabs: productList.map((product) {
// //               return Tab(
// //                 text: product,
// //               );
// //             }).toList(),
// //           ),
// //         ),
// //         body: TabBarView(
// //           children: [
// //             FruitsProductsPage(),
// //             VegetableProductsPage(),
// //             DairyProductsPage(),
// //             PoultryProductsPage(),
// //           ],
// //         ),
// //         floatingActionButton: Column(
// //           mainAxisAlignment: MainAxisAlignment.end,
// //           children: [
// //             FloatingActionButton(
// //               onPressed: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => CartPage()),
// //                 );
// //               },
// //               child: Icon(Icons.shopping_cart, color: Colors.white),
// //               backgroundColor: Colors.green,
// //             ),
// //             SizedBox(height: 16.0),
// //             FloatingActionButton(
// //               onPressed: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => WishlistPage()),
// //                 );
// //               },
// //               child: Icon(Icons.favorite, color: Colors.white),
// //               backgroundColor: Colors.red,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:farmconnect/pages/BuyerPages/buyerProfile.dart';
// import 'package:farmconnect/pages/BuyerPages/wishlistPage.dart';
// import 'package:farmconnect/pages/Cart/cartPage.dart';
// import 'productsDairy.dart';
// import 'productsFruit.dart';
// import 'productsPoultry.dart';
// import 'productsVegetable.dart';
//
// class BuyerDashboard extends StatefulWidget {
//   const BuyerDashboard({Key? key}) : super(key: key);
//
//   @override
//   _BuyerDashboardState createState() => _BuyerDashboardState();
// }
//
// class _BuyerDashboardState extends State<BuyerDashboard> {
//   late List<String> productList;
//
//   @override
//   void initState() {
//     super.initState();
//     productList = [];
//   }
//
//   void _loadProductList() async {
//     setState(() {
//       productList = ['Fruits', 'Vegetables', 'Dairy', 'Poultry'];
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: Text(
//             "Buyer Dashboard",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           backgroundColor: Colors.grey[900],
//           actions: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 // Handle sign out logic
//               },
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.red),
//                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                   RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.logout,
//                     color: Colors.white,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//           bottom: TabBar(
//             unselectedLabelColor: Colors.white,
//             labelColor: Colors.green,
//             indicatorColor: Colors.white,
//             indicatorWeight: 3.0,
//             tabs: [
//               Tab(
//                 text: 'Products',
//               ),
//               Tab(
//                 text: 'Profile',
//               ),
//             ],
//             labelPadding: EdgeInsets.symmetric(horizontal: 12.0),
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // Products Tab
//             Container(
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Stack(
//                       children: [
//                         Positioned.fill(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Handle navigation to Organic Products page
//                             },
//                             style: ElevatedButton.styleFrom(
//                               primary: Colors.green,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(0),
//                               ),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset(
//                                   'assets/organic.png',
//                                   height: 300,
//                                 ),
//                                 SizedBox(height: 10),
//                                 Text(
//                                   'Organic Products',
//                                   style: TextStyle(fontSize: 36, color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Stack(
//                       children: [
//                         Positioned.fill(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Load the product list and navigate to Normal Products page
//                               _loadProductList();
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => NormalProductsPage(productList),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               primary: Colors.blue,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(0),
//                               ),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset(
//                                   'assets/org.jpeg',
//                                   height: 300,
//                                 ),
//                                 SizedBox(height: 10),
//                                 Text(
//                                   'Non Organic Products',
//                                   style: TextStyle(fontSize: 36, color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Profile Tab
//             BuyerProfilePage(),
//           ],
//         ),
//         floatingActionButton: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             FloatingActionButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CartPage()),
//                 );
//               },
//               child: Icon(Icons.shopping_cart, color: Colors.white),
//               backgroundColor: Colors.green,
//             ),
//             SizedBox(height: 16.0),
//             FloatingActionButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => WishlistPage()),
//                 );
//               },
//               child: Icon(Icons.favorite, color: Colors.white),
//               backgroundColor: Colors.red,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class NormalProductsPage extends StatelessWidget {
//   final List<String> productList;
//
//   NormalProductsPage(this.productList);
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: productList.length,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Normal Products'),
//           bottom: TabBar(
//             tabs: productList.map((product) {
//               return Tab(
//                 text: product,
//               );
//             }).toList(),
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             FruitsProductsPage(),
//             VegetableProductsPage(),
//             DairyProductsPage(),
//             PoultryProductsPage(),
//           ],
//         ),
//         floatingActionButton: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             FloatingActionButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CartPage()),
//                 );
//               },
//               child: Icon(Icons.shopping_cart, color: Colors.white),
//               backgroundColor: Colors.green,
//             ),
//             SizedBox(height: 16.0),
//             FloatingActionButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => WishlistPage()),
//                 );
//               },
//               child: Icon(Icons.favorite, color: Colors.white),
//               backgroundColor: Colors.red,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:farmconnect/pages/BuyerPages/organicProducts.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/pages/BuyerPages/buyerProfile.dart';
import 'package:farmconnect/pages/BuyerPages/wishlistPage.dart';
import 'package:farmconnect/pages/Cart/cartPage.dart';
import 'productsDairy.dart';
import 'productsFruit.dart';
import 'productsPoultry.dart';
import 'productsVegetable.dart';

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({Key? key}) : super(key: key);

  @override
  _BuyerDashboardState createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  late List<String> productList;

  @override
  void initState() {
    super.initState();
    productList = [];
  }

  void _loadProductList() async {
    setState(() {
      productList = ['Fruits', 'Vegetables', 'Dairy', 'Poultry'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Buyer Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.grey[900],
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Handle sign out logic
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.green,
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
            tabs: [
              Tab(
                text: 'Products',
              ),
              Tab(
                text: 'Profile',
              ),
            ],
            labelPadding: EdgeInsets.symmetric(horizontal: 12.0),
          ),
        ),
        body: TabBarView(
          children: [
            // Products Tab
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OrganicProductsPage()),
                              );                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/organic.png',
                                  height: 300,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Organic Products',
                                  style: TextStyle(fontSize: 36, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ElevatedButton(
                            onPressed: () {
                              // Load the product list and navigate to Normal Products page
                              _loadProductList();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NormalProductsPage(productList),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/org.jpeg',
                                  height: 300,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Non Organic Products',
                                  style: TextStyle(fontSize: 36, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Profile Tab
            BuyerProfilePage(),
          ],
        ),
      ),
    );
  }
}

class NormalProductsPage extends StatelessWidget {
  final List<String> productList;

  NormalProductsPage(this.productList);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: productList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Normal Products'),
          bottom: TabBar(
            tabs: productList.map((product) {
              return Tab(
                text: product,
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: [
            FruitsProductsPage(),
            VegetableProductsPage(),
            DairyProductsPage(),
            PoultryProductsPage(),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
              child: Icon(Icons.shopping_cart, color: Colors.white),
              backgroundColor: Colors.green,
            ),
            SizedBox(height: 16.0),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WishlistPage()),
                );
              },
              child: Icon(Icons.favorite, color: Colors.white),
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
