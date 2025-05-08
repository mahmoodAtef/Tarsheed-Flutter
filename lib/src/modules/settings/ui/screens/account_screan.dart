import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/profile_screen.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/security_screen.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/setting.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../auth/ui/widgets/card_item.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(text: S.of(context).account, withBackButton: false),
        Container(
          color: ColorManager.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildItem(
                icon: Icons.person_outline,
                title: S.of(context).profile,
                subtitle: S.of(context).editPassNaAddUseEm,
                onTap: () {
                  context.push(ProfilePage());
                },
              ),
              SizedBox(height: 20.h),
              BuildItem(
                icon: Icons.shield_outlined,
                title: S.of(context).security,
                subtitle: S.of(context).faceTwoStVerification,
                onTap: () {
                  context.push(SecurityPage());
                },
              ),
              SizedBox(height: 20.h),
              BuildItem(
                icon: Icons.settings,
                title: S.of(context).settings,
                subtitle: S.of(context).lanBackEneMO,
                onTap: () {
                  context.push(SettingPage());
                },
              ),
              SizedBox(height: 25.h),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.only(left: 3.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFEFEFEF), width: 3.w),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.white,
                        offset: Offset(0, 4.h),
                        blurRadius: 4.r,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 34.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).rateApplication,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorManager.black,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                        color: ColorManager.black,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              BlocConsumer<AuthBloc, AuthState>(
                listenWhen: (previous, current) =>
                    current is LogoutSuccessState ||
                    current is LogoutLoadingState,
                listener: (context, state) {
                  if (state is LogoutSuccessState) {
                    context.pushAndRemove(LoginPage());
                  }
                },
                builder: (context, state) {
                  return state is LogoutLoadingState
                      ? Center(child: CustomLoadingWidget())
                      : TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(LogoutEvent());
                          },
                          child: Center(
                            child: Text(
                              S.of(context).signOut,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorManager.red,
                              ),
                            ),
                          ),
                        );
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ],
    );
  }
}
