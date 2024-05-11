import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class MonthlySalesReportPage extends StatelessWidget {
  final List<Map<String, dynamic>> salesData;

  MonthlySalesReportPage({required this.salesData});

  Future<void> _saveAsPDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'FarmConnect',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.green),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Monthly Sales Report',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                border: pw.TableBorder.all(color: PdfColors.grey),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                headerHeight: 40,
                cellHeight: 60,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.center,
                  2: pw.Alignment.center,
                },
                cellStyle: pw.TextStyle(fontSize: 14, color: PdfColors.black),
                data: <List<String>>[
                  <String>['Product Name', 'Quantity', 'Total Price'],
                  ...salesData.map(
                        (sale) => [
                      sale['productName'],
                      sale['quantity'].toString(),
                      '\₹${sale['totalPrice'].toStringAsFixed(2)}'
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final output = await getDownloadsDirectory();
    final file = File("${output!.path}/monthly_sales_report.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF saved to ${file.path}'),
      ),
    );
  }

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
              padding: EdgeInsets.only(left: 30.0),
              child: Icon(
                Icons.store,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8,),
            Text(
              "Product Approvals",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true, // Center the title horizontally
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
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            color: Colors.greenAccent,
            onPressed: () => _saveAsPDF(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DataTable(
              headingRowHeight: 40,
              dataRowHeight: 60,
              columnSpacing: 16,
              columns: [
                DataColumn(
                  label: Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                DataColumn(
                  label: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                DataColumn(
                  label: Text('Total Price', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
              rows: salesData.asMap().entries.map((entry) {
                final index = entry.key;
                final sale = entry.value;
                final color = index.isOdd ? Colors.grey[800]! : Colors.blueGrey[900]!;
                return DataRow(
                  color: MaterialStateProperty.all(color),
                  cells: [
                    DataCell(Text(sale['productName'], style: TextStyle(color: Colors.white))),
                    DataCell(Text(sale['quantity'].toString(), style: TextStyle(color: Colors.white))),
                    DataCell(Text('\₹${sale['totalPrice'].toStringAsFixed(2)}', style: TextStyle(color: Colors.white))),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class MonthlySalesDataFetcher extends StatefulWidget {
  @override
  _MonthlySalesDataFetcherState createState() => _MonthlySalesDataFetcherState();
}

class _MonthlySalesDataFetcherState extends State<MonthlySalesDataFetcher> {
  List<Map<String, dynamic>> _monthlySalesData = [];

  Future<void> _fetchMonthlySalesData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('orders').get();

      List<Map<String, dynamic>> salesData = [];
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        // Assuming each document in the 'orders' collection has a 'products' field containing a list of products
        List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(data['products']);
        for (var product in products) {
          salesData.add({
            'productName': product['productName'],
            'quantity': product['quantity'],
            'totalPrice': product['totalPrice'],
          });
        }
      }

      setState(() {
        _monthlySalesData = salesData;
      });
    } catch (e) {
      print("Error fetching monthly sales data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMonthlySalesData();
  }

  @override
  Widget build(BuildContext context) {
    return MonthlySalesReportPage(salesData: _monthlySalesData);
  }
}
