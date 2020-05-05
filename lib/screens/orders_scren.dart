import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_list_item.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  //const OrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context, listen: true);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: RefreshIndicator(
          onRefresh: () async{
            try {
              await orderData.fetchOrders();
            } catch (e) {
              print(e);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemBuilder: (ctx, i) => OrderListItem(orderData.orders[i]),
              itemCount: orderData.orders.length,
            ),
          ),
        ),
        drawer: AppDrawer(),
      ),
    );
  }
}
