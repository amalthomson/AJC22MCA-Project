import 'package:farmconnect/pages/Common/sign_up_page.dart';
import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
          },
        ),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30.0), // Adjust the padding as needed
              child: Icon(
                Icons.rule,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Text(
              "Terms & Conditions",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.blueGrey[900]!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: 5.0,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              TermsCard(
                text:
                "By using the FarmConnect platform, you agree to comply with all applicable laws and regulations.",
              ),
              TermsCard(
                text:
                "You must provide accurate and up-to-date information when registering and using our services.",
              ),
              TermsCard(
                text:
                "Users engaging in fraudulent activities will be permanently banned from FarmConnect.",
              ),
              TermsCard(
                text:
                "We may update our terms and conditions from time to time, and it's your responsibility to review them regularly.",
              ),
              TermsCard(
                text:
                "Any disputes arising from the use of FarmConnect will be resolved through arbitration.",
              ),
              TermsCard(
                text:
                "Only users who are Buyers can register with the 'Sign In with Google' option.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TermsCard extends StatelessWidget {
  final String text;

  TermsCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
