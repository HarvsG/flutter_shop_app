import './products_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantitiy;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantitiy,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(String productId, double price, String title) {

    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (item) => CartItem(
                id: item.id,
                title: item.title,
                price: item.price,
                quantitiy: item.quantitiy + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                price: price,
                title: title,
                quantitiy: 1,
              ));
    }
    notifyListeners();
  }
}
