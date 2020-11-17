import 'package:flutter/material.dart';
import 'package:mytodoapp/Screens/toDoScreen/backend/iconColor.dart';

class ViewHolderForIcons extends StatelessWidget {
  final Function function;
  final _index;
  final List<IconColor> _iconColor = [
    IconColor("education.png", Colors.yellow),
    IconColor("sports.png", Colors.white),
    IconColor("transport.png", Colors.blue),
    IconColor("medicine.png", Colors.red),
    IconColor("payment.png", Colors.yellow[900]),
    IconColor("shopping.png", Colors.green),
    IconColor("message.png", Colors.cyan),
    IconColor("office.png", Colors.pink)
  ];

  ViewHolderForIcons(this._index, this.function);
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      splashColor: Colors.tealAccent,
      onTap: () {
        function(_iconColor[_index]);
      },
      child: Container(
        padding: EdgeInsets.only(top: 15, left: 25, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Image.asset(
          'assests/Images/' + _iconColor[_index].getIcon(),
          color: _iconColor[_index].getColor(),
        ),
      ),
    );
  }
}
