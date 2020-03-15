import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/pages/subreddit_feed_page.dart';

class DesktopMainSubredditTile extends StatelessWidget {
  final String subreddit;
  final String title;
  final String description;

  const DesktopMainSubredditTile({
    Key key,
    @required this.subreddit,
    @required this.title,
    @required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.subhead,
      ),
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/default_icon.png'),
        backgroundColor: Theme.of(context).accentColor,
        maxRadius: 16,
      ),
      subtitle: Text(description),
      dense: true,
      onTap: () {
        Provider.of<FeedProvider>(context, listen: false)
            .fetchPostsListing(currentSubreddit: subreddit);
      },
    );
  }
}
