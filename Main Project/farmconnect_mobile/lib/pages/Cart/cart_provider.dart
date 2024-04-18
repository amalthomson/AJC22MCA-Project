import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    if (!_cartItems.contains(item)) {
      final productCollection = FirebaseFirestore.instance.collection('products');
      final productData = await productCollection.doc(item['productId']).get();
      int productStock = productData['stock'] ?? 0;

      if (productStock >= item['quantity']) {
        await _updateStock(item['productId'], item['quantity'], false);
        _cartItems.add(item);
        notifyListeners();
        await userCartCollection.set({'cartItems': _cartItems});
      } else {
        print('Insufficient stock for ${item['productName']}');
      }
    } else {
      print('${item['productName']} is already in the cart');
    }
  }

  double totalAmount() {
    double total = 0.0;
    for (var item in _cartItems) {
      double productPrice = double.tryParse(item['productPrice'].toString()) ?? 0.0;
      total += productPrice * (item['quantity'] ?? 1);
    }
    return total;
  }

  Future<void> removeFromCart(String productId) async {
    var removedItem = _cartItems.firstWhere(
          (item) => item['productId'] == productId,
      orElse: () => {},
    );

    if (removedItem.isNotEmpty) {
      await _updateStock(productId, removedItem['quantity'], true);
      _cartItems.remove(removedItem);
      notifyListeners();
      await _updateFirestoreCart();
    }
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

  void decreaseQuantity(String productId) async {
    var productIndex = _cartItems.indexWhere((item) => item['productId'] == productId);

    if (productIndex != -1) {
      _cartItems[productIndex]['quantity'] = (_cartItems[productIndex]['quantity'] ?? 1) - 1;

      if (_cartItems[productIndex]['quantity'] == 0) {
        await removeFromCart(productId);
      } else {
        await _updateStock(productId, 1, true);
        notifyListeners();
        await _updateFirestoreCart();
      }
    }
  }

  void increaseQuantity(String productId) async {
    var productIndex = _cartItems.indexWhere((item) => item['productId'] == productId);

    if (productIndex != -1) {
      _cartItems[productIndex]['quantity'] = (_cartItems[productIndex]['quantity'] ?? 0) + 1;

      await _updateStock(productId, 1, false);
      notifyListeners();
      await _updateFirestoreCart();
    } else {
      addToCart({
        'productId': productId,
        'quantity': 1,
      });

      notifyListeners();
    }
  }

  Future<void> initializeCartFromFirestore() async {
    await fetchCartFromFirestore();
  }

  Future<void> _updateStock(String productId, int quantity, bool increase) async {
    final productCollection = FirebaseFirestore.instance.collection('products');
    final productData = await productCollection.doc(productId).get();
    int productStock = productData['stock'] ?? 0;

    if (increase) {
      productCollection.doc(productId).update({
        'stock': productStock + quantity,
      });
    } else {
      productCollection.doc(productId).update({
        'stock': productStock - quantity,
      });
    }
  }
}
