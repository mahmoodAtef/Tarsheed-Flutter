import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
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
import '../widgets/container_with_switch.dart';
import 'edit_password_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Fixed AppBar at the top
          CustomAppBar(text: S.of(context).settings, withBackButton: false),

          // Scrollable content
          Expanded(
            child: BlocListener<SettingsCubit, SettingsState>(
              listener: (context, state) {
                if (state is DeleteProfileLoadingState) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is DeleteProfileSuccessState) {
                  context.pop(); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(S.of(context).accountDeletedSuccess)));
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
                    BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                        final cubit = SettingsCubit.get();
                        final currentLang =
                            LocalizationManager.getCurrentLocale().languageCode;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).language,
                              style: TextStyle(
                                color: ColorManager.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            DropdownButtonFormField<String>(
                              value: currentLang,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10.w),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'en',
                                  child: Text('English'),
                                ),
                                DropdownMenuItem(
                                  value: 'ar',
                                  child: Text('العربية'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null && value != currentLang) {
                                  cubit.changeLanguage(value);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 20.h),

                    // Edit Password Section
                    CustomContainer(
                      text: S.of(context).editPassword,
                      onTap: () {
                        context.push(EditPasswordPage());
                      },
                    ),

                    SizedBox(height: 5.h),

                    // Logout Section
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
                          return state is LogoutLoadingState
                              ? Center(child: CustomLoadingWidget())
                              : CustomContainer(
                                  text: S.of(context).signOut,
                                  icon: Icons.logout,
                                  onTap: () {
                                    context.read<AuthBloc>().add(LogoutEvent());
                                  },
                                );
                        },
                      ),
                    ),

                    SizedBox(height: 5.h),

                    // Delete Account Section
                    TextButton(
                      onPressed: () {
                        Fluttertoast.showToast(msg: "قولنا محدش يحذف الأكونت");
                        showDeleteAccountDialog(context);
                      },
                      child: Center(
                        child: Text(
                          S.of(context).deleteMyAccount,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.red,
                          ),
                        ),
                      ),
                    ),

                    // Add some bottom padding to prevent content from being cut off
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
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
