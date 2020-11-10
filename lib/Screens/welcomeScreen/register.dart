import 'package:flutter/material.dart';
import 'package:mytodoapp/Screens/welcomeScreen/components/frontEnd/welcome_customImage.dart';
import 'package:mytodoapp/Screens/welcomeScreen/log_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email, _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Builder(
            builder: (context) => Scaffold(
                backgroundColor: Colors.white12,
                body: Form(
                    key: _formKey,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                child: CustomWelcomeImage(
                                    'assests/Images/register_logo.png', 80)),
                            Container(
                              width: double.infinity,
                              height: 340,
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                      color: Colors.teal,
                                      width: 3,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.teal,
                                      width: 3,
                                    )),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      width: 250,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Can't be Empty!";
                                          }
                                          return null;
                                        },
                                        onSaved: (newValue) =>
                                            _email = newValue,
                                        obscureText: false,
                                        style: TextStyle(color: Colors.white),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            labelText: 'Email-ID',
                                            labelStyle:
                                                TextStyle(color: Colors.teal),
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: Colors.white,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1),
                                            )),
                                      )),
                                  Container(
                                      width: 250,
                                      child: TextFormField(
                                        obscureText: true,
                                        style: TextStyle(color: Colors.white),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            labelText: 'Password',
                                            labelStyle:
                                                TextStyle(color: Colors.teal),
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              color: Colors.white,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1),
                                            )),
                                      )),
                                  Container(
                                      width: 250,
                                      child: TextFormField(
                                        obscureText: true,
                                        onSaved: (input) => _password = input,
                                        style: TextStyle(color: Colors.white),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            labelText: 'Confirm Password',
                                            labelStyle:
                                                TextStyle(color: Colors.teal),
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: Colors.white,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1),
                                            )),
                                      )),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FlatButton(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.teal,
                                                width: 2,
                                                style: BorderStyle.solid,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          onPressed: () {
                                            createAccountInFireBase();
                                          },
                                          child: Text('Register',
                                              style: TextStyle(
                                                  color: Colors.teal)),
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )))));
  }

  Future<void> createAccountInFireBase() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());
        FirebaseAuth.instance.currentUser.sendEmailVerification();
        Fluttertoast.showToast(msg: "Please Verify Your Email!");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LogIn()));
      } catch (e) {
        Fluttertoast.showToast(msg: e.message);
      }
    }
  }
}
