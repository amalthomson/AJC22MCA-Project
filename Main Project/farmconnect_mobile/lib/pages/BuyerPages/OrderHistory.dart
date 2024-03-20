import 'package:farmconnect/pages/BuyerPages/OrderDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrdersHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders available.', style: TextStyle(color: Colors.white)));
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetails(orderId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class OrderListItem extends StatelessWidget {
  final String orderId;
  final DateTime orderDate;
  final double orderAmount;
  final VoidCallback onTap;

  const OrderListItem({
    required this.orderId,
    required this.orderDate,
    required this.orderAmount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      color: Colors.grey[900], // Set your desired card color
      child: ListTile(
        title: Text(
          'Order ID: $orderId',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(orderDate)}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Price: ₹$orderAmount',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
