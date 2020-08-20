import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/auth.dart';
import '../Provider/Cart.dart';
import '../Screen/product_detail_screen.dart';
import '../Provider/Product.dart';

class ProductItem extends StatelessWidget {

//  final Product ele;
//
//  ProductItem(this.ele);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cartlist = Provider.of<CartList>(context, listen: false);
    final authData = Provider.of<Auth>(context,listen: false);
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: {'id': product.id} );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(product.imageUrl, fit: BoxFit.fill,)
        ),
      ),
      footer: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTileBar(
          backgroundColor: Colors.black54,
          leading:IconButton(
            icon: Icon(product.isFavorite? Icons.favorite: Icons.favorite_border,
              color: Theme.of(context).primaryColorLight,),
            onPressed: () {
              product.toggleFavorite(authData.userId,authData.token);
            },
          ),
//          the place that need to rebuilt is the fav icon so we can make it consumer only this
          title: Text(product.title) ,
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart, color: Theme.of(context).primaryColorLight),
            onPressed: () {
              // should show dialog and undo
              cartlist.addItem(product.id, product.title, product.price);
              // this go the nearest scafold
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Items add to the cart"),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cartlist.undoAddItem(product.id);
                    },
                  ),
                )
              );

            },
          ),
        ),
      )

    );
  }
}
