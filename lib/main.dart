import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/pages/app_home.dart';

void main() {
  runApp(
    MultiProvider(
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
    ),
  );
}

class MyTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
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
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.black,
        dividerColor: Colors.white24,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.lightBlueAccent,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              background: Colors.black,
              surface: Colors.lightBlue.shade900,
              onSurface: Colors.lightBlue.shade100,
              secondary: Colors.lightBlue.shade800,
            ),
      ),
    );
  }
}
