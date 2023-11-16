import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProvider extends ChangeNotifier {
  String? _userId;
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void setUserId(String userId) {
    _userId = userId;
  }

  Future<void> fetchCartFromFirestore() async {
    try {
      final userCartCollection = FirebaseFirestore.instance.collection('cart').doc(_userId);
      final cartData = await userCartCollection.get();

      if (cartData.exists) {
        _cartItems = List.from(cartData['cartItems']);
        notifyListeners();
      }
    } catch (error) {
      print('Error fetching cart from Firestore: $error');
    }
  }

  Future<void> addToCart(Map<String, dynamic> item) async {
    final userCartCollection = FirebaseFirestore.instance.collection('cart').doc(_userId);

    item['quantity'] = item['quantity'] ?? 1;
    _cartItems.add(item);
    notifyListeners();

    await userCartCollection.set({'cartItems': _cartItems});
  }

  double? totalAmount() {
    double total = 0.0;
    for (var item in _cartItems) {
      double productPrice = item['productPrice']?.toDouble() ?? 0.0;
      total += productPrice * (item['quantity'] ?? 1);
    }
    return total;
  }

  Future<void> removeFromCart(String productId) async {
    _cartItems.removeWhere((item) => item['productId'] == productId);
    notifyListeners();

    await _updateFirestoreCart();
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    notifyListeners();

    await _updateFirestoreCart();
  }

  Future<void> _updateFirestoreCart() async {
    final userCartCollection = FirebaseFirestore.instance.collection('cart').doc(_userId);
    await userCartCollection.set({'cartItems': _cartItems});
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
      _updateFirestoreCart();
    }
  }

  void increaseQuantity(String productId) {
    var productIndex = _cartItems.indexWhere((item) => item['productId'] == productId);

    if (productIndex != -1) {
      _cartItems[productIndex]['quantity'] = (_cartItems[productIndex]['quantity'] ?? 0) + 1;

      notifyListeners();
      _updateFirestoreCart();
    } else {
      addToCart({
        'productId': productId,
        'quantity': 1,
        // Add other product details as needed
      });

      notifyListeners(); // Notify listeners after adding a new item
    }
  }

  Future<void> initializeCartFromFirestore() async {
    await fetchCartFromFirestore();
  }
}
