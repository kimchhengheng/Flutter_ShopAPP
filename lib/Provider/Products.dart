import 'package:flutter/material.dart';
import 'Product.dart';
// provider is like a place where every widget can access the resource so we do not need to pass it back and forth
// also when the value of it change we can notify all that listen to update there value or not change is depend on you
// if we use stateful widget it would affect only one widget does not affect the other
// provider is like producer, first we have to create Provider class then declare which widget will be the provider by the ChangeNotifyProvider ,
// in create key of this widget it declare which instance will be the provider so the child and child of child, can retrieve the data without passing through constructor
class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
//    _items;this would return the reference lead to data leak
    return [..._items]; // this mean make another list by taking the list extract one level outside
  }
  List<Product> get onlyFavorite{
    return _items.where((prod) => prod.isFavorite).toList();
  }
  Product getProductbyID(String id){
    return _items.firstWhere((prod) => prod.id == id);
  }
  //add product
  void add (){
    // when we add a product we have to notify all the widget that using Products object that it has been change
    notifyListeners();
  }
  // remove prod

}