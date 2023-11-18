import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PaymentSuccessfulPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Text(
            'Error: User not logged in',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Payments Received'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading bills: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          var paymentDocs = snapshot.data?.docs;

          if (paymentDocs == null || paymentDocs.isEmpty) {
            return Center(
              child: Text(
                'No bills available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: paymentDocs.length,
            itemBuilder: (context, index) {
              var paymentData = paymentDocs[index].data() as Map<String,
                  dynamic>;

              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: Colors.grey[900],
                child: ListTile(
                  leading: Icon(
                    Icons.money,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Amount: ₹${paymentData['amount']?.toStringAsFixed(2) ?? 'N/A'}',
                    style: TextStyle(fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: ${paymentData['paymentId']}',
                        style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'Date: ${_formatDate(paymentData['timestamp'])}',
                        style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  onTap: () async {
                    await _showOrderDetailsDialog(
                        context, paymentData, user.uid);
                  },
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }

  String _formatDate(Timestamp timestamp) {
    return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
  }

  Future<void> _showOrderDetailsDialog(BuildContext context,
      Map<String, dynamic> paymentData, String userUid) async {
    Map<String, dynamic>? userData = await _getUserData(userUid);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Order Details', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Payment ID:', paymentData['paymentId']),
              _buildDetailRow('Amount:',
                  '₹${paymentData['amount']?.toStringAsFixed(2) ?? 'N/A'}'),
              _buildDetailRow('Date:', _formatDate(paymentData['timestamp'])),
              _buildDetailRow('Name:', paymentData['customerName']),
              _buildDetailRow('Email:', paymentData['customerEmail']),
              _buildDetailRow('Phone:', paymentData['customerPhone']),
              SizedBox(height: 16),
              Text('Products:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._buildProductList(paymentData['products']),
              SizedBox(height: 16),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  List<Widget> _buildProductList(List<dynamic>? products) {
    if (products == null || products.isEmpty) {
      return [Text('No products in the order.')];
    }

    return products.map<Widget>((product) {
      return Text(
        '- ${product['productName']} x${product['quantity']} ₹${product['totalPrice']
            ?.toStringAsFixed(2) ?? 'N/A'}',
      );
    }).toList();
  }

  Future<Map<String, dynamic>?> _getUserData(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection(
        'users').doc(userId).get();
    return userSnapshot.data() as Map<String, dynamic>?;
  }

}