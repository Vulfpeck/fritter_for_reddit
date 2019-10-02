import 'package:meta/meta.dart';

class Subreddit {
  final String displayName;
  final String headerImg;
  final String displayNamePrefixed;
  final String subscribers;
  final String communityIcon;
  final String userIsSubscriber;
  final String url;

  Subreddit({
    @required this.displayName,
    @required this.headerImg,
    @required this.displayNamePrefixed,
    @required this.subscribers,
    @required this.communityIcon,
    @required this.userIsSubscriber,
    @required this.url,
  });
}
