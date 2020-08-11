import 'package:flutter/material.dart';
import 'package:shop_app/Provider/Product.dart';


class OrderItem {
  final String id;
  final double amount;
  final Map<int, Product> products;
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
    return [..._orderlist];
  }
  void addOrder(OrderItem item){
    _orderlist.insert(0, item);
    notifyListeners();
  }
}