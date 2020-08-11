import 'package:flutter/material.dart';

import '../Screen/product_order.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text("Shop App", textAlign: TextAlign.center, style: TextStyle(fontSize: 35),),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text("Shops"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context).pushNamed(ProductOrder.routeName);
            },
          ),
          Divider(),
      ],
    )

    );
  }
}
