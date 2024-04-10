import 'package:farmconnect/pages/Admin/order_history.dart';
import 'package:farmconnect/pages/Admin/payments.dart';
import 'package:flutter/material.dart';
import 'package:farmconnect/widgets/admin_grid_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Orders extends StatelessWidget {
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
                  FontAwesomeIcons.shoppingCart,
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
                  title: 'Orders',
                  gradientColors: [Colors.blue.shade100, Colors.blue.shade300],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderHistory(),
                      ),
                    );
                  },
                  icon: FontAwesomeIcons.shoppingBag,
                ),
                GridCard(
                  title: 'Payments',
                  gradientColors: [Colors.green.shade100, Colors.green.shade300],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentSuccessfulPage(),
                      ),
                    );
                  },
                  icon: FontAwesomeIcons.indianRupeeSign,
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
