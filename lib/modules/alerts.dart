import 'package:flutter/material.dart';

class Alerts {
  static showAlertDialog(BuildContext context, String title, String content) {
    Widget okButton = TextButton(
      child: const Text('OK'),
      onPressed: () {

        Navigator.of(context).pop();

      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}