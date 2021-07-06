import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_app/utilities/constants.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductWidgetState createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var storage = FirebaseStorage.instance;
  final picker = ImagePicker();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  File _image;
  bool _isLoading = false;
  double originalSize = 0.0;
  double newSize = 0;

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    File imageCompressed = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      setState(() {
        originalSize = image.readAsBytesSync().lengthInBytes / 1024;
        newSize = imageCompressed.readAsBytesSync().lengthInBytes / 1024;
        _image = imageCompressed;
      });
    }
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File imageCompressed = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      setState(() {
        originalSize = image.readAsBytesSync().lengthInBytes / 1024;
        newSize = imageCompressed.readAsBytesSync().lengthInBytes / 1024;
        _image = imageCompressed;
      });
    }
  }

  getImage() {
    if (_image != null) {
      return FileImage(File(_image.path));
    }
    return NetworkImage(
        "https://icon-library.com/images/add-camera-icon/add-camera-icon-13.jpg");
  }

  getImageName() {
    if (_image != null) {
      return _image.path.split('/').last;
    }
    return "No Image selected";
  }

  @override
  void initState() {
    super.initState();
  }

  getToastBar(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  handleAdd() async {
    if (_image == null) {
      getToastBar("Select Product Image!");
    } else {
      Random random = new Random();
      int id = random.nextInt(9999);
      FocusScope.of(context).unfocus();
      if (_formKey.currentState.validate()) {
        String imageName = _image.path
            .substring(
                _image.path.lastIndexOf("/"), _image.path.lastIndexOf("."))
            .replaceAll("/", "");
        final byteData = await rootBundle.load(_image.path);
        await _image.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

        TaskSnapshot snapshot =
            await storage.ref().child("images/$imageName").putFile(_image);

        if (snapshot.state == TaskState.success) {
          final String downloadUrl = await snapshot.ref.getDownloadURL();
          await FirebaseFirestore.instance.collection("product").add({
            "image": downloadUrl,
            "id": id,
            "name": _productNameController.text,
            "price": _productPriceController.text,
            "description": _descriptionController.text
          }).then((value) =>
              {getToastBar("Product Added!"), Navigator.of(context).pop()});
        } else {
          throw ('This file is not an image');
        }
      }
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: kPrimaryColor,
        title: Text("Add Product"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Container(
                            height: 150,
                            width: 130,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: getImage())),
                          ),
                        ),
                        _image != null
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Original Image Size - ${originalSize.toStringAsFixed(2)} kb",
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                      "New Image Size - ${newSize.toStringAsFixed(2)} kb")
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Product Name';
                            }
                            return null;
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny('  ')
                          ],
                          controller: _productNameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.shopping_bag_outlined),
                            hintText: 'Product Name*',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Product Price';
                            }
                            return null;
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                new RegExp(r"^\d+\.?\d{0,2}"))
                          ],
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          controller: _productPriceController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.money),
                            hintText: 'Product Price*',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Description';
                            }
                            return null;
                          },
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.description),
                            hintText: 'Description*',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(child: _isLoading ? Container() : Container())
        ],
      ),
      bottomNavigationBar: Container(
        color: kPrimaryColor,
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
            onPressed: () {
              handleAdd();
            },
            textColor: Colors.white,
            child: Text(
              "Add Product",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
