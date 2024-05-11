import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class MonthlyPaymentsReportPage extends StatelessWidget {
  final List<Map<String, dynamic>> paymentsData;

  MonthlyPaymentsReportPage({required this.paymentsData});

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
                'Monthly Payments Report',
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
                },
                cellStyle: pw.TextStyle(fontSize: 14, color: PdfColors.black),
                data: <List<String>>[
                  <String>['Customer Name', 'Amount'],
                  ...paymentsData.map(
                        (payment) => [
                      payment['customerName'],
                      '\₹${payment['amount'].toStringAsFixed(2)}'
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
    final file = File("${output!.path}/monthly_payments_report.pdf");
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
                Icons.monetization_on,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8,),
            Text(
              "Monthly Payments",
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
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [Colors.blueGrey[800]!, Colors.blueGrey[900]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: DataTable(
              headingRowHeight: 40,
              dataRowHeight: 60,
              columnSpacing: 16,
              columns: [
                DataColumn(
                  label: Text('Customer Name', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                DataColumn(
                  label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
              rows: paymentsData.asMap().entries.map((entry) {
                final index = entry.key;
                final payment = entry.value;
                final color = index.isOdd ? Colors.grey[800]! : Colors.blueGrey[900]!;
                return DataRow(
                  color: MaterialStateProperty.all(color),
                  cells: [
                    DataCell(Text(payment['customerName'], style: TextStyle(color: Colors.white))),
                    DataCell(Text('\₹${payment['amount'].toStringAsFixed(2)}', style: TextStyle(color: Colors.white))),
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

class MonthlyPaymentsDataFetcher extends StatefulWidget {
  @override
  _MonthlyPaymentsDataFetcherState createState() => _MonthlyPaymentsDataFetcherState();
}

class _MonthlyPaymentsDataFetcherState extends State<MonthlyPaymentsDataFetcher> {
  List<Map<String, dynamic>> _monthlyPaymentsData = [];

  Future<void> _fetchMonthlyPaymentsData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('payments').get();

      List<Map<String, dynamic>> paymentsData = [];
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        paymentsData.add({
          'customerName': data['customerName'],
          'amount': data['amount'],
        });
      }

      setState(() {
        _monthlyPaymentsData = paymentsData;
      });
    } catch (e) {
      print("Error fetching monthly payments data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMonthlyPaymentsData();
  }

  @override
  Widget build(BuildContext context) {
    return MonthlyPaymentsReportPage(paymentsData: _monthlyPaymentsData);
  }
}
