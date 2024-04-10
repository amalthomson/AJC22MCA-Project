import 'package:farmconnect/blockchain/add_user_screen.dart';
import 'package:farmconnect/blockchain/user_list_screen.dart';
import 'package:farmconnect/blockchain/web3client.dart';
import 'package:farmconnect/pages/Farmer/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:farmconnect/features/splashScreen/splash_screen.dart';
import 'package:farmconnect/pages/Admin/add_categories.dart';
import 'package:farmconnect/pages/Admin/dashboard.dart';
import 'package:farmconnect/pages/Admin/buyers.dart';
import 'package:farmconnect/pages/Admin/farmers.dart';
import 'package:farmconnect/pages/Admin/farmer_rejected.dart';
import 'package:farmconnect/pages/Admin/farmer_approvals.dart';
import 'package:farmconnect/pages/Admin/caterogy_wise_products.dart';
import 'package:farmconnect/pages/Admin/stocks.dart';
import 'package:farmconnect/pages/Admin/payments.dart';
import 'package:farmconnect/pages/Admin/products_approved.dart';
import 'package:farmconnect/pages/Admin/products_approvals.dart';
import 'package:farmconnect/pages/Admin/products_rejected.dart';
import 'package:farmconnect/pages/Buyer/buyerDashboard.dart';
import 'package:farmconnect/pages/Buyer/buyerProfile.dart';
import 'package:farmconnect/pages/Buyer/buyerftl.dart';
import 'package:farmconnect/pages/Buyer/productsDairy.dart';
import 'package:farmconnect/pages/Buyer/productsFruit.dart';
import 'package:farmconnect/pages/Buyer/productsPoultry.dart';
import 'package:farmconnect/pages/Buyer/productsVegetable.dart';
import 'package:farmconnect/pages/Buyer/updatePassword.dart';
import 'package:farmconnect/pages/Buyer/updateProfile.dart';
import 'package:farmconnect/pages/Cart/cartProvider.dart';
import 'package:farmconnect/pages/Cart/viewBillsandInvoice.dart';
import 'package:farmconnect/pages/Farmer/farmerDashboard.dart';
import 'package:farmconnect/pages/Farmer/farmerftl.dart';
import 'package:farmconnect/pages/Common/termsAndConditions.dart';
import 'package:farmconnect/pages/Common/email_verification_pending_page.dart';
import 'package:farmconnect/pages/Common/login_page.dart';
import 'package:farmconnect/pages/Common/sign_up_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cartProvider = CartProvider();
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    cartProvider.setUserId(user.uid);
    await cartProvider.initializeCartFromFirestore();
  }

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
        '/buyer_profile': (context) => BuyerProfilePage(),
        '/buyer_home': (context) => BuyerDashboard(),
        '/update_details': (context) => UpdateDetailsPage(),
        '/update_password': (context) => UpdatePasswordPage(),
        '/farmer_dash': (context) => FarmerDashboard(),
        '/buyer_ftl': (context) => BuyerFTLPage(),
        '/farmer_ftl': (context) => FarmerFTLPage(),
        '/admin_dashboard': (context) => AdminDashboard(),
        // '/buyer_details': (context) => BuyerDetailsPage(),
        // '/farmer_details': (context) => FarmerDetailsPage(),
        '/email_verification_pending': (context) => EmailVerificationPendingPage(),
        '/terms': (context) => TermsPage(),
        // '/pendingapproval': (context) => PendingApprovalPage(),
        // '/approvedproducts': (context) => ApprovedProductsPage(),
        // '/rejectedproducts': (context) => RejectedProductsPage(),
        '/poultry_page': (context) => PoultryProductsPage(),
        '/dairy_page': (context) => DairyProductsPage(),
        '/fruits_page': (context) => FruitsProductsPage(),
        '/vegetables_page': (context) => VegetableProductsPage(),
        '/added_product': (context) => FarmerDashboard(),
        // '/farmer_approval_pending': (context) => PendingFarmerApprovalPage(),
        // '/farmer_approval_rejected': (context) => RejectedFarmerApprovalPage(),
        // '/products_categoryWise': (context) => CategoryWiseProducts(),
        "/bills_and_invoice": (context) => BillsPage(),
        // '/paymentSuccessful': (context) => PaymentSuccessfulPage(),
        // '/stockDetails': (context) => StockByProductNamePage(),
        // '/add_category': (context) => AddCategoriesAndProducts(),
        '/display_user': (context) => UserListScreen(),
        '/add_user': (context) => AddUserScreen(),
      },
    );
  }
}
