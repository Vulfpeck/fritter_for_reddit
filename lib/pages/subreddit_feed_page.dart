import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/widgets/feed/subreddit_feed.dart';

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
    return Scaffold(
      body: CupertinoPageScaffold(
        child: CupertinoPageScaffold(
          child: SubredditFeed(
            pageTitle: widget.subreddit,
          ),
        ),
      ),
    );
  }
}
