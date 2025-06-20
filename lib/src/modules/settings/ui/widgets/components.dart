import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool enabled;
  final int? maxLines;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const ProfileField({
    Key? key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.hintText,
    this.enabled = true,
    this.maxLines = 1,
    this.onTap,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final inputDecorationTheme = theme.inputDecorationTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLabel(textTheme, colorScheme),
        SizedBox(height: 8.h),
        _buildTextField(context, theme, colorScheme, inputDecorationTheme),
      ],
    );
  }

  Widget _buildLabel(TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        label,
        style: textTheme.labelMedium?.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    InputDecorationTheme inputDecorationTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.1),
                  blurRadius: 4.r,
                  offset: Offset(0, 2.h),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
        maxLines: maxLines,
        onTap: onTap,
        validator: validator,
        onChanged: onChanged,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 16.sp,
          color: enabled
              ? colorScheme.onSurface
              : colorScheme.onSurface.withOpacity(0.5),
        ),
        decoration: _buildInputDecoration(
          context,
          colorScheme,
          inputDecorationTheme,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    BuildContext context,
    ColorScheme colorScheme,
    InputDecorationTheme inputDecorationTheme,
  ) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon != null
          ? Container(
              margin: EdgeInsets.only(right: 8.w),
              child: suffixIcon,
            )
          : null,
      prefixIcon: prefixIcon != null
          ? Container(
              margin: EdgeInsets.only(left: 8.w),
              child: prefixIcon,
            )
          : null,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: maxLines == 1 ? 16.h : 12.h,
      ),
      filled: true,
      fillColor:
          enabled ? colorScheme.surface : colorScheme.surface.withOpacity(0.5),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(0.5),
          width: 1.5.w,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 2.w,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 1.5.w,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 2.w,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(0.3),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 16.sp,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
      errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
            color: colorScheme.error,
          ),
      suffixIconColor: colorScheme.onSurface.withOpacity(0.7),
      prefixIconColor: colorScheme.onSurface.withOpacity(0.7),
    );
  }
}
