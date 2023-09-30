import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/login_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  late String email, phone, username, password, userrole = '';

  final dbRef = FirebaseDatabase.instance.ref().child('users');
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;

  void register() async {
    // Get the values from the text fields
    email = _emailController.text;
    username = _usernameController.text;
    phone = _phoneController.text;
    password = _passwordController.text;

    try {
      final newUser = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (newUser != null) {
        // Store user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(newUser.user?.uid).set(
          {
            "email": newUser.user?.email,
            "name": username,
            "phone": phone,
            "role": userrole,
          },
        );

        // Navigate to the login page after successful registration
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      }
    } catch (e) {
      print(e);
      SnackBar(
        content: Text("Username Already exists"),
        backgroundColor: Colors.teal,
      );
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "   FarmConnect",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Sign Up as',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0),
                                borderSide: BorderSide(),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Select One";
                              }
                            },
                            value: userrole.isNotEmpty ? userrole : null,
                            items: <String>['Buyer', 'Farmer'].map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              setState(() {
                                userrole = value.toString();
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              labelText: 'Name',
                              hintText: 'Enter your Name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              if (!RegExp(r'^[a-zA-Z\s\-\’]+$').hasMatch(value)) {
                                return ("Please enter a valid name");
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              labelText: 'Email',
                              hintText: 'Enter your email',
                            ),
                            validator: (value) {
                              if (value!.length == 0) {
                                return "Email cannot be empty";
                              }
                              if (!RegExp(
                                r"^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$",
                              ).hasMatch(value)) {
                                return ("Please enter a valid email");
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              labelText: 'Phone Number',
                              hintText: 'Enter your Phone Number',
                            ),
                            validator: (val) {
                              if (val!.length == 0) {
                                return "Phone Number cannot be empty";
                              }
                              if (!(val.isEmpty) && !RegExp(r"^[0-9]{10}$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              labelText: 'Password',
                              hintText: 'Enter your Password',
                            ),
                            validator: (value) {
                              if (!_isValidPassword(value!)) {
                                return 'Password must be at least 8 characters with at least one number and a special character.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              labelText: 'Confirm Password',
                              hintText: 'Reenter Password',
                            ),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: register,
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                              Text("Already have an account?", style: TextStyle(color: Colors.white)),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                        (route) => false,
                                  );
                                },
                                child: Text("Login", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidPassword(String password) {
    final minLength = 8;
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return password.length >= minLength && hasNumber && hasSpecialChar;
  }
}
