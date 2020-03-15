import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/widgets/desktop/desktop_subreddit_feed.dart';
import 'package:fritter_for_reddit/widgets/feed/subreddit_feed.dart';

class DesktopSubredditFeedPage extends StatefulWidget {
  final String subreddit;
  final bool frontPageLoad;
  DesktopSubredditFeedPage({this.subreddit = "", this.frontPageLoad = false});

  @override
  _DesktopSubredditFeedPageState createState() =>
      _DesktopSubredditFeedPageState();
}

class _DesktopSubredditFeedPageState extends State<DesktopSubredditFeedPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        child: CupertinoPageScaffold(
          child: DesktopSubredditFeed(
            pageTitle: widget.subreddit,
          ),
        ),
      ),
    );
  }
}
