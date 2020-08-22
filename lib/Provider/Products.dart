import 'package:flutter/material.dart';
import 'package:shop_app/Model/http_error.dart';
import 'Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// provider is like a place where every widget can access the resource so we do not need to pass it back and forth
// also when the value of it change we can notify all that listen to update there value or not change is depend on you
// if we use stateful widget it would affect only one widget does not affect the other
// provider is like producer, first we have to create Provider class then declare which widget will be the provider by the ChangeNotifyProvider ,
// in create key of this widget it declare which instance will be the provider so the child and child of child, can retrieve the data without passing through constructor
class Products with ChangeNotifier {
  final String token;
  final String userId;
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];


  Products(this.token, this.userId, this._items);

  List<Product> get items {
//    _items;this would return the reference lead to data leak
    return [..._items]; // this mean make another list by taking the list extract one level outside
  }
  // should have the fetch from database when the pull to refresh for product edit  and init for shop
  Future<void> fetchAndSetProduct([bool filterprod=false]) async {
//filter the product and alternate fecth

    // we have to change the rule in realtime firebase if you want to filter it , simply adding the "products" : { ".indexOn": [ "createor"]
    // i think it mean in products go one level deeper and indexOn creator but products is likest of productId and another map inside that map have creator
//    var filterurl = "";
//    if(filterprod){
//      filterurl = 'orderBy="creator"&equalTo="$userId"'; orderBy="creatorId"&equalTo="$userId"
//    } short hand
//    print(filterprod);
    final filterurl= filterprod ? 'orderBy="creator"&equalTo="$userId"': ''; // for orderby to work we have to add index on in rule firebase
//    print(filterurl);
    var url = 'https://shopapp-7d685.firebaseio.com/product.json?auth=$token&$filterurl';
    // we have to wait until get every from the database so we need async await
    try{
      final response =await http.get(url);
      final responseData = json.decode(response.body) as Map<String , dynamic>;
      // flutter does not accept Map of Map
//      print(responseData);
      List<Product> productlist = [];
      url = 'https://shopapp-7d685.firebaseio.com/Favourite/$userId.json?auth=$token';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body) as Map<String , dynamic>;
//      print(responseData);
      if(responseData == null || responseData.containsKey('error'))
        return ;
//      print(favoriteData['id']); if the map does not have the key return null ?? question mean if null
      responseData.forEach((productId, productData) {
        // you dont need to acess through responseData since it is key value pair iteration already
//        print(productData['price'].runtimeType); string not double

        productlist.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: double.parse(productData['price']),
            imageUrl:productData['imageUrl'],
            isFavorite: favoriteData == null ? false : favoriteData[productId] ?? false,
        )
        );

        // this expression is favoriteData is empty make isFavorite false then if favoriteData is not empty try to check the with the product key (when product doesnot exist it would return null ) so assign to false too
      });
//      print('after');
      _items = productlist;

      notifyListeners();

    }
    catch(error){
      print(error);
      print('fechtand setup');
    }

  }

  List<Product> get onlyFavorite{
    return _items.where((prod) => prod.isFavorite).toList();
  }
  Product getProductbyID(String id){
    // should we check the _items empty or not
    return _items.firstWhere((prod) => prod.id == id);
    // first where return the element
  }
  Future<void> updateProduct(Map<String, Object> product) async{
    final url = 'https://shopapp-7d685.firebaseio.com/product/${product['id']}.json?auth=$token';
    int proInd = _items.indexWhere((prod) {return prod.id == product['id'];});
    if(proInd >=0){
      var response = await http.patch(url, body: json.encode({
                'title': product['title'],
                'price':product['price'] ,
                'description': product['description'] ,
                'imageUrl': product['imageUrl'],
              }));
      if(response.statusCode>=400) throw HttpError("cannot update");
      _items[proInd]= Product(
        id: product['id'],
        title: product['title'],
        description: product['description'],
        price: double.parse(product['price']),
        imageUrl: product['imageUrl'],
        isFavorite: product['isFavorite'],
      );
      notifyListeners();
    }
       // _items.removeWhere((prod) => prod.id == product['id']);

  }


  //add product
  // Future<void> mean is type future the return type is void which is the value pass to then method
  Future<void> addProduct(Map<String, Object> product) async{
      final url = 'https://shopapp-7d685.firebaseio.com/product.json?auth=$token';
      product['creator']=userId;
      // if there is problem post and get will throw the error automatically but not the patch put and delete
  // the error does not throw and keep execute the code after the error part so handle the exception by ourself
        var response = await http.post(url, body: json.encode(product));

        if(response.statusCode >= 400) {
          throw HttpError("Incomplete action");
        }
//        print(json.decode(response.body)['name']);
//        print(product['title']);
//        print(product['description']);
//        print(product['price']);
//        print(product['imageUrl']);
        _items.add(Product(
            id: json.decode(response.body)['name'],
            title: product['title'],
            description: product['description'],
            price:double.parse(product['price'].toString()) ,
            imageUrl: product['imageUrl'])
        );
        // cannot create the product
        notifyListeners();

      }
//        print(json.decode(response.body));  {name: -MEnh0ICOrGcsOeAk_Yi}





//      print(json.decode(response.body));



    // when we add a product we have to notify all the widget that using Products object that it has been change


  // remove prod
  Future<void> deleteProduct(String produceId) async{
    // we remove the produce first if cannot remove put it back

    final url = 'https://shopapp-7d685.firebaseio.com/product/$produceId.json?auth=$token';
//    _items.forEach((element) {
//      if(element.id == produceId)
//        print(element.id);});
    int deleteProInd = _items.indexWhere((prod) {return prod.id == produceId;});

    Product delpro= _items.removeAt(deleteProInd);
    notifyListeners();
    // if we dont notifylistener the product grid will try to access the one that we have delete
    var response = await http.delete(url);
    if(response.statusCode >=400) {
      _items.insert(deleteProInd, delpro);
      notifyListeners();
      throw HttpError("Cannot delete");
    }
    deleteProInd = null;




//    if(_items.isNotEmpty){
//      _items.removeWhere((prod) =>prod.id == produceId );
//    }


  }

}