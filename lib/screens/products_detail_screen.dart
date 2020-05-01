import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductsDetailScreen extends StatelessWidget {
  //const ProductsDetailScreen({Key key}) : super(key: key);
  // final String title;
  // final double price;

  //const ProductsDetailScreen({Key key, this.title, this.price}) : super(key: key);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: null,
    );
  }
}
