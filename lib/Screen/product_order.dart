import 'package:flutter/material.dart';

class ProductOrder extends StatelessWidget {
  static String routeName = "/order";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text("Ordered"),
        ),
        body: Center(child: Text("order") ),
      ),
    );
  }
}
