import 'package:flutter/material.dart';
import 'package:farmconnect/features/user_auth/presentation/pages/common/colors.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'Terms and Conditions',
          style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Set the back button color to white
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                "Terms and Conditions",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Change the title color
                ),
              ),
              SizedBox(height: 30),
              StyledTerms(
                number: "1",
                text:
                "By using the FarmConnect platform, you agree to comply with all applicable laws and regulations.",
              ),
              StyledTerms(
                number: "2",
                text:
                "You must provide accurate and up-to-date information when registering and using our services.",
              ),
              StyledTerms(
                number: "3",
                text:
                "Users engaging in fraudulent activities will be permanently banned from FarmConnect.",
              ),
              StyledTerms(
                number: "4",
                text:
                "We may update our terms and conditions from time to time, and it's your responsibility to review them regularly.",
              ),
              StyledTerms(
                number: "5",
                text:
                "Any disputes arising from the use of FarmConnect will be resolved through arbitration.",
              ),
              StyledTerms(
                number: "6", // Add the new point number
                text:
                "Only users who are Buyers can register with the 'Sign In with Google' option.",
              ),
              // Add more styled terms and conditions as needed
            ],
          ),
        ),
      ),
    );
  }
}

class StyledTerms extends StatelessWidget {
  final String number;
  final String text;

  StyledTerms({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green, // Change the number color
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
