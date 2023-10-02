import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/admin_dashboard.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/admin_home.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/buyer_details.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/farmer_details.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/buyerftl.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/FarmerPages/farmer_home.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/FarmerPages/farmerftl.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/update_password.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/terms_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/features/app/splash_screen/splash_screen.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/home_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/login_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/update_details.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FarmConnect',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/buyer_home': (context) => HomePage(),
        '/update_details': (context) => UpdateDetailsPage(), // Define the route for UpdateDetailsPage
        '/update_password': (context) => UpdatePasswordPage(),
        '/farmer_home' : (context) => FarmerHomePage(),
        '/admin_home' : (context) => AdminHomePage(),
        '/buyer_ftl' : (context) => BuyerFTLPage(),
        '/farmer_ftl' : (context) => FarmerFTLPage(),
        '/admin_dashboard' : (context) => AdminDashboard(),
        '/buyer_details' : (context) => BuyerDetailsPage(),
        '/farmer_details' : (context) => FarmerDetailsPage(),
        '/terms' : (context) => TermsPage()
      },
    );
  }
}

