import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/colors.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../firebase_auth_implementation/firebase_auth_services.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/loading.dart';

class EmailFieldValidator {
  static String? validate(String value) {
    if (value.isEmpty) {
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
    if (value.isEmpty) {
      return "Password cannot be empty";
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
  bool loading = false;
  final dbRef = FirebaseDatabase.instance.ref().child('users');
  final fire = FirebaseFirestore.instance.collection('users');
  String role = 'Buyer';
  String ftl = 'yes';
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
    return loading
        ? Loading()
        : Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("FarmConnect"),
        automaticallyImplyLeading: false,
      ),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return Center(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: _formKey,
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
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
                        TextFormField(
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            hintText: 'Email',
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                              r"^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$",
                            ).hasMatch(value)) {
                              return "Please enter a valid email";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            labelText: 'Password',
                            hintText: 'Enter your Password',
                          ),
                          obscureText: true,
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
                                  builder: (context) =>
                                      ForgotPassword(),
                                ),
                                    (route) => false,
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () => signIn(scaffoldContext),
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
                                style: TextStyle(
                                    color: Colors.white)),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpPage(),
                                  ),
                                      (route) => false,
                                );
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
          );
        },
      ),
    );
  }

  void signIn(BuildContext scaffoldContext) async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      String email = _emailController.text;
      String password = _passwordController.text;
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential != null) {
          User? user = FirebaseAuth.instance.currentUser;
          final DocumentSnapshot snap = await FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .get();
          setState(() {
            role = snap['role'];
            ftl = snap['ftl'];
            // setState(() => loading = true);
          });
          if (ftl == 'no') {
            if (role == 'Buyer') {
              Navigator.pushNamed(context, "/buyer_home");
            } else if (role == 'Admin') {
              Navigator.pushNamed(context, "/admin_dashboard");
            } else if (role == 'Farmer') {
              Navigator.pushNamed(context, "/farmer_home");
            }
          } else if (ftl == 'yes') {
            if (role == 'Farmer') {
              Navigator.pushNamed(context, "/farmer_ftl");
            } else if (role == 'Buyer') {
              Navigator.pushNamed(context, "/buyer_ftl");
            }
          } else if (ftl == 'Verification Pending') {
            loading = false;
            ScaffoldMessenger.of(scaffoldContext).showSnackBar(
              SnackBar(
                content: Text("Verification not complete yet, please wait"),
                backgroundColor: Colors.red,
              ),
            );
          } else if (role == 'rej') {
            loading = false;
            ScaffoldMessenger.of(scaffoldContext).showSnackBar(
              SnackBar(
                content: Text("Your application has been rejected."),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            loading = false;
            ScaffoldMessenger.of(scaffoldContext).showSnackBar(
              SnackBar(
                content: Text("You don't have authorization to Login"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          loading = false;
        });
        if (e.code == 'user-not-found') {
          print("No user found with this email");
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            SnackBar(
              content: Text("No user found with this email: $e"),
              backgroundColor: Colors.red,
            ),
          );
        } else if (e.code == 'wrong-password') {
          print("You have entered the Wrong Password");
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            SnackBar(
              content: Text("You have entered the Wrong Password: $e"),
              backgroundColor: Colors.red,
            ),
          );
        } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          print("Invalid login credentials");
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            SnackBar(
              content: Text("Invalid login credentials"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
