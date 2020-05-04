import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';


class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  //const UserProductsScreen({Key key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your products'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                })
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: ()=> _refreshProducts(context),
                  child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemBuilder: (_, i) => Column(
                children: <Widget>[
                  UserProductItem(
                    title: productsData.items[i].title,
                    imageUrl: productsData.items[i].imageUrl,
                    id: productsData.items[i].id,
                  ),
                  const Divider()
                ],
              ),
              itemCount: productsData.items.length,
            ),
          ),
        ));
  }
}
