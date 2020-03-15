import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/helpers/functions/hex_to_color_class.dart';
import 'package:fritter_for_reddit/models/subreddits/child.dart';
import 'package:fritter_for_reddit/providers/feed_provider.dart';

class DesktopSubredditDrawerTile extends StatelessWidget {
  final Child child;

  const DesktopSubredditDrawerTile({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        child.display_name,
        style: Theme.of(context).textTheme.subhead,
      ),
      leading: CircleAvatar(
        maxRadius: 16,
        backgroundImage: child.community_icon != ""
            ? CachedNetworkImageProvider(
                child.community_icon,
              )
            : child.icon_img != ""
                ? CachedNetworkImageProvider(
                    child.icon_img,
                  )
                : AssetImage('assets/default_icon.png'),
        backgroundColor: child.primary_color == ""
            ? Theme.of(context).accentColor
            : HexColor(
                child.primary_color,
              ),
      ),
      onTap: () {
        FeedProvider.of(context, listen: false)
            .fetchPostsListing(currentSubreddit: child.display_name);
      },
    );
  }
}
