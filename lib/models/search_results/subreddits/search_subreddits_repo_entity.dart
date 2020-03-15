import 'package:fritter_for_reddit/generated/json/base/json_convert_content.dart';
import 'package:fritter_for_reddit/generated/json/base/json_filed.dart';

class SearchSubredditsRepoEntity with JsonConvert<SearchSubredditsRepoEntity> {
  List<SearchSubredditsRepoSubreddit> subreddits;
}

class SearchSubredditsRepoSubreddit
    with JsonConvert<SearchSubredditsRepoSubreddit> {
  @JSONField(name: "active_user_count")
  int activeUserCount;
  @JSONField(name: "icon_img")
  String iconImg;
  @JSONField(name: "key_color")
  String keyColor;
  String name;
  @JSONField(name: "subscriber_count")
  int subscriberCount;
  @JSONField(name: "is_chat_post_feature_enabled")
  bool isChatPostFeatureEnabled;
  @JSONField(name: "allow_chat_post_creation")
  bool allowChatPostCreation;
  @JSONField(name: "allow_images")
  bool allowImages;
}
