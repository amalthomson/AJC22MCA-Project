import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class FarmerDetailsPage extends StatefulWidget {
  @override
  _FarmerDetailsPageState createState() => _FarmerDetailsPageState();
}

class _FarmerDetailsPageState extends State<FarmerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("Farmer Details", style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'Farmer').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final farmers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: farmers.length,
            itemBuilder: (context, index) {
              final farmer = farmers[index].data() as Map<String, dynamic>;
              final userId = farmers[index].id;

              final profilePictureUrl = farmer['profileImageUrl'] ?? '';
              var isActive = farmer['isActive'] ?? 'no';

              final tileColors = [
                Colors.purple,
                Colors.lightBlue,
                Colors.lightGreen,
                Colors.amber,
                Colors.pink,
              ];

              final tileColor = tileColors[index % tileColors.length];

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profilePictureUrl),
                      radius: 30,
                    ),
                    title: Text(
                      farmer['name'] ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    childrenPadding: EdgeInsets.all(16),
                    children: [
                      SingleChildScrollView(
                        child: _buildDetailItem(
                          icon: Icons.person,
                          label: "Gender",
                          value: farmer['gender'] ?? 'N/A',
                        ),
                      ),
                      SingleChildScrollView(
                        child: _buildDetailItem(
                          icon: Icons.email,
                          label: "Email",
                          value: farmer['email'] ?? 'N/A',
                        ),
                      ),
                      SingleChildScrollView(
                        child: _buildDetailItem(
                          icon: Icons.phone,
                          label: "Phone",
                          value: farmer['phone'] ?? 'N/A',
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildDetailItem(
                          icon: Icons.location_on,
                          label: "Address",
                          value: "${farmer['street'] ?? 'N/A'}, ${farmer['town'] ?? 'N/A'}, ${farmer['district'] ?? 'N/A'}, ${farmer['state'] ?? 'N/A'}, ${farmer['pincode'] ?? 'N/A'}",
                        ),
                      ),
                      SingleChildScrollView(
                        child: _buildDetailItem(
                          icon: Icons.agriculture,
                          label: "Farm Name",
                          value: farmer['farmName'] ?? 'N/A',
                        ),
                      ),
                      SingleChildScrollView(
                        child: _buildDetailItem(
                          icon: Icons.credit_card,
                          label: "Aadhaar",
                          value: farmer['aadhaar'] ?? 'N/A',
                        ),
                      ),
                      _buildDetailItem(
                        icon: Icons.image,
                        label: "ID Card Image",
                        value: '',
                        imageIdCardUrl: farmer['idCardImageUrl'],
                      ),
                    ],
                    trailing: Container(
                      width: 70,
                      height: 42,
                      child: Switch(
                        value: isActive == 'yes',
                        onChanged: (value) {
                          // Update the 'isActive' field in Firestore as a string
                          FirebaseFirestore.instance.collection('users').doc(userId).update({
                            'isActive': value ? 'yes' : 'no',
                          });
                          setState(() {
                            isActive = value ? 'yes' : 'no';
                          });

                          // Show a Snackbar
                          final snackBarMessage = isActive == 'yes' ? 'User Enabled' : 'User Disabled';
                          final snackBarColor = isActive == 'yes' ? Colors.green : Colors.red; // Set color based on status
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                snackBarMessage,
                                style: TextStyle(color: Colors.white), // Text color
                              ),
                              backgroundColor: snackBarColor, // Background color
                              duration: Duration(seconds: 2),
                            ),
                          );

                          // Send a notification email
                          sendNotificationEmail(farmer['email'], isActive == 'yes');
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    String? imageIdCardUrl,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  label == "ID Card Image"
                      ? GestureDetector(
                    onTap: () {
                      _showIdCardImage(imageIdCardUrl);
                    },
                    child: Text(
                      'Click to view ID Card',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                      : Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showIdCardImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Image.network(imageUrl),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  void sendNotificationEmail(String recipient, bool isActive) async {
    final smtpServer = gmail('namalthomson2024b@mca.ajce.in', 'Amal664422');
    final message = Message()
      ..from = Address('admin@farmconnect.com', 'Admin FarmConnect')
      ..recipients.add(recipient)
      ..subject = 'Account Status Update'
      ..text = isActive ? 'Your account has been enabled.' : 'Your account has been disabled.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport}');
    } on MailerException catch (e) {
      print('Message not sent. ${e.message}');
    }
  }
}

