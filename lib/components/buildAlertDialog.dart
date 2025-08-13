import 'package:flutter/material.dart';

AlertDialog buildAlertDialog(
    BuildContext context,
    {required IconData newIcons,
    required MaterialColor newColor,
    required String newMessage}) {

  return AlertDialog(
    content: Row(
      children: [
        Icon(
          newIcons,
          color: newColor,
          size: 70,
        ),
        SizedBox(
          width: 160,
          child: Text(newMessage),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('OK'),
      ),
    ],
  );
}