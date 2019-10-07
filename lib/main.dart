import 'package:flutter/material.dart';
import 'package:flutter_provider_app/pages/app_home.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';
import 'package:provider/provider.dart';

import 'exports.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        builder: (_) => UserInformationProvider(),
      ),
      ChangeNotifierProvider(
        builder: (_) => FeedProvider(),
      ),
      ChangeNotifierProvider(
        builder: (_) => CommentsProvider(),
      )
    ],
    child: MyTestApp(),
  ));
}

class MyTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      home: MyApp(),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
    );
  }
}
