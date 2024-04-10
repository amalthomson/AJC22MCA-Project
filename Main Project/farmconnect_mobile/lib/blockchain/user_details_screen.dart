import 'package:farmconnect/blockchain/user.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final User user;

  UserDetailsScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 65.0),
              child: Icon(
                Icons.security,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8,),
            Text(
              "User Details",
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
      ),
      backgroundColor: Colors.blueGrey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          color: Colors.blueGrey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.lock, color: Colors.white),
                  title: Text(
                    'FarmConnect ID',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    '${user.fuid}',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                Divider(color: Colors.grey),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.white),
                  title: Text(
                    'Name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    '${user.name}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Divider(color: Colors.grey),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text(
                    'Farm Name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    '${user.farmname}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Divider(color: Colors.grey),
                ListTile(
                  leading: Icon(Icons.email, color: Colors.white),
                  title: Text(
                    'Email',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    '${user.email}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Divider(color: Colors.grey),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.white),
                  title: Text(
                    'Phone',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    '${user.phone}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Divider(color: Colors.grey),
                ListTile(
                  leading: Icon(Icons.credit_card, color: Colors.white),
                  title: Text(
                    'Aadhar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    '${user.aadhar}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Divider(color: Colors.grey),
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.white),
                  title: Text(
                    'Address',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    '${user.address}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Divider(color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Back',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
