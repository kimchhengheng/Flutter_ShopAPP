
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/Order.dart';

import 'Screen/splash_screen.dart';
import 'Screen/auth_screen.dart';
import 'Screen/product_cart.dart';
import 'Screen/product_detail_screen.dart';
import 'Screen/product_order.dart';
import 'Screen/products_overview_screen.dart';
import 'Screen/user_product_screen.dart';
import 'Screen/edit_add_screen.dart';

import 'Provider/Products.dart';
import 'Provider/Cart.dart';
import 'Provider/Order.dart';
import 'Provider/auth.dart';

// to avoid keyboard overlap we can use two way one handle the botton insect , another is use resize bottom insect in scafold because every keyboard open the widget screen would rebuild
// future builder have future and builder
/// these widget would start with future, which all some function, in that function the code execute line by line when they see await they code after that cannot execute, waiting for that line to finish
/// so it would go to builder when code in builder finish it go back to future await
/// then when the code in future function call is finish it go the builder again
/// Future build 1 go to future then await, 2 go to builder when builder finish 3 go to future again when future is finish 4 go to buiilder again
///
/// ProxyProvider is a provider that combines multiple values from other providers into a new object, and sends the result to Provider.
//
//That new object will then be updated whenever one of the providers it depends on updates.
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
//    print('main build');
    // if we make ChangeNotifierProvider within the material app the route will be disposed it cannot go back
    return MultiProvider(

      providers: [
        ChangeNotifierProvider<Auth>(create:  (ctx) => Auth(),),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousData) {
            return Products(
                auth.token,
                auth.userId,
                previousData == null ? [] : previousData.items);
          },
        ),
        ChangeNotifierProvider<CartList>(create: (ctx) => CartList(),),
        ChangeNotifierProvider<OrdersList>(create: (ctx) => OrdersList(),),
      ],
      child:Consumer<Auth>(
        // when the notifylisten in AUth this cosumer rebuild but not the build of Myapp
        // consumer would rebuild the specific widget avoid the infinite rebuilt of Future
        //  Build a widget tree based on the value from a [Provider<T>]. Provider.of<T>(context) which is the Auth
        builder: (context, auth, _) {
//          print("cosumer auth build");
          return MaterialApp(

            theme: ThemeData(
              primarySwatch: Colors.pink,
              accentColor: Colors.red,

            ),
            // when we save to share ref even we flutter run the login in still work since it save the memory device
            // we check if the auth is login or not , then if they do not login we should check if we have data in disk since after we refresh the app remove the cache the memory of app is clear so they can store the previous value,
            // the sharepref only remove when we logoout
            home: auth.isAuth() ? ProductsOverviewScreen():
                FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (context, snapshot) {
//                    print('futurebuilder builder ');
                    return snapshot.connectionState == ConnectionState.waiting ? SplashScreen() :AuthScreen();
                  },
                ),

            routes: {
//            '/' : (ctx) => ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              ProductCart.routeName: (ctx) => ProductCart(),
              ProductOrder.routeName: (ctx) => ProductOrder(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditAddScreen.routeName: (ctx) => EditAddScreen(),
            },
          );
        },
      )
    );
  }
}