import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/widgets/feed/subreddit_feed.dart';

class SubredditFeedPage extends StatefulWidget {
  final String subreddit;
  final bool frontPageLoad;
  SubredditFeedPage({this.subreddit = "", this.frontPageLoad = false});

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
    // print("New scaffold from " + widget.subreddit);
    return CupertinoPageScaffold(
      child: ChangeNotifierProvider(
        builder: (context) => widget.frontPageLoad
            ? FeedProvider()
            : FeedProvider.openFromName(widget.subreddit),
        child: Scaffold(
          body: SubredditFeed(
            pageTitle: widget.subreddit,
          ),
        ),
      ),
    );
  }
}
