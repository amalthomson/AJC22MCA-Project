import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/colors.dart';
import 'login_page.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  Future<void> sendPasswordResetEmail(BuildContext context) async {
    final email = _emailController.text.trim();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Password reset email sent successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Password reset email sent to $email",
            style: TextStyle(color: Colors.white), // White text color
          ),
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      // An error occurred while sending the password reset email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to send password reset email: $e",
            style: TextStyle(color: Colors.white), // White text color
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Forgot Password", style: TextStyle(color: Colors.white)), // White text color
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // White icon color
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
                  (route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Forgot Your Password?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text color
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Please enter your email address below, and we'll send you a link to reset your password.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white, // White text color
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black), // White text color
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendPasswordResetEmail(context); // Call the function to send reset email
              },
              child: Text("Reset Password"),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Background color
                onPrimary: Colors.white, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
