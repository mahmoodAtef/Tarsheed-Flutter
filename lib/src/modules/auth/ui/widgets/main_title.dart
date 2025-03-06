import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainTitle extends StatelessWidget {
  const MainTitle({required this.maintext});

  final String maintext;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        maintext,
        style: TextStyle(
          fontSize: 30.sp,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2666DE),
        ),
      ),
    );
  }
}
