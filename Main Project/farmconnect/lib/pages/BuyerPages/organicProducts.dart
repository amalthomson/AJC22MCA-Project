import 'package:flutter/material.dart';

class OrganicProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organic Products'),
      ),
      body: Center(
        child: Text(
          'This is the Organic Products Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
