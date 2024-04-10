// import 'package:farmconnect/widgets/admin_bottom_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:farmconnect/pages/Farmer/LowStockProductsPage.dart';
// import 'package:farmconnect/pages/Farmer/addproducts.dart';
// import 'package:farmconnect/pages/Farmer/agriculturalNewsPage.dart';
// import 'package:farmconnect/pages/Farmer/farmer_page.dart';
// import 'package:farmconnect/pages/Farmer/myproducts.dart';
//
// class FarmerDashboard extends StatefulWidget {
//   const FarmerDashboard({Key? key}) : super(key: key);
//
//   @override
//   _FarmerDashboardState createState() => _FarmerDashboardState();
// }
//
// class _FarmerDashboardState extends State<FarmerDashboard> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _widgetOptions = <Widget>[
//     MyProductsPage(),
//     LowStockProductsPage(),
//     AddProducts(),
//     AgriculturalNewsPage(),
//     FarmerPage(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.black,
//       ),
//       backgroundColor: Colors.blueGrey[900],
//       body: _widgetOptions.elementAt(_selectedIndex),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         selectedIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         items: <Icon>[
//           Icon(Icons.storage, size: 30),
//           Icon(Icons.store, size: 30),
//           Icon(Icons.add, size: 30),
//           Icon(Icons.info, size: 30),
//           Icon(Icons.person, size: 30),
//         ],
//       ),
//     );
//   }
// }
