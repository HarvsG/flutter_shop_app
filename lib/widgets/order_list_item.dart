import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart';


class OrderListItem extends StatelessWidget {
  //const OrderListItem({Key key}) : super(key: key);
  final OrderItem order;

  const OrderListItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('£${order.amount}'),
              subtitle: Text(DateFormat.yMMMd().format(order.dateTime)),
              trailing: IconButton(icon: Icon(Icons.expand_more), onPressed: null),
            )
          ],
        ),
      ),
    );
  }
}
