import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_project/classification.dart';
import 'package:food_project/inventorypage.dart';
import 'package:food_project/profile.dart';
import 'package:food_project/profilepage.dart';
import 'homepage.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.index});
  int index;

  @override
  State<Home> createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    starting();
  }

  void starting() {
    setState(() {
       currentIndex = widget.index;
    });
  }


  void onTappedBar(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      Home_Page(),
      Classification(),
      Inventory_Page(),
      Profile_Page(),
    ];
    return Scaffold(
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTappedBar,
          currentIndex: currentIndex,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFFFAF8EE),
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: Color(0xFF4E841A),
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              label: "",
              icon: Icon(Icons.home_outlined, size: 35),
            ),
            BottomNavigationBarItem(
                label: "",
                icon: Icon(Icons.camera_alt_outlined)
            ),
            BottomNavigationBarItem(
                label: "",
                icon: Icon(Icons.list_alt_rounded)
            ),
            BottomNavigationBarItem(
                label: "",
                icon: Icon(Icons.person_outline_rounded, size: 35)
            ),
          ]
      ),
    );
  }
}
