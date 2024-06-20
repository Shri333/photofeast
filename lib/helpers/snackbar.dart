import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context,
    {String message = 'An unknown error occurred'}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(label: 'Hide', onPressed: () {}),
    ),
  );
}
