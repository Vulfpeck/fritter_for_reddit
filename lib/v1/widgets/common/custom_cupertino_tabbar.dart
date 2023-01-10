import 'package:flutter/cupertino.dart';

class CustomCupertinoTabBar extends CupertinoTabBar {
  final Color? backgroundColor;
  final Color? activeColor;
  final List<BottomNavigationBarItem> items;

  CustomCupertinoTabBar({this.backgroundColor, this.activeColor, required this.items})
      : super(
            items: items,
            backgroundColor: backgroundColor,
            activeColor: activeColor);
  @override
  bool opaque(BuildContext context) {
    return true;
  }
}
