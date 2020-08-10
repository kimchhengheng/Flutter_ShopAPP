import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/Products.dart';
import '../Provider/Product.dart';

class ProductDetailScreen extends StatelessWidget {
  static String routeName = "/product-detail";
  @override
  Widget build(BuildContext context) {
    final routeArg = ModalRoute.of(context).settings.arguments as Map<String,String>;
    Product prod = Provider.of<Products>(context, listen: false).getProductbyID(routeArg['id']);
    // we only need data one time not care about the update
    return Scaffold(
      appBar: AppBar(
        title: Text(prod.title),
      ),
      body: Center(
        child: Text("detail screen"),
      )
    );

  }
}
