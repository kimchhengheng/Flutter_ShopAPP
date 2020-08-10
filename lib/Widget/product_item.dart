import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screen/product_detail_screen.dart';
import '../Provider/Product.dart';

class ProductItem extends StatelessWidget {

//  final Product ele;
//
//  ProductItem(this.ele);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
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
              product.toggleFavorite();
            },
          ),
          title: Text(product.title) ,
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart, color: Theme.of(context).primaryColorLight),
            onPressed: () {},
          ),
        ),
      )

    );
  }
}
