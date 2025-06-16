import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/utils/image_manager.dart';

class CustomErrorWidget extends StatelessWidget {
  final Exception exception;
  final double? height;
  const CustomErrorWidget({super.key, required this.exception, this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image(
                height: 80.h,
                width: 80.w,
                image: AssetImage(ExceptionManager.getIconPath(exception)),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              ExceptionManager.getMessage(exception),
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitThreeBounce(
      color: ColorManager.primary,
      size: 30.sp,
    ));
  }
}

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              height: 60.h,
              width: 60.w,
              image: AssetImage(AssetsManager.noDataFound)),
          SizedBox(height: 10.h),
          Text(S.of(context).noDataFound),
        ],
      ),
    );
  }
}

void showToast(String message) {
  Fluttertoast.showToast(msg: message);
}

class DropDownWidget extends StatefulWidget {
  final String? value;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final String label;
  final List<DropDownItem> items;
  const DropDownWidget({
    super.key,
    this.value,
    this.validator,
    this.onChanged,
    required this.label,
    required this.items,
  });

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.value,
      hint: Text(widget.label),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.label,
      ),
      items: widget.items.map((item) {
        return DropdownMenuItem<String>(
          value: item.value,
          child: Row(
            children: [
              item.leading ?? const SizedBox(),
              const SizedBox(width: 8),
              Text(item.label),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          widget.onChanged!(value);
        });
      },
    );
  }
}

class DropDownItem {
  final String value;
  final String label;
  final Widget? leading;
  DropDownItem(this.value, this.label, {this.leading});
}
