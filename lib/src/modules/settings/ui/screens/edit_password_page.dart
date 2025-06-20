import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../../../../core/utils/theme_manager.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../auth/bloc/auth_bloc.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: _handleAuthStateChanges,
      child: Scaffold(
        appBar: CustomAppBar(text: S.of(context).editPassword),
        body: _buildBody(theme),
      ),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is UpdatePasswordLoadingState) {
      _showLoadingDialog(context);
    } else if (state is UpdatePasswordSuccessState) {
      context.pop(); // close loading dialog
      _showSuccessSnackBar(context);
      Navigator.pop(context); // go back to previous screen
    } else if (state is AuthErrorState) {
      context.pop(); // close loading dialog if open
      ExceptionManager.showMessage(state.exception);
    }
  }

  Widget _buildBody(ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 30.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPasswordField(
              controller: _oldPasswordController,
              label: S.of(context).currentPassword,
              validator: _validateCurrentPassword,
            ),
            SizedBox(height: 16.h),
            _buildPasswordField(
              controller: _newPasswordController,
              label: S.of(context).newPassword,
              validator: _validateNewPassword,
            ),
            SizedBox(height: 16.h),
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: S.of(context).confirmNewPassword,
              validator: _validateConfirmPassword,
            ),
            SizedBox(height: 32.h),
            _buildUpdateButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: validator,
    );
  }

  Widget _buildUpdateButton(ThemeData theme) {
    return SizedBox(
      height: 50.h,
      child: ElevatedButton(
        onPressed: _handleUpdatePassword,
        child: Text(
          S.of(context).updatePassword,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _handleUpdatePassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      _showErrorSnackBar(
        context,
        S.of(context).passwordsDoNotMatch,
      );
      return;
    }

    AuthBloc.instance.add(
      UpdatePasswordEvent(
        oldPassword: oldPassword,
        newPassword: newPassword,
      ),
    );
  }

  // Validation methods
  String? _validateCurrentPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).currentPassword + ' ' + S.of(context).required;
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).newPassword + ' ' + S.of(context).required;
    }
    if (value.length < 8) {
      return S.of(context).passwordAtLeast;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).confirmNewPassword + ' ' + S.of(context).required;
    }
    if (value != _newPasswordController.text) {
      return S.of(context).passwordsDoNotMatch;
    }
    return null;
  }

  // Helper methods for dialogs and snack bars
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          S.of(context).passwordUpdatedSuccessfully,
          style: Theme.of(context).snackBarTheme.contentTextStyle,
        ),
        backgroundColor: ThemeManager.statusColors['active'],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).snackBarTheme.contentTextStyle,
        ),
        backgroundColor: ThemeManager.statusColors['high'], // danger red
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
