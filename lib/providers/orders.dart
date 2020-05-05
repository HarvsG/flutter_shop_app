import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String _authToken;

  List<OrderItem> get orders {
    return [..._orders];
  }

  String get token {
    if (_authToken != null) {
      return _authToken;
    } else {
      return null;
    }
  }
  void addToken(String newToken) {
    _authToken = newToken;
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url = 'https://my-shop-app-be8be.firebaseio.com/orders.json?auth=$token';
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData == null){
        return;
      }
      List<OrderItem> loadedOrders = [];
      responseData.forEach((name, order) {
        List<CartItem> loadedCartItems = [];
        order['products'].forEach((cartItem) {
          loadedCartItems.add(CartItem(
            id: cartItem['id'] as String,
            title: cartItem['title'] as String,
            quantity: cartItem['quantity'] as int,
            price: cartItem['price'] as double,
          ));
        });
        loadedOrders.add(OrderItem(
          id: name,
          amount: order['amount'] as double,
          dateTime: DateTime.parse(order['dateTime']),
          products: loadedCartItems.reversed.toList(),
        ));
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://my-shop-app-be8be.firebaseio.com/orders.json?auth=$token';
    final dateTime = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': dateTime.toIso8601String(),
            'products': cartProducts.map((cartItem) {
              return {
                'id': cartItem.id,
                'title': cartItem.title,
                'quantity': cartItem.quantity,
                'price': cartItem.price,
              };
            }).toList(),
          }));
      final newOrder = OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: dateTime,
          products: cartProducts);
      _orders.insert(
        0,
        newOrder,
      );
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }
}
