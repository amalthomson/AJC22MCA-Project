import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/admin_dashboard.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/aprovedproducts.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/buyer_details.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/farmer_approval_pending.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/farmer_approval_rejected.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/farmer_details.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/rejectedproducts.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/buyer_dashboard.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/buyerftl.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/dairy_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/fruits_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/poultry_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/update_google.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/vegetables_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/FarmerPages/farmerDashboard.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/FarmerPages/farmerftl.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/update_password.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/pendingapproval.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/admin_approval_pending.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/terms_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/features/app/splash_screen/splash_screen.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/update_profile.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/login_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/update_details.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/email_verification_pending_page.dart';


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
        '/buyer_profile': (context) => BuyerProfilePage(),
        '/buyer_home' : (context) => BuyerDashboard(),
        '/update_details': (context) => UpdateDetailsPage(),
        '/update_google': (context) => UpdateGoogleDetails(),
        '/update_password': (context) => UpdatePasswordPage(),
        '/farmer_dash': (context) => FarmerDashboard(),
        '/buyer_ftl' : (context) => BuyerFTLPage(),
        '/farmer_ftl' : (context) => FarmerFTLPage(),
        '/admin_dashboard' : (context) => AdminDashboard(),
        '/buyer_details' : (context) => BuyerDetailsPage(),
        '/farmer_details' : (context) => FarmerDetailsPage(),
        '/email_verification_pending': (context) => EmailVerificationPendingPage(),
        '/terms' : (context) => TermsPage(),
        '/pendingapproval' : (context) => PendingApprovalPage(),
        '/approvedproducts' : (context) => ApprovedProductsPage(),
        '/rejectedproducts' : (context) => RejectedProductsPage(),
        '/poultry_page' : (context) => PoultryProductsPage(),
        '/dairy_page' : (context) => DairyProductsPage(),
        '/fruits_page' : (context) => FruitsProductsPage(),
        '/vegetables_page' : (context) => VegetableProductsPage(),
        '/added_product' : (context) => FarmerDashboard(),
        '/admin_approval_pending' : (context) => AdminApprovalPendingPage(),
        '/farmer_approval_pending' : (context) => PendingFarmerApprovalPage(),
        '/farmer_approval_rejected' : (context) => RejectedFarmerApprovalPage(),
      },
    );
  }
}

