import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewHolder extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  ViewHolder(this.documentSnapshot);
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
            documentSnapshot['Title'],
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ],
    );
  }
}
