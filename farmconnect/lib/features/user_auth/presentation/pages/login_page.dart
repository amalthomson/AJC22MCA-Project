

import 'package:farmconnect/features/user_auth/presentation/pages/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:farmconnect/features/user_auth/presentation/widgets/form_container_widget.dart';
import '../../firebase_auth_implementation/firebase_auth_services.dart';

class EmailFieldValidator {
  static String? validate(String value) {
    if (value!.length == 0) {
      return "Email cannot be empty";
    }
    if (!RegExp(
        r"^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$")
        .hasMatch(value)) {
      return "Please enter a valid email";
    } else {
      return null;
    }
  }
}

class PasswordFieldValidator {
  static String? validate(String value) {
    RegExp regex = new RegExp(r'^.{6,}$');
    if (value!.isEmpty) {
      return "Password cannot be empty";
    }
    if (!regex.hasMatch(value)) {
      return "Please enter a valid password (min. 6 characters)";
    } else {
      return null;
    }
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FarmConnect"),
      ),
      body: Center(
        child: Stack(
          children: [
            // Background Image
            Image.asset(
              'assets/icons/bgImage.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login to FarmConnect",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FormContainerWidget(
                      controller: _emailController,
                      hintText: "Email",
                      isPasswordField: false,
                      validator: (value) =>
                          EmailFieldValidator.validate(value!),
                      onSaved: (value) {
                        _emailController.text = value!;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormContainerWidget(
                      controller: _passwordController,
                      hintText: "Password",
                      isPasswordField: true,
                      validator: (value) =>
                          PasswordFieldValidator.validate(value!),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()),
                                  (route) => false);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: _signIn,
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("New to FarmConnect?",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                                    (route) => false);
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        User? user = await _auth.signInWithEmailAndPassword(email, password);

        if (user != null) {
          print("User is successfully signed in");
          Navigator.pushNamed(context, "/home");
        } else {
          // Show an error message if login fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Invalid Username or Password"),
              backgroundColor: Colors.red,
            ),
          );
          print("Some error happened");
        }
      } catch (e) {
        // Handle other exceptions (e.g., network issues, etc.) here
        print("Error: $e");
      }
    }
  }
}
