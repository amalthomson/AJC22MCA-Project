import 'package:farmconnect/pages/Admin/order_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
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
              "Order History",
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
              var orderStatus = order['orderStatus'];

              return OrderListItem(
                orderId: orderId,
                orderDate: orderDate,
                orderAmount: orderAmount,
                orderStatus: orderStatus,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminOrderDetails(orderId),
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
  final String orderStatus;
  final VoidCallback onTap;

  const OrderListItem({
    required this.orderId,
    required this.orderDate,
    required this.orderAmount,
    required this.orderStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      color: Colors.grey[900], // Set your desired card color
      child: ListTile(
        leading: Icon(Icons.shopping_bag, color: Colors.white), // Add an icon to the left of the list tile
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
            Text(
              'Order Status: $orderStatus',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
