

import 'dart:io';

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
    final scafold = Scaffold.of(context);


    final products = Provider.of<Products>(context, listen: false);
    Product prod = products.getProductbyID(productid);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage:FileImage(File(prod.imageUrl)),

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
                  onPressed: () async {
                    CartItem itemtoremove = Provider.of<CartList>(context, listen: false).getCartItem(productid);
//                    print(itemtoremove.title);
                    if(itemtoremove != null){
                      Provider.of<CartList>(context, listen: false).removeCartItem(productid);
                    }
                    try {

                      await Provider.of<Products>(context, listen: false).deleteProduct(productid);


                    // cannot find the problem why cannot remove from cartlist
//                      try{
                      // Provider.of<CartList>(context).removeCartItem(productid);

//                      }
//                      catch(error){
//                        print('cannot remove the cartitem');
//                      }


                    }
                    catch(error){
                      Provider.of<CartList>(context, listen: false).addItem(productid, itemtoremove.title, itemtoremove.price, itemtoremove.quantity);
                      scafold.showSnackBar(
                          SnackBar(
                            content: Text("Cannot delete", textAlign: TextAlign.center,),
                          ));
                      // the scafold does not working
                    //  element tree is no longer stable
                    }



                  }
                    // delete from the provider, allow delete from the cartlist


                ),

          ],
    ), 
      

    );
  }
}
