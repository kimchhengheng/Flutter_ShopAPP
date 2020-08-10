
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screen/product_detail_screen.dart';
import 'package:shop_app/Screen/products_overview_screen.dart';

import './Provider/Products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // if we make ChangeNotifierProvider within the material app the route will be disposed it cannot go back
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(

        theme: ThemeData(
          primarySwatch: Colors.cyan,
//        accentColor: Colors.limeAccent,

        ),

          routes: {
            '/' : (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),

          },
      ),
    );
  }
}