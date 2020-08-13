// this would display all the available product to user edit delete add
// list view of the user_product_item

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widget/app_drawer.dart';
import '../Widget/user_product_item.dart';

import '../Screen/edit_add_screen.dart';

import '../Provider/Products.dart';
import '../Provider/Product.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = "/user-product";
  @override
  Widget build(BuildContext context) {
    final List<Product> products = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text("User Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.of(context).pushNamed(EditAddScreen.routeName );
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return UserProductItem(products[index].id);
        },),
    );
  }
}
