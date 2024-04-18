import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GridCard extends StatefulWidget {
  final String title;
  final List<Color> gradientColors; // List of gradient colors
  final Function onTap;
  final IconData icon; // Icon to be displayed

  GridCard({
    required this.title,
    required this.gradientColors,
    required this.onTap,
    required this.icon, // New property for the icon
  });

  @override
  _GridCardState createState() => _GridCardState();
}

class _GridCardState extends State<GridCard> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_scaleController);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTap: () {
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Reduced from 14 to 10
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 3.5, // Adjusted width
                padding: EdgeInsets.all(5), // Reduced padding
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: widget.gradientColors, // Use provided gradient colors
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.gradientColors.first.withOpacity(0.5), // Use first color in gradient
                      blurRadius: 4, // Reduced blur radius
                      offset: Offset(0, 2), // Reduced offset
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.rotate(
                      angle: _scaleAnimation.value * 2 * math.pi,
                      child: FaIcon(
                        widget.icon, // Use provided icon
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5), // Reduced size of SizedBox
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
