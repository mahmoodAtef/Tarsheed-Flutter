import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class UsageCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;

  const UsageCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164,
      height: 64,
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: ColorManager.black),
          ),
          Text(
            value,
            style: TextStyle(
              color: ColorManager.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 3),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                  color: ColorManager.black,
                  fontSize: 5,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
