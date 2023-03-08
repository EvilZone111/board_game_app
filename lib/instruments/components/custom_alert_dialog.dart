import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {

  String title;
  Widget? content;
  List<Widget> actions;
  CustomAlertDialog({required this.title, this.content, required this.actions});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
        fontSize: 17,
        color: Colors.black
    );
    OutlineInputBorder borderStyle = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: Text(
        title,
        style: textStyle,
      ),
      content: content,
      contentPadding: const EdgeInsets.all(10.0),
      titlePadding: EdgeInsets.only(left: 10.0, top: 20.0, bottom: 10.0),
      actionsAlignment: MainAxisAlignment.center,
      actions: actions,
    );
  }
}
