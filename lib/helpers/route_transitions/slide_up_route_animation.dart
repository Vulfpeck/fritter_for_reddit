import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlideUpRoute extends PageRouteBuilder {
  final Widget page;
  SlideUpRoute({this.page})
      : super(
          opaque: true,
          barrierColor: Colors.black54,
          transitionDuration: Duration(milliseconds: 450),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              end: Offset.zero,
              begin: Offset(0, 1),
            ).animate(
              CurvedAnimation(
                curve: Curves.linearToEaseOut,
                parent: animation,
                reverseCurve: Curves.easeInToLinear,
              ),
            ),
            child: page,
          ),
        );
}
