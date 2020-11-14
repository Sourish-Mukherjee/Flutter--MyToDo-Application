import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/iconColor.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/notificationManager.dart';

class MakeChanges {
  String email;
  Set<int> set;
  NotificationManager notificationManager;
  MakeChanges(
      {String email, NotificationManager notificationManager, Set set}) {
    this.email = email;
    this.notificationManager = notificationManager;
    this.set = set;
  }

  void createRecord(
      String _title,
      String _desc,
      String _chosenDate,
      String _chosenTime,
      DateTime chosenDateTime,
      IconColor _chosenIconColor,
      int _index) async {
    final databaseReference = FirebaseFirestore.instance;
    int notificationID = giveRandomNumber();
    await databaseReference
        .collection("Tasks")
        .doc(email)
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

  void updateData(int oldIndex, int newIndex, bool field) async {
    FirebaseFirestore databaseReference = FirebaseFirestore.instance;
    if (oldIndex < newIndex) {
      databaseReference
          .collection("Tasks")
          .doc(email)
          .collection("User_Tasks_List")
          .get()
          .then((QuerySnapshot snapshot) {
        for (DocumentSnapshot documentSnapshot in snapshot.docs) {
          if (documentSnapshot['index'] >= oldIndex &&
              documentSnapshot['index'] <= newIndex) {
            if (documentSnapshot['index'] == oldIndex && field == true) {
              databaseReference
                  .collection("Tasks")
                  .doc(email)
                  .collection("User_Tasks_List")
                  .doc(documentSnapshot['Title'])
                  .update({'index': newIndex});
            } else
              databaseReference
                  .collection("Tasks")
                  .doc(email)
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
          .doc(email)
          .collection("User_Tasks_List")
          .get()
          .then((QuerySnapshot snapshot) {
        for (DocumentSnapshot documentSnapshot in snapshot.docs) {
          if (documentSnapshot['index'] <= oldIndex &&
              documentSnapshot['index'] >= newIndex) {
            if (documentSnapshot['index'] == oldIndex && field == true) {
              databaseReference
                  .collection("Tasks")
                  .doc(email)
                  .collection("User_Tasks_List")
                  .doc(documentSnapshot['Title'])
                  .update({'index': newIndex});
            } else
              databaseReference
                  .collection("Tasks")
                  .doc(email)
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

  int giveRandomNumber() {
    int x = Random().nextInt(999999999);
    if (set.contains(x)) giveRandomNumber();
    return x;
  }
}
