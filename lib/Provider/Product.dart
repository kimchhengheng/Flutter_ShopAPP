import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/Model/http_error.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false});

  Future<void> toggleFavorite() async{
    //handle the change of fav to the db
    final url = 'https://shopapp-7d685.firebaseio.com/product/$id.json';
//    print(url);
    bool prevfav = isFavorite;
    isFavorite=!isFavorite;
//    print(isFavorite);
    try{
      final response = await http.patch(url, body: json.encode({
        'isFavorite': isFavorite
      }));
      if(response.statusCode >= 400) throw HttpError("cannot change the value");
      notifyListeners();
    }
    catch(_){
      isFavorite=prevfav;
      notifyListeners();
    }

  }
}