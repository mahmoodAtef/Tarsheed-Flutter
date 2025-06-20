import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/utils/image_manager.dart';
import 'package:tarsheed/src/core/utils/theme_manager.dart';
import 'package:tarsheed/src/core/widgets/connectivity_widget.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';
import 'package:tarsheed/src/modules/settings/data/models/user.dart';

import '../../../../core/widgets/appbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: SettingsCubit.get()..getProfile(),
      child: Scaffold(
        appBar: CustomAppBar(text: S.of(context).profile),
        body: ConnectionWidget(
          onRetry: () => SettingsCubit.get().getProfile(),
          child: const ProfileContent(),
        ),
      ),
    );
  }
}

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  User? _originalUser;
  bool _hasChanges = false;
  bool _fieldsInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupControllerListeners();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _setupControllerListeners() {
    _firstNameController.addListener(_onTextChanged);
    _lastNameController.addListener(_onTextChanged);
    _emailController.addListener(_onTextChanged);
  }

  void _disposeControllers() {
    _firstNameController.removeListener(_onTextChanged);
    _lastNameController.removeListener(_onTextChanged);
    _emailController.removeListener(_onTextChanged);

    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
  }

  void _onTextChanged() {
    if (_fieldsInitialized) {
      _checkForChanges();
    }
  }

  void _checkForChanges() {
    if (_originalUser == null) return;

    final hasChanges =
        _firstNameController.text.trim() != _originalUser!.firstName ||
            _lastNameController.text.trim() != _originalUser!.lastName ||
            _emailController.text.trim() != _originalUser!.email;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  void _populateFields(User user) {
    _fieldsInitialized = false;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _emailController.text = user.email;
    _originalUser = user;
    _fieldsInitialized = true;
    _hasChanges = false;
  }

  void _saveChanges() {
    if (_originalUser == null || !_formKey.currentState!.validate()) return;

    final updatedUser = _originalUser!.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
    );

    SettingsCubit.get().updateProfile(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) =>
          current is SettingsErrorState || current is UpdateProfileSuccessState,
      listener: _handleStateChanges,
      buildWhen: (previous, current) =>
          current is SettingsInitial ||
          current is GetProfileLoadingState ||
          current is GetProfileSuccessState,
      builder: _buildContent,
    );
  }

  void _handleStateChanges(BuildContext context, SettingsState state) {
    if (state is SettingsErrorState) {
      ExceptionManager.showMessage(state.exception);
    } else if (state is UpdateProfileSuccessState) {
      _showSuccessMessage(context);
      _populateFields(state.user);
    }
  }

  Widget _buildContent(BuildContext context, SettingsState state) {
    if (state is GetProfileSuccessState) {
      if (!_fieldsInitialized) {
        _populateFields(state.user);
      }
      return _buildProfileForm(context);
    }

    if (state is GetProfileLoadingState) {
      return _buildLoadingState(context);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileAvatar(theme),
            SizedBox(height: 32.h),
            _buildFormFields(context),
            SizedBox(height: 32.h),
            if (_hasChanges) _buildSaveButton(context),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(ThemeData theme) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundImage: AssetImage(AssetsManager.avatar),
            backgroundColor: theme.colorScheme.surfaceVariant,
          ),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.outline,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.camera_alt,
              size: 20.r,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        _buildTextFormField(
          label: S.of(context).firstName,
          controller: _firstNameController,
          validator: _validateName,
        ),
        SizedBox(height: 16.h),
        _buildTextFormField(
          label: S.of(context).lastName,
          controller: _lastNameController,
          validator: _validateName,
        ),
        SizedBox(height: 16.h),
        _buildTextFormField(
          label: S.of(context).email,
          controller: _emailController,
          validator: _validateEmail,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: label,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          current is UpdateProfileLoadingState ||
          (previous is UpdateProfileLoadingState &&
              current is! UpdateProfileLoadingState),
      builder: (context, state) {
        final isLoading = state is UpdateProfileLoadingState;
        final theme = Theme.of(context);

        return SizedBox(
          height: 50.h,
          child: ElevatedButton(
            onPressed: isLoading ? null : _saveChanges,
            child: isLoading
                ? SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : Text(
                    S.of(context).saveChanges,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }

  // Validation methods
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).nameRequired;
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).emailRequired;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return S.of(context).invalidEmailFormat;
    }
    return null;
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          S.of(context).profileUpdatedSuccessfully,
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
}
