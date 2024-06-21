import 'package:flutter/material.dart';

Future<void> showErrorAlert(BuildContext context) async {
  return showAlert(context, 'Error', 'An unknown error occurred');
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
