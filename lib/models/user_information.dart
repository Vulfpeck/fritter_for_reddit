import 'package:flutter_provider_app/models/subreddit.dart';
import 'package:meta/meta.dart';

class AppUserInformation {
  final String iconColor;
  final String iconImg;
  final String displayNamePrefixed;
  final String commentKarma;
  final String linkKarma;
  final List<Subreddit> subredditsList;

  AppUserInformation({
    @required this.iconColor,
    @required this.iconImg,
    @required this.displayNamePrefixed,
    @required this.commentKarma,
    @required this.linkKarma,
    @required this.subredditsList,
  });
}
