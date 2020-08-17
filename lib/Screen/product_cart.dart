import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import '../Provider/Products.dart';

import '../Provider/Order.dart';
import '../Provider/Cart.dart' ;

import '../Screen/product_order.dart';

import '../Widget/cart_item.dart' as cartIS;

// we want disable and loading when we send order

// now delete the product does not delete in the cartlist

class ProductCart extends StatelessWidget {
  static String routeName = "/cart";
  
  
  
  


  @override
  Widget build(BuildContext context) {
    var cartlist = Provider.of<CartList>(context);
    var cartmap= cartlist.cartlist;

//    var scafold = Scaffold.of(context);
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
                    OrderButton(cart: cartlist),
                  ],
                ),
              ),
            ),
            // listview make error since it cannot decide how much height they need in in column
            Expanded(
              child: ListView.builder(
                  itemCount: cartlist.amount,
                  itemBuilder: (context, index) {

                    return cartIS.CartItem(
                    cartmap.values.toList()[index].id, // this take the list of all the value, index 0 is the cartitem 0
                    cartmap.keys.toList()[index],
                    cartmap.values.toList()[index].price,
                    cartmap.values.toList()[index].quantity,
                    cartmap.values.toList()[index].title
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final CartList cart;

  OrderButton( {Key key,
      @required this.cart,
    }) : super(key: key);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {


  void ordernow(){

  }

  @override
  Widget build(BuildContext context) {
    
    return FlatButton(
      child: Text("Order Now", style: TextStyle(color: Theme.of(context).primaryColorDark),),
      onPressed: widget.cart.amount == 0 ? null : () async{
        // we can try catch to make sure it add already no problem happend during send http request
        await Provider.of<OrdersList>(context, listen: false).addOrder(widget.cart.cartlist.values.toList(),widget.cart.totalPrice );
        
       
        widget.cart.clear();
        Navigator.of(context).pushReplacementNamed(ProductOrder.routeName);
      },
        // add order then clear cart
//                      orders is list of orderItem, orderitem have unique id total amount price, list of map quantity and product , datetime
        // do we have check carte is empty?




    );
  }
}


//void orderNow() {
//  if(cartmap.isNotEmpty){
//
//  }
//  else {
//    showDialog(
//      context: context,
//      builder: (context) {
//        return AlertDialog(
//          content: Text("cannot make the order"),
//          actions: [
//            FlatButton(
//              child: Text("okay"),
//              onPressed: (){
//                Navigator.of(context).pop();
//              },
//            )
//          ],);
//      },
//    );
//                          scafold.showSnackBar(
//                            SnackBar(
//                              content: Text("The cart is empty cannot proceed order"),
//                            )
//                          );
//  }
//}
