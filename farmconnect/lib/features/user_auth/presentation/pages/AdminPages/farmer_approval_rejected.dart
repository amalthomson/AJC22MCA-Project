import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RejectedFarmerApprovalPage extends StatefulWidget {
  @override
  _RejectedFarmerApprovalPageState createState() => _RejectedFarmerApprovalPageState();
}

class _RejectedFarmerApprovalPageState extends State<RejectedFarmerApprovalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("Rejected Farmers", style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'Farmer').where('isAdminApproved', isEqualTo: 'rejected').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final farmers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: farmers.length,
            itemBuilder: (context, index) {
              final farmer = farmers[index].data() as Map<String, dynamic>;
              final profilePictureUrl = farmer['profileImageUrl'] ?? '';
              final remark = farmer['remark'] ?? '';

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
                      _buildDetailItem(
                        icon: Icons.comment,
                        label: "Remark",
                        value: '',
                        remark: remark,
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

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    String? imageIdCardUrl,
    String? remark,
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
                  if (label == "ID Card Image") GestureDetector(
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
                  ) else if (label == "Remark" && remark != null && remark.isNotEmpty) GestureDetector(
                    onTap: () {
                      _showRemarkDialog(remark);
                    },
                    child: Text(
                      'Click to view Remark',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ) else Text(
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

  void _showRemarkDialog(String remark) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Remark'),
          content: Text(remark),
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
