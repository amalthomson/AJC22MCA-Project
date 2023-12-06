import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BillsPage extends StatelessWidget {
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
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'Bills and Invoices',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
                color: Colors.grey[900],
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
                    ],
                  ),
                  onTap: () async {
                    await _showOrderDetailsDialog(context, paymentData, user.uid);
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

  Future<void> _showOrderDetailsDialog(BuildContext context, Map<String, dynamic> paymentData, String userUid) async {
    Map<String, dynamic>? userData = await _getUserData(userUid);

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
              SizedBox(height: 16),
              Text('Additional Details:', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildDetailRow('Payment Method:', paymentData['paymentMethod'] ?? 'RazorPay'),
              _buildDetailRow('Farm Name:', userData?['farmName'] ?? 'Homegrown Heaven'),
              _buildDetailRow('Phone:', userData?['phone'] ?? 'N/A'),
              _buildDetailRow('Street:', userData?['street'] ?? 'N/A'),
              _buildDetailRow('Town:', userData?['town'] ?? 'N/A'),
              _buildDetailRow('District:', userData?['district'] ?? 'N/A'),
              _buildDetailRow('State:', userData?['state'] ?? 'N/A'),
              _buildDetailRow('Pincode:', userData?['pincode'] ?? 'N/A'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _generateAndShowPDF(paymentData, userData);
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

  Future<Map<String, dynamic>?> _getUserData(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userSnapshot.data() as Map<String, dynamic>?;
  }

  Future<void> _generateAndShowPDF(Map<String, dynamic> paymentData, Map<String, dynamic>? userData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          _buildHeader(),
          pw.Header(
            level: 0,
            child: pw.Text('Order Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
          ),
          pw.SizedBox(height: 16),
          _buildCustomerInfo(paymentData),
          pw.SizedBox(height: 16),
          _buildProductTable(paymentData['products']),
          _buildTotalAmount(paymentData['amount']),
          _buildAdditionalDetails(paymentData, userData),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'bill_${paymentData['paymentId']}.pdf',
    );
  }

  pw.Widget _buildHeader() {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        children: [
          pw.Text('FarmConnect', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 36)),
          pw.Text('Invoice', style: pw.TextStyle(fontSize: 24)),
          pw.Text('****************************', style: pw.TextStyle(fontSize: 24)),
        ],
      ),
    );
  }

  pw.Widget _buildCustomerInfo(Map<String, dynamic> paymentData) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildDetailText('Name:', paymentData['customerName'], fontSize: 18, fontWeight: pw.FontWeight.bold),
              _buildDetailText('Email:', paymentData['customerEmail']),
              _buildDetailText('Phone:', paymentData['customerPhone']),
              _buildDetailText('Payment ID:', paymentData['paymentId']),
              _buildDetailText('Date:', _formatDate(paymentData['timestamp'])),
            ],
          ),
        ),
        pw.SizedBox(width: 16),
      ],
    );
  }

  pw.Widget _buildProductTable(List<dynamic>? products) {
    if (products == null || products.isEmpty) {
      return pw.Text('No products in the order.');
    }

    const tableHeaders = ['Product', 'Quantity', 'Total'];
    final List<List<String>> tableData = products.map((product) {
      return [
        product['productName'].toString(),
        product['quantity'].toString(),
        '${(product['totalPrice'] ?? 0.0).toStringAsFixed(2)}',
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: tableHeaders,
      data: tableData,
      border: pw.TableBorder.all(color: PdfColor.fromHex("#000000")),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
      cellStyle: const pw.TextStyle(color: PdfColors.black),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
      },
    );
  }

  pw.Widget _buildTotalAmount(double? amount) {
    if (amount == null) {
      return pw.SizedBox.shrink();
    }

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        _buildDetailText('Total Amount:', '${amount.toStringAsFixed(2)}', fontSize: 18, fontWeight: pw.FontWeight.bold),
      ],
    );
  }

  pw.Widget _buildAdditionalDetails(Map<String, dynamic> paymentData, Map<String, dynamic>? userData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 16),
        pw.Text('Additional Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        _buildDetailText('Phone:', userData?['phone'] ?? 'N/A'),
        _buildDetailText('Street:', userData?['street'] ?? 'N/A'),
        _buildDetailText('Town:', userData?['town'] ?? 'N/A'),
        _buildDetailText('District:', userData?['district'] ?? 'N/A'),
        _buildDetailText('State:', userData?['state'] ?? 'N/A'),
        _buildDetailText('Pincode:', userData?['pincode'] ?? 'N/A'),
      ],
    );
  }

  pw.Widget _buildDetailText(String label, String value, {double fontSize = 18, pw.FontWeight? fontWeight}) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: fontWeight, fontSize: fontSize)),
          pw.SizedBox(width: 8),
          pw.Text(value),
        ],
      ),
    );
  }
}
