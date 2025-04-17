import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../settings/cubit/settings_cubit.dart';

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
                S.of(context).deleteAccountTitle, // Localized Title
                style: TextStyle(
                  color: ColorManager.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                S.of(context).deleteAccountMessage, // Localized Message
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
                      child: Text(S.of(context).cancel, // Localized cancel text
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
                      child: Text(
                          S.of(context).confirmDelete, // Localized confirm text
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
