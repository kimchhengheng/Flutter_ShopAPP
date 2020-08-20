// this would display all the available product to user edit delete add
// list view of the user_product_item

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widget/app_drawer.dart';
import '../Widget/user_product_item.dart';

import '../Screen/edit_add_screen.dart';

import '../Provider/Products.dart';
import '../Provider/Product.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = "/user-product";

  Future<void> refreshhandle(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
//    final List<Product> products = Provider.of<Products>(context, listen: false).items; this make the future builder run infinitely
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
      body:  FutureBuilder(
        future: refreshhandle(context),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)?
             Center(child: CircularProgressIndicator() ,) :
          RefreshIndicator(
            onRefresh: () async{
              refreshhandle(context);
            } ,
            child: Consumer<Products>(
              //(BuildContext context, T value, Widget child)
              builder: (context, productData, _) =>Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: productData.items.length,
                  itemBuilder: (context, index) {
                    return UserProductItem(
                        productData.items[index].id,
                    );
                  },),
              ) ,
//              builder: (ctx, productsData, _) => Padding(
//                padding: EdgeInsets.all(8),
//                child: ListView.builder(
//                  itemCount: productsData.items.length,
//                  itemBuilder: (_, i) => Column(
//                    children: [
//                      UserProductItem(
//                        productsData.items[i].id,
//                        productsData.items[i].title,
//                        productsData.items[i].imageUrl,
//                      ),
//                      Divider(),
//                    ],
//                  ),
//                ),
//              ),
//            ),
            ),
          );
        },

      ),
    );
  }
}
