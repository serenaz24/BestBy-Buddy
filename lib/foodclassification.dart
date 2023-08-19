import 'package:flutter/material.dart';
import 'dictionary.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:food_project/meatclassification.dart';
import 'food_info.dart';
import 'package:food_project/bananaclassification.dart';

//The following code is based heavily off of code provided by:
//  -Teresa Wu https://spltech.co.uk/flutter-image-classification-using-tensorflow-in-4-steps/
//  -Nancy Patel https://medium.com/geekculture/image-classification-with-flutter-182368fea3b

class Food_Classification extends StatefulWidget {
  const Food_Classification({Key? key}) : super(key: key);

  @override
  _FoodClassificationState createState() => _FoodClassificationState();
}

class _FoodClassificationState extends State<Food_Classification> {

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
      model: "assets/food_model_unquant.tflite",
      labels: "assets/foodlabels.txt",
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
        _imageClassification(value!);
      }
    });
  }

  void _cameraSelection() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.camera).
    then((value) {
      if (value != null)
        {
          _imageClassification(value!);
        }
    });
  }

  void _imageClassification(PickedFile image) async {
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
          centerTitle: true,
            title: Text(
                "Produce Classification",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 30.0),
            ),
        backgroundColor: Color(0xFF4E841A),
      ),
      body: Center(
        child: Column(
          children: [ if(_image == null)
             Container(
                margin: EdgeInsets.all(20.0),
                color: Color(0xFF91BA5A),
                child:
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Take a picture of a produce",
                      style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w400),
                    ),
                    style: ElevatedButton.styleFrom(
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
                    ? Container(height: 535,
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
                          Container(
                              margin: EdgeInsets.only(left: 10.0),
                              height: 50,
                              child: Text("Storage Tips:",
                                  style: TextStyle(
                                      fontSize: 30.0
                                  ))),
                          Padding(
                              padding: EdgeInsets.only(left:20, bottom: 10, right: 10, top: 0),
                              child: Text(foodInfo!.storage,
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
            children: [if (_listResult != null)
              Positioned(
                bottom: -10,
                right: 130,
                  child: Row(
                    children: [SizedBox(
                      child: _listResult![0]["label"] == "1 banana"
                          ? Container(
                            margin: EdgeInsets.all(15),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Banana_Classification()),
                                  );
                                }, child: Text("Analyze Banana",
                                style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w400)),
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(10.0),
                                    fixedSize: Size(200, 55))
                            ))
                          : Text("")
                  )
              ])),
              Positioned(
                bottom: 3,
                right: 0,
                child: Row(
                  children:[
                    FloatingActionButton(
                        heroTag: null,
                        onPressed: _imageSelection,
                        child: Icon(Icons.add, color: Colors.white)
                    ),
                    SizedBox(
                      width: 10
                    ),
                    FloatingActionButton(
                        heroTag: null,
                        onPressed: _cameraSelection,
                        child: Icon(
                            Icons.add_a_photo_rounded, color: Colors.white)
                    ),
                  ],
                ),
              ),
            ]
        ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF619427),
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          items: [
            BottomNavigationBarItem(
                label: "",
                icon: Icon(Icons.home_rounded)
            ),
            BottomNavigationBarItem(
                label: "",
                icon: Icon(Icons.camera_alt)
            ),
            BottomNavigationBarItem(
                label: "",
                icon: Icon(Icons.list_alt)
            ),
            BottomNavigationBarItem(
                label: "",
                icon: Icon(Icons.person)
            )
          ]
      ),

    );
  }
}

