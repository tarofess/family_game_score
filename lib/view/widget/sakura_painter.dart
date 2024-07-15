import 'dart:math';

import 'package:flutter/material.dart';

class SakuraPainter extends CustomPainter {
  final List<SakuraPetal> petals;
  SakuraPainter(this.petals);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 255, 183, 197)
      ..style = PaintingStyle.fill;

    for (var petal in petals) {
      canvas.save();
      canvas.translate(petal.x, petal.y);
      canvas.rotate(petal.rotation);

      final path = Path()
        ..moveTo(0, -petal.size / 2)
        ..cubicTo(petal.size / 3, -petal.size / 2, petal.size / 2,
            -petal.size / 6, petal.size / 2, petal.size / 2)
        ..cubicTo(petal.size / 2, petal.size / 3, petal.size / 6,
            petal.size / 2, 0, petal.size / 2)
        ..cubicTo(-petal.size / 6, petal.size / 2, -petal.size / 2,
            petal.size / 3, -petal.size / 2, petal.size / 2)
        ..cubicTo(-petal.size / 2, -petal.size / 6, -petal.size / 3,
            -petal.size / 2, 0, -petal.size / 2);

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SakuraPetal {
  double x;
  double y;
  double size;
  double speed;
  double angle;
  double rotation;

  SakuraPetal()
      : x = Random().nextDouble() * 400,
        y = Random().nextDouble() * 800,
        size = Random().nextDouble() * 10 + 5,
        speed = Random().nextDouble() * 2 + 1,
        angle = Random().nextDouble() * 2 * pi,
        rotation = Random().nextDouble() * 2 * pi;

  void update() {
    y += speed;
    x += speed * sin(angle);
    rotation += 0.01;
    if (y > 800) {
      y = -size;
      x = Random().nextDouble() * 400;
    }
  }
}
