import 'package:flutter/material.dart';

class BackgroundCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..color = Color(0xFFF1F4FF)
      ..style = PaintingStyle.fill;

    Paint linePaint = Paint()
      ..color = Color(0xFFE0E4FF)
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
