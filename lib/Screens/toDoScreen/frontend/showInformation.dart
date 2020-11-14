import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/makeChanges.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/notificationManager.dart';

class ShowInformation {
  void popupDialog(BuildContext context, DocumentSnapshot documentSnapshot) {
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

  void showOnDoubleTap(String email, BuildContext context, DocumentSnapshot e,
      AsyncSnapshot snapshot,
      {NotificationManager notificationManager}) {
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
          }).then((value) => MakeChanges(
                  email: email, notificationManager: notificationManager)
              .updateData(ind, snapshot.data.documents.length - 1, false));
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
}
