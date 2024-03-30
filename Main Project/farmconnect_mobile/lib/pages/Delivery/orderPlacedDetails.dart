import 'package:farmconnect/pages/Delivery/deliveryDashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPlacedDetails extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  OrderPlacedDetails({required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2.0,
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${orderDetails['orderId']}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    _buildDivider(),
                    _buildDetailRow('Amount:', '\₹${orderDetails['amount']}'),
                    _buildDetailRow('Date:', '${orderDetails['timestamp'].toDate()}'),
                    _buildDetailRow('Name:', '${orderDetails['customerName']}'),
                    _buildDetailRow('Email:', '${orderDetails['customerEmail']}'),
                    _buildDetailRow('Phone:', '${orderDetails['customerPhone']}'),
                    _buildDivider(),
                    Text(
                      'Delivery Address:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    _buildAddressDetails(orderDetails),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: Text(
                'Items in this Order',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (orderDetails['products'] as List<dynamic>).map((product) {
                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: SizedBox(
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          product['productImage'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      product['productName'],
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${product['quantity']}', style: TextStyle(fontSize: 14.0)),
                        Text('Unit Price: \₹${product['unitPrice']}', style: TextStyle(fontSize: 14.0)),
                        Text('Total Price: \₹${product['totalPrice']}', style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _updateOrderStatus(context); // Call function to update order status
                },
                child: Text('Mark as Shipped'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateOrderStatus(BuildContext context) {
    // Update order status in Firestore
    FirebaseFirestore.instance
        .collection('orders')
        .doc(orderDetails['orderId'])
        .update({'orderStatus': 'Shipped'})
        .then((value) {
      print('Order status updated successfully');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DeliveryDashboard()),
            (route) => false, // Remove all routes from the stack
      );
    }).catchError((error) {
      print('Failed to update order status: $error');
    });
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Adjusted vertical padding
      child: Divider(
        color: Colors.grey[400],
        thickness: 1.0,
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Adjusted vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: title == 'Email:'
                ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                value,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                overflow: TextOverflow.clip,
              ),
            )
                : Text(
              value,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressDetails(Map<String, dynamic> orderDetails) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0), // Adjusted top padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${orderDetails['street']}, ${orderDetails['town']}, ${orderDetails['district']}, ${orderDetails['state']} - ${orderDetails['pincode']}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
