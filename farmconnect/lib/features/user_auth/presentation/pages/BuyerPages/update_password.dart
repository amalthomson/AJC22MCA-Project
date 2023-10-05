import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/colors.dart';

class UpdatePasswordPage extends StatefulWidget {
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isOldPasswordValid = true;
  bool _isNewPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Update Password"),
      ),
      body: Center(
        child: Container(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                SizedBox(height: 100),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Set background color to transparent
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Update Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _oldPasswordController,
                        decoration: InputDecoration(
                          labelText: "Old Password",
                          fillColor: Colors.white, // Set background color to white
                          filled: true,
                          errorText: _isOldPasswordValid ? null : "Invalid password",
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            _isOldPasswordValid = value.length >= 8;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          labelText: "New Password",
                          fillColor: Colors.white, // Set background color to white
                          filled: true,
                          errorText: _isNewPasswordValid ? null : "Invalid password",
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            _isNewPasswordValid = value.length >= 8 && _isPasswordValid(value);
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          fillColor: Colors.white, // Set background color to white
                          filled: true,
                          errorText: _isConfirmPasswordValid ? null : "Passwords do not match",
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            _isConfirmPasswordValid = value == _newPasswordController.text;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _updatePassword();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Update Password",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updatePassword() async {
    try {
      final String newPassword = _newPasswordController.text;
      final String confirmPassword = _confirmPasswordController.text;

      User? user = _auth.currentUser;

      if (user != null) {
        final AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _oldPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);

        FirebaseAuth.instance.signOut();
        Navigator.pushNamed(context, "/login");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User not signed in"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Password update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password update failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _isPasswordValid(String value) {
    // Implement your password validation logic here
    // You can check for capital letters, small letters, digits, and special characters
    return true; // Return true if the password is valid, false otherwise
  }
}