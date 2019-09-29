import 'package:meta/meta.dart';

class Subreddit {
  final String display_name;
  final String header_img;
  final String display_name_prefixed;
  final String subscribers;
  final String community_icon;
  final String user_is_subscriber;
  final String url;

  Subreddit({
    @required this.display_name,
    @required this.header_img,
    @required this.display_name_prefixed,
    @required this.subscribers,
    @required this.community_icon,
    @required this.user_is_subscriber,
    @required this.url,
  });
}
