import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/l10n.dart';

enum FieldType {
  email,
  password,
  confirmPassword,
  code,
  firstName,
  lastName,
} // Todo: remove this enum

class CustomTextField extends StatefulWidget {
  final FieldType fieldType;
  final TextEditingController? controller;
  final TextEditingController? originalPasswordController;
  final String hintText;
  final Function(String?)? validator;

  const CustomTextField(
      {super.key,
      required this.fieldType,
      this.controller,
      this.originalPasswordController,
      required this.hintText,
      this.validator});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    String? defaultHint;
    switch (widget.fieldType) {
      case FieldType.firstName:
        keyboardType = TextInputType.name;
        defaultHint = S.of(context).first_name;
        break;
      case FieldType.lastName:
        keyboardType = TextInputType.name;
        defaultHint = S.of(context).last_name;
        break;
      case FieldType.email:
        keyboardType = TextInputType.emailAddress;
        defaultHint = S.of(context).email;
        break;
      case FieldType.password:
        keyboardType = TextInputType.visiblePassword;
        defaultHint = S.of(context).password;
        break;
      case FieldType.confirmPassword:
        keyboardType = TextInputType.visiblePassword;
        defaultHint = S.of(context).confirm_password;
        break;

      case FieldType.code:
        keyboardType = TextInputType.number;
        defaultHint = S.of(context).enter_code;
        break;
    }

    return TextFormField(
        controller: widget.controller,
        keyboardType: keyboardType,
        obscureText: (widget.fieldType == FieldType.password ||
                widget.fieldType == FieldType.confirmPassword)
            ? _obscureText
            : false,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xfff1f4ff)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade700),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          hintText: widget.hintText ?? defaultHint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          suffixIcon: (widget.fieldType == FieldType.password ||
                  widget.fieldType == FieldType.confirmPassword)
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$defaultHint ${S.of(context).is_required}';
          }
          final trimmedValue = value.trim();
          switch (widget.fieldType) {
            case FieldType.firstName:
              String? nameValidator(String? value, String fieldName) {
                if (value == null || value.trim().isEmpty) {
                  return '$fieldName ${S.of(context).is_required}';
                }
                final trimmedValue = value.trim();
                final validCharacters = RegExp(r"^[a-zA-Z\- 'أ-ي]+$");

                if (trimmedValue.length < 2) {
                  return '$fieldName ${S.of(context).must_be_at_least} 2 ${S.of(context).characters}';
                }
                if (trimmedValue.length > 50) {
                  return '$fieldName ${S.of(context).cannot_exceed} 50 ${S.of(context).characters}';
                }
                if (!validCharacters.hasMatch(trimmedValue)) {
                  return '$fieldName ${S.of(context).contains_invalid_characters}';
                }
                if (trimmedValue.contains('--') ||
                    trimmedValue.contains("''") ||
                    trimmedValue.contains('  ')) {
                  return '$fieldName ${S.of(context).has_invalid_formatting}';
                }

                return null;
              }
              return nameValidator(trimmedValue, S.of(context).name);
            case FieldType.email:
              final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                caseSensitive: false,
              );
              if (!emailRegex.hasMatch(trimmedValue)) {
                return S.of(context).invalid_email;
              }
              return null;
            case FieldType.password:
              if (trimmedValue.length < 8) {
                return S.of(context).password_min_length;
              }
              if (trimmedValue.length > 64) {
                return S.of(context).password_max_length;
              }
              final hasUppercase = RegExp(r'[A-Z]').hasMatch(trimmedValue);
              final hasLowercase = RegExp(r'[a-z]').hasMatch(trimmedValue);
              final hasNumber = RegExp(r'[0-9]').hasMatch(trimmedValue);
              final hasSpecialChar =
                  RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(trimmedValue);
              if (!(hasUppercase &&
                  hasLowercase &&
                  hasNumber &&
                  hasSpecialChar)) {
                return S.of(context).password_requirements;
              }
              return null;
            case FieldType.confirmPassword:
              if (widget.originalPasswordController == null) {
                return S.of(context).original_password_not_provided;
              }
              if (trimmedValue !=
                  widget.originalPasswordController!.text.trim()) {
                return S.of(context).passwords_do_not_match;
              }
              return null;
            case FieldType.code:
              final codeRegex = RegExp(r'^\d+$');
              if (!codeRegex.hasMatch(trimmedValue)) {
                return S.of(context).code_numbers_only;
              }
              return null;
            case FieldType.lastName:
              return null;
              // TODO: Handle this case.
              throw UnimplementedError();
          }
        });
  }
}
