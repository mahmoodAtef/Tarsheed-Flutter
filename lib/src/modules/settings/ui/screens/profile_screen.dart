import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/utils/image_manager.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';
import 'package:tarsheed/src/modules/settings/data/models/user.dart';

import '../../../../core/widgets/appbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<SettingsCubit>()..getProfile(),
      child: Scaffold(
        appBar: CustomAppBar(text: S.of(context).profile),
        body: const ProfileContent(),
      ),
    );
  }
}

class ProfileContent extends StatefulWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  User? _originalUser;
  bool _hasChanges = false;
  bool _fieldsInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupControllerListeners();
  }

  void _setupControllerListeners() {
    _firstNameController.addListener(_onTextChanged);
    _lastNameController.addListener(_onTextChanged);
    _emailController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Only check for changes if fields were already initialized
    if (_fieldsInitialized) {
      _checkForChanges();
    }
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_onTextChanged);
    _lastNameController.removeListener(_onTextChanged);
    _emailController.removeListener(_onTextChanged);

    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    if (_originalUser == null) return;

    final hasChanges = _firstNameController.text != _originalUser!.firstName ||
        _lastNameController.text != _originalUser!.lastName ||
        _emailController.text != _originalUser!.email;

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
  }

  void _saveChanges() {
    if (_originalUser == null) return;

    final updatedUser = _originalUser!.copyWith(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
    );

    context.read<SettingsCubit>().updateProfile(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) =>
          current is SettingsErrorState || current is UpdateProfileSuccessState,
      listener: (context, state) {
        if (state is SettingsErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(ExceptionManager.getMessage(state.exception))),
          );
        } else if (state is UpdateProfileSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).profileUpdatedSuccessfully)),
          );
          setState(() {
            _populateFields(state.user);
          });
        }
      },
      buildWhen: (previous, current) =>
          current is SettingsInitial ||
          current is GetProfileLoadingState ||
          current is GetProfileSuccessState,
      builder: (context, state) {
        if (state is GetProfileSuccessState) {
          _populateFields(state.user);
          return _buildProfileForm();
        }

        if (state is GetProfileLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProfileForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: AssetImage(AssetsManager.avatar),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 24.r,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            _buildTextField(S.of(context).firstName, _firstNameController),
            SizedBox(height: 16.h),
            _buildTextField(S.of(context).lastName, _lastNameController),
            SizedBox(height: 16.h),
            _buildTextField(S.of(context).email, _emailController),
            SizedBox(height: 16.h),

            SizedBox(height: 32.h),
            // Only show save button if changes are detected
            if (_hasChanges)
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, current) =>
                    current is UpdateProfileLoadingState ||
                    !(previous is UpdateProfileLoadingState &&
                        current is! UpdateProfileLoadingState),
                builder: (context, state) {
                  final isLoading = state is UpdateProfileLoadingState;

                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              S.of(context).saveChanges,
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  );
                },
              ),
            SizedBox(height: 24.h), // Add some bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            suffixIcon: suffix,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(8.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(8.r),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIconConstraints: BoxConstraints(
              minWidth: suffix != null ? 100.w : 40.w,
            ),
          ),
          onChanged: (_) {
            _checkForChanges();
          },
        ),
      ],
    );
  }
}
