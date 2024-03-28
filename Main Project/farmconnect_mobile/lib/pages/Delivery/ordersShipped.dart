import 'package:farmconnect/pages/BuyerPages/OrderHistory.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderShipped extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').where('orderStatus', isEqualTo: 'Shipped').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No placed orders available.', style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var order = snapshot.data!.docs[index];
              var orderId = order['orderId'];
              var orderDate = order['timestamp'].toDate();
              var orderAmount = order['amount'];

              return OrderListItem(
                orderId: orderId,
                orderDate: orderDate,
                orderAmount: orderAmount,
                onTap: () {
                  // Navigate to order details page
                },
              );
            },
          );
        },
      ),
    );
  }
}
