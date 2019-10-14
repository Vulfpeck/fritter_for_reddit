import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/pages/app_home.dart';

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
      home: HomePage(),
      theme: ThemeData(
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
    );
  }
}
