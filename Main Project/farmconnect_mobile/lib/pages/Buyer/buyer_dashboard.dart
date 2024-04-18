import 'package:farmconnect/pages/Buyer/buyer_home.dart';
import 'package:farmconnect/pages/Buyer/wishlist.dart';
import 'package:farmconnect/pages/Cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/pages/Buyer/buyer_profile.dart';
import 'package:farmconnect/pages/Buyer/order_history.dart';
import 'package:farmconnect/pages/Buyer/product_search.dart';

final TextEditingController _searchController = TextEditingController();

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({Key? key}) : super(key: key);

  @override
  _BuyerDashboardState createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  late Future<List<String>> productList;

  List<Icon> bottomNavBarIcons = [
    Icon(Icons.home, size: 30),
    Icon(Icons.history, size: 30),
    Icon(Icons.favorite, size: 30),
    Icon(Icons.shopping_cart, size: 30),
    Icon(Icons.person, size: 30),
  ];

  int _selectedIndex = 0;

  Future<List<String>> getProductList() async {
    List<String> productList = [];

    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('products').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        String productName = documentSnapshot['productName'];
        productList.add(productName);
      }
    } catch (error) {
      print("Error fetching product list: $error");
    }

    return productList;
  }


  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    productList = getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/icons/appLogoDark.png'),
            ),
            SizedBox(width: 8),
            Text(
              "FarmConnect",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
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
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: ProductSearch(productList),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  size: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: productList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            switch (_selectedIndex) {
              case 0:
                return BuyerHome();
              case 1:
                return OrdersHistory();
              case 2:
                return Wishlist();
              case 3:
                return CartPage();
              case 4:
                return BuyerProfile();
              default:
                return BuyerHome();
            }
          }
        },
      ),
      bottomNavigationBar: BuyerCustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: bottomNavBarIcons,
      ),
    );
  }
}

class BuyerCustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<Icon> items;

  BuyerCustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: selectedIndex,
      backgroundColor: Colors.blueGrey[900]!,
      items: items.map((icon) => _whiteIcon(icon)).toList(),
      animationDuration: Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      color: Colors.black,
      buttonBackgroundColor: Colors.blueAccent,
      height: 60,
      onTap: onTap,
    );
  }

  Icon _whiteIcon(Icon icon) {
    return Icon(
      icon.icon,
      color: Colors.white,
      size: icon.size,
    );
  }
}
