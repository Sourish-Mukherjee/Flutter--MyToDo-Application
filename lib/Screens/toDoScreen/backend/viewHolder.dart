import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewHolder extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final bool _field;
  final Map<String, Color> _iconColorMap = {
    "education.png": Colors.yellow,
    "sports.png": Colors.white,
    "transport.png": Colors.blue,
    "medicine.png": Colors.red,
    "payment.png": Colors.yellow[900],
    "shopping.png": Colors.green,
    "message.png": Colors.cyan,
    "office.png": Colors.pink
  };
  ViewHolder(this.documentSnapshot, this._field);
  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = documentSnapshot['DateTimeStamp'];
    if (_field && DateTime.now().difference(timestamp.toDate()).inSeconds < 0) {
      return _getContainer();
    } else if (!_field &&
        DateTime.now().difference(timestamp.toDate()).inSeconds > 0) {
      return _getContainer();
    }
    return Container();
  }

  Widget _getContainer() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
      decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: _iconColorMap[documentSnapshot['icon']],
              blurRadius: 3, // changes position of shadow
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: Image.asset(
                'assests/Images/' + documentSnapshot['icon'],
                color: _iconColorMap[documentSnapshot['icon']],
              )),
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
