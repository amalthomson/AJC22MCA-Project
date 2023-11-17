import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/adminDashboard.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/displayBuyers.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/displayFarmersApproved.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/displayFarmersRejected.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/displayFramersPending.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/displayProductsCaterogyWise.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/productsApproved.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/productsPending.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/AdminPages/productsRejected.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/buyerDashboard.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/buyerProfile.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/buyerftl.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/productsDairy.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/productsFruit.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/productsPoultry.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/productsVegetable.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/updatePassword.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/updateProfile.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/Cart/viewBillsandInvoice.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/Cart/cartProvider.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/FarmerPages/farmerDashboard.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/FarmerPages/farmerftl.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/admin_approval_pending.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/termsAndConditions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/features/app/splash_screen/splash_screen.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/login_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/email_verification_pending_page.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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
        '/admin_approval_pending' : (context) => AdminApprovalPendingPage(),
        '/farmer_approval_pending' : (context) => PendingFarmerApprovalPage(),
        '/farmer_approval_rejected' : (context) => RejectedFarmerApprovalPage(),
        '/products_categoryWise' : (context) => CategoryWiseProducts(),
        "/bills_and_invoice" : (context) => BillsPage(),
      },
    );
  }
}
