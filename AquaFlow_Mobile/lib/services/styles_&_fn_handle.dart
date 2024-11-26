import 'package:flutter/material.dart';

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const Offset beginOffset = Offset(1.0, 0.0); // Slide in from right
      const Offset endOffset = Offset(0.0, 0.0);
      return SlideTransition(
        position: Tween<Offset>(begin: beginOffset, end: endOffset)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(animation),
        child: child,
      );
    },
  );
}