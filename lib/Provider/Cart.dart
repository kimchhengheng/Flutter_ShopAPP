import 'package:flutter/material.dart';

import 'Product.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  // we can make a change of quantity then we have to make it as provider too to rebuilt widget when increase
  final Product product;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.product
  });
}

class CartList with ChangeNotifier {
  Map<String, CartItem> _cartlist= {};

  CartList ();

  Map<String, CartItem> get cartlist => {..._cartlist} ;

  void addItem(String productId, Product product){
    if(_cartlist.containsKey(productId)){
      // increase the qunatiy_
      _cartlist.update(productId, (oldvalue) {
        return CartItem(id: oldvalue.id,
            title: oldvalue.title,
            product: oldvalue.product,
            quantity: oldvalue.quantity + 1);
      } );
    }
    else {
      // add the new item with productId as the key 
      _cartlist.putIfAbsent(productId, () => CartItem(id: DateTime.now().toString(), title: product.title, product: product, quantity: 1));
    }
    notifyListeners();
  }
  int get amount{
    return _cartlist.length;
  }
  double get totalPrice {
    double total = 0.0;
    _cartlist.forEach((k, v) {
      total += _cartlist[k].quantity * _cartlist[k].product.price;
  });
    return total;
  }
  // this is remove the how quantity
  void removeCartItem(String productId){
    _cartlist.remove(productId);
    notifyListeners();
  }
  // this is just remove only one quantity
  void undoAddItem(String productId){
    int index = _cartlist.keys.toList().indexOf(productId);
    if(_cartlist.values.toList()[index].quantity >1){
      _cartlist.update(productId, (oldvalue) {
        return CartItem(id: oldvalue.id,
            title: oldvalue.title,
            product: oldvalue.product,
            quantity: oldvalue.quantity - 1);
      } );
    }
    else{
      removeCartItem(productId);
    }
  }
  void clear(){
    _cartlist.clear();
    notifyListeners();
  }
}