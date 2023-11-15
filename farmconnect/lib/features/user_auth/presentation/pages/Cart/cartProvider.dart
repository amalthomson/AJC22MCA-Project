import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  String? _userId;

  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void setUserId(String userId) {
    _userId = userId;
  }

  void addToCart(Map<String, dynamic> item) {
    item['quantity'] = item['quantity'] ?? 1;
    _cartItems.add(item);
    notifyListeners();
  }


  double? totalAmount() {
    double total = 0.0;
    for (var item in _cartItems) {
      double productPrice = item['productPrice']?.toDouble() ?? 0.0;
      total += productPrice * (item['quantity'] ?? 1);
    }
    return total;
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item['productId'] == productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int productCount(String productId) {
    return _cartItems.where((item) => item['productId'] == productId).length;
  }

  List<Map<String, dynamic>> get uniqueProducts {
    Set<String> uniqueProductIds = Set<String>();
    List<Map<String, dynamic>> uniqueProductsList = [];

    for (var item in _cartItems) {
      if (uniqueProductIds.add(item['productId'])) {
        uniqueProductsList.add(item);
      }
    }

    return uniqueProductsList;
  }

  int get uniqueProductCount {
    return uniqueProducts.length;
  }

  void decreaseQuantity(String productId) {
    var productIndex = _cartItems.indexWhere((item) => item['productId'] == productId);

    if (productIndex != -1) {
      _cartItems[productIndex]['quantity'] = (_cartItems[productIndex]['quantity'] ?? 1) - 1;

      if (_cartItems[productIndex]['quantity'] == 0) {
        _cartItems.removeAt(productIndex);
      }

      notifyListeners();
    }
  }

  void increaseQuantity(String productId) {
    var productIndex = _cartItems.indexWhere((item) => item['productId'] == productId);

    if (productIndex != -1) {
      _cartItems[productIndex]['quantity'] = (_cartItems[productIndex]['quantity'] ?? 0) + 1;

      notifyListeners();
    } else {
      addToCart({
        'productId': productId,
        'quantity': 1,
        // Add other product details as needed
      });

      notifyListeners(); // Notify listeners after adding a new item
    }
  }
}
