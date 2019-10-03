import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_provider_app/providers/feed_provider.dart';
import 'package:flutter_provider_app/widgets/drawer.dart';
import 'package:flutter_provider_app/widgets/feed_list.dart';
import 'package:provider/provider.dart';

import 'exports.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromARGB(0, 255, 255, 255),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        builder: (_) => UserInformationProvider(),
      ),
      ChangeNotifierProvider(
        builder: (_) => FeedProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String code;
  String authToken;
  String refreshToken;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FeedList(),
      drawer: LeftDrawer(),
    );
  }
}
