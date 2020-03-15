import 'package:fritter_for_reddit/models/search_results/posts/search_posts_repo_entity_entity.dart';

searchPostsRepoEntityFromJson(
    SearchPostsRepoEntity data, Map<String, dynamic> json) {
  data.kind = json['kind']?.toString();
  data.data = json['data'] != null
      ? new SearchPostsRepoEntityData().fromJson(json['data'])
      : null;
  return data;
}

Map<String, dynamic> searchPostsRepoEntityToJson(SearchPostsRepoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['kind'] = entity.kind;
  if (entity.data != null) {
    data['data'] = SearchPostsRepoEntityData().toJson();
  }
  return data;
}

searchPostsRepoEntityDataFromJson(
    SearchPostsRepoEntityData data, Map<String, dynamic> json) {
  data.after = json['after']?.toString();
  data.dist = json['dist']?.toInt();
  data.facets = json['facets'] != null
      ? new SearchPostsRepoEntityDataFacets().fromJson(json['facets'])
      : null;
  data.modhash = json['modhash']?.toString();
  if (json['children'] != null) {
    data.children = new List<SearchPostsRepoEntityDatachild>();
    (json['children'] as List).forEach((v) {
      data.children.add(new SearchPostsRepoEntityDatachild().fromJson(v));
    });
  }
  data.before = json['before'];
  return data;
}

Map<String, dynamic> searchPostsRepoEntityDataToJson(
    SearchPostsRepoEntityData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['after'] = entity.after;
  data['dist'] = entity.dist;
  if (entity.facets != null) {
    data['facets'] = SearchPostsRepoEntityDataFacets().toJson();
  }
  data['modhash'] = entity.modhash;
  if (entity.children != null) {
    data['children'] = entity.children.map((v) => v.toJson()).toList();
  }
  data['before'] = entity.before;
  return data;
}

searchPostsRepoEntityDataFacetsFromJson(
    SearchPostsRepoEntityDataFacets data, Map<String, dynamic> json) {
  return data;
}

Map<String, dynamic> searchPostsRepoEntityDataFacetsToJson(
    SearchPostsRepoEntityDataFacets entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}

searchPostsRepoEntityDatachildFromJson(
    SearchPostsRepoEntityDatachild data, Map<String, dynamic> json) {
  data.kind = json['kind']?.toString();
  data.data = json['data'] != null
      ? new SearchPostsRepoEntityDataChildrenData().fromJson(json['data'])
      : null;
  return data;
}

Map<String, dynamic> searchPostsRepoEntityDatachildToJson(
    SearchPostsRepoEntityDatachild entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['kind'] = entity.kind;
  if (entity.data != null) {
    data['data'] = SearchPostsRepoEntityDataChildrenData().toJson();
  }
  return data;
}

searchPostsRepoEntityDataChildrenDataFromJson(
    SearchPostsRepoEntityDataChildrenData data, Map<String, dynamic> json) {
  data.approvedAtUtc = json['approved_at_utc'];
  data.subreddit = json['subreddit']?.toString();
  data.selftext = json['selftext']?.toString();
  data.authorFullname = json['author_fullname']?.toString();
  data.saved = json['saved'];
  data.modReasonTitle = json['mod_reason_title'];
  data.gilded = json['gilded']?.toInt();
  data.clicked = json['clicked'];
  data.title = json['title']?.toString();
  if (json['link_flair_richtext'] != null) {
    data.linkFlairRichtext = new List<dynamic>();
    data.linkFlairRichtext.addAll(json['link_flair_richtext']);
  }
  data.subredditNamePrefixed = json['subreddit_name_prefixed']?.toString();
  data.hidden = json['hidden'];
  data.pwls = json['pwls'];
  data.linkFlairCssClass = json['link_flair_css_class'];
  data.downs = json['downs']?.toInt();
  data.thumbnailHeight = json['thumbnail_height']?.toInt();
  data.hideScore = json['hide_score'];
  data.name = json['name']?.toString();
  data.quarantine = json['quarantine'];
  data.linkFlairTextColor = json['link_flair_text_color']?.toString();
  data.authorFlairBackgroundColor = json['author_flair_background_color'];
  data.subredditType = json['subreddit_type']?.toString();
  data.ups = json['ups']?.toInt();
  data.totalAwardsReceived = json['total_awards_received']?.toInt();
  data.mediaEmbed = json['media_embed'] != null
      ? new SearchPostsRepoEntityDataChildrenDataMediaEmbed()
          .fromJson(json['media_embed'])
      : null;
  data.thumbnailWidth = json['thumbnail_width']?.toInt();
  data.authorFlairTemplateId = json['author_flair_template_id'];
  data.isOriginalContent = json['is_original_content'];
  if (json['user_reports'] != null) {
    data.userReports = new List<dynamic>();
    data.userReports.addAll(json['user_reports']);
  }
  data.secureMedia = json['secure_media'];
  data.isRedditMediaDomain = json['is_reddit_media_domain'];
  data.isMeta = json['is_meta'];
  data.category = json['category'];
  data.secureMediaEmbed = json['secure_media_embed'] != null
      ? new SearchPostsRepoEntityDataChildrenDataSecureMediaEmbed()
          .fromJson(json['secure_media_embed'])
      : null;
  data.linkFlairText = json['link_flair_text'];
  data.canModPost = json['can_mod_post'];
  data.score = json['score']?.toInt();
  data.approvedBy = json['approved_by'];
  data.authorPremium = json['author_premium'];
  data.thumbnail = json['thumbnail']?.toString();
  data.edited = json['edited'];
  data.authorFlairCssClass = json['author_flair_css_class'];
  if (json['steward_reports'] != null) {
    data.stewardReports = new List<dynamic>();
    data.stewardReports.addAll(json['steward_reports']);
  }
  if (json['author_flair_richtext'] != null) {
    data.authorFlairRichtext = new List<dynamic>();
    data.authorFlairRichtext.addAll(json['author_flair_richtext']);
  }
  data.gildings = json['gildings'] != null
      ? new SearchPostsRepoEntityDataChildrenDataGildings()
          .fromJson(json['gildings'])
      : null;
  data.postHint = json['post_hint']?.toString();
  data.contentCategories = json['content_categories'];
  data.isSelf = json['is_self'];
  data.modNote = json['mod_note'];
  data.created = json['created']?.toInt();
  data.linkFlairType = json['link_flair_type']?.toString();
  data.wls = json['wls'];
  data.removedByCategory = json['removed_by_category'];
  data.bannedBy = json['banned_by'];
  data.authorFlairType = json['author_flair_type']?.toString();
  data.domain = json['domain']?.toString();
  data.allowLiveComments = json['allow_live_comments'];
  data.selftextHtml = json['selftext_html'];
  data.likes = json['likes'];
  data.suggestedSort = json['suggested_sort'];
  data.bannedAtUtc = json['banned_at_utc'];
  data.viewCount = json['view_count'];
  data.archived = json['archived'];
  data.noFollow = json['no_follow'];
  data.isCrosspostable = json['is_crosspostable'];
  data.pinned = json['pinned'];
  data.over18 = json['over_18'];
  data.preview = json['preview'] != null
      ? new SearchPostsRepoEntityDataChildrenDataPreview()
          .fromJson(json['preview'])
      : null;
  if (json['all_awardings'] != null) {
    data.allAwardings = new List<dynamic>();
    data.allAwardings.addAll(json['all_awardings']);
  }
  if (json['awarders'] != null) {
    data.awarders = new List<dynamic>();
    data.awarders.addAll(json['awarders']);
  }
  data.mediaOnly = json['media_only'];
  data.canGild = json['can_gild'];
  data.spoiler = json['spoiler'];
  data.locked = json['locked'];
  data.authorFlairText = json['author_flair_text'];
  data.visited = json['visited'];
  data.removedBy = json['removed_by'];
  data.numReports = json['num_reports'];
  data.distinguished = json['distinguished'];
  data.subredditId = json['subreddit_id']?.toString();
  data.modReasonBy = json['mod_reason_by'];
  data.removalReason = json['removal_reason'];
  data.linkFlairBackgroundColor =
      json['link_flair_background_color']?.toString();
  data.id = json['id']?.toString();
  data.isRobotIndexable = json['is_robot_indexable'];
  data.reportReasons = json['report_reasons'];
  data.author = json['author']?.toString();
  data.discussionType = json['discussion_type'];
  data.numComments = json['num_comments']?.toInt();
  data.sendReplies = json['send_replies'];
  data.whitelistStatus = json['whitelist_status'];
  data.contestMode = json['contest_mode'];
  if (json['mod_reports'] != null) {
    data.modReports = new List<dynamic>();
    data.modReports.addAll(json['mod_reports']);
  }
  data.authorPatreonFlair = json['author_patreon_flair'];
  data.authorFlairTextColor = json['author_flair_text_color'];
  data.permalink = json['permalink']?.toString();
  data.parentWhitelistStatus = json['parent_whitelist_status'];
  data.stickied = json['stickied'];
  data.url = json['url']?.toString();
  data.subredditSubscribers = json['subreddit_subscribers']?.toInt();
  data.createdUtc = json['created_utc']?.toInt();
  data.numCrossposts = json['num_crossposts']?.toInt();
  data.media = json['media'];
  data.isVideo = json['is_video'];
  return data;
}

Map<String, dynamic> searchPostsRepoEntityDataChildrenDataToJson(
    SearchPostsRepoEntityDataChildrenData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['approved_at_utc'] = entity.approvedAtUtc;
  data['subreddit'] = entity.subreddit;
  data['selftext'] = entity.selftext;
  data['author_fullname'] = entity.authorFullname;
  data['saved'] = entity.saved;
  data['mod_reason_title'] = entity.modReasonTitle;
  data['gilded'] = entity.gilded;
  data['clicked'] = entity.clicked;
  data['title'] = entity.title;
  if (entity.linkFlairRichtext != null) {
    data['link_flair_richtext'] = [];
  }
  data['subreddit_name_prefixed'] = entity.subredditNamePrefixed;
  data['hidden'] = entity.hidden;
  data['pwls'] = entity.pwls;
  data['link_flair_css_class'] = entity.linkFlairCssClass;
  data['downs'] = entity.downs;
  data['thumbnail_height'] = entity.thumbnailHeight;
  data['hide_score'] = entity.hideScore;
  data['name'] = entity.name;
  data['quarantine'] = entity.quarantine;
  data['link_flair_text_color'] = entity.linkFlairTextColor;
  data['author_flair_background_color'] = entity.authorFlairBackgroundColor;
  data['subreddit_type'] = entity.subredditType;
  data['ups'] = entity.ups;
  data['total_awards_received'] = entity.totalAwardsReceived;
  if (entity.mediaEmbed != null) {
    data['media_embed'] =
        SearchPostsRepoEntityDataChildrenDataMediaEmbed().toJson();
  }
  data['thumbnail_width'] = entity.thumbnailWidth;
  data['author_flair_template_id'] = entity.authorFlairTemplateId;
  data['is_original_content'] = entity.isOriginalContent;
  if (entity.userReports != null) {
    data['user_reports'] = [];
  }
  data['secure_media'] = entity.secureMedia;
  data['is_reddit_media_domain'] = entity.isRedditMediaDomain;
  data['is_meta'] = entity.isMeta;
  data['category'] = entity.category;
  if (entity.secureMediaEmbed != null) {
    data['secure_media_embed'] =
        SearchPostsRepoEntityDataChildrenDataSecureMediaEmbed().toJson();
  }
  data['link_flair_text'] = entity.linkFlairText;
  data['can_mod_post'] = entity.canModPost;
  data['score'] = entity.score;
  data['approved_by'] = entity.approvedBy;
  data['author_premium'] = entity.authorPremium;
  data['thumbnail'] = entity.thumbnail;
  data['edited'] = entity.edited;
  data['author_flair_css_class'] = entity.authorFlairCssClass;
  if (entity.stewardReports != null) {
    data['steward_reports'] = [];
  }
  if (entity.authorFlairRichtext != null) {
    data['author_flair_richtext'] = [];
  }
  if (entity.gildings != null) {
    data['gildings'] = SearchPostsRepoEntityDataChildrenDataGildings().toJson();
  }
  data['post_hint'] = entity.postHint;
  data['content_categories'] = entity.contentCategories;
  data['is_self'] = entity.isSelf;
  data['mod_note'] = entity.modNote;
  data['created'] = entity.created;
  data['link_flair_type'] = entity.linkFlairType;
  data['wls'] = entity.wls;
  data['removed_by_category'] = entity.removedByCategory;
  data['banned_by'] = entity.bannedBy;
  data['author_flair_type'] = entity.authorFlairType;
  data['domain'] = entity.domain;
  data['allow_live_comments'] = entity.allowLiveComments;
  data['selftext_html'] = entity.selftextHtml;
  data['likes'] = entity.likes;
  data['suggested_sort'] = entity.suggestedSort;
  data['banned_at_utc'] = entity.bannedAtUtc;
  data['view_count'] = entity.viewCount;
  data['archived'] = entity.archived;
  data['no_follow'] = entity.noFollow;
  data['is_crosspostable'] = entity.isCrosspostable;
  data['pinned'] = entity.pinned;
  data['over_18'] = entity.over18;
  if (entity.preview != null) {
    data['preview'] = SearchPostsRepoEntityDataChildrenDataPreview().toJson();
  }
  if (entity.allAwardings != null) {
    data['all_awardings'] = [];
  }
  if (entity.awarders != null) {
    data['awarders'] = [];
  }
  data['media_only'] = entity.mediaOnly;
  data['can_gild'] = entity.canGild;
  data['spoiler'] = entity.spoiler;
  data['locked'] = entity.locked;
  data['author_flair_text'] = entity.authorFlairText;
  data['visited'] = entity.visited;
  data['removed_by'] = entity.removedBy;
  data['num_reports'] = entity.numReports;
  data['distinguished'] = entity.distinguished;
  data['subreddit_id'] = entity.subredditId;
  data['mod_reason_by'] = entity.modReasonBy;
  data['removal_reason'] = entity.removalReason;
  data['link_flair_background_color'] = entity.linkFlairBackgroundColor;
  data['id'] = entity.id;
  data['is_robot_indexable'] = entity.isRobotIndexable;
  data['report_reasons'] = entity.reportReasons;
  data['author'] = entity.author;
  data['discussion_type'] = entity.discussionType;
  data['num_comments'] = entity.numComments;
  data['send_replies'] = entity.sendReplies;
  data['whitelist_status'] = entity.whitelistStatus;
  data['contest_mode'] = entity.contestMode;
  if (entity.modReports != null) {
    data['mod_reports'] = [];
  }
  data['author_patreon_flair'] = entity.authorPatreonFlair;
  data['author_flair_text_color'] = entity.authorFlairTextColor;
  data['permalink'] = entity.permalink;
  data['parent_whitelist_status'] = entity.parentWhitelistStatus;
  data['stickied'] = entity.stickied;
  data['url'] = entity.url;
  data['subreddit_subscribers'] = entity.subredditSubscribers;
  data['created_utc'] = entity.createdUtc;
  data['num_crossposts'] = entity.numCrossposts;
  data['media'] = entity.media;
  data['is_video'] = entity.isVideo;
  return data;
}

searchPostsRepoEntityDataChildrenDataMediaEmbedFromJson(
    SearchPostsRepoEntityDataChildrenDataMediaEmbed data,
    Map<String, dynamic> json) {
  return data;
}

Map<String, dynamic> searchPostsRepoEntityDataChildrenDataMediaEmbedToJson(
    SearchPostsRepoEntityDataChildrenDataMediaEmbed entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}

searchPostsRepoEntityDataChildrenDataSecureMediaEmbedFromJson(
    SearchPostsRepoEntityDataChildrenDataSecureMediaEmbed data,
    Map<String, dynamic> json) {
  return data;
}

Map<String, dynamic>
    searchPostsRepoEntityDataChildrenDataSecureMediaEmbedToJson(
        SearchPostsRepoEntityDataChildrenDataSecureMediaEmbed entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}

searchPostsRepoEntityDataChildrenDataGildingsFromJson(
    SearchPostsRepoEntityDataChildrenDataGildings data,
    Map<String, dynamic> json) {
  return data;
}

Map<String, dynamic> searchPostsRepoEntityDataChildrenDataGildingsToJson(
    SearchPostsRepoEntityDataChildrenDataGildings entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}

searchPostsRepoEntityDataChildrenDataPreviewFromJson(
    SearchPostsRepoEntityDataChildrenDataPreview data,
    Map<String, dynamic> json) {
  if (json['images'] != null) {
    data.images = new List<SearchPostsRepoEntityDatachildDataPreviewImages>();
    (json['images'] as List).forEach((v) {
      data.images.add(
          new SearchPostsRepoEntityDatachildDataPreviewImages().fromJson(v));
    });
  }
  data.enabled = json['enabled'];
  return data;
}

Map<String, dynamic> searchPostsRepoEntityDataChildrenDataPreviewToJson(
    SearchPostsRepoEntityDataChildrenDataPreview entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.images != null) {
    data['images'] = entity.images.map((v) => v.toJson()).toList();
  }
  data['enabled'] = entity.enabled;
  return data;
}

searchPostsRepoEntityDatachildDataPreviewImagesFromJson(
    SearchPostsRepoEntityDatachildDataPreviewImages data,
    Map<String, dynamic> json) {
  data.source = json['source'] != null
      ? new SearchPostsRepoEntityDataChildrenDataPreviewImagesSource()
          .fromJson(json['source'])
      : null;
  if (json['resolutions'] != null) {
    data.resolutions =
        new List<SearchPostsRepoEntityDatachildDataPreviewImagesResolutions>();
    (json['resolutions'] as List).forEach((v) {
      data.resolutions.add(
          new SearchPostsRepoEntityDatachildDataPreviewImagesResolutions()
              .fromJson(v));
    });
  }
  data.variants = json['variants'] != null
      ? new SearchPostsRepoEntityDataChildrenDataPreviewImagesVariants()
          .fromJson(json['variants'])
      : null;
  data.id = json['id']?.toString();
  return data;
}

Map<String, dynamic> searchPostsRepoEntityDatachildDataPreviewImagesToJson(
    SearchPostsRepoEntityDatachildDataPreviewImages entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.source != null) {
    data['source'] =
        SearchPostsRepoEntityDataChildrenDataPreviewImagesSource().toJson();
  }
  if (entity.resolutions != null) {
    data['resolutions'] = entity.resolutions.map((v) => v.toJson()).toList();
  }
  if (entity.variants != null) {
    data['variants'] =
        SearchPostsRepoEntityDataChildrenDataPreviewImagesVariants().toJson();
  }
  data['id'] = entity.id;
  return data;
}

searchPostsRepoEntityDataChildrenDataPreviewImagesSourceFromJson(
    SearchPostsRepoEntityDataChildrenDataPreviewImagesSource data,
    Map<String, dynamic> json) {
  data.url = json['url']?.toString();
  data.width = json['width']?.toInt();
  data.height = json['height']?.toInt();
  return data;
}

Map<String, dynamic>
    searchPostsRepoEntityDataChildrenDataPreviewImagesSourceToJson(
        SearchPostsRepoEntityDataChildrenDataPreviewImagesSource entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['url'] = entity.url;
  data['width'] = entity.width;
  data['height'] = entity.height;
  return data;
}

searchPostsRepoEntityDatachildDataPreviewImagesResolutionsFromJson(
    SearchPostsRepoEntityDatachildDataPreviewImagesResolutions data,
    Map<String, dynamic> json) {
  data.url = json['url']?.toString();
  data.width = json['width']?.toInt();
  data.height = json['height']?.toInt();
  return data;
}

Map<String, dynamic>
    searchPostsRepoEntityDatachildDataPreviewImagesResolutionsToJson(
        SearchPostsRepoEntityDatachildDataPreviewImagesResolutions entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['url'] = entity.url;
  data['width'] = entity.width;
  data['height'] = entity.height;
  return data;
}

searchPostsRepoEntityDataChildrenDataPreviewImagesVariantsFromJson(
    SearchPostsRepoEntityDataChildrenDataPreviewImagesVariants data,
    Map<String, dynamic> json) {
  return data;
}

Map<String, dynamic>
    searchPostsRepoEntityDataChildrenDataPreviewImagesVariantsToJson(
        SearchPostsRepoEntityDataChildrenDataPreviewImagesVariants entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
