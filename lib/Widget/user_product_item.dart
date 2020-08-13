

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Cart.dart';

import '../Screen/edit_add_screen.dart';

import '../Provider/Products.dart';
import '../Provider/Product.dart';

class UserProductItem extends StatelessWidget {
  final String productid;

  UserProductItem(this.productid);

  @override
  Widget build(BuildContext context) {
    var cartlist = Provider.of<CartList>(context);
    final products = Provider.of<Products>(context, listen: false);
    Product prod = products.getProductbyID(productid);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(prod.imageUrl),
      ),
      title: Text(prod.title),
      subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(prod.description, overflow: TextOverflow.ellipsis,),
            Text('Price: \$ ${prod.price}')
          ],

      ),
      // trailing will take infinite width so with the row it make error
      // expanded make it expand the width not strink the remaining width
      trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () {
                  // go to edit page
                  Navigator.of(context).pushNamed(EditAddScreen.routeName , arguments: productid);
                },
              ),

              IconButton(
                  icon: Icon(Icons.delete, color: Theme.of(context).primaryColor,),
                  onPressed: () {
                    // delete from the provider, allow delete from the cartlist
                    products.deleteProduct(productid);
                    cartlist.removeCartItem(productid);
                  },
                ),

          ],
    ), 
      

    );
  }
}