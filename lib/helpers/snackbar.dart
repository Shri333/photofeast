import 'package:flutter/material.dart';

Future<void> showSnackBar(BuildContext context, String message,
    {Duration delay = const Duration(milliseconds: 500)}) async {
  return Future.delayed(delay, () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
      ),
    );
  });
}
