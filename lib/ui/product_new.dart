import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wowow/const/custom_color.dart';
import 'package:wowow/const/validator.dart';
import 'package:wowow/models/product.dart';
import 'package:wowow/widget/custom_form_field.dart';

class ProductNew extends StatelessWidget {
  const ProductNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF545D68),
            ),
          ),
          title: const Text(
            'New Product',
            style: TextStyle(
              fontFamily: 'Varela',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF545D68),
            ),
          ),
        ),
        body: AddFormProduct());
  }
}

class AddFormProduct extends StatefulWidget {
  const AddFormProduct({Key? key}) : super(key: key);

  @override
  _AddFormProductState createState() => _AddFormProductState();
}

class _AddFormProductState extends State<AddFormProduct> {
  final _addProductFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var _image;
  var imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Options"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      openCamera();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      openGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void openCamera() async {
    XFile image = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50, preferredCameraDevice: CameraDevice.rear);
    setState(() {
      _image = File(image.path);
    });

    Navigator.of(context).pop();
  }

  void openGallery() async {
    XFile image = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
    setState(() {
      _image = File(image.path);
    });

    Navigator.of(context).pop();
  }

  Widget _displayImage() {
    if (_image == null) {
      return Text("No Image Selected!");
    } else {
      return Image.file(_image, width: 350, height: 350);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addProductFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'Product Form',
                style:
                    TextStyle(color: Color(0xFFF17532), fontWeight: FontWeight.w500, fontSize: 30),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CustomFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                inputAction: TextInputAction.next,
                validator: (value) => Validator.validateField(
                  value: value,
                ),
                label: 'Product Name',
                hint: 'Enter your product name',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CustomFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                inputAction: TextInputAction.next,
                validator: (value) => Validator.validateField(
                  value: value,
                ),
                label: 'Sales Price',
                hint: 'Enter product price',
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _displayImage(),
                    SizedBox(height: 30),
                    _image != null
                        ? Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  onPressed: () {
                                    showOptionsDialog(context);
                                  },
                                  child: Text('Change Image'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              showOptionsDialog(context);
                            },
                            child: Text('Select Image'),
                          )
                  ],
                ),
              ),
            ),
            _isProcessing
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColors.firebaseOrange,
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: MaterialButton(
                      textColor: Colors.white,
                      color: Color(0xFFF17532),
                      child: Text('Create'),
                      onPressed: () async {
                        if (_addProductFormKey.currentState!.validate()) {
                          setState(() {
                            _isProcessing = true;
                          });

                          await Product.addItem(
                            name: nameController.text,
                            price: double.parse(priceController.text),
                          );

                          setState(() {
                            _isProcessing = false;
                          });

                          Navigator.of(context).pop();

                          Flushbar(
                            margin: EdgeInsets.all(8),
                            borderRadius: BorderRadius.circular(8),
                            message: "${nameController.text} telah di buat",
                            icon: Icon(
                              Icons.check,
                              size: 28.0,
                              color: Colors.red,
                            ),
                            duration: Duration(seconds: 2),
                          )..show(context);
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
