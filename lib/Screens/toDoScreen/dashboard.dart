import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/iconColor.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/makeChanges.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/notificationManager.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/completedTask.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/dashboard_custom_textfield.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/dashboard_dateandtime_.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/tobedoneScreen.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/viewHolderForIcons.dart';

class MainDashboard extends StatefulWidget {
  final String _email;
  final NotificationManager notificationManager = NotificationManager();
  MainDashboard(this._email);
  @override
  _MainActivityState createState() => _MainActivityState(
      _email,
      ToDoScreenWidget(_email, notificationManager),
      notificationManager,
      CompletedTask(_email, notificationManager));
}

class _MainActivityState extends State<MainDashboard> {
  String _email;
  String chosenDate = "", chosenTime = "", title = "", desc = "";
  IconColor _chosenIconColor;
  DateTime chosenDateTime;
  NotificationManager notificationManager;
  ToDoScreenWidget toDoScreenWidget;
  CompletedTask completedTask;
  int _bottomNavIndex;
  _MainActivityState(this._email, this.toDoScreenWidget,
      this.notificationManager, this.completedTask);
  List<Widget> bottomTabs;

  @override
  initState() {
    super.initState();
    _bottomNavIndex = 0;
    bottomTabs = [
      toDoScreenWidget.getColumn(),
      completedTask.getCompletedColumn()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 80.0,
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            iconSize: 35.0,
            onPressed: () {},
          ),
          title: Text(
            "Your Tasks",
            style: TextStyle(color: Colors.white, fontSize: 35.0),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              iconSize: 35.0,
              onPressed: () {},
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: bottomTabs[_bottomNavIndex],
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: onButtonPressed,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.black,
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(canvasColor: Colors.transparent),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _bottomNavIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.book,
                  color: Colors.teal,
                ),
                title: Text(
                  'To Be Done',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check, color: Colors.teal),
                title: Text(
                  'Tasks Completed',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            onTap: (value) {
              setState(() {
                _bottomNavIndex = value;
              });
            },
          ),
        ),
      ),
    );
  }

  void onButtonPressed() {
    notificationManager
        .getPendingNotifications()
        .then((value) => value.forEach((element) {
              print(element.title);
            }));
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        backgroundColor: Colors.grey[850],
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Container(
                height: MediaQuery.of(context).copyWith().size.height * 0.65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.teal),
                      title: Text(
                        chosenDate + '           ' + chosenTime ?? '',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(Icons.timer, color: Colors.teal),
                    ),
                    DashboardCustomTextField(),
                    Container(
                      width: double.infinity,
                      height: 80,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 8,
                          itemBuilder: (context, index) =>
                              ViewHolderForIcons(index, selectedIcon)),
                    ),
                    DashBoardDateTime(updated, mystate),
                    SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () {
                        MakeChanges(
                                email: _email,
                                set: ToDoScreenWidget.getSet(),
                                notificationManager: notificationManager)
                            .createRecord(
                                DashboardCustomTextField.getTitle().text,
                                DashboardCustomTextField.getDesc().text,
                                chosenDate,
                                chosenTime,
                                chosenDateTime,
                                _chosenIconColor,
                                ToDoScreenWidget.getIndex());
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      color: Colors.teal,
                      child: Icon(Icons.save, size: 50, color: Colors.white),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                  ],
                ));
          });
        });
  }

  void updated(
      StateSetter updateState, String date, String time, DateTime dateTime) {
    updateState(() {
      this.chosenDate = date;
      this.chosenTime = time;
      this.chosenDateTime = dateTime;
    });
  }

  void selectedIcon(IconColor chosenIconColor) {
    this._chosenIconColor = chosenIconColor;
  }

  void setTitleForTask(String title) => this.title = title;

  void setDescriptionForTask(String desc) => this.desc = desc;
}
