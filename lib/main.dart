import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';
import 'package:flutter_provider_app/widgets/drawer.dart';
import 'package:flutter_provider_app/widgets/feed_list.dart';
import 'package:provider/provider.dart';

import 'exports.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(),
  );
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
    );
  }
}

class Machod extends StatefulWidget {
  @override
  _MachodState createState() => _MachodState();
}

class _MachodState extends State<Machod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(),
      body: Consumer(
        builder: (BuildContext context, CommentsProvider model, _) {
          return Column(
            children: <Widget>[
              RaisedButton(
                child: Text('get comments lol'),
                onPressed: () {
                  model.fetchComments();
                },
              ),
            ],
          );
        },
      ),
    );
  }
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
