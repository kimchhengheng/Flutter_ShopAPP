import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: [PopupMenuButton<displaySelection>(
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
        ), ]
      ),
      body: ProductGrid(isfav),
      // this would create the grid view that each of it just called the item
    );
  }
}
