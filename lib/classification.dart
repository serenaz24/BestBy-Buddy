import 'package:flutter/material.dart';
import 'package:food_project/foodclassification.dart';
import 'package:food_project/meatclassification.dart';

class Classification extends StatefulWidget {
  const Classification({super.key});

  @override
  State<Classification> createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "Classification",
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
          children: [
            Container(
                margin: EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Food_Classification()),
                      );
                    },
                    child: Text(
                      "Produce Classification",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w300),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      padding: EdgeInsets.all(20.0),
                      backgroundColor: Color(0xFF619427),
                      fixedSize: Size(330, 90),
                    ))),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Meat_Classification()),
                      );
                    },
                    child: Text(
                      "Meat Classification",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      padding: EdgeInsets.all(20.0),
                      backgroundColor: Color(0xFF619427),
                      fixedSize: Size(330, 90),
                    ))),
          ], // children
        ),
      ),
    );
  }
}
