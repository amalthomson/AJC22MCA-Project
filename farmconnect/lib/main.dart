import 'package:farmconnect/features/user_auth/presentation/pages/admin_home.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/buyerftl.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/farmer_home.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/reset_password.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/update_password.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmconnect/features/app/splash_screen/splash_screen.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/home_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/login_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/update_details.dart';

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
        '/reset_password': (context) => ResetPasswordPage(),
        '/update_password': (context) => UpdatePasswordPage(),
        '/farmer_home' : (context) => FarmerHomePage(),
        '/admin_home' : (context) => AdminHomePage(),
        '/buyer_ftl' : (context) => BuyerFTLPage()
      },
    );
  }
}

