import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/login_page.dart';

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

  late String email, phone, username, password, userrole = '', ftl = '';

  final dbRef = FirebaseDatabase.instance.ref().child('users');
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;

  bool _isCheckboxChecked = false; // Add this variable

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
            "ftl" : 'yes'
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
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "FarmConnect",
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
                    Text(
                      "Sign Up with FarmConnect",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          DropdownButtonFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: 'Sign Up as',
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
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black), // Change text color to black
                                  ),
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              if(!(value.isEmpty) && !RegExp(r"(^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$)")
                                  .hasMatch(value)){
                                return "Enter a valid Name";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _emailController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                return "Please enter a valid email";
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            height: 1,
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          // Use a custom CheckboxListTile
                          ListTile(
                            title: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/terms');
                              },
                              child: Text(
                                "I agree to terms and conditions",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            leading: Checkbox(
                              value: _isCheckboxChecked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _isCheckboxChecked = newValue!;
                                });
                              },
                              activeColor: Colors.blue, // Color of the checkbox when checked
                              checkColor: Colors.white, // Color of the checkmark
                              fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                // Change the border color when not checked
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.blue;
                                }
                                return Colors.white; // Color of the checkbox border when not checked
                              }),
                            ),
                            tileColor: Colors.transparent, // Color of the checkbox box
                          ),

                          SizedBox(
                            height: 1,
                          ),
                          // Wrap the Sign Up button with GestureDetector
                          GestureDetector(
                            onTap: _isCheckboxChecked ? register : null, // Check the checkbox state
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: _isCheckboxChecked ? Colors.blue : Colors.grey, // Change button color when checkbox is unchecked
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white, // Change text color to white
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
                              Text(
                                "Already have an account?",
                                style: TextStyle(color: Colors.white),
                              ),
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
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                ),
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
    final hasNoSpace = !password.contains(' ');
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password); // At least one uppercase letter
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password); // At least one lowercase letter
    return password.length >= minLength &&
        hasNumber &&
        hasSpecialChar &&
        hasNoSpace &&
        hasUpperCase &&
        hasLowerCase;
  }
}