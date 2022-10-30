import 'package:fritter_for_reddit/v1/generated/json/base/json_convert_content.dart';
import 'package:fritter_for_reddit/v1/generated/json/base/json_filed.dart';

class SearchPostsRepoEntity with JsonConvert<SearchPostsRepoEntity> {
  String kind;
  SearchPostsRepoEntityData data;
}

class SearchPostsRepoEntityData with JsonConvert<SearchPostsRepoEntityData> {
  String after;
  int dist;
  SearchPostsRepoEntityDataFacets facets;
  String modhash;
  List<SearchPostsRepoEntityDatachild> children;
  dynamic before;
}

class SearchPostsRepoEntityDataFacets
    with JsonConvert<SearchPostsRepoEntityDataFacets> {}

class SearchPostsRepoEntityDatachild
    with JsonConvert<SearchPostsRepoEntityDatachild> {
  String kind;
  SearchPostsRepoEntityDataChildrenData data;
}

class SearchPostsRepoEntityDataChildrenData
    with JsonConvert<SearchPostsRepoEntityDataChildrenData> {
  @JSONField(name: "approved_at_utc")
  dynamic approvedAtUtc;
  String subreddit;
  String selftext;
  @JSONField(name: "author_fullname")
  String authorFullname;
  bool saved;
  @JSONField(name: "mod_reason_title")
  dynamic modReasonTitle;
  int gilded;
  bool clicked;
  String title;
  @JSONField(name: "link_flair_richtext")
  List<dynamic> linkFlairRichtext;
  @JSONField(name: "subreddit_name_prefixed")
  String subredditNamePrefixed;
  bool hidden;
  dynamic pwls;
  @JSONField(name: "link_flair_css_class")
  dynamic linkFlairCssClass;
  int downs;
  @JSONField(name: "thumbnail_height")
  int thumbnailHeight;
  @JSONField(name: "hide_score")
  bool hideScore;
  String name;
  bool quarantine;
  @JSONField(name: "link_flair_text_color")
  String linkFlairTextColor;
  @JSONField(name: "author_flair_background_color")
  dynamic authorFlairBackgroundColor;
  @JSONField(name: "subreddit_type")
  String subredditType;
  int ups;
  @JSONField(name: "total_awards_received")
  int totalAwardsReceived;
  @JSONField(name: "media_embed")
  SearchPostsRepoEntityDataChildrenDataMediaEmbed mediaEmbed;
  @JSONField(name: "thumbnail_width")
  int thumbnailWidth;
  @JSONField(name: "author_flair_template_id")
  dynamic authorFlairTemplateId;
  @JSONField(name: "is_original_content")
  bool isOriginalContent;
  @JSONField(name: "user_reports")
  List<dynamic> userReports;
  @JSONField(name: "secure_media")
  dynamic secureMedia;
  @JSONField(name: "is_reddit_media_domain")
  bool isRedditMediaDomain;
  @JSONField(name: "is_meta")
  bool isMeta;
  dynamic category;
  @JSONField(name: "secure_media_embed")
  SearchPostsRepoEntityDataChildrenDataSecureMediaEmbed secureMediaEmbed;
  @JSONField(name: "link_flair_text")
  dynamic linkFlairText;
  @JSONField(name: "can_mod_post")
  bool canModPost;
  int score;
  @JSONField(name: "approved_by")
  dynamic approvedBy;
  @JSONField(name: "author_premium")
  bool authorPremium;
  String thumbnail;
  dynamic edited;
  @JSONField(name: "author_flair_css_class")
  dynamic authorFlairCssClass;
  @JSONField(name: "steward_reports")
  List<dynamic> stewardReports;
  @JSONField(name: "author_flair_richtext")
  List<dynamic> authorFlairRichtext;
  SearchPostsRepoEntityDataChildrenDataGildings gildings;
  @JSONField(name: "post_hint")
  String postHint;
  @JSONField(name: "content_categories")
  dynamic contentCategories;
  @JSONField(name: "is_self")
  bool isSelf;
  @JSONField(name: "mod_note")
  dynamic modNote;
  int created;
  @JSONField(name: "link_flair_type")
  String linkFlairType;
  dynamic wls;
  @JSONField(name: "removed_by_category")
  dynamic removedByCategory;
  @JSONField(name: "banned_by")
  dynamic bannedBy;
  @JSONField(name: "author_flair_type")
  String authorFlairType;
  String domain;
  @JSONField(name: "allow_live_comments")
  bool allowLiveComments;
  @JSONField(name: "selftext_html")
  dynamic selftextHtml;
  dynamic likes;
  @JSONField(name: "suggested_sort")
  dynamic suggestedSort;
  @JSONField(name: "banned_at_utc")
  dynamic bannedAtUtc;
  @JSONField(name: "view_count")
  dynamic viewCount;
  bool archived;
  @JSONField(name: "no_follow")
  bool noFollow;
  @JSONField(name: "is_crosspostable")
  bool isCrosspostable;
  bool pinned;
  @JSONField(name: "over_18")
  bool over18;
  SearchPostsRepoEntityDataChildrenDataPreview preview;
  @JSONField(name: "all_awardings")
  List<dynamic> allAwardings;
  List<dynamic> awarders;
  @JSONField(name: "media_only")
  bool mediaOnly;
  @JSONField(name: "can_gild")
  bool canGild;
  bool spoiler;
  bool locked;
  @JSONField(name: "author_flair_text")
  dynamic authorFlairText;
  bool visited;
  @JSONField(name: "removed_by")
  dynamic removedBy;
  @JSONField(name: "num_reports")
  dynamic numReports;
  dynamic distinguished;
  @JSONField(name: "subreddit_id")
  String subredditId;
  @JSONField(name: "mod_reason_by")
  dynamic modReasonBy;
  @JSONField(name: "removal_reason")
  dynamic removalReason;
  @JSONField(name: "link_flair_background_color")
  String linkFlairBackgroundColor;
  String id;
  @JSONField(name: "is_robot_indexable")
  bool isRobotIndexable;
  @JSONField(name: "report_reasons")
  dynamic reportReasons;
  String author;
  @JSONField(name: "discussion_type")
  dynamic discussionType;
  @JSONField(name: "num_comments")
  int numComments;
  @JSONField(name: "send_replies")
  bool sendReplies;
  @JSONField(name: "whitelist_status")
  dynamic whitelistStatus;
  @JSONField(name: "contest_mode")
  bool contestMode;
  @JSONField(name: "mod_reports")
  List<dynamic> modReports;
  @JSONField(name: "author_patreon_flair")
  bool authorPatreonFlair;
  @JSONField(name: "author_flair_text_color")
  dynamic authorFlairTextColor;
  String permalink;
  @JSONField(name: "parent_whitelist_status")
  dynamic parentWhitelistStatus;
  bool stickied;
  String url;
  @JSONField(name: "subreddit_subscribers")
  int subredditSubscribers;
  @JSONField(name: "created_utc")
  int createdUtc;
  @JSONField(name: "num_crossposts")
  int numCrossposts;
  dynamic media;
  @JSONField(name: "is_video")
  bool isVideo;
}

class SearchPostsRepoEntityDataChildrenDataMediaEmbed
    with JsonConvert<SearchPostsRepoEntityDataChildrenDataMediaEmbed> {}

class SearchPostsRepoEntityDataChildrenDataSecureMediaEmbed
    with JsonConvert<SearchPostsRepoEntityDataChildrenDataSecureMediaEmbed> {}

class SearchPostsRepoEntityDataChildrenDataGildings
    with JsonConvert<SearchPostsRepoEntityDataChildrenDataGildings> {}

class SearchPostsRepoEntityDataChildrenDataPreview
    with JsonConvert<SearchPostsRepoEntityDataChildrenDataPreview> {
  List<SearchPostsRepoEntityDatachildDataPreviewImages> images;
  bool enabled;
}

class SearchPostsRepoEntityDatachildDataPreviewImages
    with JsonConvert<SearchPostsRepoEntityDatachildDataPreviewImages> {
  SearchPostsRepoEntityDataChildrenDataPreviewImagesSource source;
  List<SearchPostsRepoEntityDatachildDataPreviewImagesResolutions> resolutions;
  SearchPostsRepoEntityDataChildrenDataPreviewImagesVariants variants;
  String id;
}

class SearchPostsRepoEntityDataChildrenDataPreviewImagesSource
    with JsonConvert<SearchPostsRepoEntityDataChildrenDataPreviewImagesSource> {
  String url;
  int width;
  int height;
}

class SearchPostsRepoEntityDatachildDataPreviewImagesResolutions
    with
        JsonConvert<
            SearchPostsRepoEntityDatachildDataPreviewImagesResolutions> {
  String url;
  int width;
  int height;
}

class SearchPostsRepoEntityDataChildrenDataPreviewImagesVariants
    with
        JsonConvert<
            SearchPostsRepoEntityDataChildrenDataPreviewImagesVariants> {}
