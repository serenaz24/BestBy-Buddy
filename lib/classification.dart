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
        title: Text(
          "Classification",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 30.0),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4E841A),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Food_Classification()),
                      );
                    },
                    child: Text(
                      "Produce Classification",
                      style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w400),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20.0),
                      fixedSize: Size(300, 80),
                    )
                )
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Meat_Classification()),
                      );
                    },
                    child: Text(
                      "Meat Classification",
                      style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w400),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20.0),
                      fixedSize: Size(300, 80),
                    )
                )
            ),
          ], // children
        ),
      ),
    );
  }
}
