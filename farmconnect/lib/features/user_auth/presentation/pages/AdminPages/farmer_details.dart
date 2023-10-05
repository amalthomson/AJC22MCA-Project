import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                padding: const EdgeInsets.all(8.0), // Add spacing
                child: Card(
                  color: tileColor,
                  elevation: 4, // Add elevation for a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      farmer['name'] ?? 'N/A',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email: ${farmer['email'] ?? 'N/A'}",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Phone: ${farmer['phone'] ?? 'N/A'}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
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
