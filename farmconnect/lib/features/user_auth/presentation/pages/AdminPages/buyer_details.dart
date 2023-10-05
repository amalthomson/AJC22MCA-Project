import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage for image loading
import 'package:farmconnect/features/user_auth/presentation/pages/common/colors.dart';

class BuyerDetailsPage extends StatefulWidget {
  @override
  _BuyerDetailsPageState createState() => _BuyerDetailsPageState();
}

class _BuyerDetailsPageState extends State<BuyerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Buyer Details"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Buyer')
            .snapshots(),
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

              // Get the profile picture URL from the database
              final profilePictureUrl = buyer['profileImageUrl'] ?? '';

              // Define a list of background colors
              final tileColors = [
                Colors.lightBlue,
                Colors.lightGreen,
                Colors.amber,
                Colors.pink,
                Colors.purple,
              ];

              // Get the color based on index
              final tileColor = tileColors[index % tileColors.length];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: tileColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      buyer['name'] ?? 'N/A',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gender: ${buyer['gender'] ?? 'N/A'}",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Email: ${buyer['email'] ?? 'N/A'}",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Phone: ${buyer['phone'] ?? 'N/A'}",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Address: ${buyer['street'] ?? 'N/A'}, ${buyer['town'] ?? 'N/A'}, ${buyer['state'] ?? 'N/A'}, ${buyer['district'] ?? 'N/A'}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    leading: CircleAvatar(
                      // Display the profile picture
                      backgroundImage: NetworkImage(profilePictureUrl),
                      radius: 30, // Set the radius as needed
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
