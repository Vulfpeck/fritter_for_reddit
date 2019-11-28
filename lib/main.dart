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
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        colorScheme: Theme.of(context).colorScheme.copyWith(
              background: Colors.blueGrey.shade50,
              surface: Colors.blueGrey.shade100,
              onSurface: Colors.blueGrey,
              secondary: Colors.blueGrey.shade100,
            ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey.shade900,
        dividerColor: Colors.white24,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.orange.shade200,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              background: Colors.black,
              surface: Colors.brown.shade900,
              onSurface: Colors.yellow.shade100,
              secondary: Colors.grey.shade800,
            ),
      ),
    );
  }
}
