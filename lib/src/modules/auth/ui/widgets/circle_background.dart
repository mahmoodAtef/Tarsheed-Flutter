import 'package:flutter/material.dart';

class BackgroundCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..color = Color(0xFFF1F4FF) // لون الدائرة الكبيرة
      ..style = PaintingStyle.fill;

    Paint linePaint = Paint()
      ..color = Color(0xFFE0E4FF) // لون الخط الدائري
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // رسم الدائرة الكبيرة في الخلفية
    canvas.drawCircle(
      Offset(size.width * 1.1, size.height * -0.05), // الموقع
      size.width * 0.83, // الحجم (التجربة حسب الحاجة)
      circlePaint,
    );

    // رسم الخط الدائري المنحني
    Path path = Path();
    path.moveTo(0, size.height * 0.01); // نقطة البداية أعلى الشاشة يسارًا
    path.arcToPoint(
      Offset(size.width, size.height * 0.4), // نقطة النهاية مع الحافة اليمنى
      radius: Radius.circular(size.width * 0.9), // نصف القطر لمنحنى سلس
      clockwise: false, // للتحكم في اتجاه القوس
    );

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

