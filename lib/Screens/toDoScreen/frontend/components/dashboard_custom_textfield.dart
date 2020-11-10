import 'package:flutter/material.dart';

class DashboardCustomTextField extends StatefulWidget {
  @override
  _DashboardCustomTextFieldState createState() =>
      _DashboardCustomTextFieldState();
  static TextEditingController getTitle() {
    return _DashboardCustomTextFieldState.textEditingControllerTitle;
  }

  static TextEditingController getDesc() {
    return _DashboardCustomTextFieldState.textEditingControllerDesc;
  }
}

class _DashboardCustomTextFieldState extends State<DashboardCustomTextField> {
  static TextEditingController textEditingControllerTitle =
      TextEditingController();
  static TextEditingController textEditingControllerDesc =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Container(
            child: TextField(
              controller: textEditingControllerTitle,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(fontSize: 20, color: Colors.teal),
                fillColor: Colors.grey[200],
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: TextField(
              controller: textEditingControllerDesc,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: TextStyle(fontSize: 20, color: Colors.teal),
                fillColor: Colors.grey[200],
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
