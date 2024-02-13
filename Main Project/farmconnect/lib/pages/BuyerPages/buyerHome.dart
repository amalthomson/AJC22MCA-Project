import 'package:farmconnect/pages/BuyerPages/productsNonOrganic.dart';
import 'package:farmconnect/pages/BuyerPages/productsOrganic.dart';
import 'package:flutter/material.dart';

class BuyerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buyer Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrganicProducts()),
                );
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/org.jpeg', // Replace with the actual image asset for Organic Products
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 8),
                  Text("Organic Products"),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NonOrganicProducts()),
                );
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/norg.jpeg', // Replace with the actual image asset for Non-Organic Products
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 8),
                  Text("Non-Organic Products"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
