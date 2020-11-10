import 'package:flutter/material.dart';

class CustomWelcomeImage extends StatelessWidget {
  final String _path;
  final double _margin;
  CustomWelcomeImage(this._path, this._margin);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: _margin),
      height: 150,
      child: Center(
        child: Image(
          image: AssetImage(_path),
          color: Colors.teal,
        ),
      ),
    );
  }
}
