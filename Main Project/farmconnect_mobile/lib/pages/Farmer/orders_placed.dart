import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmconnect/pages/Farmer/order_placed_detail.dart';

class OrdersPlace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text(
          'Orders Place',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey[900],
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No orders available.', style: TextStyle(color: Colors.white)),
            );
          }

          final currentUserID = FirebaseAuth.instance.currentUser?.uid;

          final filteredOrders = snapshot.data!.docs.where((order) {
            final products = order['products'] as List<dynamic>;
            final product = products.firstWhere((element) => element['farmerId'] == currentUserID, orElse: () => null);
            return product != null;
          }).toList();

          if (filteredOrders.isEmpty) {
            return Center(
              child: Text('No orders available.', style: TextStyle(color: Colors.white)),
            );
          }

          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              var order = filteredOrders[index];
              var orderId = order['orderId'];
              var orderDate = order['timestamp'].toDate();
              var orderAmount = order['amount'];
              var orderStatus = order['orderStatus'];
              var products = order['products'] as List<dynamic>;
              var product = products.firstWhere((element) => element['farmerId'] == currentUserID, orElse: () => null);
              var farmerId = product != null ? product['farmerId'] : '';

              return OrderListItem(
                orderId: orderId,
                orderDate: orderDate,
                orderAmount: orderAmount,
                farmerId: farmerId,
                orderStatus: orderStatus,
                products: products,
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
  final String farmerId;
  final String orderStatus;
  final List<dynamic> products;

  const OrderListItem({
    required this.orderId,
    required this.orderDate,
    required this.orderAmount,
    required this.farmerId,
    required this.orderStatus,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderPlacedDetail(
              orderId: orderId,
              orderDate: orderDate,
              orderAmount: orderAmount,
              farmerId: farmerId,
              orderStatus: orderStatus,
              products: products,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(8),
        color: Colors.grey[900],
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID: $orderId',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Status: $orderStatus',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Date: ${DateFormat('yyyy-MM-dd').format(orderDate)}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'Price: ₹$orderAmount',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
