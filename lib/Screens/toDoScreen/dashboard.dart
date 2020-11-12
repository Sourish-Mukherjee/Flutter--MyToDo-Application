import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/tasklist.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/viewHolder.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/components/dashboard_custom_textfield.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/components/dashboard_dateandtime_.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainDashboard extends StatefulWidget {
  final String _email;
  MainDashboard(this._email);
  @override
  _MainActivityState createState() => _MainActivityState(_email);
}

class _MainActivityState extends State<MainDashboard> {
  final String _email;
  int _index = 0;
  List<DocumentSnapshot> _docs;
  TaskList taskList = new TaskList();
  String chosenDate = "", chosenTime = "", title = "", desc = "";
  _MainActivityState(this._email);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white12,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 10),
              child: Text(
                "Your Tasks ",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: Divider(color: Colors.grey, thickness: 1)),
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
                    DashBoardDateTime(updated, mystate),
                    SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () {
                        createRecord(
                            DashboardCustomTextField.getTitle().text,
                            DashboardCustomTextField.getDesc().text,
                            chosenDate,
                            chosenTime);
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

  void updated(StateSetter updateState, {String date, String time}) {
    updateState(() {
      if (date != null) this.chosenDate = date;
      if (time != null) this.chosenTime = time;
    });
  }

  void setTitleForTask(String title) => this.title = title;

  void setDescriptionForTask(String desc) => this.desc = desc;

  void createRecord(String _title, String _desc, String _chosenDate,
      String _chosenTime) async {
    final databaseReference = FirebaseFirestore.instance;
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
      'index': _index++
    });
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
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(documentSnapshot['description']),
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
          String x = documentSnapshot['Title'];
          print("Tite is : '$x");
          if (documentSnapshot['index'] >= oldIndex &&
              documentSnapshot['index'] <= newIndex) {
            if (documentSnapshot['index'] == oldIndex && field == true) {
              print("YES YESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
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
              print("YES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
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
}
/*content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                e['description'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontStyle: bold
                ),
              ),
            ],
          ),*/
