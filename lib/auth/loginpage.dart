import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login_Page extends StatefulWidget {
  final VoidCallback showSignupPage;
  const Login_Page({Key? key, required this.showSignupPage}) : super(key: key);

  @override
  State<Login_Page> createState() => _LoginPageState();
}

class _LoginPageState extends State<Login_Page> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    showDialog(context: context,
        builder: (context){
          return Center(child: CircularProgressIndicator());
    });

    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()
    ).then((value){
      print("successfully logged in");
    }).catchError((error) {
      print("failed to log in");
      print(error);
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              //login
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Log-in",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: "Franklin Gothic",
                          fontSize: 37,
                          color: Color(0xFF4E841A))),
                ),
              ),
              SizedBox(height: 30),
              //email
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Email",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color(0xFF4E841A))),
                ),
              ),
              SizedBox(height: 5),

              //email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Your email",
                    )),
              ),
              SizedBox(height: 25),

              //password
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Password",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color(0xFF4E841A))),
                ),
              ),
              SizedBox(height: 5),

              //password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Your password",
                    )),
              ),
              SizedBox(height: 30),

              //login button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: signIn,
                  child: Container(
                    padding: EdgeInsets.all(17),
                    decoration: BoxDecoration(
                        color: Color(0xFF4E841A),
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                        child: Text("Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ))),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: widget.showSignupPage,
                    child: Text(" Sign up",
                        style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF4E841A),
                            fontWeight: FontWeight.bold)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
