import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlideUpRoute<T> extends CupertinoPageRoute<T> {
  SlideUpRoute({
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(
          builder: builder,
          settings: settings,
          fullscreenDialog: false,
        );
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
