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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
                tag: "${routeArg['id']}",
                child: Image.network(prod.imageUrl, fit: BoxFit.cover, height: 255, width: double.infinity,)),
            Text("\$ ${prod.price}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple),),
            Text(prod.description,  style: TextStyle(fontSize: 25, color: Colors.deepPurple,),textAlign: TextAlign.center,),
          ],
        ),
      )
    );

  }
}
