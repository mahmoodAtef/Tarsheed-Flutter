import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/services/app_initializer.dart';
import 'package:tarsheed/src/core/utils/image_manager.dart';
import 'package:tarsheed/src/core/widgets/rectangle_background.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/sign_up_create_account.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(child: BackGroundRectangle()),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  SizedBox(height: 24.h),
                  _buildWelcomeText(context, textTheme, colorScheme),
                  SizedBox(height: 40.h),
                  _buildActionButtons(context, theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 220.w,
      height: 220.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.asset(
          AssetsManager.logo,
          width: 220.w,
          height: 220.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildWelcomeText(
      BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 343.w),
      child: Text(
        S.of(context).takeControl,
        textAlign: TextAlign.center,
        style: textTheme.displaySmall?.copyWith(
          fontSize: 28.sp,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20.w,
      runSpacing: 16.h,
      children: [
        _buildLoginButton(context, theme),
        _buildRegisterButton(context, theme),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: 140.w,
      height: 50.h,
      child: ElevatedButton(
        style: theme.elevatedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStateProperty.all(theme.colorScheme.primary),
          foregroundColor:
              MaterialStateProperty.all(theme.colorScheme.onPrimary),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          elevation: MaterialStateProperty.all(4),
          shadowColor: MaterialStateProperty.all(
            theme.colorScheme.primary.withOpacity(0.3),
          ),
        ),
        onPressed: () => _handleLoginPressed(context),
        child: Text(
          S.of(context).login,
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 50.h,
      child: TextButton(
        style: theme.textButtonTheme.style?.copyWith(
          foregroundColor:
              MaterialStateProperty.all(theme.colorScheme.onBackground),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          overlayColor: MaterialStateProperty.all(
            theme.colorScheme.primary.withOpacity(0.1),
          ),
        ),
        onPressed: () => _handleRegisterPressed(context),
        child: Text(
          S.of(context).register,
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onBackground,
          ),
        ),
      ),
    );
  }

  void _handleLoginPressed(BuildContext context) {
    AppInitializer.saveFirstRunFlag();
    context.push(LoginPage());
  }

  void _handleRegisterPressed(BuildContext context) {
    AppInitializer.saveFirstRunFlag();
    context.push(SignUpScreen());
  }
}
