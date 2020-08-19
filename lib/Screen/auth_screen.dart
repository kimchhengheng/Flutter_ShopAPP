import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/auth.dart';
import 'dart:math';

import '../Screen/products_overview_screen.dart';


class AuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient( // linear gradient cannot assign to color
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(

            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // the top logo
                  // auth card
                  Flexible(
                    child: Container(
                      child: Text(
                        "Shop App",
                        style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'Anton',
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: 20),
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.orange,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2), // blur radiua and spread radius constructor
                          )
                        ],
                      ),
                      transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0 , 0.0 ),
                      /// .. like first you assigne the Matrix4.rotationZ(-8 * pi / 180) then operation translate(-10,0) apply on it but return Matrix4 value not the from the translate
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.height>600 ?2:1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

enum AuthMode { Signup, Login}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _form = GlobalKey<FormState>();
  final _pwfnode= FocusNode();
  var _passwordcontroller= TextEditingController();
  var _authMode = AuthMode.Login;
  var _inputData = {
    "email": "",
    "password": ""
  };

 @override
  void dispose() {
    // TODO: implement dispose
    _pwfnode.dispose();
    _passwordcontroller.dispose();

    super.dispose();
  }

  void toggleButton(){
   if(_authMode == AuthMode.Signup){
     setState(() {
       _form.currentState.reset();
       _passwordcontroller.clear();
       _authMode = AuthMode.Login;
     });
   }
   else{
     setState(() {
       _form.currentState.reset();
       _passwordcontroller.clear();
       _authMode = AuthMode.Signup;
     });
   }
  }

  Future<void> _saveform() async{
      bool isvalid=  _form.currentState.validate();
      if(!isvalid)
        return ;
      _form.currentState.save();
      if(_authMode == AuthMode.Login){
        // because sign in return the method so .signIn would call the method that is returning
        Provider.of<Auth>(context, listen: false).signIn(_inputData['email'], _inputData['password']);
      }
      else{
        Provider.of<Auth>(context, listen: false).signUp(_inputData['email'], _inputData['password']);
      }

  }
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints: BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(10),
        child: Form(

          key: _form,
          child: SingleChildScrollView(
            child: Column(

              children: [
                TextFormField(
                  initialValue: "",
                  decoration: InputDecoration(
//                    icon: Icon(Icons.email),
                    labelText: "Email",
                  ),
                  validator: (value) {
                    if(!value.contains("@"))
                      return "Invalid Email";
                    return null;
                  },
                  onSaved: (value){
                    _inputData['email']=value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {//soft keyboard submit
                    FocusScope.of(context).requestFocus(_pwfnode);
                  },
                ),
                TextFormField(
                  focusNode: _pwfnode,
                  decoration: InputDecoration(

                    labelText: "Password",
                  ),
                  validator: (value) {
                    if(value.length< 6 )
                      return "The password is too short";
                    return null;
                  },
                  onSaved: (value){
                    _inputData['password']=value;
                  },
                  obscureText: true,
                  controller: _passwordcontroller,
                ),
                // in case sign up we have to confirm the password
                if(_authMode == AuthMode.Signup)
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                    ),
                    validator: (value) {
                      if(value != _passwordcontroller.text)
                        return "Password not match";
                      return null;
                    },
//                  onSaved: (value){},

                  ),

                // need two button want to sign in sign up one to switch
                SizedBox(height: 10,),
                RaisedButton(// should be call the same function of onField sumit
                  child: _authMode == AuthMode.Signup ? Text('Sign Up'): Text("Log In"),
                  onPressed: () {_saveform();},
                  textColor: Theme.of(context).primaryColor,
                ),
                FlatButton(
                  child: Text(' ${_authMode == AuthMode.Signup? 'Log In': 'Sign Up'} INSTEAD') ,
                  onPressed: () {toggleButton();},// toggle the sign in sign up ,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
