import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/exports.dart';

class DesktopMainSubredditTile extends StatelessWidget {
  final String subreddit;
  final String title;
  final String description;
  final Function(String subreddit) onTap;

  const DesktopMainSubredditTile({
    Key key,
    @required this.subreddit,
    @required this.title,
    @required this.description,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/default_icon.png'),
        backgroundColor: Theme.of(context).accentColor,
        maxRadius: 16,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subtitle: Text(description),
      dense: true,
      onTap: () => onTap(subreddit),
    );
  }
}
