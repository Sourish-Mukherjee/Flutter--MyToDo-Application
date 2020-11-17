import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytodoapp/Screens/toDoScreen/frontend/showInformation.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/notificationManager.dart';

class ViewHolder extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final bool _field;
  final String _email;
  final AsyncSnapshot snapshot;
  final NotificationManager _notificationManager;
  final Map<String, Color> _iconColorMap = {
    "education.png": Colors.yellow,
    "sports.png": Colors.white,
    "transport.png": Colors.blue,
    "medicine.png": Colors.red,
    "payment.png": Colors.yellow[900],
    "shopping.png": Colors.green,
    "message.png": Colors.cyan,
    "office.png": Colors.pink
  };
  ViewHolder(this.documentSnapshot, this._field, this._email,this.snapshot,this._notificationManager);
  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = documentSnapshot['DateTimeStamp'];
    if (_field && DateTime.now().difference(timestamp.toDate()).inSeconds < 0) {
      return _getContainer(context);
    } else if (!_field &&
        DateTime.now().difference(timestamp.toDate()).inSeconds > 0) {
      return _getContainer(context);
    }
    return Container();
  }

  Widget _getContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
      decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: _iconColorMap[documentSnapshot['icon']],
              blurRadius: 3, // changes position of shadow
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: Image.asset(
                'assests/Images/' + documentSnapshot['icon'],
                color: _iconColorMap[documentSnapshot['icon']],
              )),
          Expanded(
            child: Text(
              documentSnapshot['Title'],
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.teal,
              size: 35.0,
            ),
            onPressed: () => ShowInformation()
                                    .showOnDoubleTap(
                                        this._email, context, this.documentSnapshot, snapshot,
                                        notificationManager:
                                            _notificationManager),
          ),
          /*Theme(
            data: ThemeData(
              cardColor: Colors.black,
            ),
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                      child: Text(
                    "Share",
                    style: TextStyle(color: Colors.white),
                  )),
                  PopupMenuItem(
                      child: TextButton(
                        onPressed: () => ShowInformation()
                                    .showOnDoubleTap(
                                        this._email, context, this.documentSnapshot, snapshot,
                                        notificationManager:
                                            _notificationManager),
                    child: Text("Delete",
                    style: TextStyle(color: Colors.white),)
                  ))
                ],
                offset: Offset(0,100),
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
            ),*/
        ],
      ),
    );
  }
}
