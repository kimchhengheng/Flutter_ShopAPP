import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Products.dart';
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
  bool _firstinit =true;
  bool _isloading = false;


  @override
  void didChangeDependencies() {
   if(_firstinit){
     setState(() {
//       print("loading true");
       _isloading= true;
     });
     // so if we not wait for the frecht to finish the setstate gonna execute before the that
     Provider.of<Products>(context, listen: false).fetchAndSetProduct().then((_) {
//          print("finish fetch ");

       setState(() {
//          print("loading true");
         _isloading=false;
       });
     });


   }
    _firstinit=false;
    super.didChangeDependencies();
  }

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
      body: _isloading? Center(
        child: CircularProgressIndicator(),
      ): ProductGrid(isfav),
      // this would create the grid view that each of it just called the item
    );
  }
}
