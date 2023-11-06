import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class PendingFarmerApprovalPage extends StatefulWidget {
  @override
  _PendingFarmerApprovalPageState createState() => _PendingFarmerApprovalPageState();
}

class _PendingFarmerApprovalPageState extends State<PendingFarmerApprovalPage> {
  void updateApprovalStatus(String userId, String status, String email) {
    String messageSubject, messageText;

    if (status == 'approved') {
      messageSubject = 'Account Approved';
      messageText = 'Your account has been approved by the Admin, You can now log in to your account.';
    } else if (status == 'rejected') {
      messageSubject = 'Account Rejected';
      messageText = 'Your account has been rejected by the Admin. Please contact Admin for further inquiries.';
    } else {
      // Handle other cases if necessary
      return;
    }

    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isAdminApproved': status,
      'remark': status == 'approved' ? 'The User is Approved' : '', // Update the remark field
    });

    // Send email notification
    sendNotificationEmail(email, messageSubject, messageText);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User $status'),
        backgroundColor: status == 'approved' ? Colors.green : Colors.red,
      ),
    );
  }

  void sendNotificationEmail(String recipient, String subject, String text) async {
    final smtpServer = gmail('namalthomson2024b@mca.ajce.in', 'Amal664422'); // Replace with your email and password
    final message = Message()
      ..from = Address('admin@farmconnect.com', 'Admin FarmConnect')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = text;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent. ${e.message}');
    }
  }

  Future<void> showRemarkDialog(String userId, String email) async {
    String remark = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Remark'),
          content: TextField(
            onChanged: (value) {
              remark = value;
            },
            decoration: InputDecoration(hintText: 'Enter your remark'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (remark.isNotEmpty) {
                  FirebaseFirestore.instance.collection('users').doc(userId).update({
                    'isAdminApproved': 'rejected',
                    'remark': remark, // Update the remark field with the entered value
                  });

                  // Send email notification for rejection
                  sendNotificationEmail(email, 'Account Rejected', 'Your account has been rejected by the Admin. Please contact Admin for further inquiries');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('User rejected'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Reject'),
            ),
          ],
        );
      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("Pending Farmer Approvals", style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'Farmer').where('isAdminApproved', isEqualTo: 'no').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final farmers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: farmers.length,
            itemBuilder: (context, index) {
              final farmer = farmers[index].data() as Map<String, dynamic>;
              final farmerId = farmers[index].id;
              final profilePictureUrl = farmer['profileImageUrl'] ?? '';

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
                        child: _buildDetailItem(
                          icon: Icons.location_on,
                          label: "Address",
                          value:
                          "${farmer['street'] ?? 'N/A'}, ${farmer['town'] ?? 'N/A'}, ${farmer['district'] ?? 'N/A'}, ${farmer['state'] ?? 'N/A'}, ${farmer['pincode'] ?? 'N/A'}",
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
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                updateApprovalStatus(farmerId, 'approved', farmer['email']);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: Text('Approve'),
                            ),
                            SizedBox(width: 30),
                            ElevatedButton(
                              onPressed: () {
                                showRemarkDialog(farmerId, farmer['email']);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              child: Text('Reject'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
