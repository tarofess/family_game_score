import 'package:flutter/material.dart';

class GradientCircleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double size;
  final List<Color> gradientColors;
  final TextStyle textStyle;

  const GradientCircleButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.size = 200.0,
    this.gradientColors = const [Colors.blue, Colors.purple],
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 18),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Color.fromARGB(255, 174, 206, 255),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
