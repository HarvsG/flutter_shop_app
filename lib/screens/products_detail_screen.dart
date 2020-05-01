import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';

class ProductsDetailScreen extends StatelessWidget {
  //const ProductsDetailScreen({Key key}) : super(key: key);
  // final String title;
  // final double price;

  //const ProductsDetailScreen({Key key, this.title, this.price}) : super(key: key);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: null,
    );
  }
}
