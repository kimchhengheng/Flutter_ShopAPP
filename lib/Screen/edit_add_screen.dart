// after your click edit or add , we gonna check if the porduct have in the provider or not if yes edit, not add
// we can globalkey to make call all onsave validate of every textformfield
// we need stateful widget for the case that we pass the image url lose context and update preview
// price title despcrition imageurl


//The framework will call this init method exactly once for each State object it creates.
// didchange depency when dependency of the state change

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Products.dart';

class EditAddScreen extends StatefulWidget {
  static String routeName = "/edit-add-product";
  @override
  _EditAddScreenState createState() => _EditAddScreenState();
}
//A FormState object can be used to save, reset, and validate every FormField that is a descendant of the associated Form.
//A key that is unique across the entire app. Global keys uniquely identify elements.
//We need to create a global key to save and get form values at any time and for validating purpose too.
// on saved is An optional method to call with the final value when the form is saved via FormState.save, to get the value
class _EditAddScreenState extends State<EditAddScreen> {
  final _form = GlobalKey<FormState>();
  final _pricefnode = FocusNode();
  final _descripfnode = FocusNode();
  final _imageurlfnode = FocusNode();
  var _imagecontent= TextEditingController();
  bool edit=false;
  bool firstinit = true; // attribute of the class is only one
  Map<String, String> product = {};

  @override
  void initState() {
    // add listener to keeptrack of change focus of image url focus node, we not do in build becuase build are rebuild many time
    _imageurlfnode.addListener(_imageFocus);// notify when gain/ lose focus , add listener mean when focus change it called imageFocus function
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // this call many time not like inite call only one time but inite cannot access the context so used this to access context but make sure it work only one time
    if(firstinit){
      String productId = ModalRoute.of(context).settings.arguments as String;
      var prod=productId!=null? Provider.of<Products>(context, listen: false).getProductbyID(productId): null;
      if(prod !=null){
        product['id']= prod.id;
        product['title'] = prod.title;
        product['price'] = prod.price.toString();
        product['description'] = prod.description;
        product['imageUrl'] = prod.imageUrl;
        product['isFavorite'] = prod.isFavorite.toString();
      }

    }
    firstinit=false;
    super.didChangeDependencies();
  }
  void _imageFocus(){

    print(_imagecontent.text);
    setState(() {

    });
  }
  void _saveForm(){
    _form.currentState.validate();

    _form.currentState.save();// this global key of generic FormState will get the value in onSaved when the on submit is press because i make only a specific place to saved that why not handle each one differently
    print(product);
  }

  @override
  void dispose() {
    _pricefnode.dispose();
    _descripfnode.dispose();
    _imageurlfnode.dispose();
    _imagecontent.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add/ Edit product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
            child: Column(

              children: [

                TextFormField(
                  initialValue: product.isNotEmpty? product['title']: "",
                  decoration: InputDecoration(
                    labelText: "Title",
                  ),
                  onSaved: (value) {
                    product['title']= value;
                  }
                  ,
                  validator: (value) {
                    if(value.isEmpty){
                      return 'Please input the title';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next, // make the nexk on the softkeyboard
                  onFieldSubmitted: (value) {
                    // when we press submit of softkeyboard go to the next focus but we have to decleare the focus node in the textformfield too
                    FocusScope.of(context).requestFocus(_pricefnode);
                  },
                ),
                TextFormField(
                  initialValue: product.isNotEmpty? product['price']: "",
                  focusNode: _pricefnode,
                  decoration: InputDecoration(
                    labelText: "Price",
                  ),
                  onSaved: (value) {
                    product['price']=value;
                  }
                  ,
                  validator: (value) {
                    if(value.isEmpty){
                      return 'Please input the price';
                    }
                    if(double.tryParse(value) == null ){
                      return 'Input value is not double';
                    }
                    if(double.parse(value)<=0){
                      return 'The price has to be larger than 0';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next, // make the nexk on the softkeyboard
                  onFieldSubmitted: (value) {
                    // when we press submit of softkeyboard go the next one
                    FocusScope.of(context).requestFocus(_descripfnode);
                  },
                ),
                TextFormField(
                  initialValue: product.isNotEmpty? product['description']: "",
                  focusNode: _descripfnode,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 7,
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                  onSaved: (value) {
                    product['description']=value;
                  }
                  ,
                  validator: (value) {
                    if(value.isEmpty){
                      return 'Please input the title';
                    }
                    if(value.length<10){
                      return 'Please input a descriptive description';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done, // make the nexk on the softkeyboard
                  onFieldSubmitted: (value) {
                    // when we press submit of softkeyboard
                    FocusScope.of(context).requestFocus(_pricefnode);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 10),

                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Theme.of(context).primaryColorLight),
                      ),
                      width: 100,
                      height: 100,
                      child: _imagecontent.text.isEmpty? Text( "Image URL",textAlign: TextAlign.center,): Image.network(_imagecontent.text, fit: BoxFit.cover,),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: product.isNotEmpty? product['imageUrl']: "",
                        controller: _imagecontent,
                        focusNode: _imageurlfnode,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          labelText: "Image URL",
                          //_imagecontent.text.isEmpty ? "Image url": NetworkImage(_imagecontent.text),
                        ),
                        onSaved: (value) {
                          product['imageUrl']=value;
                        }
                        ,
                        validator: (value) {
                          if(value.isEmpty){
                            return 'Please input the image URL';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done, // make the nexk on the softkeyboard
                        onFieldSubmitted: (value) {
                          // when click submit we should call the method to save
                          _saveForm;
                          Navigator.of(context).pop();
                          // save then should pop to previous screen
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

      ),
    );
  }
}
