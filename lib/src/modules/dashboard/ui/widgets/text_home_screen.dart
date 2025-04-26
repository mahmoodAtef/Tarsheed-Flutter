import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String label;
  final double size;

  const CustomTextWidget({
    Key? key,
    required this.label,
    required this.size,
  }) : super(key: key);

  TextStyle _getTextStyle({double? fontSize}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: _getTextStyle(fontSize: size),
    );
  }
}
