import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/constants/colors.dart';
import 'package:flutter_firebase/constants/images.dart';
import 'package:flutter_firebase/constants/consts.dart';
import 'package:flutter_firebase/constants/strings.dart';
import 'package:flutter_firebase/constants/styles.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
              (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/icons/bg1.png',
            fit: BoxFit.cover, // Adjust the fit as needed
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60), // Adjust the radius as needed
                    border: Border.all(
                      color: Colors.white, // Set the border color to white
                      width: 4.0, // Adjust the border width as needed
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60), // Same radius as the container
                    child: Image.asset(
                      'assets/icons/app_logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Text with different styles for each line
                Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28, // Font size for "Welcome"
                  ),
                ),
                Text(
                  "FarmConnect",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 48, // Font size for "FarmConnect"
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
