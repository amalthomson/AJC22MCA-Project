// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:farmconnect/main.dart' as app;
// void main() {
//   group('User Login Test', () {
//     IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//     testWidgets("Login Scenarios", (WidgetTester widgetTester) async {
//       app.main();
//       Color green = Color.fromARGB(255, 0, 255, 0);
//       Color red = Color.fromARGB(255, 255, 0, 0);
//       await widgetTester.pumpAndSettle(Duration(seconds: 2));
//       final getStartedBtn = find.byKey(Key('getStartedBtn'));
//       await widgetTester.tap(getStartedBtn);
//       await widgetTester.pumpAndSettle();
//       final emailField = find.byKey(const ValueKey('email'));
//       final passwordField = find.byKey(const ValueKey('password'));
//       final loginButton = find.byKey(const ValueKey('login'));
//       print("Scenario 1: Press login button without entering anything");
//       await widgetTester.tap(loginButton);
//       await widgetTester.pumpAndSettle(Duration(seconds: 5));
//       expect(find.text("TEST PASS"), findsNothing);
//       print("Scenario 2: Enter wrong password and press login");
//       await widgetTester.enterText(emailField, "amalthomson@gmail.com");
//       await widgetTester.enterText(passwordField, "amal123");
//       await widgetTester.tap(loginButton);
//       await widgetTester.pumpAndSettle(Duration(seconds: 5));
//       expect(find.text("TEST PASS"), findsNothing);
//       print("Scenario 3: Enter correct email and password");
//       await widgetTester.enterText(emailField, "amalthomson@icloud.com");
//       await widgetTester.enterText(passwordField, "Amal#123");
//       await widgetTester.tap(loginButton);
//       await widgetTester.pumpAndSettle(Duration(seconds: 5));
//       expect(find.text("TEST PASS"), findsNothing);
//       print("All scenarios passed!");
//     });
//   });
// }
