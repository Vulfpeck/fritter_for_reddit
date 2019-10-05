import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/models/subreddit_info/subreddit_information_entity.dart';
import 'package:flutter_provider_app/models/user_profile/user_information_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "PostsFeedEntity") {
      return PostsFeedEntity.fromJson(json) as T;
    } else if (T.toString() == "SubredditInformationEntity") {
      return SubredditInformationEntity.fromJson(json) as T;
    } else if (T.toString() == "UserInformationEntity") {
      return UserInformationEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}