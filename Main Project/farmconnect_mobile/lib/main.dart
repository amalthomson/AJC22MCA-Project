import 'package:farmconnect/pages/Admin/addCategories.dart';
import 'package:farmconnect/pages/Admin/adminDashboard.dart';
import 'package:farmconnect/pages/Admin/displayBuyers.dart';
import 'package:farmconnect/pages/Admin/displayFarmersApproved.dart';
import 'package:farmconnect/pages/Admin/displayFarmersRejected.dart';
import 'package:farmconnect/pages/Admin/displayFramersPending.dart';
import 'package:farmconnect/pages/Admin/displayProductsCaterogyWise.dart';
import 'package:farmconnect/pages/Admin/displayStock.dart';
import 'package:farmconnect/pages/Admin/paymentSuccessful.dart';
import 'package:farmconnect/pages/Admin/productsApproved.dart';
import 'package:farmconnect/pages/Admin/productsPending.dart';
import 'package:farmconnect/pages/Admin/productsRejected.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/features/splashScreen/splash_screen.dart';
import 'package:provider/provider.dart';

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
    ChangeNotifierProvider.value(
      value: cartProvider,
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
        '/farmer_approval_pending' : (context) => PendingFarmerApprovalPage(),
        '/farmer_approval_rejected' : (context) => RejectedFarmerApprovalPage(),
        '/products_categoryWise' : (context) => CategoryWiseProducts(),
        "/bills_and_invoice" : (context) => BillsPage(),
        '/paymentSuccessful' : (context) => PaymentSuccessfulPage(),
        '/stockDetails' : (context) => StockByProductNamePage(),
        '/add_category' : (context) => AddCategoriesAndProducts(),
      },
    );
  }
}
