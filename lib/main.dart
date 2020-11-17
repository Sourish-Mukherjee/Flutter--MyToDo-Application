import 'package:mytodoapp/Screens/welcomeScreen/log_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(MaterialApp(
      home: LogIn(),
    ));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LogIn();
  }
}
