import 'package:flutter/material.dart';

class ViewHolder extends StatelessWidget {
  final String text;
  ViewHolder(this.text);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 50, top: 20, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ],
    );
  }
}
