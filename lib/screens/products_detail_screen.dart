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
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover),
          ),
          SizedBox(height: 10),
          Text(
            '£${loadedProduct.price}',
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
            loadedProduct.description,
            textAlign: TextAlign.center,
            softWrap: true,
          ))
        ]),
      ),
    );
  }
}
