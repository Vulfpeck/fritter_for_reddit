import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_provider_app/widgets/drawer.dart';
import 'package:flutter_provider_app/widgets/feed_list.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).platformBrightness);
    return MaterialApp(
      themeMode: ThemeMode.dark,
      title: 'Flutter Demo',
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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        child: FeedList(),
        value: SystemUiOverlayStyle.dark,
      ),
      drawer: LeftDrawer(),
    );
  }
}
