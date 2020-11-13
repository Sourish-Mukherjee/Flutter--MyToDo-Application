import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/iconColor.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/notificationManager.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/viewHolder.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/dashboard_custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/dashboard_dateandtime_.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/viewHolderForIcons.dart';

class MainDashboard extends StatefulWidget {
  final String _email;
  MainDashboard(this._email);
  @override
  _MainActivityState createState() => _MainActivityState(_email);
}

class _MainActivityState extends State<MainDashboard> {
  final String _email;
  List<DocumentSnapshot> _docs;
  String chosenDate = "", chosenTime = "", title = "", desc = "";
  IconColor _chosenIconColor;
  DateTime chosenDateTime;
  NotificationManager notificationManager;
  Set<int> set;
  int _index = 0;
  _MainActivityState(this._email);

  @override
  initState() {
    super.initState();
    notificationManager = NotificationManager();
    _index = 0;
    set = HashSet();
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
        backgroundColor: Colors.white12,
        body: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: 400.0,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Tasks")
                        .doc(_email)
                        .collection("User_Tasks_List")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text("Loading!...");
                      _docs = snapshot.data.documents;
                      _index = _docs.length;
                      _docs.sort((a, b) => a['index'].compareTo(b['index']));
                      _docs.forEach((element) {
                        set.add(element['notificationID']);
                        notificationManager
                            .getPendingNotifications()
                            .then((value) {
                          if (!value.contains(element['notificationID'])) {
                            Timestamp timestamp = element['DateTimeStamp'];
                            if (timestamp
                                    .toDate()
                                    .difference(DateTime.now())
                                    .inSeconds >=
                                0) {
                              notificationManager.showNotificationDaily(
                                  element['notificationID'],
                                  element['Title'],
                                  element['description'],
                                  timestamp.toDate());
                            }
                          }
                        });
                      });
                      return Theme(
                        data: ThemeData(canvasColor: Colors.transparent),
                        child: ReorderableListView(
                            children: _docs
                                .map((e) => InkWell(
                                    key: ObjectKey(e),
                                    onTap: () => _popupDialog(context, e),
                                    onDoubleTap: () =>
                                        _showOnDoubleTap(context, e, snapshot),
                                    child: ViewHolder(e)))
                                .toList(),
                            onReorder: onReorder),
                      );
                    }),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: onButtonPressed,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }

  void onButtonPressed() {
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
                        createRecord(
                            DashboardCustomTextField.getTitle().text,
                            DashboardCustomTextField.getDesc().text,
                            chosenDate,
                            chosenTime);
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

  void createRecord(String _title, String _desc, String _chosenDate,
      String _chosenTime) async {
    final databaseReference = FirebaseFirestore.instance;
    int notificationID = giveRandomNumber();
    await databaseReference
        .collection("Tasks")
        .doc(_email)
        .collection("User_Tasks_List")
        .doc(_title)
        .set({
      'Title': _title,
      'description': _desc,
      'date': _chosenDate,
      'time': _chosenTime,
      'notificationID': notificationID,
      'DateTimeStamp': chosenDateTime,
      'icon': _chosenIconColor.getIcon(),
      'index': _index++
    }).whenComplete(() => notificationManager.showNotificationDaily(
            notificationID, _title, _desc, chosenDateTime));
  }

  void _popupDialog(BuildContext context, DocumentSnapshot documentSnapshot) {
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
    );
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Colors.teal,
            title: Text(
              documentSnapshot['Title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  documentSnapshot['description'],
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 3.0,
                ),
                Text(documentSnapshot['date']),
                Text(documentSnapshot['time']),
              ],
            ),
            actions: [
              okButton,
            ],
          );
        });
  }

  onReorder(oldIndex, newIndex) {
    if (oldIndex < newIndex)
      updateData(oldIndex, newIndex - 1, true);
    else
      updateData(oldIndex, newIndex, true);
  }

  void updateData(int oldIndex, int newIndex, bool field) async {
    FirebaseFirestore databaseReference = FirebaseFirestore.instance;
    if (oldIndex < newIndex) {
      databaseReference
          .collection("Tasks")
          .doc(_email)
          .collection("User_Tasks_List")
          .get()
          .then((QuerySnapshot snapshot) {
        for (DocumentSnapshot documentSnapshot in snapshot.docs) {
          if (documentSnapshot['index'] >= oldIndex &&
              documentSnapshot['index'] <= newIndex) {
            if (documentSnapshot['index'] == oldIndex && field == true) {
              databaseReference
                  .collection("Tasks")
                  .doc(_email)
                  .collection("User_Tasks_List")
                  .doc(documentSnapshot['Title'])
                  .update({'index': newIndex});
            } else
              databaseReference
                  .collection("Tasks")
                  .doc(_email)
                  .collection("User_Tasks_List")
                  .doc(documentSnapshot['Title'])
                  .update({'index': documentSnapshot['index'] - 1});
          }
        }
      }).catchError((err) {
        print('$err');
      });
    } else {
      databaseReference
          .collection("Tasks")
          .doc(_email)
          .collection("User_Tasks_List")
          .get()
          .then((QuerySnapshot snapshot) {
        for (DocumentSnapshot documentSnapshot in snapshot.docs) {
          if (documentSnapshot['index'] <= oldIndex &&
              documentSnapshot['index'] >= newIndex) {
            if (documentSnapshot['index'] == oldIndex && field == true) {
              databaseReference
                  .collection("Tasks")
                  .doc(_email)
                  .collection("User_Tasks_List")
                  .doc(documentSnapshot['Title'])
                  .update({'index': newIndex});
            } else
              databaseReference
                  .collection("Tasks")
                  .doc(_email)
                  .collection("User_Tasks_List")
                  .doc(documentSnapshot['Title'])
                  .update({'index': documentSnapshot['index'] + 1});
          }
        }
      }).catchError((err) {
        print('$err');
      });
    }
  }

  void _showOnDoubleTap(
      BuildContext context, DocumentSnapshot e, AsyncSnapshot snapshot) {
    int ind = e['index'];
    Widget deletebutton = FlatButton(
        child: Text(
          "Delete",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            transaction.delete(e.reference);
            Fluttertoast.showToast(msg: "Task has been deleted!");
            Navigator.of(context, rootNavigator: true).pop();
          }).then((value) =>
              updateData(ind, snapshot.data.documents.length - 1, false));
          notificationManager.removeReminder(e['notificationID']);
        });
    Widget cancelbutton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.teal,
          title: Text(
            "Are you sure you want to delete?",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          actions: [
            cancelbutton,
            deletebutton,
          ],
        );
      },
    );
  }

  int giveRandomNumber() {
    int x = Random().nextInt(999999999);
    if (set.contains(x)) giveRandomNumber();
    return x;
  }
}
