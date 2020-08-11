import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Order.dart';
import '../Provider/Cart.dart' ;

import '../Screen/product_order.dart';

import '../Widget/cart_item.dart' as cartIS;




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
//                      orders is list of orderItem, orderitem have unique id total amount price, list of map quantity and product , datetime
                      // do we have check carte is empty?
                        if(cartmap.isNotEmpty){
                          List<Map<String, Object>> prods=[];
                          cartmap.values.toList().forEach((cartit) {
                            prods.insert(0, {'quantity': cartit.quantity, 'product': cartit.product});
                          });
                          order.addOrder(OrderItem(id: DateTime.now().toString(), products: prods,dateTime: DateTime.now(), amount: cartlist.totalPrice));
                          cartlist.clear();
                          Navigator.of(context).pushReplacementNamed(ProductOrder.routeName);
                        }
                        else {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text("The cart is empty cannot proceed order"),
                            )
                          );
                        }


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
                    return cartIS.CartItem(cartmap.values.toList()[index]);
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}