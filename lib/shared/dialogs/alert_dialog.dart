import 'package:flutter/material.dart';

void showAlertPopup(BuildContext context, String title, String message) async {
  void showAlertDialog<T>({required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    );
  }

  return showAlertDialog(
    context: context,
    child: AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(message),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    )
  );
}