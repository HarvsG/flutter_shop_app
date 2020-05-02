import 'package:flutter/material.dart';
import '../widgets/order_list_item.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  //const OrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of(context, listen: true);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, i) => OrderListItem(orderData[i]),
          itemCount: orderData.orders.length,
        ),
      ),
    );
  }
}
