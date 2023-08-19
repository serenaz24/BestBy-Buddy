import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  var _genders = ['Female', 'Male'];
  String? _gender;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    // getUserInfo().then((info) {
    //   // print(info);
    //   setState(() {
    //     _gender = info!['gender'];
    //     _weightController.text = info!['weight'];
    //     _ageController.text = info!['age'];
    //     _heightController.text = info!['height'];
    //   });
    // });
  }

  updateInfo() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    Map<String, dynamic> userInfo = {
      'height': _heightController.text.trim(),
      'weight': _weightController.text.trim(),
      'age': _ageController.text.trim(),
      'gender': _gender
    };

    buildLoading();
    // editUserInfo(userInfo).then((value) {
    //   Navigator.of(context).pop();
    //   snapBarBuilder('User info edited');
    // });
  }

  buildLoading() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        });
  }

  snapBarBuilder(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(
              context); //This method returns future boolean, based on your condition you can either
          return true; //allow you to go back or you can show a toast and restrict in this page
        },
        child: Container(
          // color: Color.fromRGBO(171, 196, 170, 0.5),
          child: ListView(
            children: <Widget>[
              Container(
                  color: const Color.fromRGBO(227, 219, 218, 1.0),
                  height: height * .12,
                  child: Image.asset('images/logo.png', fit: BoxFit.fitHeight)),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12, top: 20),
                  child: Column(
                    children: [
                      const Text(
                        "Profile",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(220, 166, 129, 1.0)),
                      ),
                      Container(
                        height: 3,
                        color: const Color.fromRGBO(80, 80, 74, 1.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          decoration: InputDecoration(
                              counterText: '',
                              labelText: 'Height',
                              hintText: "5.05",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          controller: _heightController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          decoration: InputDecoration(
                              label: const Text('Weight (lb)'),
                              hintText: "140",
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          controller: _weightController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          decoration: InputDecoration(
                              label: const Text('Age'),
                              hintText: "Age",
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          controller: _ageController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: createRoundedDropDown(width),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: ElevatedButton(
                            onPressed: updateInfo,
                            child: Text('Update User Info'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(220, 166, 129, 1.0))),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget createRoundedDropDown(width) {
    return Container(
      width: width * .95,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(65, 58, 58, 1.0)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            borderRadius: BorderRadius.circular(10),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            hint: Text("Select Gender"),
            value: _gender,
            isDense: true,
            onChanged: (newValue) {
              setState(() {
                _gender = newValue;
              });
            },
            items: _genders.map((document) {
              return DropdownMenuItem<String>(
                value: document,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(document,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(65, 58, 58, 1.0)))),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}