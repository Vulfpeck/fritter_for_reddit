import 'package:flutter_provider_app/models/Subreddit.dart';
import 'package:meta/meta.dart';

class AppUserInformation {
  final String icon_color;
  final String icon_img;
  final String display_name_prefixed;
  final String comment_karma;
  final String link_karma;
  final List<Subreddit> subredditsList;

  AppUserInformation({
    @required this.icon_color,
    @required this.icon_img,
    @required this.display_name_prefixed,
    @required this.comment_karma,
    @required this.link_karma,
    @required this.subredditsList,
  });
}
