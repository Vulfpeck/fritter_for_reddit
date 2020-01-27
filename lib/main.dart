import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/pages/app_home.dart';
import 'package:flutter_provider_app/providers/search_provider.dart';

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
        ),
        ChangeNotifierProvider(
          builder: (_) => SearchProvider(),
        ),
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
          color: Colors.black.withOpacity(0.7),
        ),
        primaryColor: Colors.blue,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              background: Colors.blueGrey.shade50,
              surface: Colors.blueGrey.shade100,
              onSurface: Colors.blueGrey,
              secondary: Colors.blueGrey.shade100,
            ),
        dividerTheme: DividerThemeData(color: Colors.black.withOpacity(0.15)),
        cardColor: Colors.white,
        textTheme: Theme.of(context).textTheme.copyWith(
              title: TextStyle(
                fontSize: 15,
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
              ),
              body2: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade800,
              ),
              caption: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade900,
              ),
              subtitle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700,
              ),
            ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.black,
        dividerTheme: DividerThemeData(
          color: Colors.white.withOpacity(0.12),
          thickness: 1,
        ),
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.redAccent,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              background: Colors.black,
              surface: Colors.lightBlue.shade900,
              onSurface: Colors.lightBlue.shade100,
              secondary: Colors.lightBlue.shade800,
            ),
        textTheme: ThemeData.dark().textTheme.copyWith(
              title: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
                color: Colors.white.withOpacity(0.95),
              ),
              body2: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.8),
              ),
              caption: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
              subtitle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(
                  0.55,
                ),
              ),
            ),
      ),
    );
  }
}
