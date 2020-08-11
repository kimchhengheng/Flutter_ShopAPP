
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Provider/Product.dart';
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
  final List<Map<String, Object>> orditemlist;

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
                    ...orditemlist.map( (ele) {
                      Product pro= ele['product'];
                      int quan = ele['quantity'];
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(pro.imageUrl),
                            ),
                            Text('$quan X ${pro.price}'),
                            Text('Total: \$ ${(quan*pro.price*1.0).toStringAsFixed(2)} ')
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

