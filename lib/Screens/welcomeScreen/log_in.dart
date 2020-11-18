import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytodoapp/Screens/toDoScreen/dashboard.dart';
import 'package:mytodoapp/Screens/welcomeScreen/components/frontEnd/welcome_customImage.dart';
import 'package:mytodoapp/Screens/welcomeScreen/components/backEnd/welcome_login_google.dart';
import 'package:mytodoapp/Screens/welcomeScreen/register.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogIn extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LogIn> {
  String _email="", _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final myController=TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    myController.addListener(setEmail);
  }

  @override
  void dispose(){
    myController.dispose();
    super.dispose();
  }

  void setEmail(){
    _email=myController.text;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Builder(
            builder: (context) => Scaffold(
                backgroundColor: Colors.white12,
                body: Form(
                    key: _formKey,
                    child: Center(
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.teal),
                                strokeWidth: 5,
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomWelcomeImage(
                                    'assests/Images/login_screen_logo.png',
                                    110),
                                Container(
                                    width: 300,
                                    child: TextFormField(
                                      controller: myController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Can't be Empty!";
                                        }
                                        return null;
                                      },
                                      obscureText: false,
                                      style: TextStyle(color: Colors.white),
                                      keyboardType: TextInputType.emailAddress,
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
                                                color: Colors.white, width: 1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                      keyboardType:
                                          TextInputType.visiblePassword,
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
                                                color: Colors.white, width: 1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                        if(_email.isEmpty){
                                           Fluttertoast.showToast(
                                            msg:
                                                "Email can't be empty");
                                        }
                                        else{
                                        FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: _email);
                                        Fluttertoast.showToast(
                                            msg:
                                                'Email has been sent with password reset option!');
                                        }
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
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        onPressed: signInFireBase,
                                        child: Text('Sign-In',
                                            style:
                                                TextStyle(color: Colors.teal)),
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
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterScreen()),
                                          );
                                        },
                                        child: Text('Create Account',
                                            style:
                                                TextStyle(color: Colors.teal)),
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
      onPressed: callGoogleSignIn,
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
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password)
            .then((value) {
          if (FirebaseAuth.instance.currentUser.emailVerified) {
            Fluttertoast.showToast(msg: "Signed In");
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MainDashboard(_email)));
            Future.delayed(Duration(seconds: 1)).whenComplete(() {
              setState(() {
                isLoading = false;
              });
            });
          } else {
            Fluttertoast.showToast(msg: "Please Verify Your Email");
          }
        }).catchError(
                (onError) => Fluttertoast.showToast(msg: onError.toString()));
      } catch (e) {
        //This is for Debugging purpose only.
        //print(e.toString());
      }
      Future.delayed(Duration(seconds: 1)).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  callGoogleSignIn() {
    signInWithGoogle().then((result) {
      if (result != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MainDashboard(FirebaseAuth.instance.currentUser.email);
            },
          ),
        );
      }
    });
  }
}
