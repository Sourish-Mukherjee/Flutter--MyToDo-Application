import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoDialog {
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
  Widget getInfoDialog(
      DocumentSnapshot documentSnapshot, BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        color: Colors.grey[850],
        height: 500,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(children: [
              Text(
                "Title : ",
                style: GoogleFonts.ubuntu(
                    fontSize: 15,
                    color: _iconColorMap[documentSnapshot['icon']]),
              ),
              Expanded(child: Divider())
            ]),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                documentSnapshot['Title'],
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                    color: _iconColorMap[documentSnapshot['icon']],
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Row(children: [
              Text(
                "Description : ",
                style: GoogleFonts.ubuntu(
                    fontSize: 15,
                    color: _iconColorMap[documentSnapshot['icon']]),
              ),
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Divider()))
            ]),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(documentSnapshot['description'],
                    style: GoogleFonts.ubuntu(
                      color: _iconColorMap[documentSnapshot['icon']],
                      fontSize: 25,
                    )),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10, top: 20),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: _iconColorMap[documentSnapshot['icon']]),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              height: 50,
              child: Row(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 5),
                      constraints: BoxConstraints(maxHeight: 45),
                      child: Image(
                        image: AssetImage('assests/Images/info_time.png'),
                        color: _iconColorMap[documentSnapshot['icon']],
                      )),
                  VerticalDivider(
                    color: _iconColorMap[documentSnapshot['icon']],
                    thickness: 1,
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                          child: Text(documentSnapshot['time'],
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      color: _iconColorMap[
                                          documentSnapshot['icon']])))),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: _iconColorMap[documentSnapshot['icon']]),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              height: 50,
              child: Row(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 5),
                      constraints: BoxConstraints(maxHeight: 45),
                      child: Image(
                        image: AssetImage('assests/Images/info_calender.png'),
                        color: _iconColorMap[documentSnapshot['icon']],
                      )),
                  VerticalDivider(
                    color: _iconColorMap[documentSnapshot['icon']],
                    thickness: 1,
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                          child: Text(documentSnapshot['date'],
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      color: _iconColorMap[
                                          documentSnapshot['icon']])))),
                    ),
                  ),
                ],
              ),
            ),
            Row(children: [
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 15),
                      child: Divider())),
              Container(
                margin: EdgeInsets.only(right: 15),
                child: InkWell(
                  onTap: () => Navigator.of(context, rootNavigator: true).pop(),
                  child: Text(
                    "OK",
                    style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        color: _iconColorMap[documentSnapshot['icon']]),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
