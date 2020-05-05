import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop_app/models/http_exception.dart';
//import 'package:provider/provider.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;
  String _authToken;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  // String get token {
  //   if (_authToken != null) {
  //     return _authToken;
  //   } else {
  //     return null;
  //   }
  // }
  // void addToken(String newToken) {
  //   _authToken = newToken;
  //   print('new token set in product');
  //   notifyListeners();
  // }

  Future<void> toggleFavouriteStatus(String token) async {
    print('Token is $token');
    final url = 'https://my-shop-app-be8be.firebaseio.com/products/$id.json?auth=$token';
    //use optimistic updating
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavourite': isFavourite,
        }),
      );
      // http doesnt treat errors on patch as a true error
      if (response.statusCode >= 400) throw HttpException('Error setting favourite');
    } catch (e) {
      // roll back changes
      isFavourite = oldStatus;
      notifyListeners();
      print(e);
      throw e;
    }
  }
}
