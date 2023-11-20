import 'package:flutter/material.dart';
import 'dictionary.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'food_info.dart';
import 'home.dart';

//The following code is based heavily off of code provided by:
//  -Teresa Wu https://spltech.co.uk/flutter-image-classification-using-tensorflow-in-4-steps/
//  -Nancy Patel https://medium.com/geekculture/image-classification-with-flutter-182368fea3b

class Meat_Classification extends StatefulWidget {
  const Meat_Classification({Key? key}) : super(key: key);

  @override
  _MeatClassificationState createState() => _MeatClassificationState();
}

class _MeatClassificationState extends State<Meat_Classification> {

  List? _listResult;
  PickedFile? _imageFile;
  bool _loading = false;

  File? _image;
  Image? _imageWidget;
  final picker = ImagePicker();

  FoodInfo? foodInfo;

  FoodInfo? getCorrespondingFood(List<dynamic> l){
    String classification = l[0]["label"];
    try {
      return FoodDictionary.allFoods[classification];
    } catch (Exception) {
      return FoodInfo("Null", "Null", "Null");
    }
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    _loadModel();
  }

  void _loadModel() async {
    await Tflite.loadModel(
      model: "assets/meat_model_unquant.tflite",
      labels: "assets/meatlabels.txt",
    ).then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  void processImage(PickedFile i) {
    _imageFile = i;
    _image = File(i!.path);
    _imageWidget = Image.file(_image!);
  }

  void _imageSelection() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.gallery).
    then((value) {
      if (value != null)
      {
        _imageClasification(value!);
      }
    });
  }

  void _cameraSelection() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.camera).
    then((value) {
      if (value != null)
      {
        _imageClasification(value!);
      }
    });
  }

  void _imageClasification(PickedFile image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.1,
      imageMean: 0,
      imageStd: 255,
    ).
    then((value) {
      setState(() {
        if (value == null) print("did not successfully load");
        print(value);
        _listResult = value;
        processImage(image);
        foodInfo = getCorrespondingFood(value!);
      });
    }
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: BackButton(color: Color(0xFF6B9D2F))
          ),
          title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "Meat Classification",
                style: TextStyle(
                    color: Color(0xFF76A737),
                    fontWeight: FontWeight.w300,
                    fontSize: 27.0),
              )),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0),
      body: Center(
        child: Column(
          children: [ if(_image == null)
            Container(
                margin: EdgeInsets.all(20.0),
                child:
                ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Take a picture of a meat",
                      style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w400),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      padding: EdgeInsets.all(20.0),
                      fixedSize: Size(400, 80),
                    )
                )
            ),
            Container(
              child: _image == null
                  ? Container(
                    width: 500.0, height: 450.0,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("No image selected",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center)
                    )
                )
                  : Text("")
            ),
            _listResult != null
                ? Container(height: 600,
                  child: ListView(children: [
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                      constraints: BoxConstraints(
                          maxHeight: 275),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFA5C677), width: 2),
                      ),
                      child: Container(
                          child: _imageWidget
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10.0),
                        height: 50,
                        child: Text(foodInfo!.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 35.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 10.0),
                        height: 50,
                        child: Text("Shelf Life:",
                            style: TextStyle(
                                fontSize: 30.0
                            ))),
                    Padding(
                        padding: EdgeInsets.only(left:20, bottom: 10, right: 10, top: 0),
                        child: Text(foodInfo!.description,
                          style: TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                  ],
                  ))
                : Container(),
          ],
        ),
      ),

      floatingActionButton: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  FloatingActionButton(
                      heroTag: null,
                      onPressed: _imageSelection,
                      child: Icon(Icons.add, color: Colors.white),
                      backgroundColor: Color(0xFF619427)
                  ),
                  SizedBox(
                      width: 10
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: _cameraSelection,
                    child: Icon(Icons.add_a_photo_rounded, color: Colors.white),
                    backgroundColor: Color(0xFF619427),
                  ),
                ],
              ),
            ),
          ]
      ),
    );
  }
}

