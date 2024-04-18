import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/blockchain/web3client.dart';
import 'package:farmconnect/features/splashScreen/splash_screen.dart';
import 'package:farmconnect/pages/Admin/dashboard.dart';
import 'package:farmconnect/pages/Buyer/buyer_dashboard.dart';
import 'package:farmconnect/pages/Buyer/buyer_ftl.dart';
import 'package:farmconnect/pages/Buyer/buyer_profile.dart';
import 'package:farmconnect/pages/Buyer/dairy.dart';
import 'package:farmconnect/pages/Buyer/fruits.dart';
import 'package:farmconnect/pages/Buyer/poultry.dart';
import 'package:farmconnect/pages/Buyer/update_password.dart';
import 'package:farmconnect/pages/Buyer/update_profile.dart';
import 'package:farmconnect/pages/Buyer/vegetable.dart';
import 'package:farmconnect/pages/Cart/cart_provider.dart';
import 'package:farmconnect/pages/Common/email_verification.dart';
import 'package:farmconnect/pages/Common/login_page.dart';
import 'package:farmconnect/pages/Common/sign_up_page.dart';
import 'package:farmconnect/pages/Common/terms_conditions.dart';
import 'package:farmconnect/pages/Farmer/farmer_dashboard.dart';
import 'package:farmconnect/pages/Farmer/farmer_ftl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cartProvider = CartProvider();
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    cartProvider.setUserId(user.uid);
    await cartProvider.initializeCartFromFirestore();
  }

  await checkAndMarkExpiredProducts();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: cartProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => UserServices(),
        ),
      ],
      child: MyApp(),
    ),
  );

  Timer.periodic(Duration(hours: 6), (Timer timer) async {
    await checkAndMarkExpiredProducts();
  });
}

Future<void> checkAndMarkExpiredProducts() async {
  final DateTime now = DateTime.now();
  final QuerySnapshot<Map<String, dynamic>> productsSnapshot =
  await FirebaseFirestore.instance.collection('products').get();

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> expiredProducts = [];

  for (final QueryDocumentSnapshot<Map<String, dynamic>> product
  in productsSnapshot.docs) {
    final DateTime expiryDate = DateTime.parse(product['expiryDate']);
    if (expiryDate.isBefore(now) && product['isApproved'] != 'Expired') {
      expiredProducts.add(product);
    }
  }

  final WriteBatch batch = FirebaseFirestore.instance.batch();
  for (final QueryDocumentSnapshot<Map<String, dynamic>> product
  in expiredProducts) {
    final DocumentReference productRef = FirebaseFirestore.instance
        .collection('products')
        .doc(product.id);
    batch.update(productRef, {'isApproved': 'Expired'});
  }

  await batch.commit();

  print('Expired Products:');
  print('Total Expired Products: ${expiredProducts.length}');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      cartProvider.setUserId(user.uid);
    }
    return MaterialApp(
      title: 'FarmConnect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/buyer_profile': (context) => BuyerProfile(),
        '/buyer_home': (context) => BuyerDashboard(),
        '/update_details': (context) => UpdateDetailsPage(),
        '/update_password': (context) => UpdatePasswordPage(),
        '/farmer_dash': (context) => FarmerDashboard(),
        '/buyer_ftl': (context) => BuyerFTLPage(),
        '/farmer_ftl': (context) => FarmerFTLPage(),
        '/admin_dashboard': (context) => AdminDashboard(),
        '/email_verification_pending': (context) => EmailVerificationPendingPage(),
        '/terms': (context) => TermsPage(),
        '/poultry_page': (context) => PoultryProductsPage(),
        '/dairy_page': (context) => DairyProductsPage(),
        '/fruits_page': (context) => FruitsProductsPage(),
        '/vegetables_page': (context) => VegetableProductsPage(),
        '/added_product': (context) => FarmerDashboard(),
      },
    );
  }
}
