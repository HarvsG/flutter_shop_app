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

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus() async {
    final url = 'https://my-shop-app-be8be.firebaseio.com/products/$id.json';
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
      throw e;
    }
  }
}
