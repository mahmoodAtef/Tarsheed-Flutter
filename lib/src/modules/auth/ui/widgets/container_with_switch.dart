import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatefulWidget {
  const CustomContainer({
    super.key,
    this.height,
    required this.text,
    this.size,
    this.onTap,
    this.status,
    this.icon,
    this.onpressed,
  });

  final double? height;
  final String text;
  final double? size;
  final VoidCallback? onTap;
  final bool? status;
  final IconData? icon;
  final VoidCallback? onpressed;

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool? status;

  @override
  void initState() {
    super.initState();
    status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.r,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: widget.size ?? 18.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (status != null)
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Switch(
                      inactiveThumbColor: Color(0xFF2666DE),
                      activeColor: Colors.white,
                      inactiveTrackColor: Color(0xFFD4E2FD),
                      activeTrackColor: Color(0xFF669BF7),
                      value: status!,
                      onChanged: (val) {
                        setState(() {
                          status = val;
                        });
                      },
                    ),
                  ),
                if (widget.icon != null)
                  IconButton(
                    onPressed: widget.onpressed,
                    icon: Icon(widget.icon, size: 20.sp, color: Colors.black),
                  ),
              ],
            ),
          ),
          Divider(thickness: 1, color: Colors.grey[300]),
          SizedBox(height: 6.h),
        ],
      ),
    );
  }
}
