import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/makeChanges.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/notificationManager.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/viewHolder.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/showInformation.dart';

class ToDoScreenWidget {
  String email = "somu18cs@cmrit.ac.in";
  List<DocumentSnapshot> _docs = List();
  String chosenDate = "", chosenTime = "", title = "", desc = "";
  DateTime chosenDateTime;
  NotificationManager notificationManager;
  static Set<int> _set;
  static int _index;
  ToDoScreenWidget(String email, NotificationManager notificationManager) {
    this.email = email;
    this.notificationManager = notificationManager;
    _set = HashSet();
    _index = 0;
  }

  Widget getColumn() {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            height: 400.0,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Tasks")
                    .doc(email)
                    .collection("User_Tasks_List")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text("Loading!...");
                  _docs = snapshot.data.documents;
                  _index = _docs.length;
                  _docs.sort((a, b) => a['index'].compareTo(b['index']));
                  _docs.forEach((element) {
                    _set.add(element['notificationID']);
                    notificationManager.getPendingNotifications().then((value) {
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
                                onTap: () =>
                                    ShowInformation().popupDialog(context, e),
                                onDoubleTap: () => ShowInformation()
                                    .showOnDoubleTap(
                                        email, context, e, snapshot,
                                        notificationManager:
                                            notificationManager),
                                child: ViewHolder(e, true)))
                            .toList(),
                        onReorder: onReorder),
                  );
                }),
          ),
        ),
      ],
    );
  }

  onReorder(oldIndex, newIndex) {
    if (oldIndex < newIndex)
      MakeChanges(email: email).updateData(oldIndex, newIndex - 1, true);
    else
      MakeChanges(email: email).updateData(oldIndex, newIndex, true);
  }

  static int getIndex() {
    return _index;
  }

  static Set<int> getSet() {
    return _set;
  }
}
