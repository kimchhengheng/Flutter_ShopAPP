
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/Provider/Cart.dart';

//import '../Provider/Product.dart';
import '../Provider/Order.dart' as OrdPro;

class OrderItem extends StatefulWidget {
  final OrdPro.OrderItem orditem;

  OrderItem(this.orditem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded =false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        child: FittedBox(child: Text("\$ ${widget.orditem.amount.toStringAsFixed(2)}"),),
      ),
      title: Text("Ordered on ${DateFormat("dd/MMM/yy hh:mm").format(widget.orditem.dateTime)}"),
      subtitle: _expanded?
      DisplayExtended(widget.orditem.products)
      : Text(""),
      trailing: IconButton(
        icon: _expanded?Icon(Icons.expand_less): Icon(Icons.expand_more),
        onPressed: (){
          setState(() {
            _expanded = ! _expanded;
          });
        },)
    );

  }
}

class DisplayExtended extends StatelessWidget {
  final List<CartItem> orditemlist;

  DisplayExtended(this.orditemlist);

  @override
  Widget build(BuildContext context) {
    return (Container(
        constraints: BoxConstraints(
        maxHeight: 100,
          ),
          child: SingleChildScrollView(
              child: Column(
                  children: [
                    ...orditemlist.map( (item) {

                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text('${item.quantity} X ${item.price}'),
                            Text('Total: \$ ${(item.quantity*item.price*1.0).toStringAsFixed(2)} ')
                   ]
              );
             }
             )
             ],
              ),
            ),
          )
    );
  }
}

