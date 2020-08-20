import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/auth.dart';

import '../Screen/product_order.dart';
import '../Screen/user_product_screen.dart';

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
              // when you push or push replacement the widget would build regain from scratch init would call again
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
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Product List"),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Log out"),
            onTap: () {
              Provider.of<Auth>(context, listen: false).Logout();
              /// Tried to listen to a value exposed with provider, from outside of the widget tree.
              ///This is likely caused by an event handler (like a button's onPressed) that called
              // Provider.of without passing `listen: false`.
              ///
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/');
            },
          ),
      ],
    )

    );
  }
}
