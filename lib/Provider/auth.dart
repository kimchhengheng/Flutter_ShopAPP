import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/Model/http_error.dart';

/// execute fuction then return is not the same with return the function, if we execute , there is an automatic future return
/// but if you return the function it mean you return the reference to that function the one calling can store and or execute it


class Auth with ChangeNotifier{
  String _token;
  DateTime _expireDate;
  String _userId;


  Future<void> authenticate(String email, String password, String urlSegment) async {
    final url = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyAefo1XWpHxm7Iyq0flnmYK6tbHRu4r3PQ';
    try {
      var response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }));
      final responseData = json.decode(response.body) as Map<String , dynamic>;
// veritypasswork and sigu up new user would return the smae token
      if(responseData.containsKey('error')) throw HttpError(responseData['error']['message']);
      _token= responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(Duration(milliseconds:responseData['expiresIn'] ));


    }
    catch(error){
      print(error);
    }

    notifyListeners();
  }


  //when we need to wait for it finish like communicate with back end used async/await or then
  Future<void> signUp(String email, String password) async{
      return authenticate(email, password, 'signupNewUser');
  }
  Future<void> signIn(String email, String password) async{
    return authenticate(email, password, 'verifyPassword');

  }
}