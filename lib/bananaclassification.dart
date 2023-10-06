import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class Banana_Classification extends StatefulWidget {
  const Banana_Classification({Key? key}) : super(key: key);

  @override
  _BananaClassificationState createState() => _BananaClassificationState();
}

class _BananaClassificationState extends State<Banana_Classification> {
  late ModelObjectDetection _model;
  List<ResultObjectDetection?> object_detection = [];
  File? _image;
  Image? _imageWidget;
  PickedFile? _imageFile;

  @override
  void initState() {
    super.initState();
    loadmodel();
  }

  Future loadmodel() async {
    String path_of_model = "assets/bananas.torchscript";
    try {
      _model = await FlutterPytorch.loadObjectDetectionModel(
          path_of_model, 6, 640, 640,
          labelPath: "assets/bananalabels.txt");
    } catch (e) {
      if (e is PlatformException) {
        print("This function is only supported on androids, error is $e");
      } else {
        print("error is $e");
      }
    }
  }

  void _imageSelection() async {
    var imageFile =
        await ImagePicker().getImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        // print(1);
        processImage(value!);
        run_model_on_image(value!);
      }
    });
  }

  void _cameraSelection() async {
    var imageFile =
        await ImagePicker().getImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        run_model_on_image(value!);
      }
    });
  }

  void processImage(PickedFile i) {
    setState(() {
      _imageFile = i;
      _image = File(i!.path);
      _imageWidget = Image.file(_image!);
    });
  }

  Future run_model_on_image(PickedFile image) async {
    // print(3);
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });

    object_detection =
        await _model.getImagePrediction(await File(image.path).readAsBytes());
    object_detection.forEach((element) {
      print({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        }
      });
    });
    setState(() {
      processImage(image);
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: BackButton(color: Color(0xFF6B9D2F))),
          title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "Banana Analysis",
                style: TextStyle(
                    color: Color(0xFF76A737),
                    fontWeight: FontWeight.w300,
                    fontSize: 27.0),
              )),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0),
        body: Center(
            child: Column(children: [
              if (_image == null)
                Container(
                    margin: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Take a picture of a banana",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w400),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          // backgroundColor: Color(0xFF91BA5A),
                          padding: EdgeInsets.all(20.0),
                          fixedSize: Size(400, 80),
                        ))),
                Expanded(
                    child: object_detection.isNotEmpty
                        ? _image == null
                            ? Align(
                              alignment: Alignment.center,
                              child: Container(
                                      child: Text("No image selected",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center)),
                            )
                      : Container(
                            height: 900,
                            child: Align(
                              alignment: Alignment.center,
                              child: ListView(
                                shrinkWrap: true,
                                  children: [
                                      Container(margin: EdgeInsets.only(left: 15, right: 15),
                                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2.8),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Color(0xFFA5C677), width: 2),
                                        ),
                                        child: _model.renderBoxesOnImage(_image!, object_detection)),
                              ]),
                            ),
                          )
                  : _image == null
                      ? Align(
                        alignment: Alignment.center,
                        child: Container(
                                child: Text("No image selected",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center)),
                      )
                      : Container(
                        child: Text("cannot classify image, please select another image.")
                    )

            ),
      ])),
      floatingActionButton: Stack(fit: StackFit.expand, children: [
        Positioned(
          bottom: 10,
          right: 5,
          child: Row(
            children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: _imageSelection,
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: Color(0xFF619427),
              ),
              SizedBox(width: 7),
              FloatingActionButton(
                heroTag: null,
                onPressed: _cameraSelection,
                child: Icon(Icons.add_a_photo_rounded, color: Colors.white),
                backgroundColor: Color(0xFF619427),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
