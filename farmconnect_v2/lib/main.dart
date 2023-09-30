import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/update_details.dart'; // Replace with the correct path to your update_details.dart file
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:farmconnect/features/app/splash_screen/splash_screen.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/home_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/login_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/sign_up_page.dart';
// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//         );
//   } else {
//     await Firebase.initializeApp();
//   }
//   runApp(MyApp());
// }
void main() async {
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
      routes: {
        '/': (context) => SplashScreen(
              child: LoginPage(),
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/update_details': (context) => UpdateDetailsPage(),
      },
    );
  }
}
