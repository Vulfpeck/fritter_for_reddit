import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/helpers/functions/hex_to_color_class.dart';
import 'package:fritter_for_reddit/models/subreddit_info/subreddit_information_entity.dart';
import 'package:fritter_for_reddit/models/subreddits/child.dart';
import 'package:fritter_for_reddit/providers/feed_provider.dart';
import 'package:fritter_for_reddit/widgets/common/circle_avatar_image.dart';

class DesktopSubredditDrawerTile extends StatelessWidget {
  final String displayName;

  final String communityIcon;

  final String iconImg;

  final String primaryColor;

  DesktopSubredditDrawerTile.fromSubredditListChild({
    Key key,
    @required SubredditListChild subreddit,
  })  : displayName = subreddit.display_name,
        communityIcon = subreddit.community_icon,
        iconImg = subreddit.icon_img,
        primaryColor = subreddit.primary_color,
        super(key: key);
  DesktopSubredditDrawerTile.fromSubredditInformationEntity({
    Key key,
    @required SubredditInformationEntity subreddit,
  })  : displayName = subreddit.data.displayName,
        communityIcon = subreddit.data.communityIcon,
        iconImg = subreddit.data.iconImg,
        primaryColor = subreddit.data.primaryColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ListTile(
          dense: true,
          title: Text(
            displayName,
            style: Theme.of(context).textTheme.subtitle1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
          leading: CircleAvatarImage(
              imageUrl: communityIcon != "" ? communityIcon : iconImg,
              backgroundColor: HexColor(primaryColor)),
          onTap: () {
            FeedProvider.of(context).navigateToSubreddit(displayName);
          },
        );
      },
    );
  }
}
