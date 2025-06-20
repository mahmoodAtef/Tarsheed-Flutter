import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/reports_cubit/reports_cubit.dart';
import 'package:tarsheed/src/modules/notifications/cubit/notifications_cubit.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/show_dialog.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/appbar.dart';
import 'edit_password_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          CustomAppBar(text: S.of(context).settings, withBackButton: false),
          Expanded(
            child: BlocListener<SettingsCubit, SettingsState>(
              listener: (context, state) {
                if (state is DeleteProfileLoadingState) {
                  _showLoadingDialog(context);
                } else if (state is DeleteProfileSuccessState) {
                  context.pop(); // Close loading dialog
                  _showSuccessSnackBar(context);
                  _clearData(context);
                } else if (state is SettingsErrorState) {
                  ExceptionManager.showMessage(state.exception);
                }
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Language Selection Section
                    _buildLanguageSection(
                        context, theme, textTheme, colorScheme),

                    SizedBox(height: 16.h),

                    // Theme Selection Section

                    SizedBox(height: 24.h),

                    // Settings Options
                    _buildSettingsOptions(
                        context, theme, textTheme, colorScheme),

                    // Bottom spacing
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = SettingsCubit.get();
        final currentLang = LocalizationManager.getCurrentLocale().languageCode;

        return Card(
          elevation: theme.cardTheme.elevation,
          color: theme.cardTheme.color,
          shape: theme.cardTheme.shape,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).language,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                  value: currentLang,
                  hint: Text(
                    S.of(context).selectLanguage,
                  ),
                  dropdownColor: theme.cardTheme.color,
                  style: textTheme.bodyLarge,
                  items: [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(
                        S.of(context).english,
                        style: textTheme.bodyLarge,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text(
                        S.of(context).arabic,
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null && value != currentLang) {
                      cubit.changeLanguage(value);
                    }
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                SizedBox(),
                SizedBox(
                  height: 20.h,
                ),
                _buildThemeOption(context, theme, textTheme, colorScheme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = SettingsCubit.get();
        bool isDarkMode = cubit.isDarkMode;

        if (state is ChangeThemeSuccessState) {
          isDarkMode = state.isDarkMode;
        } else if (state is SettingsLoadedState) {
          isDarkMode = state.isDarkMode;
        }

        return Row(
          children: [
            Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: colorScheme.onSurface,
              size: 24.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).theme,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    isDarkMode
                        ? S.of(context).darkMode
                        : S.of(context).lightMode,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                cubit.toggleTheme();
              },
              activeColor: colorScheme.primary,
              inactiveThumbColor: colorScheme.onSurface.withOpacity(0.6),
              inactiveTrackColor: colorScheme.onSurface.withOpacity(0.3),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsOptions(
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Card(
      elevation: theme.cardTheme.elevation,
      color: theme.cardTheme.color,
      shape: theme.cardTheme.shape,
      child: Column(
        children: [
          // Edit Password Option
          _buildSettingOption(
            context: context,
            theme: theme,
            textTheme: textTheme,
            colorScheme: colorScheme,
            icon: Icons.lock_outline,
            title: S.of(context).editPassword,
            onTap: () => context.push(EditPasswordPage()),
            showDivider: true,
          ),

          // Logout Option
          BlocProvider(
            create: (context) => AuthBloc.instance,
            child: BlocConsumer<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
                  current is LogoutSuccessState ||
                  current is LogoutLoadingState,
              listener: (context, state) {
                if (state is LogoutSuccessState) {
                  _clearData(context);
                }
              },
              builder: (context, state) {
                if (state is LogoutLoadingState) {
                  return _buildLoadingOption(theme, textTheme, context);
                }

                return _buildSettingOption(
                  context: context,
                  theme: theme,
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                  icon: Icons.logout,
                  title: S.of(context).signOut,
                  onTap: () => context.read<AuthBloc>().add(LogoutEvent()),
                  showDivider: true,
                );
              },
            ),
          ),

          // Delete Account Option
          _buildDeleteAccountOption(context, theme, textTheme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildSettingOption({
    required BuildContext context,
    required ThemeData theme,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = false,
    Color? textColor,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: textColor ?? colorScheme.onSurface,
                  size: 24.sp,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurface.withOpacity(0.6),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: theme.dividerTheme.thickness,
            color: theme.dividerTheme.color,
            indent: 56.w,
          ),
      ],
    );
  }

  Widget _buildLoadingOption(
      ThemeData theme, TextTheme textTheme, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          SizedBox(
            width: 24.sp,
            height: 24.sp,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.progressIndicatorTheme.color!,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            S.of(context).signingOut,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccountOption(
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return InkWell(
      onTap: () {
        showDeleteAccountDialog(context);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(
              Icons.delete_outline,
              color: colorScheme.error,
              size: 24.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                S.of(context).deleteMyAccount,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.error.withOpacity(0.6),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        shape: theme.dialogTheme.shape,
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: theme.progressIndicatorTheme.color,
              ),
              SizedBox(height: 16.h),
              Text(
                S.of(context).deletingAccount,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          S.of(context).accountDeletedSuccess,
          style: Theme.of(context).snackBarTheme.contentTextStyle,
        ),
        backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
        behavior: Theme.of(context).snackBarTheme.behavior,
        shape: Theme.of(context).snackBarTheme.shape,
      ),
    );
  }

  void _clearData(BuildContext context) {
    context.pushAndRemove(LoginPage()).whenComplete(() {
      DevicesCubit.get().close();
      DashboardBloc.get().close();
      ReportsCubit.get().close();
      NotificationsCubit.get().close();
      SettingsCubit.get().changeIndex(0);
    });
  }
}
