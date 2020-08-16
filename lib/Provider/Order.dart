import 'package:flutter/material.dart';



class OrderItem {
  final String id;
  final double amount;
  final List<Map<String,Object>> products;
  final DateTime dateTime;

  OrderItem(
  {
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime
  });
}

class OrdersList with ChangeNotifier {
  List<OrderItem> _orderlist= [];

  List<OrderItem> get orderlist {
    //fetch from the database
    return [..._orderlist];
  }
  void addOrder(OrderItem item){
    // we should add to the db
    _orderlist.insert(0, item);
    notifyListeners();
  }
}