import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/dashboard.dart';
import 'package:mytodoapp/Screens/welcomeScreen/components/frontEnd/welcome_customImage.dart';
import 'package:mytodoapp/Screens/welcomeScreen/components/backEnd/welcome_login_google.dart';
import 'package:mytodoapp/Screens/welcomeScreen/register.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogIn extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LogIn> {
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomWelcomeImage(
                              'assests/Images/login_screen_logo.png', 110),
                          Container(
                              width: 300,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Can't be Empty!";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) => _email = newValue,
                                obscureText: false,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'Email-ID',
                                    labelStyle: TextStyle(color: Colors.teal),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1),
                                    )),
                              )),
                          SizedBox(height: 15),
                          Container(
                              width: 300,
                              child: TextFormField(
                                obscureText: true,
                                onSaved: (input) => _password = input,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: Colors.teal),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1),
                                    )),
                              )),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: GestureDetector(
                                child: Text(
                                  "Forgot Password ?",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.teal,
                                  ),
                                ),
                                onTap: () {
                                  FirebaseAuth.instance
                                      .sendPasswordResetEmail(email: _email);
                                  Fluttertoast.showToast(
                                      msg:
                                          'Email has been sent with password reset option!');
                                }),
                          ),
                          SizedBox(height: 25),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.teal,
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: signInFireBase,
                                  child: Text('Sign-In',
                                      style: TextStyle(color: Colors.teal)),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.teal,
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen()),
                                    );
                                  },
                                  child: Text('Create Account',
                                      style: TextStyle(color: Colors.teal)),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                          _googleSignInButton(),
                        ],
                      )),
                    )))));
  }

  Widget _googleSignInButton() {
    return FlatButton(
      onPressed: () {
        signInWithGoogle().then((result) {
          if (result != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return MainDashboard("90385rishi@gmail.com".trim());
                },
              ),
            );
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(right: 5),
              constraints: BoxConstraints(maxHeight: 40),
              child: Image.asset('assests/Images/google_logo.png',
                  fit: BoxFit.cover)),
          Text(
            'Sign-in with Google',
            style: TextStyle(color: Colors.teal, fontSize: 15),
          )
        ],
      ),
    );
  }

  Future<void> signInFireBase() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());
        if (FirebaseAuth.instance.currentUser.emailVerified) {
          Fluttertoast.showToast(msg: "Signed In");
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MainDashboard(_email)));
        }
        Fluttertoast.showToast(msg: 'Email Is Not Verified!');
      } catch (e) {
        Fluttertoast.showToast(msg: e.message);
      }
    }
  }
}
