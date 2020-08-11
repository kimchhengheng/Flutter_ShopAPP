import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Cart.dart';
import '../Screen/product_cart.dart';
import '../Widget/app_drawer.dart';
import '../Widget/product_grid.dart';
// we want to display the favorite only or all but we don't want to affect the provider products we just want for only this screen


enum displaySelection {
  OnlyFavorite,
  All
}
class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool isfav=false;

  @override
  Widget build(BuildContext context) {
    var cartlist = Provider.of<CartList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: [
          PopupMenuButton<displaySelection>(
          onSelected: (value) {
            setState(() {
              if(value == displaySelection.All){
                isfav=false;
              }
              if(value == displaySelection.OnlyFavorite){
                isfav=true;
              }
            });
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("All"),
                value: displaySelection.All ,
              ),
              PopupMenuItem(
                child: Text("Favorite"),
                value: displaySelection.OnlyFavorite,
              )
            ];
          },
          ),
          Badge(
            position: BadgePosition.topRight(top: 10, right : 10),
            badgeContent: Text('${cartlist.amount}', style: TextStyle(fontSize: 10, color: Theme.of(context).primaryColorLight),),
            badgeColor: Theme.of(context).primaryColorDark ,
            animationType: BadgeAnimationType.slide,
            child: IconButton(
              icon: Icon(Icons.shopping_cart,),
              onPressed: () {

                Navigator.of(context).pushNamed(ProductCart.routeName);

              },
            )
          )

        ]
      ),
      drawer: AppDrawer(),
      body: ProductGrid(isfav),
      // this would create the grid view that each of it just called the item
    );
  }
}
