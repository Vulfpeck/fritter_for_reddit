import 'package:fritter_for_reddit/models/search_results/subreddits/search_subreddits_repo_entity.dart';

searchSubredditsRepoEntityFromJson(
    SearchSubredditsRepoEntity data, Map<String, dynamic> json) {
  if (json['subreddits'] != null) {
    data.subreddits = new List<SubredditSearchResultEntry>();
    (json['subreddits'] as List).forEach((v) {
      data.subreddits.add(new SubredditSearchResultEntry().fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> searchSubredditsRepoEntityToJson(
    SearchSubredditsRepoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.subreddits != null) {
    data['subreddits'] = entity.subreddits.map((v) => v.toJson()).toList();
  }
  return data;
}

searchSubredditsRepoSubredditFromJson(
    SubredditSearchResultEntry data, Map<String, dynamic> json) {
  data.activeUserCount = json['active_user_count']?.toInt();
  data.iconImg = json['icon_img']?.toString();
  data.keyColor = json['key_color']?.toString();
  data.name = json['name']?.toString();
  data.subscriberCount = json['subscriber_count']?.toInt();
  data.isChatPostFeatureEnabled = json['is_chat_post_feature_enabled'];
  data.allowChatPostCreation = json['allow_chat_post_creation'];
  data.allowImages = json['allow_images'];
  return data;
}

Map<String, dynamic> searchSubredditsRepoSubredditToJson(
    SubredditSearchResultEntry entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['active_user_count'] = entity.activeUserCount;
  data['icon_img'] = entity.iconImg;
  data['key_color'] = entity.keyColor;
  data['name'] = entity.name;
  data['subscriber_count'] = entity.subscriberCount;
  data['is_chat_post_feature_enabled'] = entity.isChatPostFeatureEnabled;
  data['allow_chat_post_creation'] = entity.allowChatPostCreation;
  data['allow_images'] = entity.allowImages;
  return data;
}
