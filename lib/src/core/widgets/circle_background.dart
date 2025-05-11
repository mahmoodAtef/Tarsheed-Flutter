import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class BackgroundCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..color = ColorManager.lightBlue
      ..style = PaintingStyle.fill;

    Paint linePaint = Paint()
      ..color = ColorManager.lightPeriwinkle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(
      Offset(size.width * 1.1, size.height * -0.05),
      size.width * 0.83,
      circlePaint,
    );

    Path path = Path();
    path.moveTo(0, size.height * 0.01);
    path.arcToPoint(
      Offset(size.width, size.height * 0.4),
      radius: Radius.circular(size.width * 0.9),
      clockwise: false,
    );

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
