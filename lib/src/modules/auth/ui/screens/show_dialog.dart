import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';

void showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Container(
          width: 340.w,
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delete Your Account?',
                style: TextStyle(
                  color: ColorManager.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Once you submit a request to delete data,"
                " there's a 72-hour window during which you can cancel the process."
                " During this period, you can cancel your deletion request in your Intuit Account."
                " After the window, you'll no longer be able to cancel the request, "
                "and we're unable to retrieve your data.",
                style: TextStyle(
                  color: ColorManager.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ColorManager.black,
                        backgroundColor: ColorManager.white,
                        elevation: 1,
                        side: BorderSide.none,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel',
                          style: TextStyle(
                            color: ColorManager.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.red,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        final cubit = SettingsCubit.getInstance;
                        await cubit.deleteProfile();
                      },
                      child: Text('Confirm Delete',
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          )),
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
