import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/helpers/functions/hex_to_color_class.dart';
import 'package:fritter_for_reddit/models/subreddits/child.dart';
import 'package:fritter_for_reddit/providers/feed_provider.dart';
import 'package:fritter_for_reddit/widgets/common/circle_avatar_image.dart';

class DesktopSubredditDrawerTile extends StatelessWidget {
  final SubredditListChild subreddit;

  const DesktopSubredditDrawerTile({
    Key key,
    @required this.subreddit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        subreddit.display_name,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      leading: CircleAvatarImage(
          imageUrl: subreddit.community_icon != ""
              ? subreddit.community_icon
              : subreddit.icon_img,
          backgroundColor: HexColor(subreddit.primary_color)),
      onTap: () {
        FeedProvider.of(context).navigateToSubreddit(subreddit.display_name);
      },
    );
  }
}
