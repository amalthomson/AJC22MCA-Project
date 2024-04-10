import 'package:flutter/material.dart';
import 'package:farmconnect/widgets/admin_grid_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:farmconnect/pages/Admin/add_categories.dart';
import 'package:farmconnect/pages/Admin/caterogy_wise_products.dart';
import 'package:farmconnect/pages/Admin/stocks.dart';
import 'package:farmconnect/pages/Admin/products_approved.dart';
import 'package:farmconnect/pages/Admin/products_approvals.dart';
import 'package:farmconnect/pages/Admin/products_rejected.dart';

class Products extends StatelessWidget {
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
                  FontAwesomeIcons.shoppingBasket,
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
                  title: 'All Products',
                  gradientColors: [Colors.blue.shade100, Colors.blue.shade300],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApprovedProductsPage(),
                      ),
                    );
                  },
                  icon: FontAwesomeIcons.shoppingBasket,
                ),
                GridCard(
                  title: 'Approvals',
                  gradientColors: [Colors.yellow.shade100, Colors.yellow.shade300],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PendingApprovalPage(),
                      ),
                    );
                  },
                  icon: FontAwesomeIcons.listNumeric,
                ),
                GridCard(
                  title: 'Rejected',
                  gradientColors: [Colors.red.shade100, Colors.red.shade300],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RejectedProductsPage(),
                      ),
                    );
                  },
                  icon: FontAwesomeIcons.cancel,
                ),
                GridCard(
                  title: 'Stock',
                  gradientColors: [Colors.green.shade100, Colors.green.shade300],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StockByProductNamePage(),
                      ),
                    );
                  },
                  icon: FontAwesomeIcons.warehouse,
                ),
                GridCard(
                  title: 'Category',
                  gradientColors: [Colors.orange.shade100, Colors.orange.shade300],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryWiseProducts(),
                      ),
                    );
                  },
                  icon: FontAwesomeIcons.store,
                ),
                GridCard(
                  title: 'Add Category',
                  gradientColors: [Colors.purple.shade100, Colors.purple.shade300],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCategoriesAndProducts(),
                      ),
                    );
                  },
                  icon: FontAwesomeIcons.plus,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
