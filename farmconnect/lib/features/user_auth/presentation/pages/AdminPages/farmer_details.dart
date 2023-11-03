// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';
// import 'package:mailer/smtp_server.dart';
//
// class FarmerDetailsPage extends StatefulWidget {
//   @override
//   _FarmerDetailsPageState createState() => _FarmerDetailsPageState();
// }
//
// class _FarmerDetailsPageState extends State<FarmerDetailsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.blueGrey[900],
//         title: Text(
//           "Farmer Details",
//           style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .where('role', isEqualTo: 'Farmer')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           final farmers = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: farmers.length,
//             itemBuilder: (context, index) {
//               final farmer = farmers[index].data() as Map<String, dynamic>;
//               final userId = farmers[index].id;
//
//               final profilePictureUrl = farmer['profileImageUrl'] ?? '';
//               var isActive = farmer['isActive'] ?? 'no'; // Initialize with 'no'
//
//               final tileColors = [
//                 Colors.purple,
//                 Colors.lightBlue,
//                 Colors.lightGreen,
//                 Colors.amber,
//                 Colors.pink,
//               ];
//
//               final tileColor = tileColors[index % tileColors.length];
//
//               return Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                   ),
//                   child: ExpansionTile(
//                     tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(profilePictureUrl),
//                       radius: 30,
//                     ),
//                     title: Text(
//                       farmer['name'] ?? 'N/A',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                     childrenPadding: EdgeInsets.all(16),
//                     children: [
//                       SingleChildScrollView( // Add a SingleChildScrollView to handle overflow
//                         child: _buildDetailItem(
//                           icon: Icons.person,
//                           label: "Gender",
//                           value: farmer['gender'] ?? 'N/A',
//                         ),
//                       ),
//                       SingleChildScrollView(
//                         child: _buildDetailItem(
//                           icon: Icons.email,
//                           label: "Email",
//                           value: farmer['email'] ?? 'N/A',
//                         ),
//                       ),
//                       SingleChildScrollView(
//                         child: _buildDetailItem(
//                           icon: Icons.phone,
//                           label: "Phone",
//                           value: farmer['phone'] ?? 'N/A',
//                         ),
//                       ),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: _buildDetailItem(
//                           icon: Icons.location_on,
//                           label: "Address",
//                           value: "${farmer['street'] ?? 'N/A'}, ${farmer['town'] ?? 'N/A'}, ${farmer['district'] ?? 'N/A'}, ${farmer['state'] ?? 'N/A'}, ${farmer['pincode'] ?? 'N/A'}",
//                         ),
//                       ),
//                     ],
//                     trailing: Container(
//                       width: 70,
//                       height: 42,
//                       child: Switch(
//                         value: isActive == 'yes',
//                         onChanged: (value) async {
//                           // Update the 'isActive' field in Firestore as a string
//                           FirebaseFirestore.instance.collection('users').doc(userId).update({
//                             'isActive': value ? 'yes' : 'no',
//                           });
//
//                           // Send email notification when the user is disabled
//                           if (!value) {
//                             await sendEmailNotification(farmer['email']);
//                           }
//
//                           // Show a snackbar to notify the admin action
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(value ? 'User is active' : 'User is disabled'),
//                               duration: Duration(seconds: 3),
//                             ),
//                           );
//
//                           setState(() {
//                             isActive = value ? 'yes' : 'no';
//                           });
//                         },
//                         activeColor: Colors.green,
//                         inactiveThumbColor: Colors.grey,
//                         inactiveTrackColor: Colors.grey.withOpacity(0.5),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildDetailItem({required IconData icon, required String label, required String value}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: Colors.green,
//             size: 28,
//           ),
//           SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 18,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> sendEmailNotification(String recipientEmail) async {
//     final smtpServer = gmail('your_email@gmail.com', 'your_password');
//
//     final message = Message()
//       ..from = Address('your_email@gmail.com', 'Your Name')
//       ..recipients.add(recipientEmail)
//       ..subject = 'Account Disabled'
//       ..text = 'Your account has been disabled by the admin. Please contact support for more information.';
//
//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: ${sendReport}');
//     } catch (e) {
//       print('Error sending email: $e');
//     }
//   }
// }

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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(snackBarMessage),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
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
      ..from = Address('your@gmail.com', 'Your Name')
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
