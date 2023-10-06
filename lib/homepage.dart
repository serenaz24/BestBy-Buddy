import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_project/foodclassification.dart';
import 'package:food_project/meatclassification.dart';
import 'package:food_project/bananaclassification.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _HomePageState();
}

class _HomePageState extends State<Home_Page> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
            "app name",
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
            Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const Banana_Classification()),
                      );
                    },
                    child: Text(
                      "Banana Analysis ",
                       textAlign: TextAlign.left,
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
                    )))
          ], // children
        ),
      ),
    );
  }
}
