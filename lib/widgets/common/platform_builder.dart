import 'dart:io';

import 'package:flutter/material.dart';

class PlatformBuilder extends StatelessWidget {
  final WidgetBuilder android;
  final WidgetBuilder iOS;
  final WidgetBuilder windows;
  final WidgetBuilder macOS;
  final WidgetBuilder linux;
  final WidgetBuilder fuschia;
  final WidgetBuilder fallback;

  const PlatformBuilder({
    Key key,
    this.android,
    this.iOS,
    this.windows,
    this.macOS,
    this.linux,
    this.fuschia,
    this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      if (android != null) {
        return android(context);
      }
    }
    if (Platform.isIOS) {
      if (iOS != null) {
        return iOS(context);
      }
    }
    if (Platform.isWindows) {
      if (windows != null) {
        return windows(context);
      }
    }
    if (Platform.isMacOS) {
      if (macOS != null) {
        return macOS(context);
      }
    }
    if (Platform.isLinux) {
      if (linux != null) {
        return linux(context);
      }
    }
    if (Platform.isFuchsia) {
      if (fuschia != null) {
        return fuschia(context);
      }
    }

    assert(fallback != null,
        'A matching case was not found. You must define a fallback function in this case.');
    return fallback(context);
  }
}
