import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdatePasswordPage extends StatefulWidget {
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isOldPasswordValid = true;
  bool _isNewPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
                    color: Colors.transparent,
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
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 50),
                      TextFormField(
                        controller: _oldPasswordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Enter Old Password',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9), // Match the background color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50), // Match the border radius
                            borderSide: BorderSide(color: Colors.blue), // Match the border color
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue, // Blue icon color
                          ),
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
                          hintText: 'Enter New Password',
                          fillColor: Colors.white,
                          filled: true,
                          errorText: _isNewPasswordValid ? null : "Invalid password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            _isNewPasswordValid = _isPasswordValid(value);
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          hintText: "Confirm New Password",
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue, // Icon color
                          ),
                          errorText: _isConfirmPasswordValid
                              ? null
                              : "Passwords do not match",
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            _isConfirmPasswordValid =
                                value == _newPasswordController.text;
                          });
                        },
                      ),
                      SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _updatePassword();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Change the button color
                          onPrimary: Colors.white, // Change the text color
                          elevation: 5, // Add elevation
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50), // Change the button shape
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          child: Text(
                            "Update Password",
                            style: TextStyle(fontSize: 18),
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

        try {
          // Attempt to reauthenticate the user with the old password
          await user.reauthenticateWithCredential(credential);
        } catch (reauthError) {
          // Handle reauthentication error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Old Password Incorrect"),
              backgroundColor: Colors.red,
            ),
          );
          return; // Exit early if reauthentication fails
        }

        if (_oldPasswordController.text == _newPasswordController.text) {
          // Display an error message if old and new passwords are the same
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Old and new passwords are the same"),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          // Reauthentication successful and passwords are different,
          // so now update the password
          await user.updatePassword(newPassword);
          await FirebaseAuth.instance.signOut();
          //Navigator.pushNamed(context, "/login");
          Navigator.pushReplacementNamed(context, "/login");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Password updated successfully"),
              backgroundColor: Colors.green,
            ),
          );
        }
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
    // Define the regular expression pattern for password validation
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}\[\]:;<>,.?~\\-])\S{8,}$',
    );

    return passwordRegExp.hasMatch(value);
  }
}
