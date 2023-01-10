import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void launchURL(Color toolBarColor, String? url) async {
  if (Platform.isMacOS) {
    Process.run('open', [url!]);
  } else
    try {
      await launch(
        url!,
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      // print(e.toString());
    }
}
