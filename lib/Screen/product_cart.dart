import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Order.dart';
import '../Provider/Product.dart';
import '../Provider/Cart.dart' show CartList;

import '../Screen/product_order.dart';

import '../Widget/cart_item.dart';
import '../Widget/app_drawer.dart';



class ProductCart extends StatelessWidget {
  static String routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    var cartlist = Provider.of<CartList>(context);
    var cartmap= cartlist.cartlist;
    var order = Provider.of<OrdersList>(context);
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text("Product Cart"),
        ),
        drawer: AppDrawer(),
        body: Column(
          children: [
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text("Total: "),
                    Spacer(),
                    Chip(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.all(10),
                      label: Text('${cartlist.totalPrice.toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold  )),
                    ),
                    FlatButton(
                      child: Text("Order Now", style: TextStyle(color: Theme.of(context).primaryColorDark),),
                      onPressed: () {
                        // add order then clear cart
                        // the order is not map but it is the list of list , we can make it map cart too
                        // so we have to create a OrderItem first


                        cartlist.clear();
                        Navigator.of(context).pushReplacementNamed(ProductOrder.routeName);
                      },
                    )
                  ],
                ),
              ),
            ),
            // listview make error since it cannot decide how much height they need in in column
            Expanded(
              child: ListView.builder(
                  itemCount: cartlist.amount,
                  itemBuilder: (context, index) {
                    return CartItem(cartmap.values.toList()[index]);
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}