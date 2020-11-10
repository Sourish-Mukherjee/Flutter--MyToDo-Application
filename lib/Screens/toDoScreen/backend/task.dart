import 'package:flutter/material.dart';

class Task {
  String _title = "";
  String _desc = "";
  DateTime _date;
  TimeOfDay _time;
  Task(this._title, this._desc, this._date, this._time);

  String getTitle() {
    return this._title;
  }

  String getDesc() {
    return this._desc;
  }

  DateTime getDateForTask() {
    return this._date;
  }

  TimeOfDay getTimeForTask() {
    return this._time;
  }

  void setTitle(String title) {
    this._title = title;
  }

  void setDescription(String desc) {
    this._desc = desc;
  }

  void setDateForTask(DateTime date) {
    this._date = date;
  }

  void setTimeForTask(TimeOfDay time) {
    this._time = time;
  }
}
