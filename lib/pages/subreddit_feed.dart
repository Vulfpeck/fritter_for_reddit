import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/widgets/feed/subreddit_feed.dart';

class SubredditFeedPage extends StatefulWidget {
  final subreddit;
  SubredditFeedPage({this.subreddit});

  @override
  _SubredditFeedPageState createState() => _SubredditFeedPageState();
}

class _SubredditFeedPageState extends State<SubredditFeedPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("New scaffold from " + widget.subreddit);
    return ChangeNotifierProvider(
      builder: (context) => FeedProvider.openFromName(widget.subreddit),
      child: Scaffold(
        body: SubredditFeed(),
      ),
    );
  }
}
