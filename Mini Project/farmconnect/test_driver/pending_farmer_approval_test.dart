// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:farmconnect/main.dart' as app;
// void main() {
//   group('Farmer Approval Test', () {
//     IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//     testWidgets("Farmer Approval Scenarios", (WidgetTester tester) async {
//       try {
//         app.main();
//         Color green = Color.fromARGB(255, 0, 255, 0);
//         Color red = Color.fromARGB(255, 255, 0, 0);
//         await tester.pumpAndSettle(Duration(seconds: 2));
//         expect(find.byType(SplashScreen), findsOneWidget);
//         print("Step 1: Splash screen shown");
//         final emailField = find.byKey(const ValueKey('email'));
//         final passwordField = find.byKey(const ValueKey('password'));
//         final loginButton = find.byKey(const ValueKey('login'));
//         await tester.tap(emailField);
//         await tester.enterText(emailField, "amalthomson007@gmail.com");
//         await tester.tap(passwordField);
//         await tester.enterText(passwordField, "Amal#123");
//         print("Step 2: Entered email and password");
//         await tester.tap(loginButton);
//         print("Step 3: Tapped 'Login' button");
//         final pendingApprovalButton = find.byKey(const ValueKey('pendingApprovalButton'));
//         await tester.tap(pendingApprovalButton);
//         await tester.pumpAndSettle();
//         print("Step 4: Tapped on pending farmer approval");
//         final approveFarmerButton = find.byKey(const ValueKey('approveFarmerButton'));
//         await tester.tap(approveFarmerButton);
//         await tester.pumpAndSettle();
//         print("Step 5: Tapped on approve Farmer");
//         expect(find.text("Farmer approved successfully"), findsOneWidget);
//         print("Step 6: Farmer approved successfully");
//         expect(find.text("All details saved successfully"), findsOneWidget);
//         print("Step 7: All details saved successfully");
//         bool testPassed = true;
//         printResult(testPassed);
//         void printResult(bool passed) {
//           if (passed) {
//             print("\x1B[32mTest Passed\x1B[0m");
//           } else {
//             print("\x1B[31mTest Failed\x1B[0m");
//           }
//     });
//   });
// }
