import 'package:farmconnect/pages/Delivery/orderPlacedDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPlaced extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').where('orderStatus', isEqualTo: 'Placed').snapshots(),
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
              var order = snapshot.data!.docs[index].data() as Map<String, dynamic>; // Convert QueryDocumentSnapshot to Map<String, dynamic>
              var orderId = order['orderId'];
              var amount = order['amount'];
              var timestamp = order['timestamp'];
              var orderStatus = order['orderStatus'];

              return Card(
                color: Colors.grey[900], // Adjust the card color
                margin: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                child: ListTile(
                  title: Text(
                    'Order ID: $orderId',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount: $amount',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Order Date: ${timestamp.toDate()}',
                        style: TextStyle(color: Colors.white),
                      ), // Convert timestamp to DateTime
                      Text(
                        'Order Status: $orderStatus',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderPlacedDetails(orderDetails: order)), // Pass order details to OrderPlacedDetails page
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
