import 'package:flutter/material.dart';
import 'dart:math' as math;

// This is the Painter class
class HalfCircleRight extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xFF121212);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height , size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi*0.5,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}