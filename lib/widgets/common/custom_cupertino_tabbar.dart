import 'package:flutter/cupertino.dart';

class CustomCupertinoTabBar extends CupertinoTabBar {
  final backgroundColor;
  final activeColor;
  final items;

  CustomCupertinoTabBar({this.backgroundColor, this.activeColor, this.items})
      : super(
            items: items,
            backgroundColor: backgroundColor,
            activeColor: activeColor);
  @override
  bool opaque(BuildContext context) {
    return true;
  }
}
