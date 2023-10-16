import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignupPage({Key? key, required this.showLoginPage});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future signUp() async {
    showDialog(context: context,
        builder: (context){
          return Center(child: CircularProgressIndicator());
        });

    if (passwordConfirmed()) {
      //create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

     // add user details
      addUserDetails(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
      );
    }
    Navigator.of(context).pop();
  }

  Future addUserDetails(String firstName, String lastName, String email) async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection(user.email!).add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
    }).then((value) {
      print("successfully added user");
    }).catchError((error) {
      print("failed to add user");
      print(error);
    });
  }

  bool passwordConfirmed() {
    if(_passwordController.text.trim() == _confirmpasswordController.text.trim())
    {return true;}
    else {
      return false;
    }
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
                  padding: const EdgeInsets.only(left: 25.0, top: 75.0, bottom: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sign-up",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: "Franklin Gothic",
                            fontSize: 37,
                            color: Color(0xFF4E841A))),
                  ),
                ),
                SizedBox(height: 15),

                //first name
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("First Name",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Color(0xFF4E841A))),
                  ),
                ),
                SizedBox(height: 5),

                //firstname textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        hintText: "Your first name",
                      )),
                ),
                SizedBox(height: 15),

                //last name
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Last Name",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Color(0xFF4E841A))),
                  ),
                ),
                SizedBox(height: 5),

                //lastname textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        hintText: "Your last name",
                      )),
                ),
                SizedBox(height: 15),

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
                SizedBox(height: 15),

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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Your password",
                      )),
                ),
                SizedBox(height: 15),

                //confirm password
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Confirm Password",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Color(0xFF4E841A))),
                  ),
                ),
                SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                      controller: _confirmpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Confirm your password",
                      )),
                ),

                SizedBox(height: 30),
                //sign up button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: EdgeInsets.all(17),
                      decoration: BoxDecoration(
                          color: Color(0xFF4E841A),
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                          child: Text("Sign Up",
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
                    Text("I have an account.",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text(" Login now",
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
        ));;
  }
}
