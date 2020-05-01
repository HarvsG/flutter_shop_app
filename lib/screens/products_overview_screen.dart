import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
//import '../providers/product.dart';
import '../providers/products_provider.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  //const ProductsOverviewScreen({Key key}) : super(key: key);
  //final List<Product> loadedProducts = ;

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selected) {
                setState(() {
                  if (selected == FilterOptions.Favourites) {
                    _showOnlyFavourites = true;
                  } else {
                    _showOnlyFavourites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('Only favourites'),
                        value: FilterOptions.Favourites),
                    PopupMenuItem(
                        child: Text('Show all'), value: FilterOptions.All),
                  ],
              icon: Icon(Icons.more_vert)),
        ],
      ),
      body: ProductsGrid(_showOnlyFavourites),
    );
  }
}
