import 'package:flutter/material.dart';

class DashBoardDateTime extends StatefulWidget {
  final Function function;
  final StateSetter state;
  DashBoardDateTime(this.function, this.state);
  @override
  _DashBoardDateTimeState createState() => _DashBoardDateTimeState();
}

class _DashBoardDateTimeState extends State<DashBoardDateTime> {
  DateTime d;
  TimeOfDay selectedTime;
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
            child: Text("Date - Time",
                style: TextStyle(fontSize: 18, color: Colors.white)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    d = await showDatePicker(
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
    ).whenComplete(() async {
      selectedTime = await showTimePicker(
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
    });
    if (d != null) {
      var date = DateTime.parse(d.toString());
      String formattedDate = "${date.day}-${date.month}-${date.year}";
      widget?.function(
          widget?.state,
          formattedDate,
          selectedTime.format(context),
          DateTime(
              d.year, d.month, d.day, selectedTime.hour, selectedTime.minute));
    }
    /*else{
      d=DateTime.now();
      selectedTime=TimeOfDay.now();
      var date = DateTime.parse(d.toString());
      String formattedDate = "${date.day}-${date.month}-${date.year}";
      widget?.function(
          widget?.state,
          formattedDate,
          selectedTime.format(context),
          DateTime(
              d.year, d.month, d.day, selectedTime.hour, selectedTime.minute));
    }*/
  }
}
