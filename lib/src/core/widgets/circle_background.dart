import 'package:flutter/material.dart';

class BackgroundCircle extends CustomPainter {
  final ColorScheme colorScheme;

  BackgroundCircle({required this.colorScheme});

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..color = colorScheme.primary.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    Paint linePaint = Paint()
      ..color = colorScheme.primary.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw main circle
    canvas.drawCircle(
      Offset(size.width * 1.1, size.height * -0.05),
      size.width * 0.83,
      circlePaint,
    );

    // Draw decorative path
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is BackgroundCircle &&
        oldDelegate.colorScheme != colorScheme;
  }
}
