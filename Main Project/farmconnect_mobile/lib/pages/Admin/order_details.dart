import 'package:farmconnect/pages/Buyer/add_reviews_ratings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrderDetails extends StatelessWidget {
  final String orderId;

  AdminOrderDetails(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 50.0),
              child: Icon(
                Icons.history,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8,),
            Text(
              "Order Details",
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
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('orders').doc(orderId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Order not found.', style: TextStyle(color: Colors.white)));
          }

          var order = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: _buildSectionTitle('Order ID'),
                  subtitle: _buildSectionContent(order['orderId']),
                ),
                ListTile(
                  title: _buildSectionTitle('Amount'),
                  subtitle: _buildSectionContent('₹${order['amount']}'),
                ),
                Divider(height: 20, color: Colors.grey),
                _buildSectionTitle('Products'),
                order['products'] != null
                    ? Column(
                  children: [
                    for (var product in order['products']) ...[
                      _buildProductDetails(context, product), // Pass the context here
                      SizedBox(height: 10),
                    ],
                  ],
                )
                    : _buildSectionContent('No products in this order.'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  Widget _buildProductDetails(BuildContext context, Map<String, dynamic> product) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      color: Colors.blueGrey[900],
      child: Row(
        children: [
          // Left part: Product Image
          product['productImage'] != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              product['productImage'],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          )
              : SizedBox.shrink(),

          // Middle part: Product Details
          Expanded(
            child: ListTile(
              title: Text(
                product['productName'],
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quantity: ${product['quantity']}', style: TextStyle(color: Colors.white)),
                  Text('Unit Price: ₹${product['unitPrice']}', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
