import 'package:flutter/material.dart';

class CartItem {
  String itemId;
  String imageUrl;
  String itemName;
  int quantity;
  double rate;
  double total;

  CartItem({
    this.itemId,
    this.imageUrl,
    this.itemName,
    this.quantity,
    this.rate,
    this.total,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  get productList {
    List<String> k = this.items.keys.toList();
    k.sort();
    return k;
  }

  get itemList {
    return this.productList.map((e) => _items[e]).toList();
  }

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.rate * value.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
    String imageUrl,
    double total,
    int quantity,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          itemId: existingItem.itemId,
          itemName: existingItem.itemName,
          rate: existingItem.rate,
          imageUrl: existingItem.imageUrl,
          quantity: existingItem.quantity + 1,
          total: existingItem.quantity * existingItem.rate + existingItem.rate,
        ),
      );
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                itemId: DateTime.now().toString(),
                itemName: title,
                rate: price,
                quantity: quantity,
                imageUrl: imageUrl,
                total: total,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId, CartItem item) {
    //  _items.remove(productId);
    _items.removeWhere((key, value) => key == productId && value == item);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingItem) => CartItem(
                itemId: existingItem.itemId,
                itemName: existingItem.itemName,
                rate: existingItem.rate,
                imageUrl: existingItem.imageUrl,
                quantity: existingItem.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
