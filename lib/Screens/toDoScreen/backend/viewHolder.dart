import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewHolder extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  ViewHolder(this.documentSnapshot);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 30, top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            documentSnapshot['Title'],
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          Expanded(child: Divider()),
          Container(
              margin: const EdgeInsets.only(right: 15),
              constraints: BoxConstraints(maxHeight: 20),
              child: Image.asset(
                'assests/Images/drag_icon.png',
                fit: BoxFit.cover,
                color: Colors.teal,
              ))
        ],
      ),
    );
  }
}
