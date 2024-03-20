// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:farmconnect/main.dart' as app;
// void main() {
//   group('Password Update Test', () {
//     IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//     testWidgets("Password Update Scenarios", (WidgetTester tester) async {
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
//         final profileButton = find.byKey(const ValueKey('profileButton'));
//         await tester.tap(profileButton);
//         await tester.pumpAndSettle();
//         print("Step 4: Tapped on profile");
//         final resetPasswordButton = find.byKey(const ValueKey('resetPasswordButton'));
//         await tester.tap(resetPasswordButton);
//         await tester.pumpAndSettle();
//         print("Step 5: Tapped on reset password");
//         final oldPasswordField = find.byKey(const ValueKey('oldPassword'));
//         final newPasswordField = find.byKey(const ValueKey('newPassword'));
//         final confirmPasswordField = find.byKey(const ValueKey('confirmPassword'));
//         await tester.enterText(oldPasswordField, "old_password");
//         await tester.enterText(newPasswordField, "new_password");
//         await tester.enterText(confirmPasswordField, "new_password");
//         print("Step 6: User validated & Entered new password");
//         final updatePasswordButton = find.byKey(const ValueKey('updatePasswordButton'));
//         await tester.tap(updatePasswordButton);
//         await tester.pumpAndSettle();
//         print("Step 7: Tapped on entered password");
//         expect(find.text("Password updated successfully"), findsOneWidget);
//         print("Step 8: Password updated successfully");
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
