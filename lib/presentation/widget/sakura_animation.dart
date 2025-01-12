import 'dart:math';

import 'package:family_game_score/application/state/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SakuraAnimation extends HookConsumerWidget {
  const SakuraAnimation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionProvider).valueOrNull;

    final animationController = useAnimationController(
      duration: const Duration(seconds: 10),
    )..repeat();

    final petals = useState(List.generate(35, (index) => SakuraPetal()));

    useEffect(() {
      void listener() {
        petals.value = petals.value.map((petal) {
          petal.update();
          return petal;
        }).toList();
      }

      animationController.addListener(listener);
      return () => animationController.removeListener(listener);
    }, [animationController]);

    return session?.endTime == null
        ? const SizedBox()
        : CustomPaint(
            painter: SakuraPainter(petals.value),
            child: Container(),
          );
  }
}

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
      : x = Random().nextDouble() * 400.r,
        y = Random().nextDouble() * 800.r,
        size = Random().nextDouble() * 10.r + 5.r,
        speed = Random().nextDouble() * 2.r + 1,
        angle = Random().nextDouble() * 2.r * pi,
        rotation = Random().nextDouble() * 2.r * pi;

  void update() {
    y += speed;
    x += speed * sin(angle);
    rotation += 0.01;
    if (y > 800.r) {
      y = -size;
      x = Random().nextDouble() * 400.r;
    }
  }
}
