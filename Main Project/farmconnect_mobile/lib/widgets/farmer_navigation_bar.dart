import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class FarmerCustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<IconData> items; // Change Icon to IconData

  FarmerCustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: selectedIndex,
      backgroundColor: Colors.blueGrey[900]!,
      items: items.map((icon) => Icon(icon, color: Colors.white)).toList(), // Map IconData to Icon
      animationDuration: Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      color: Colors.black,
      buttonBackgroundColor: Colors.blueAccent,
      height: 60,
      onTap: onTap,
    );
  }
}
