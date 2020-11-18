import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/iconColor.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/makeChanges.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/notificationManager.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/completedTask.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/dashboard_custom_textfield.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/dashboard_dateandtime_.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/showInformation.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/tobedoneScreen.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/viewHolderForIcons.dart';

class MainDashboard extends StatefulWidget {
  final String _email;
  final String title="";
  final String desc="";
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
  bool field = true;
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
          toolbarHeight: 90.0,
          backgroundColor: Colors.black,
          title: Container(
            child: Column(
              children: [
                Text(
                  "My To-Do App",
                  style: GoogleFonts.dancingScript(
                      fontSize: 35,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.teal,
              ),
              iconSize: 35.0,
              onPressed: callSignOut,
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: bottomTabs[_bottomNavIndex],
        floatingActionButton: field
            ? FloatingActionButton(
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: onButtonPressed,
                backgroundColor: Colors.teal,
                foregroundColor: Colors.black,
              )
            : Center(),
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
                if (value == 1) {
                  field = false;
                } else {
                  field = true;
                }
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
                height: MediaQuery.of(context).copyWith().size.height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 15, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(right: 15),
                              constraints: BoxConstraints(maxHeight: 20),
                              child: Icon(
                                Icons.date_range,
                                color: Colors.teal,
                              )),
                          Text(chosenDate,
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      fontSize: 20, color: Colors.white))),
                          Text(chosenTime,
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      fontSize: 20, color: Colors.white))),
                          Container(
                              margin: const EdgeInsets.only(right: 15),
                              constraints: BoxConstraints(maxHeight: 20),
                              child: Icon(
                                Icons.alarm,
                                color: Colors.teal,
                              ))
                        ],
                      ),
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
                        title=DashboardCustomTextField.getTitle().text;
                        desc=DashboardCustomTextField.getDesc().text;
                        if(title.isEmpty){
                          title="Undefined";
                          Fluttertoast.showToast(msg: "Title missing\nDefault title set to 'Undefined'");
                        }
                        if(desc.isEmpty){
                          desc="Undefined";
                          Fluttertoast.showToast(msg: "Description missing\nDefault description set to 'Undefined'");
                        }
                        /*if (chosenDate==null){
                          var d = DateTime.parse(DateTime.now().toString());
                          chosenDate="${d.day}-${d.month}-${d.year}";
                          Fluttertoast.showToast(msg: 'Date not selected\nDefault date set to now');
                        }
                        if (chosenTime==null){
                          chosenTime=TimeOfDay.now().format(context);
                          Fluttertoast.showToast(msg: 'Time not selected\nDefault time set to now');
                        }*/
                        MakeChanges(
                                email: _email,
                                set: ToDoScreenWidget.getSet(),
                                notificationManager: notificationManager)
                            .createRecord(
                                title,
                                desc,
                                chosenDate,
                                chosenTime,
                                chosenDateTime,
                                _chosenIconColor,
                                ToDoScreenWidget.getIndex());
                        Navigator.of(context, rootNavigator: true).pop();
                        DashboardCustomTextField.getTitle().clear();
                        DashboardCustomTextField.getDesc().clear();
                        setState(() {
                          chosenTime = "";
                          chosenDate = "";
                          chosenDateTime = null;
                          _chosenIconColor = null;
                        });
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
      /*if (date==null){
        var d = DateTime.parse(DateTime.now().toString());
        date="${d.day}-${d.month}-${d.year}";
        Fluttertoast.showToast(msg: 'Date not selected\nDefault date set to now');
      }
      if (time==null){
        time=TimeOfDay.now().format(context);
        Fluttertoast.showToast(msg: 'Time not selected\nDefault time set to now');
      }*/
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

  callSignOut() {
    ShowInformation()
        .onSignOut(context: context, notificationManager: notificationManager);
  }
}
