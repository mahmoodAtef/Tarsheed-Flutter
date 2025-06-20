import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? suffixIcon;
  final Iterable<String>? autofillHints;
  final int? maxLines;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.autofillHints,
    this.maxLines,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: ThemeData(
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        hintStyle: theme.inputDecorationTheme.hintStyle,
      )),
      child: TextFormField(
        maxLines: widget.maxLines,
        autofillHints: widget.autofillHints,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscureText : false,
        cursorColor: theme.colorScheme.primary,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: theme.colorScheme.onSurface,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : widget.suffixIcon,
        ),
        validator: widget.validator,
      ),
    );
  }
}
