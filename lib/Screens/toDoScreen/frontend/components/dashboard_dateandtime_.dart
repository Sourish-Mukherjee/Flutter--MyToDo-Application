import 'package:flutter/material.dart';

class DashBoardDateTime extends StatefulWidget {
  final Function function;
  final StateSetter state;
  DashBoardDateTime(this.function, this.state);
  @override
  _DashBoardDateTimeState createState() => _DashBoardDateTimeState();
}

class _DashBoardDateTimeState extends State<DashBoardDateTime> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FlatButton(
            onPressed: () {
              _selectDate(context);
            },
            child: Text("Date",
                style: TextStyle(fontSize: 15, color: Colors.white)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.teal)),
          ),
          FlatButton(
            onPressed: () {
              _selectTime(context);
            },
            child: Text(
              "Time",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.teal)),
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData(
              primarySwatch: Colors.teal,
              splashColor: Colors.green,
              brightness: Brightness.dark),
          child: child,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (d != null) {
      var date = DateTime.parse(d.toString());
      String formattedDate = "${date.day}-${date.month}-${date.year}";
      widget?.function(widget?.state, date: formattedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay selectedTime = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData(
              primarySwatch: Colors.teal,
              splashColor: Colors.green,
              brightness: Brightness.dark),
          child: child,
        );
      },
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      widget?.function(widget?.state, time: selectedTime.format(context));
    }
  }
}
