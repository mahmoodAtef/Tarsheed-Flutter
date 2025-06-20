import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';

import '../../../../../generated/l10n.dart';
import '../../cubit/settings_cubit.dart';

void showDeleteAccountDialog(BuildContext context) {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final colorScheme = theme.colorScheme;

  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (context) {
      return AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        elevation: theme.dialogTheme.elevation,
        shape: theme.dialogTheme.shape,
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 340.w,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with warning icon
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: colorScheme.error,
                    size: 28.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      S.of(context).deleteAccountTitle,
                      style: theme.dialogTheme.titleTextStyle?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Warning message
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: colorScheme.error.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  S.of(context).deleteAccountMessage,
                  style: theme.dialogTheme.contentTextStyle?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Action buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      style: theme.outlinedButtonTheme.style?.copyWith(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        side: MaterialStateProperty.all(
                          BorderSide(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: () => context.pop(),
                      child: Text(
                        S.of(context).cancel,
                        style: textTheme.labelLarge?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Delete button
                  Expanded(
                    child: ElevatedButton(
                      style: theme.elevatedButtonTheme.style?.copyWith(
                        backgroundColor:
                            MaterialStateProperty.all(colorScheme.error),
                        foregroundColor:
                            MaterialStateProperty.all(colorScheme.onError),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        elevation: MaterialStateProperty.all(2),
                        shadowColor: MaterialStateProperty.all(
                          colorScheme.error.withOpacity(0.3),
                        ),
                      ),
                      onPressed: () async {
                        context.pop();
                        final cubit = SettingsCubit.get();
                        await cubit.deleteProfile();
                      },
                      child: Text(
                        S.of(context).confirmDelete,
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onError,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Optional: Enhanced version with confirmation input
void showDeleteAccountDialogWithConfirmation(BuildContext context) {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final colorScheme = theme.colorScheme;
  final TextEditingController confirmationController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final isConfirmationValid =
              confirmationController.text.toLowerCase() ==
                  S.of(context).deleteConfirmationWord.toLowerCase();

          return AlertDialog(
            backgroundColor: theme.dialogTheme.backgroundColor,
            elevation: theme.dialogTheme.elevation,
            shape: theme.dialogTheme.shape,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: 360.w,
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with warning icon
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: colorScheme.error,
                        size: 28.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          S.of(context).deleteAccountTitle,
                          style: theme.dialogTheme.titleTextStyle?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Warning message
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: colorScheme.error.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).deleteAccountMessage,
                          style: theme.dialogTheme.contentTextStyle?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          S.of(context).deleteAccountConfirmationInstruction,
                          style: theme.dialogTheme.contentTextStyle?.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Confirmation input
                  Theme(
                    data: ThemeData(
                        inputDecorationTheme:
                            theme.inputDecorationTheme.copyWith(
                      focusedBorder:
                          theme.inputDecorationTheme.focusedBorder?.copyWith(
                        borderSide: BorderSide(
                          color: colorScheme.error,
                          width: 2,
                        ),
                      ),
                    )),
                    child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.keyboard,
                            color: colorScheme.error.withOpacity(0.7),
                          ),
                          hintText: S.of(context).deleteConfirmationWord),
                      controller: confirmationController,
                      style: textTheme.bodyMedium,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Action buttons
                  Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: OutlinedButton(
                          style: theme.outlinedButtonTheme.style?.copyWith(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 12.h),
                            ),
                          ),
                          onPressed: () => context.pop(),
                          child: Text(
                            S.of(context).cancel,
                            style: textTheme.labelLarge?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // Delete button
                      Expanded(
                        child: ElevatedButton(
                          style: theme.elevatedButtonTheme.style?.copyWith(
                            backgroundColor: MaterialStateProperty.all(
                              isConfirmationValid
                                  ? colorScheme.error
                                  : colorScheme.error.withOpacity(0.5),
                            ),
                            foregroundColor:
                                MaterialStateProperty.all(colorScheme.onError),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 12.h),
                            ),
                          ),
                          onPressed: isConfirmationValid
                              ? () async {
                                  context.pop();
                                  final cubit = SettingsCubit.get();
                                  await cubit.deleteProfile();
                                }
                              : null,
                          child: Text(
                            S.of(context).confirmDelete,
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onError,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
