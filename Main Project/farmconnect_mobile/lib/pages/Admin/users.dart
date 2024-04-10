import 'package:farmconnect/pages/Admin/farmers.dart';
import 'package:farmconnect/pages/Admin/farmer_rejected.dart';
import 'package:farmconnect/pages/Admin/farmer_approvals.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/widgets/admin_grid_card.dart';
import 'package:farmconnect/pages/Admin/buyers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Users extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.userGear,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 20),              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                GridCard(
                  title: 'Farmers',
                  gradientColors: [Colors.green.shade100, Colors.green.shade300],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Farmers(),
                      ),
                    );
                  }, icon: FontAwesomeIcons.usersRectangle,
                ),
                GridCard(
                  title: 'Buyers',
                  gradientColors: [Colors.orange.shade100, Colors.orange.shade300],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuyerDetailsPage(),
                      ),
                    );
                  }, icon: FontAwesomeIcons.userGroup,
                ),
                GridCard(
                  title: 'Approvals',
                  gradientColors: [Colors.purple.shade100, Colors.purple.shade300],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PendingFarmerApprovalPage(),
                      ),
                    );
                  }, icon: FontAwesomeIcons.listNumeric,
                ),
                GridCard(
                  title: 'Rejected',
                  gradientColors: [Colors.red.shade100, Colors.red.shade300],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RejectedFarmerApprovalPage(),
                      ),
                    );
                  }, icon: FontAwesomeIcons.listCheck,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
