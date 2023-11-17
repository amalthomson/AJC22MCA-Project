import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

class BillsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle the case when the user is not logged in
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
        title: Text('Bills & Invoice'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .where('userUid', isEqualTo: user.uid)
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
              var paymentData = paymentDocs[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: Colors.grey[900], // Dark background color
                child: ListTile(
                  leading: Icon(
                    Icons.receipt,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Amount: ₹${paymentData['amount']?.toStringAsFixed(2) ?? 'N/A'}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment ID: ${paymentData['paymentId']}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        'Date: ${_formatDate(paymentData['timestamp'])}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      // Add other bill details here
                    ],
                  ),
                  onTap: () {
                    _showOrderDetailsDialog(context, paymentData);
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

  void _showOrderDetailsDialog(BuildContext context, Map<String, dynamic> paymentData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Details', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Payment ID:', paymentData['paymentId']),
              _buildDetailRow('Amount:', '₹${paymentData['amount']?.toStringAsFixed(2) ?? 'N/A'}'),
              _buildDetailRow('Date:', _formatDate(paymentData['timestamp'])),
              _buildDetailRow('Name:', paymentData['customerName']),
              _buildDetailRow('Email:', paymentData['customerEmail']),
              _buildDetailRow('Phone:', paymentData['customerPhone']),
              SizedBox(height: 16),
              Text('Products:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._buildProductList(paymentData['products']),
              // Add other order details here
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _generateAndShowPDF(paymentData);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text('Download Bill', style: TextStyle(color: Colors.white)),
            ),
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
        '- ${product['productName']} x${product['quantity']} ₹${product['totalPrice']?.toStringAsFixed(2) ?? 'N/A'}',
      );
    }).toList();
  }

  Future<void> _generateAndShowPDF(Map<String, dynamic> paymentData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Header(
              level: 0,
              child: pw.Text('Order Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 16),
            // ... add content to the PDF
          ],
        ),
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'bill_${paymentData['paymentId']}.pdf',
    );
  }
}


