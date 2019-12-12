import 'package:flutter/material.dart';
import 'package:flutter_provider_app/widgets/drawer/drawer.dart';
import 'package:flutter_provider_app/widgets/feed/feed_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FeedList(),
      drawer: LeftDrawer(),
      drawerScrimColor: Theme.of(context).accentColor.withOpacity(0.2),
    );
  }
}
