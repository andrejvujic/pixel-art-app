import 'package:flutter/material.dart';

Route buildSlideRoute(Widget _child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => _child,
    transitionsBuilder: (context, animation, secondaryAnimation, _child) {
      final begin = Offset(0.0, 1.0);
      final end = Offset.zero;
      final curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: _child,
      );
    },
  );
}
