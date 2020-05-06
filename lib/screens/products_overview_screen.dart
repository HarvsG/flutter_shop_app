import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
//import '../providers/product.dart';
import '../widgets/badge.dart';
import '../screens/cart_screen.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview';
  //const ProductsOverviewScreen({Key key}) : super(key: key);
  //final List<Product> loadedProducts = ;

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Products>(context, listen: true)
          .fetchAndSetProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        print('init ran');
        _isInit = false;
      }).catchError((e){
        print('error in product_overview_screen');
        print(e);
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final productsContainer = Provider.of<Products>(context, listen: false);

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
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavourites),
    );
  }
}
