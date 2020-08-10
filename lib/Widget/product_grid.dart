import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widget/product_item.dart';
import '../Provider/Products.dart';


class ProductGrid extends StatelessWidget {
  bool showFavourite;

  ProductGrid(this.showFavourite);

  @override
  Widget build(BuildContext context) {
    // to get the list of product from the provider we have to declare on level up of this
    final productlist=showFavourite? Provider.of<Products>(context).onlyFavorite : Provider.of<Products>(context).items;
//    print(productlist);
    // i think add and remove sould change the value here ,
    return GridView.builder(
        padding: EdgeInsets.all(15),
        itemCount: productlist.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,// fixed size of cross axis and 2 in one row
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3/2
        ),
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
              value: productlist[index] ,
              child: ProductItem()
              // the nested provider make widget provider reused, so the route cannot find after it come back, the data attach to widget change then widget reuse
//            .value make them detach and attach the data not changing , should be use on single list of grid or view so it would even it come back, .value existing ChangeNotifier:
//          .value make sure provider will work even the value is change , handle the widget recycle
          );
        },);
  }
}
