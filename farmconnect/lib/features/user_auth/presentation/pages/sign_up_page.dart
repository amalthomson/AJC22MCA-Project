import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool _isObscure = true;
  bool _isObscureConfirmPassword = true;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  late String email, phone, username, password, userrole = '', ftl = '', isActive = '', isAdminApproved = '';

  final dbRef = FirebaseDatabase.instance.ref().child('users');
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;

  bool _isCheckboxChecked = false; // Add this variable

  void register() async {
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
        final userUid = newUser.user?.uid;
        await newUser.user!.sendEmailVerification();
        await FirebaseFirestore.instance.collection('users').doc(newUser.user?.uid).set(
          {
            "uid": userUid,
            "email": newUser.user?.email,
            "name": username,
            "phone": phone,
            "role": userrole,
            "ftl" : 'yes',
            "isActive": 'yes',
            "isAdminApproved": "no"
          },
        );
        Navigator.pushNamed(context, '/email_verification_pending');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email already registered or invalid, verify the fields or try again later"),
          backgroundColor: Colors.red,
        ),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          "Sign Up with FarmConnect",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return Container(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 88,
                        ),
                        Text(
                          "Registration",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 25,
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
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  prefixIcon: Icon(Icons.person, color: Colors.blue),
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
                                        style: TextStyle(color: Colors.black),
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
                                height: 10,
                              ),
                              TextFormField(
                                controller: _usernameController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.9),
                                  hintText: 'Enter your Name',
                                  prefixIcon: Icon(Icons.person, color: Colors.blue),
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
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name is required';
                                  }
                                  if (!(value.isEmpty) &&
                                      !RegExp(r"(^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$)")
                                          .hasMatch(value)) {
                                    return "Enter a valid Name";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _emailController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.9),
                                  hintText: 'Enter your email',
                                  prefixIcon: Icon(Icons.email, color: Colors.blue),
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
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email cannot be empty';
                                  }
                                  if (!RegExp(
                                      r"^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$")
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _phoneController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.9),
                                  hintText: 'Enter your Phone Number',
                                  prefixIcon: Icon(Icons.phone, color: Colors.blue),
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
                                ),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Phone Number cannot be empty';
                                  }
                                  if (!RegExp(r"^[6789]\d{9}$").hasMatch(val)) {
                                    return 'Enter a valid 10-digit phone number starting with 6, 7, 8, or 9';
                                  }
                                  if (RegExp(r"^(\d)\1*$").hasMatch(val)) {
                                    return 'Avoid using all identical digits';
                                  }
                                  if (RegExp(r"0123456789|9876543210").hasMatch(val)) {
                                    return 'Avoid using sequential digits';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: _isObscure,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.9),
                                  hintText: 'Enter your Password',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.blue,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscure ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                  ),
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
                                ),
                                validator: (value) {
                                  if (!_isValidPassword(value!)) {
                                    return 'Password must be at least 8 characters with at least one number and a special character.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _confirmPasswordController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: _isObscureConfirmPassword,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.9),
                                  hintText: 'Reenter Password',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.blue,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscureConfirmPassword = !_isObscureConfirmPassword;
                                      });
                                    },
                                  ),
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
                              ListTile(
                                title: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/terms');
                                  },
                                  child: Text(
                                    'I agree to terms and conditions',
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
                                  activeColor: Colors.blue,
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return Colors.blue;
                                      }
                                      return Colors.white;
                                    },
                                  ),
                                ),
                                tileColor: Colors.transparent,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: _isCheckboxChecked ? register : null,
                                child: Container(
                                  width: double.infinity,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: _isCheckboxChecked ? Colors.blue : Colors.grey,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account?',
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
                                      'Login',
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
          );
        },
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
