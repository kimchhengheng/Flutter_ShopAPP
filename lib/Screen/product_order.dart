import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Order.dart';
import '../Widget/app_drawer.dart';
import '../Widget/order_item.dart' as orderIS;

class ProductOrder extends StatelessWidget {
  static String routeName = "/order";


  @override
  Widget build(BuildContext context) {
    var orderpro = Provider.of<OrdersList>(context);
    var orderli = orderpro.orderlist;
    return Scaffold(
        appBar: AppBar(title: Text("Ordered"),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
            itemCount: orderli.length ,
            itemBuilder: (context, ind) {
              return orderIS.OrderItem(orderli[ind]);
            },
        ),

    );
  }
}
