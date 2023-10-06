import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dictionary.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
    setState(() {
      _imageFile = i;
      _image = File(i!.path);
      _imageWidget = Image.file(_image!);
    });
  }

  void _imageSelection() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.gallery).
    then((value) {
      if (value != null)
      {
        _imageClassification(value!);
        uploadFileToFBStorage(_image!);
      }
    });
  }

  void _cameraSelection() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.camera).
    then((value) {
      if (value != null)
        {
          _imageClassification(value!);
          uploadFileToFBStorage(_image!);
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

  void uploadFileToFBStorage (File file) {
    var fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
    FirebaseStorage.instance.ref().child("images/" + fileName).putFile(file)
    .then((res) {
      print("successfully uploaded image");
    }).catchError((error) {
      print("failed to upload image");
      print(error);
    }
    );
  }

  get_date(exp_date) {
    var today = DateTime.now();
    if(exp_date!.contains("day")) {
    String? refrigerator = exp_date?.split("day")[0];
    String? refrigerator2 = refrigerator?.split("about")[1];
    today = today.add(Duration(days: int.parse(refrigerator2!)));
    }
    else if (exp_date!.contains("week")) {
    String? refrigerator = exp_date?.split("week")[0];
    String? refrigerator2 = refrigerator?.split("about")[1];
    today = today.add(Duration(days: int.parse(refrigerator2!) * 7));
    }
    else if (exp_date!.contains("month")) {
    String? refrigerator = exp_date?.split("month")[0];
    String? refrigerator2 = refrigerator?.split("about")[1];
    today = today.add(Duration(days: int.parse(refrigerator2!) * 30));
    }
    return today;
  }



  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final CollectionReference _inventory = FirebaseFirestore.instance.collection(user.email!);
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: BackButton(color: Color(0xFF6B9D2F))
          ),
          title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "Produce Classification",
                style: TextStyle(
                    color: Color(0xFF76A737),
                    fontWeight: FontWeight.w400,
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
                      "Take a picture of a produce",
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
                    ? Container(height: 605,
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
                bottom: -14,
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
                                style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w400)),
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(10.0),
                                    fixedSize: Size(200, 55),
                                    backgroundColor: Color(0xFF619427),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50)))
                            ))
                          : Text("")
                  )
              ])),
              Positioned(
                bottom: -14,
                right: 125,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_listResult != null && _listResult![0]["label"] != "1 banana")
                      SizedBox(
                          child: Container(
                              margin: EdgeInsets.all(15),
                              child: ElevatedButton(
                                onPressed: () async{
                                  showDialog(context: context,
                                    builder: (context) => SimpleDialog(
                                      backgroundColor: Color(0xFFFAF8EE),
                                      contentPadding: const EdgeInsets.only(
                                          top: 15, bottom: 20, left: 30, right: 30),
                                      title: const Text("Add to Inventory",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Color(0xFF4E841A),
                                              fontWeight: FontWeight.w500)),
                                      children: [
                                        Container(
                                          child: Text(
                                              "How will you be storing your produce?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 17,
                                              )
                                          ),
                                          padding: EdgeInsets.only(bottom: 15),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50.0),
                                              color: Color(0xFF76A737)
                                          ),
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: TextButton(onPressed: () async {
                                            var desc = foodInfo?.description.split(":");
                                            var room_temp = desc?[1].split("Ref");
                                            String? roomtemp = room_temp?[0];
                                            var exp = get_date(roomtemp);
                                            final today = DateTime(2023, 9, 20);
                                            final difference = today.difference(exp);
                                            String expdate = exp.month.toString()+"/"+exp.day.toString()+"/"+exp.year.toString().substring(2,4);
                                            await _inventory.add({"food name": foodInfo!.name, "expiration date": expdate, "order": int.parse(difference.inDays.toString())});
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                    backgroundColor: Color(0xFF619427),
                                                    behavior: SnackBarBehavior.fixed,
                                                    duration: Duration(milliseconds: 1500),
                                                    // shape: StadiumBorder(),
                                                    content: Text('Successfully added food item',
                                                        style: TextStyle(color: Colors.white,
                                                            fontSize: 18,
                                                            fontFamily: "Mona Sans"))));
                                          }, child: const Text("Room Temperature",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20
                                              ))
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50.0),
                                              color: Color(0xFF76A737)
                                          ),
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: TextButton(onPressed: () async {
                                            var desc = foodInfo?.description.split(":");
                                            String? refrig = desc?[2];
                                            var exp = get_date(refrig);
                                            final today = DateTime(2023, 9, 20);
                                            final difference = today.difference(exp);
                                            print(difference.inDays);
                                            String expdate = exp.month.toString()+"/"+exp.day.toString()+"/"+exp.year.toString().substring(2,4);
                                            await _inventory.add({"food name": foodInfo!.name, "expiration date": expdate, "order": int.parse(difference.inDays.toString())});

                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                    backgroundColor: Color(0xFF619427),
                                                    behavior: SnackBarBehavior.fixed,
                                                    duration: Duration(milliseconds: 1500),
                                                    // shape: StadiumBorder(),
                                                    content: Text('Successfully added food item',
                                                        style: TextStyle(color: Colors.white,
                                                            fontSize: 18,
                                                            fontFamily: "Mona Sans"))));

                                            Navigator.of(context).pop();
                                          }, child: const Text("Refrigerator",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20
                                              ))
                                          ),
                                        )
                                      ],
                                    ),
                                  );


                                }, child: Text("Add to Inventory",
                                  style: TextStyle(color: Colors.white, fontSize: 21.0, fontWeight: FontWeight.w400)),
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(15.0),
                                    fixedSize: Size(200, 55),
                                    backgroundColor: Color(0xFF619427),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50))),
                              ))
                      ),
                  ]
                ),
              ),

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

