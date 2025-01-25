import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientCircleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final List<Color> gradientColors;

  const GradientCircleButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.r,
      height: 200.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color.fromARGB(255, 174, 206, 255),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

List<Color> getActiveButtonColor() {
  return const [
    Color.fromARGB(255, 255, 194, 102),
    Color.fromARGB(255, 255, 101, 90)
  ];
}

List<Color> getInactiveButtonColor() {
  return const [
    Color.fromARGB(255, 223, 223, 223),
    Color.fromARGB(255, 109, 109, 109)
  ];
}
