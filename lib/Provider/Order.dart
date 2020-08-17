import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Model/http_error.dart';
import 'dart:convert';

import 'package:shop_app/Provider/Cart.dart';



class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
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
  Future<void> fetchAndSetupOrder() async {
    final url = 'https://shopapp-7d685.firebaseio.com/order.json';
    try{
      final response =await http.get(url);
      final responseData = json.decode(response.body) as Map<String , dynamic>;
      // flutter does not accept Map of Map
      List<OrderItem> orderlist = [];
      responseData.forEach((orderId, orderData) {
        // you dont need to acess through responseData since it is key value pair iteration already
//        print(productData['price'].runtimeType); string not double
      print(orderData['products']);});
//        orderlist.add(OrderItem(
//            id: orderId,
//            amount: orderData['amount'],
//            dateTime: orderData['datetime'],
//            products: orderData['products'].map((){
//
//            })
//        ));

//      });
//      _orderlist = orderlist;
//
//      notifyListeners();

    }
    catch(error){
      print(error);
    }
  }

// order you gonna add and retrie
  Future<void> addOrder(List<CartItem> cartitem, double amount) async{
    // we should add to the db
    final url = 'https://shopapp-7d685.firebaseio.com/order.json';
    final timestamp = DateTime.now();
    try{
      // json encode does not understand the object so we have to create map instead of passing the object cartitem
      final response = await http.post(url, body: json.encode({
          'amount': amount,
          'datetime': timestamp.toIso8601String(), // without to Iso cannot send to db
          'products': cartitem.map( (citem) {
              return {
                'id': citem.id,
                'title': citem.title,
                'quantity': citem.quantity,
                'product': citem.price,
              };
          }).toList(),
      }));

      if(response.statusCode >=400) throw HttpError("cannot add order");
//      print(json.decode(response.body));
      _orderlist.insert(0, OrderItem(
          id: json.decode(response.body)['name'],
          amount: amount,
          products: cartitem,
          dateTime: timestamp));
    }
    catch(error){
      print('catch');
    }

//    _orderlist.insert(0, );
    notifyListeners();
  }
}