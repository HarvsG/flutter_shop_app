import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import '../models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  //const ProductsOverviewScreen({Key key}) : super(key: key);
  //final List<Product> loadedProducts = ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
      ),
      body: ProductsGrid(),
    );
  }
}


