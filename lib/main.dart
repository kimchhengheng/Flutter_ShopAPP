
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/Order.dart';


import 'Screen/product_cart.dart';
import 'Screen/product_detail_screen.dart';
import 'Screen/product_order.dart';
import 'Screen/products_overview_screen.dart';
import 'Screen/user_product_screen.dart';
import 'Screen/edit_add_screen.dart';

import 'Provider/Products.dart';
import 'Provider/Cart.dart';
import 'Provider/Order.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // if we make ChangeNotifierProvider within the material app the route will be disposed it cannot go back
    return MultiProvider(

      providers: [
        ChangeNotifierProvider<Products>(create: (ctx) => Products(),),
        ChangeNotifierProvider<CartList>(create: (ctx) => CartList(),),
        ChangeNotifierProvider<OrdersList>(create: (ctx) => OrdersList(),),
      ],
      child: MaterialApp(

        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.red,

        ),

          routes: {
            '/' : (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            ProductCart.routeName: (ctx) => ProductCart(),
            ProductOrder.routeName: (ctx) => ProductOrder(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditAddScreen.routeName: (ctx) => EditAddScreen(),
          },
      ),
    );
  }
}