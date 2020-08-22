import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;



///path provider The Flutter plugin used for finding commonly used locations on the filesystem of the device.
///The path package provides common operations for manipulating paths: joining, splitting, normalizing, etc.

class ImageInput extends StatefulWidget {
  final Function setimagepath;
  String prevImage;

  ImageInput(this.setimagepath, this.prevImage );

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImageInput> {
  File _imageFile ;// we can file from picked file
  final picker = ImagePicker();
  /// before we have static that can use pickImage but now it attribute of a class we have to create an instance first to use getImage which return pickedFile

  Future<File> _pickImage(ImageSource source) async{

    final _imagePickFile = await picker.getImage(source: source);
    if(_imagePickFile == null){
      return null;
    }
//    print(_imagePickFile.path); // the attribute is the path so we have to access the attribute path(string) they return an instance
    setState(() {
      _imageFile = File(_imagePickFile.path) ;
      //File: '/storage/emulated/0/Android/data/com.example.shop_app/files/Pictures/eb8ce1f6-531e-4408-94c7-9f2ac630e15d8205523634412761938.jpg'
      // using the constructor to get the file of image by _imagePickFile.path , .path is from the base, this image is only temporary
    });
//    print("image picker ");
//    print(_imageFile); // this file is store permanently , system can clear at any time
    /// we need to write to Documents directory:A directory for the app to store files that only it can access. The system clears the directory only when the app is deleted.
    /// First we have to get the path of the Document Directly by using path provider
    ///we use path to join or basename of the path, for example basename would extract the file name from the path for us so we don't have to do manually
    final dirpath = await syspath.getApplicationDocumentsDirectory();// dirpath is object of type Directory
    final fileName = path.basename(_imageFile.path);
    final _imagepath = await _imageFile.copy('${dirpath.path}/${fileName}'); // this file contain attribute path, this is save in document directory which will remove only when app deleted
    widget.setimagepath(_imagepath.path);
    // this return the file so we to getter to get the path too
//    print(fileName);
// set it to the image field so we can save to database and get it after

    Navigator.of(context).pop();


  }

  Future<void> _showDialog(BuildContext ctx) {
//    Future<T> showDialog

     return showDialog
      (
        context: context,
        builder: (context) {
          return AlertDialog(
            title:  Text("Choose image from "),
            actions: [
              FlatButton(
                child: Text("Camera"),
                onPressed: () {
                  // handle it
                  _pickImage(ImageSource.camera);
//                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Gallery"),
                onPressed: () {

                  _pickImage(ImageSource.gallery);
//                  Navigator.of(context).pop();
                },
              )

            ],
          );
        }
    );

  }


  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10, right: 10),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Theme.of(context).primaryColorLight),),
                width: 200,
                height: 200,
                child:_imageFile == null? (widget.prevImage==null? Text("Image not yet picked " , textAlign: TextAlign.center,): Image.file(File(widget.prevImage)))
                :  Image.file(_imageFile),
//                child: _imagecontent.text.isEmpty? Text( "Image URL",textAlign: TextAlign.center,):
//                CachedNetworkImage(
//                imageUrl: _imagecontent.text,
//                //placeholder: (context, url) => CircularProgressIndicator(), //Widget displayed while the target [imageUrl] is loading.
//                errorWidget: (context, url, error) => Icon(Icons.error),
                ),
          FlatButton.icon(
              onPressed:() { _showDialog (context);} ,
              icon: Icon(Icons.image) ,
              label: Text("Pick an image"))
                //_imagecontent.text.isEmpty? Text( "Image URL",textAlign: TextAlign.center,): Image.network(_imagecontent.text, fit: BoxFit.cover,),

        ]
    );
  }
}
