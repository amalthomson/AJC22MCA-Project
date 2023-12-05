import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class BuyerDetailsPage extends StatefulWidget {
  @override
  _BuyerDetailsPageState createState() => _BuyerDetailsPageState();
}

class _BuyerDetailsPageState extends State<BuyerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'Buyer Details',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'Buyer').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final buyers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: buyers.length,
            itemBuilder: (context, index) {
              final buyer = buyers[index].data() as Map<String, dynamic>;
              final userId = buyers[index].id;

              final profilePictureUrl = buyer['profileImageUrl'] ?? '';
              var isActive = buyer['isActive'] ?? 'no';

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
                      buyer['name'] ?? 'N/A',
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
                          value: buyer['gender'] ?? 'N/A',
                        ),
                      ),
                      SingleChildScrollView(
                        child: _buildDetailItem(
                          icon: Icons.email,
                          label: "Email",
                          value: buyer['email'] ?? 'N/A',
                        ),
                      ),
                      SingleChildScrollView(
                        child: _buildDetailItem(
                          icon: Icons.phone,
                          label: "Phone",
                          value: buyer['phone'] ?? 'N/A',
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildDetailItem(
                          icon: Icons.location_on,
                          label: "Address",
                          value: "${buyer['street'] ?? 'N/A'}, ${buyer['town'] ?? 'N/A'}, ${buyer['district'] ?? 'N/A'}, ${buyer['state'] ?? 'N/A'}, ${buyer['pincode'] ?? 'N/A'}",
                        ),
                      ),
                    ],
                    trailing: Container(
                      width: 70,
                      height: 42,
                      child: Switch(
                        value: isActive == 'yes',
                        onChanged: (value) async {
                          await FirebaseFirestore.instance.collection('users').doc(userId).update({
                            'isActive': value ? 'yes' : 'no',
                          });
                          setState(() {
                            isActive = value ? 'yes' : 'no';
                          });

                          final snackBarMessage = isActive == 'yes' ? 'User Enabled' : 'User Disabled';
                          final snackBarColor = isActive == 'yes' ? Colors.green : Colors.red;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(snackBarMessage),
                              backgroundColor: snackBarColor,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          sendNotificationEmail(buyer['email'], isActive == 'yes');
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

  Widget _buildDetailItem({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void sendNotificationEmail(String recipient, bool isActive) async {
    final smtpServer = gmail('namalthomson2024b@mca.ajce.in', 'Amal664422');
    final message = Message()
      ..from = Address('admin@farmconnect.com', 'FarmConnect Admin')
      ..recipients.add(recipient)
      ..subject = 'Account Status Update'
      ..html = isActive
          ? '''
        <html>
        <head>
          <style>
            body {
              font-family: 'Helvetica Neue', Arial, sans-serif;
              background-color: #f4f4f4;
              color: #333;
              margin: 0;
              padding: 0;
            }
            .container {
              max-width: 600px;
              margin: 0 auto;
              background-color: #3498db;
              border-radius: 10px;
              overflow: hidden;
              box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .header {
              color: #fff;
              text-align: center;
              padding: 20px;
              background-color: #2980b9; /* Darker blue */
            }
            h1 {
              color: #fff;
            }
            .content {
              padding: 30px;
              background-color: #ffffff; /* White */
            }
            p {
              line-height: 1.6;
              color: #333; /* Dark gray for better visibility on white */
            }
            .footer {
              background-color: #f4f4f4;
              padding: 20px;
              text-align: center;
              color: #888;
              font-style: italic;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1>Account Enabled</h1>
            </div>
            <div class="content">
              <p>Dear User,</p>
              <p>Your FarmConnect account has been successfully enabled. You can now log in and explore all the features available to you.</p>
              <p>Thank you for choosing FarmConnect!</p>
            </div>
            <div class="footer">Best regards, FarmConnect Admin</div>
          </div>
        </body>
        </html>
        '''
          : '''
        <html>
        <head>
          <style>
            body {
              font-family: 'Helvetica Neue', Arial, sans-serif;
              background-color: #f4f4f4;
              color: #333;
              margin: 0;
              padding: 0;
            }
            .container {
              max-width: 600px;
              margin: 0 auto;
              background-color: #e74c3c;
              border-radius: 10px;
              overflow: hidden;
              box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .header {
              color: #fff;
              text-align: center;
              padding: 20px;
              background-color: #c0392b; /* Darker red */
            }
            h1 {
              color: #fff;
            }
            .content {
              padding: 30px;
              background-color: #ffffff; /* White */
            }
            p {
              line-height: 1.6;
              color: #333; /* Dark gray for better visibility on white */
            }
            .footer {
              background-color: #f4f4f4;
              padding: 20px;
              text-align: center;
              color: #888;
              font-style: italic;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1>Account Disabled</h1>
            </div>
            <div class="content">
              <p>Dear User,</p>
              <p>We regret to inform you that your FarmConnect account has been disabled. Please contact our support team for further assistance.</p>
              <p>Thank you for your understanding.</p>
            </div>
            <div class="footer">Best regards, FarmConnect Admin</div>
          </div>
        </body>
        </html>
        ''';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport}');
    } on MailerException catch (e) {
      print('Message not sent. ${e.message}');
    }
  }
}
