import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/makeChanges.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/notificationManager.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/getDialogforInfo.dart';

class ShowInformation {
  void popupDialog(BuildContext context, DocumentSnapshot documentSnapshot) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoDialog().getInfoDialog(documentSnapshot, context);
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
            color: Colors.teal,
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
          color: Colors.teal,
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
          backgroundColor: Colors.grey[850],
          title: Text(
            e['Title'],
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
          content: Text(
            "Are you sure you want to delete?",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
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

  void onSignOut(
      {BuildContext context, NotificationManager notificationManager}) {
    Widget signButton = FlatButton(
        child: Text(
          "Sign-Out",
          style: TextStyle(
            color: Colors.teal,
          ),
        ),
        onPressed: () {
          GoogleSignIn().signOut().then((value) {
            Navigator.popUntil(context, ModalRoute.withName("/"));
            Fluttertoast.showToast(msg: "Signed Out!");
            notificationManager
                .getPendingNotifications()
                .then((value) => value.forEach((element) {
                      notificationManager.removeReminder(element.id);
                    }));
          }).catchError(
              (onError) => Fluttertoast.showToast(msg: onError.toString()));
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.popUntil(context, ModalRoute.withName("/"));
            Fluttertoast.showToast(msg: "Signed Out!");
            notificationManager
                .getPendingNotifications()
                .then((value) => value.forEach((element) {
                      notificationManager.removeReminder(element.id);
                    }));
          }).catchError(
              (onError) => Fluttertoast.showToast(msg: onError.toString()));
        });
    Widget cancelbutton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Colors.teal,
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
          backgroundColor: Colors.grey[850],
          title: Text(
            "Are you sure you want to SignOut?",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          actions: [
            cancelbutton,
            signButton,
          ],
        );
      },
    );
  }
}
