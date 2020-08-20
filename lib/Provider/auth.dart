
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/Model/http_error.dart';
import 'package:shop_app/Screen/products_overview_screen.dart';

/// execute fuction then return is not the same with return the function, if we execute , there is an automatic future return
/// but if you return the function it mean you return the reference to that function the one calling can store and or execute it


class Auth with ChangeNotifier{
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _authtimer;

  String get token {
    if(_token !=null && _expireDate.isAfter(DateTime.now()) && _userId !=null)
      return _token;
    return null;
  }

  String get userId {
    if(_userId!=null)
      return _userId;
    return null;
  }

  Future<void> authenticate(String email, String password, String urlSegment) async {
//    print("notify listener autheticate so cosumer should rebuild");

    final url = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyAefo1XWpHxm7Iyq0flnmYK6tbHRu4r3PQ';

    try {
      var response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }));
      final responseData = json.decode(response.body) as Map<String , dynamic>;

// veritypasswork and sigu up new user would return the same token
//      print(responseData);
      if(responseData.containsKey('error')) throw HttpError(responseData['error']['message']);
      _token= responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      // store in device memoery so every time can access even we restart the app
      _autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expireDate': _expireDate.toIso8601String(),
      });
      //set the timer with the time get in the responseData
      prefs.setString('userData', userData);
    }
    catch(error){
      print('auth');
      print(error);
    }


  }
  bool isAuth() {
  // shorthand _token !=null;
    if (_token ==null )
      return false;
    return true;
  }

  //when we need to wait for it finish like communicate with back end used async/await or then
  Future<void> signUp(String email, String password) async{
      return authenticate(email, password, 'signupNewUser');
  }
  Future<void> signIn(String email, String password) async{

    return authenticate(email, password, 'verifyPassword');

  }
  Future<bool> autoLogin() async{
//    print("Future of future builder before await");
    final prefs = await SharedPreferences.getInstance();
//    print('after await');
//    print(prefs.containsKey('userData'));
    if(!prefs.containsKey('userData'))
      return false ;
    final userData = json.decode(prefs.getString("userData")) as Map<String, Object> ;
    // we have to check expiredate first
    final expired = DateTime.parse( userData['expireDate']);
    if(expired.isBefore(DateTime.now()))
      return false;
    _token = userData['token'];
    _userId = userData['userId'];
    _expireDate =expired;
    _autoLogout();
//    print('auto login');
    notifyListeners();
  }
  // logout
  Future<void> Logout() async{

    _token = null;
    _expireDate =null;
    _userId = null;
    if (_authtimer != null) {
      _authtimer.cancel();
      ///canel , you stop the timer and prevent the registered callback to be called (or be called anymore for periodic timers).
      _authtimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear(); // when user logout we clear the share ref
  }
  // autologout after 1 hour

  void _autoLogout(){
    /// when we left the app not log out when we came back we have to set a new timer
    /// For example we set time 10 second to logout then we left the app without log out after 5 second we come back so the timer still 10 which is not correct
    /// flutter run is liked reinstall the app but in reality we can quit app and comeback with the data there
    if(_authtimer!=null){
      _authtimer.cancel();
    }
    final timertime = _expireDate.difference(DateTime.now()).inSeconds;
    _authtimer = Timer(Duration(seconds: timertime) , Logout);
  }


}