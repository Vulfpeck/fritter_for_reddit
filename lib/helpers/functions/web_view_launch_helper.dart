import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void launchURL(BuildContext context, String url) async {
  try {
    await launch(
      url,
      option: new CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        enableInstantApps: true,
        animation: new CustomTabsAnimation(
          startEnter: 'slide_up',
          endExit: 'slide_down',
        ),
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    // print(e.toString());
  }
}
