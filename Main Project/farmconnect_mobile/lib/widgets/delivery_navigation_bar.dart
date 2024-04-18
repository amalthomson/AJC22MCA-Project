import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class DeliveryCustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<Icon> items;

  DeliveryCustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: selectedIndex,
      backgroundColor: Colors.blueGrey[900]!,
      items: items.map((icon) => _whiteIcon(icon)).toList(),
      animationDuration: Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      color: Colors.black,
      buttonBackgroundColor: Colors.blueAccent,
      height: 60,
      onTap: onTap,
    );
  }

  Icon _whiteIcon(Icon icon) {
    return Icon(
      icon.icon,
      color: Colors.white,
      size: icon.size,
    );
  }
}
