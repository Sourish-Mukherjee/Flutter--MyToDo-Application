import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/makeChanges.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/notificationManager.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/showInformation.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/viewHolder.dart';

class CompletedTask {
  String email = "";
  List<DocumentSnapshot> _docs = List();
  String chosenDate = "", chosenTime = "", title = "", desc = "";
  final Set<DocumentSnapshot> checkExists = HashSet();
  DateTime chosenDateTime;
  NotificationManager notificationManager;
  CompletedTask(String email, NotificationManager notificationManager) {
    this.email = email;
    this.notificationManager = notificationManager;
  }
  Widget getCompletedColumn() {
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
                  _docs.sort((a, b) => a['index'].compareTo(b['index']));
                  _docs.forEach((element) {
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
                                /*onDoubleTap: () => ShowInformation()
                                    .showOnDoubleTap(
                                        email, context, e, snapshot,
                                        notificationManager:
                                            notificationManager),*/
                                child: ViewHolder(e, false,email,snapshot,notificationManager)))
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
}
