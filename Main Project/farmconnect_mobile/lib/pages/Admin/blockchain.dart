import 'package:farmconnect/blockchain/add_user.dart';
import 'package:farmconnect/blockchain/list_user.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/widgets/grid_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Blockchain extends StatelessWidget {
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
                  FontAwesomeIcons.projectDiagram,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  GridCard(
                    title: 'View User',
                    gradientColors: [Colors.blue.shade100, Colors.blue.shade300],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserListScreen(),
                        ),
                      );
                    },
                    icon: FontAwesomeIcons.display,
                  ),
                  GridCard(
                    title: 'Add Users',
                    gradientColors: [Colors.green.shade100, Colors.green.shade300],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUserScreen(),
                        ),
                      );
                    },
                    icon: FontAwesomeIcons.userPlus,
                  ),
                  // Add more GridCard widgets for additional transactions
                ],
              ),
            ),
        ],
      ),
    );
  }
}
