import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_shop_app/models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  String _authToken;
  String _userId;

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  //var _showFavouritesOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavourite == true).toList();
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

  String get userId {
    return _userId;
  }

  void addUserid(String newUserId) {
    _userId = newUserId;
    notifyListeners();
  }

  Product findById(id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    final url = filterByUser
        ? 'https://my-shop-app-be8be.firebaseio.com/products.json?auth=$token&orderBy="creatorId"&equalTo="$userId"'
        : 'https://my-shop-app-be8be.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final favouriteResponse = await http.get(
          'https://my-shop-app-be8be.firebaseio.com/userFavourites/$userId.json?auth=$token');
      final favouriteData =
          jsonDecode(favouriteResponse.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite:
              favouriteData == null ? false : favouriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://my-shop-app-be8be.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
            //'isFavourite': product.isFavourite
          }));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }

    // }).catchError((error){
    //   throw error;
    // });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        'https://my-shop-app-be8be.firebaseio.com/products/$id.json?auth=$token';
    final prodindex = _items.indexWhere((prod) => prod.id == id);
    try {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            //'isFavourite': newProduct.isFavourite
          }));
      _items[prodindex] = newProduct;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void deleteProduct(String id) {
    final url =
        'https://my-shop-app-be8be.firebaseio.com/products/$id.json?auth=$token';
    var existingProductIndex = _items.indexWhere((item) => item.id == id);
    var existingProduct = _items[existingProductIndex];
    // uses optimistic updating
    _items.removeAt(existingProductIndex);
    http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('Failed to delete on server');
        // resinstate the product if the server returns an error
      } else {
        existingProduct = null;
        existingProductIndex = null;
      }
    }).catchError((e) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });
    notifyListeners();
  }
}
