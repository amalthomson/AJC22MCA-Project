import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Payments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text(
          'Payments',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('payments').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final currentUserID = FirebaseAuth.instance.currentUser?.uid;

          final filteredPayments = snapshot.data!.docs.where((payment) {
            final products = payment['products'] as List<dynamic>;
            final product = products.firstWhere((element) => element['farmerId'] == currentUserID, orElse: () => null);
            return product != null;
          }).toList();

          if (filteredPayments.isEmpty) {
            return Center(
              child: Text('No payments available.', style: TextStyle(color: Colors.white)),
            );
          }

          return ListView.builder(
            itemCount: filteredPayments.length,
            itemBuilder: (context, index) {
              var payment = filteredPayments[index];
              var paymentId = payment['paymentId'];
              var paymentDate = payment['timestamp'].toDate();
              var paymentAmount = payment['amount'];
              var customerName = payment['customerName'];
              var customerEmail = payment['customerEmail'];

              return PaymentListItem(
                paymentId: paymentId,
                paymentDate: paymentDate,
                paymentAmount: paymentAmount,
                customerName: customerName,
                customerEmail: customerEmail,
              );
            },
          );
        },
      ),
    );
  }
}

class PaymentListItem extends StatelessWidget {
  final String paymentId;
  final DateTime paymentDate;
  final double paymentAmount;
  final String customerName;
  final String customerEmail;

  const PaymentListItem({
    required this.paymentId,
    required this.paymentDate,
    required this.paymentAmount,
    required this.customerName,
    required this.customerEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      color: Colors.grey[900],
      child: ListTile(
        leading: Icon(
          Icons.payment,
          color: Colors.white,
        ),
        title: Text(
          'Payment ID: $paymentId',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(paymentDate)}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Customer Name: $customerName',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Customer Email: $customerEmail',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Amount Received: ₹$paymentAmount',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
