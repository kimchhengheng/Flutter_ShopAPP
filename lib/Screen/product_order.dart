import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../Provider/Order.dart';
import '../Widget/app_drawer.dart';
import '../Widget/order_item.dart' as orderIS;

class ProductOrder extends StatelessWidget {
  static String routeName = "/order";
// there are two way to fetch and excute product from db, one used stateful widget did change dependency, two used Future Builder
//  we have to make build and future build are not happend at the same time to avoid the inifintely call and rebuild
//  Future builder can use it when you have a future, to display one thing while you are waiting for it (for example a progress indicator) and another thing when it's done (for example the result).
 ///Future builder:  Creates a widget that builds itself based on the latest snapshot of interaction with a [Future].

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(title: Text("Ordered"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: Provider.of<OrdersList>(context, listen: false).fetchAndSetupOrder(),
          /// when future(async take time to finish, would excute last) finish the builder method would rebuild it self, rebuild only the Future Builder not the parent widget
          /// in future builder, it calls the future function to wait for the result, and as soon as it produces the result it calls the builder function where we build the widget.
          /// If the future is created at the same time as the FutureBuilder, then every time the FutureBuilder's parent is rebuilt(setState or stage change), the asynchronous task will be restarted.
            builder:(context, snapshotData) {
              if(snapshotData.connectionState == ConnectionState.waiting)
                return Center(child:CircularProgressIndicator() ,);
              else{
                if(snapshotData.error !=null )// it has error
                  return Center(child: Text("Error Occured"),);
                else
                  return Consumer<OrdersList> (// consumer would rebuit only the specific widget not the whole stafeful or stateless
                    builder: (context, value, _) {
                       return ListView.builder(
                            itemCount: Provider.of<OrdersList>(context).orderlist.length ,
                            itemBuilder: (context, ind) {
                              return orderIS.OrderItem(Provider.of<OrdersList>(context).orderlist[ind]);
                            }, // if we dont used consumer the rebuild and build method would run infinitely loop
                       );   //
                      }
                    );
                      }
                    },
              )


    );
  }
}
