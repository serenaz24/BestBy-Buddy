import 'package:flutter/material.dart';
import 'package:food_project/classification.dart';
import 'package:food_project/profile.dart';
import 'homepage.dart';
import 'listpage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  final List<Widget> _children = [
    Home_Page(),
    Classification(),
    List_Page(),
    ProfilePage()
  ];
  void onTappedBar(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTappedBar,
          currentIndex: currentIndex,
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
              icon: Icon(Icons.home_rounded),
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
