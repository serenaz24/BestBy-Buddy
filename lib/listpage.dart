import 'package:flutter/material.dart';

class List_Page extends StatefulWidget {
  const List_Page({super.key});

  @override
  State<List_Page> createState() => _ListPageState();
}

class _ListPageState extends State<List_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(child: Text("hello"))
    ));
  }
}
