import 'package:flutter/material.dart';

Future<void> showErrorAlert(
  BuildContext context, [
  String message = 'An unknown error occurred',
]) async {
  return showAlert(context, 'Error', message);
}

Future<void> showAlert(BuildContext context, String title, String message) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
