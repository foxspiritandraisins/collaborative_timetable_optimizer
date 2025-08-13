import 'package:flutter/material.dart';

class roundBtn extends StatelessWidget {
  roundBtn({
    this.borderRadius=0,
    this.newMinWidth =70,
    this.textColor = Colors.black,
    required this.onPressed,
    required this.label,
    required this.buttonColor
  });
  final String label;
  final void Function() onPressed;
  final Color buttonColor;
  final Color? textColor;

  double newMinWidth;
  double borderRadius;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      textColor: textColor,
      onPressed: onPressed,
      minWidth: newMinWidth,
      height: 40,
      color: buttonColor,
      splashColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(label),
    );
  }
}