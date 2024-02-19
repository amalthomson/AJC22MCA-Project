import 'package:flutter/material.dart';

class AdminDashboardTile extends StatelessWidget {
  final String title;
  final int count;
  final Color tileColor;
  final IconData iconData; // Icon data for the tile
  final List<Color> gradientColors; // List of colors for gradient

  const AdminDashboardTile({
    required this.title,
    required this.count,
    required this.tileColor,
    required this.iconData,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0), // Rounded edges
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors, // Use the provided gradient colors
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData, // Use the provided icon data
              color: Colors.white,
              size: 40.0,
            ),
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
