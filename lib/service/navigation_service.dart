import 'package:flutter/material.dart';

class NavigationService {
  void push(BuildContext context, Widget view) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => view));
  }

  void pushReplacement(BuildContext context, Widget view) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => view));
  }

  void pop(BuildContext context) {
    Navigator.pop(context);
  }

  void pushReplacementWithAnimationFromBottom(
      BuildContext context, Widget view) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => view,
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.fastLinearToSlowEaseIn;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void pushAndRemoveUntil(BuildContext context, Widget view) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => view),
        (Route<dynamic> route) => false);
  }
}
