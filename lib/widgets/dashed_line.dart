import 'package:flutter/material.dart';


class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 9, dashSpace = 5, startX = -10;
    final paint = Paint()
      ..color = Color(0xFF666666)
      ..strokeWidth = 2;
    while (startX < size.width+10) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}