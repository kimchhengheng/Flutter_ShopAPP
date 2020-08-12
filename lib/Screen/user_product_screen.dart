// this would display all the available product to user edit delete add
// list view of the user_product_item

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widget/app_drawer.dart';

import '../Provider/Products.dart';
import '../Provider/Product.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = "/user-product";
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("User Product"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index) {},),
    );
  }
}
