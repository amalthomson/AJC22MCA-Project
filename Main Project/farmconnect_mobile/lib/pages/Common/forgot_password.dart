import 'package:farmconnect/pages/Common/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  Future<void> sendPasswordResetEmail(BuildContext context) async {
    final email = _emailController.text.trim();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
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
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 40.0), // Adjust the padding as needed
              child: Icon(
                Icons.lock_reset,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8,),
            Text(
              "Reset Password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true, // Center the title horizontally
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.blueGrey[900]!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: 5.0,
          ),
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
                color: Colors.white,
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
              autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation
              validator: (value) {
                if (value!.isEmpty) {
                  return "Email cannot be empty";
                }
                if (!RegExp(
                    r"^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$")
                    .hasMatch(value)) {
                  return "Please enter a valid email";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                hintText: 'Enter your email',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.email,
                    color: Colors.blue, // Set the icon color to blue
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              style: TextStyle(color: Colors.black), // Black text color
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendPasswordResetEmail(context); 
              },
              child: Text("Reset Password"),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Background color
                onPrimary: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0), // 50% rounding
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
