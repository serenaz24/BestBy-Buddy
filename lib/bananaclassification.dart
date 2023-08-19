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

  Future loadmodel()async{
    String path_of_model = "assets/best.pt";
    try{
      _model = await FlutterPytorch.loadObjectDetectionModel(path_of_model, 6, 640, 640, labelPath: "assets/bananalabels.txt");
    }catch(e){
      if (e is PlatformException){
        print("This function is only supported on androids, error is $e");
      }
      else{
        print("error is $e");
      }
    }
  }

  void _imageSelection() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.gallery).
    then((value) {
      if (value != null)
      {
        run_model_on_image(value!);
      }
    });
  }

  void _cameraSelection() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.camera).
    then((value) {
      if (value != null)
      {
        run_model_on_image(value!);
      }
    });
  }

  void processImage(PickedFile i) {
    _imageFile = i;
    _image = File(i!.path);
    _imageWidget = Image.file(_image!);
  }

  Future run_model_on_image(PickedFile image)async{
    print(image);
    object_detection = await _model.getImagePrediction(await File(image.path).readAsBytes());
    object_detection.forEach((element){
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
        }});
    }
    );
    setState(() {
      processImage(image);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          centerTitle: true,
          title: Text(
            "Banana Analysis",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 30.0),
          ),
          backgroundColor: Color(0xFF4E841A),
        ),
      body: Center(
        child: Column(
          children: [
             if(_image == null)
              Container(
                margin: EdgeInsets.all(20.0),
                color: Color(0xFF91BA5A),
                child:
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Take a picture of a banana",
                      style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w400),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20.0),
                      fixedSize: Size(400, 80),
                    )
                )
            ),
            Expanded(
              child: object_detection.isNotEmpty
                  ? _image == null
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
                      : _model.renderBoxesOnImage(_image!, object_detection)
                  : _image == null
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
                      : Image.file(_image!)

            ),
          ]
        )
      ),

      floatingActionButton: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 10,
              right: 5,
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
    );
  }
}
