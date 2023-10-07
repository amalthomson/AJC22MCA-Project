import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage for image loading
import 'package:farmconnect/features/user_auth/presentation/pages/common/colors.dart';

class FarmerDetailsPage extends StatefulWidget {
  @override
  _FarmerDetailsPageState createState() => _FarmerDetailsPageState();
}

class _FarmerDetailsPageState extends State<FarmerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Farmer Details"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Farmer')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final farmers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: farmers.length,
            itemBuilder: (context, index) {
              final farmer = farmers[index].data() as Map<String, dynamic>;
              final userId = farmers[index].id; // Get the user's ID

              // Get the profile picture URL from the database
              final profilePictureUrl = farmer['profileImageUrl'] ?? '';

              // Define a list of background colors
              final tileColors = [
                Colors.purple,
                Colors.lightBlue,
                Colors.lightGreen,
                Colors.amber,
                Colors.pink,
              ];

              // Get the color based on index
              final tileColor = tileColors[index % tileColors.length];

              bool isEnabled = farmer['isEnabled'] ?? true; // Check if the user is enabled

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  color: tileColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      // Display the profile picture
                      backgroundImage: NetworkImage(profilePictureUrl),
                      radius: 30, // Set the radius as needed
                    ),
                    title: Text(
                      farmer['name'] ?? 'N/A',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20, // Increase the text size
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gender: ${farmer['gender'] ?? 'N/A'}",
                              style: TextStyle(color: Colors.white, fontSize: 18), // Increase the text size
                            ),
                            Text(
                              "Email: ${farmer['email'] ?? 'N/A'}",
                              style: TextStyle(color: Colors.white, fontSize: 18), // Increase the text size
                            ),
                            Text(
                              "Phone: ${farmer['phone'] ?? 'N/A'}",
                              style: TextStyle(color: Colors.white, fontSize: 18), // Increase the text size
                            ),
                            Text(
                              "Address: ${farmer['street'] ?? 'N/A'}, ${farmer['town'] ?? 'N/A'}, ${farmer['district'] ?? 'N/A'}, ${farmer['state'] ?? 'N/A'}, ${farmer['pincode'] ?? 'N/A'}",
                              style: TextStyle(color: Colors.white, fontSize: 18), // Increase the text size
                            ),
                          ],
                        ),
                      ),
                    ],
                    trailing: Container(
                      width: 70, // Increase the width of the Switch container
                      height: 42, // Increase the height of the Switch container
                      child: Switch(
                        value: isEnabled,
                        onChanged: (value) {
                          // Update the 'isEnabled' field in Firestore
                          FirebaseFirestore.instance.collection('users').doc(userId).update({
                            'isEnabled': value,
                          });
                          setState(() {
                            isEnabled = value;
                          });
                        },
                        activeColor: Colors.green, // Change the color of the active Switch
                        inactiveThumbColor: Colors.grey, // Change the color of the inactive Switch
                        inactiveTrackColor: Colors.grey.withOpacity(0.5), // Change the color of the inactive Switch track
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
}
