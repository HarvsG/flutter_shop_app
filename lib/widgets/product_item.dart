import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';
import '../screens/products_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  //const ProductItem({Key key}) : super(key: key);
  // final String id;
  // final String title;
  // //final String description;
  // //final double price;
  // final String imageUrl;

  // const ProductItem(
  //     {Key key,
  //     @required this.id,
  //     @required this.title,
  //     @required this.imageUrl})
  //     : super(key: key);
  //bool isFavourite;

  @override
  Widget build(BuildContext context) {
    print('product item runs');
    final Product product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductsDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        header: null,
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: product.toggleFavouriteStatus,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.add_shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Added to cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(label: 'UNDO', onPressed: () {
                    cart.removeSingleItem(product.id);
                  }),
                ));
              }),
        ),
      ),
    );
  }
}
