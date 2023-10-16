import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile_Page extends StatefulWidget {
  const Profile_Page({super.key});

  @override
  State<Profile_Page> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile_Page> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  "My Profile",
                  style: TextStyle(
                      color: Color(0xFF76A737),
                      fontWeight: FontWeight.w300,
                      fontSize: 27.0),
                )),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 15, bottom: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("You are logged in as: " + user.email!,
                    style: TextStyle(
                        fontSize: 20.0
                    )),
              ),
            ),
              SizedBox(height: 500),
              Container(
                margin: EdgeInsets.all(15.0),
                child: ElevatedButton(
                      onPressed: (){
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text("Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF619427),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                      padding: EdgeInsets.all(15.0))
                  ),
                ),
          ]
        )
    );
  }
}

