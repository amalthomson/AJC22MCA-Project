import 'package:farmconnect/pages/Admin/monthlysales.dart';
import 'package:farmconnect/pages/Admin/paymentsReport.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String? _selectedReport;

  final List<String> _reportNames = ['Sales', 'Payments']; // Add more report names as needed

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
                Icons.get_app,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8,),
            Text(
              "Download Reports",
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton<String>(
                hint: Text(
                  'Select a report',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                value: _selectedReport,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedReport = newValue;
                  });
                },
                items: _reportNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white, fontSize: 18)),
                  );
                }).toList(),
                dropdownColor: Colors.blueGrey[800],
                elevation: 8,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_selectedReport != null) {
                    if (_selectedReport == 'Sales') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MonthlySalesDataFetcher(),
                        ),
                      );
                    } else if (_selectedReport == 'Payments') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MonthlyPaymentsDataFetcher(),
                        ),
                      );
                    }
                  }
                },
                child: Text('Generate Report', style: TextStyle(color: Colors.white, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
