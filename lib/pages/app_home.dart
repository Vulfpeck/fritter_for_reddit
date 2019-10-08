import 'package:flutter/material.dart';
import 'package:flutter_provider_app/widgets/drawer/drawer.dart';
import 'package:flutter_provider_app/widgets/feed/feed_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
