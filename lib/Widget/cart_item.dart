import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import '../Provider/Products.dart';

import '../Provider/Cart.dart';
//import '../Provider/Cart.dart' as ci;

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
      this.id,
      this.productId,
      this.price,
      this.quantity,
      this.title,
      );


  Widget getContainer(bool delete){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: delete? Colors.red: Colors.green,
      ),
      alignment: delete? Alignment.centerRight: Alignment.centerLeft,
      padding:delete? EdgeInsets.only(right : 15):EdgeInsets.only(left : 15) ,
      child:delete?Icon(Icons.delete): Icon(Icons.add),
    );
  }


  @override
  Widget build(BuildContext context) {
    var cartlist = Provider.of<CartList>(context);
//    var products = Provider.of<Products>(context);
    // display the picture, title  , quantiy , price
    return Dismissible(
      key: ValueKey(DateTime.now()),// the key have to be unique, when i increase by swipe to the right make used the same key so it not working 
// if only background apply to both
    // if secondary exist  , background slide to the right and secondary slide to the left
      background: getContainer(false) ,
      secondaryBackground: getContainer(true),
//      direction: DismissDirection.endToStart,
//      direction is enum type we can check the type to make sure two different type of dimiss but the background
      // in confirm if return false ondimiss will not run
      confirmDismiss: (direction) {
        bool condel = direction == DismissDirection.endToStart;
        return showDialog(
          context: context,
          builder: (context) {
              return AlertDialog(
                title:  Text("Are you sure?"),
                content: condel? Text("You want to delete!"): Text("You want to add one more!"),
                actions: [
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      // pop return value as future only when it is clicked
                      Navigator.of(context).pop(true);
                    },
                  ),
                  FlatButton(
                    child: Text("No"),
                    onPressed: () {
                      // pop return value as future only when it is clicked
                      Navigator.of(context).pop(false);
                    },
                  )

               ],
                );
              }
        );
      },
      onDismissed: (direction) {
        bool del = direction == DismissDirection.endToStart;
        if(del){
          cartlist.removeCartItem(productId);
        }
        else{
          cartlist.addItem(productId,title,price);
        }
        // remove the whole product from the list

      },
      child: Card(
        elevation: 3,
        child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).primaryColorLight,
              child: FittedBox(
                child: Text("\$ ${(quantity * price *1.0).toStringAsFixed(2)}"),
              ),
            ),
            title: Text(title) ,
            trailing:
                  Text('$quantity X $price'),
        ),
      ),
    );
  }


}
