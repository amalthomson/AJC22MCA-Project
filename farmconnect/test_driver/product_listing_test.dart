// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:farmconnect/main.dart' as app;
// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//   group('Product Listing Test', () {
//     testWidgets("Product Listing Test", (WidgetTester tester) async {
//       try {
//         app.main();
//         Color green = Color.fromARGB(255, 0, 255, 0);
//         Color red = Color.fromARGB(255, 255, 0, 0);
//         await tester.pumpAndSettle(Duration(seconds: 2));
//         print("Step 1: Splash screen shown");
//         final emailField = find.byKey(const ValueKey('email'));
//         final passwordField = find.byKey(const ValueKey('password'));
//         final loginButton = find.byKey(const ValueKey('login'));
//         await tester.tap(emailField);
//         await tester.enterText(emailField, "amalthomson007@gmail.com");
//         await tester.tap(passwordField);
//         await tester.enterText(passwordField, "Amal#123");
//         print("Step 3: Entered email and password");
//         await tester.tap(loginButton);
//         print("Step 4: Tapped 'Login' button");
//         await tester.pumpAndSettle(Duration(seconds: 5));
//         final addProductsButton = find.byKey(Key('addProductsButton'));
//         await tester.tap(addProductsButton);
//         await tester.pumpAndSettle();
//         print("Step 5: Tapped add product button");
//         final productPriceField = find.byKey(const ValueKey('productPrice'));
//         final stockField = find.byKey(const ValueKey('stock'));
//         final productDescriptionField = find.byKey(const ValueKey('productDescription'));
//         await tester.enterText(productPriceField, "10.00");
//         await tester.enterText(stockField, "50");
//         await tester.enterText(productDescriptionField, "Fresh and organic product");
//         print("Step 6: Product details enetered");
//         final uploadProductButton = find.byKey(const ValueKey('uploadProductButton'));
//         await tester.tap(uploadProductButton);
//         await tester.pumpAndSettle(Duration(seconds: 5));
//         print("Step 7: Add product");
//         print("Product added successfully");
//         expect(find.text("Product added successfully"), findsOneWidget);
//         expect(find.byType(ProductItemWidget), findsOneWidget);
//         bool testPassed = true;
//         printResult(testPassed);
//         void printResult(bool passed) {
//           if (passed) {
//             print("\x1B[32mTest Passed\x1B[0m");
//           } else {
//             print("\x1B[31mTest Failed\x1B[0m");
//           }
//         }
//       }
//     });
//   });
// }
