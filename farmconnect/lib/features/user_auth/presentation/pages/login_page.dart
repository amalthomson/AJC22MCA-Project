import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/home_google.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/BuyerPages/update_profile.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/colors.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../firebase_auth_implementation/firebase_auth_services.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/loading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'sign_up_page.dart'; // Import your SignUpPage
import 'email_verification_pending_page.dart'; // Import the EmailVerificationPendingPage

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
  GoogleSignInAccount? _googleUser;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in process
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Check if the user is signing in for the first time
        final DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final bool isFirstTimeSignIn = userSnapshot.data() == null;

        if (isFirstTimeSignIn) {
          // Set "isActive" to "yes" for a new user
          await _updateUserInformation(user, googleUser, isActive: "yes");
        }

        // Check if the user is active before allowing login
        if (userSnapshot.exists && userSnapshot['isActive'] == 'yes') {
          // Store the signed-in Google account
          setState(() {
            _googleUser = googleUser;
          });

          // Navigate to the Home Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GoogleHomePage(),
            ),
          );
        } else {
          // User is not active, show an error message or block login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Your account is not active. Please contact support."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Google Sign-In failed. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error occurred during Google Sign-In: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateUserInformation(User user, GoogleSignInAccount? googleUser,
      {String isActive = "yes"}) async {
    final DocumentReference userDocRef =
    FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Retrieve additional user details from GoogleSignInAccount (if available)
    String displayName = user.displayName ?? '';
    String email = user.email ?? '';
    String photoUrl = user.photoURL ?? '';

    // Update user information in Firestore
    await userDocRef.set({
      'uid': user.uid,
      'email': email,
      'name': displayName,
      'profileImageUrl': photoUrl, // Save profile picture URL
      'role': "Buyer",
      'isActive': isActive, // Add the isActive field
      // Add more user details as needed
    }, SetOptions(merge: true)); // Use merge to update only specific fields
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          "Login to FarmConnect",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 11.0), // Adjust the top padding as needed
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 99,
                            ),
                            Text(
                              "Login to FarmConnect",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _emailController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                hintText: 'Email',
                                prefixIcon: Container(
                                  padding: EdgeInsets.all(12.0),
                                  child: Icon(
                                    Icons.email,
                                    color: Colors.blue, // Set the icon color to blue
                                  ),
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
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              obscureText: true,
                              validator: (value) =>
                                  PasswordFieldValidator.validate(value!),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                hintText: 'Enter your Password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blue, // Set the icon color to blue
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
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassword(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () => signIn(scaffoldContext),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18, // Adjust the font size as needed
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
                                Text("New to FarmConnect?",
                                    style: TextStyle(fontSize: 16,
                                        color: Colors.white)),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignUpPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(fontSize: 16,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _signInWithGoogle(context),
                              icon: Image.asset(
                                'assets/google_logo.png', // Replace with the path to your Google logo image
                                height: 24, // Adjust the height as needed
                                width: 24,  // Adjust the width as needed
                              ),
                              label: Text("Sign In with Google"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white, // Button background color
                                onPrimary: Colors.blue, // Text color
                                elevation: 3, // Add elevation for a raised effect
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0), // Adjust border radius as needed
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Adjust padding as needed
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

          if (snap.exists) {
            String isActive = snap['isActive'];
            bool isEmailVerified = user?.emailVerified ?? false;
            String isAdminApproved = snap['isAdminApproved'];

            if (isEmailVerified) {
              if (isActive == 'yes') {
                setState(() {
                  role = snap['role'];
                  ftl = snap['ftl'];
                });

                if (ftl == 'no') {
                  if (role == 'Buyer') {
                    Navigator.pushNamed(context, "/buyer_home");
                  } else if (role == 'Admin') {
                    Navigator.pushNamed(context, "/admin_dashboard");
                  } else if (role == 'Farmer') {
                    if (isAdminApproved == 'yes') {
                      Navigator.pushNamed(context, "/farmer_dash");
                    } else {
                      Navigator.pushNamed(context, '/admin_approval_pending');
                    }
                  }
                } else if (ftl == 'yes') {
                  if (role == 'Farmer') {
                    Navigator.pushNamed(context, "/farmer_ftl");
                  } else if (role == 'Buyer') {
                    Navigator.pushNamed(context, "/buyer_ftl");
                  }
                } else {
                  loading = false;
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(
                      content: Text("You don't have authorization to Login"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                // Email is not verified
                loading = false;
                ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                  SnackBar(
                    content: Text("Email not Verified"),
                    backgroundColor: Colors.red,
                  ),
                );
                await FirebaseAuth.instance.signOut(); // Sign out the user
              }
            }
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
