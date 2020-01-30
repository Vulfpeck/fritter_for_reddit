import 'package:flutter_provider_app/helpers/media_type_enum.dart';

class PostsFeedEntity {
  PostsFeedData data;
  String kind;

  PostsFeedEntity({this.data, this.kind});

  PostsFeedEntity.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? new PostsFeedData.fromJson(json['data']) : null;
    kind = json['kind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['kind'] = this.kind;
    return data;
  }
}

class PostsFeedData {
  dynamic modhash;
  List<PostsFeedDatachild> children;
  dynamic before;
  int dist;
  String after;

  PostsFeedData(
      {this.modhash, this.children, this.before, this.dist, this.after});

  PostsFeedData.fromJson(Map<String, dynamic> json) {
    modhash = json['modhash'];
    if (json['children'] != null) {
      children = new List<PostsFeedDatachild>();
      (json['children'] as List).forEach((v) {
        children.add(new PostsFeedDatachild.fromJson(v));
      });
    }
    before = json['before'];
    dist = json['dist'];
    after = json['after'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modhash'] = this.modhash;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    data['before'] = this.before;
    data['dist'] = this.dist;
    data['after'] = this.after;
    return data;
  }
}

class PostsFeedDatachild {
  PostsFeedDataChildrenData data;
  String kind;

  PostsFeedDatachild({this.data, this.kind});

  PostsFeedDatachild.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new PostsFeedDataChildrenData.fromJson(json['data'])
        : null;
    kind = json['kind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['kind'] = this.kind;
    return data;
  }
}

class PostsFeedDataChildrenData {
  dynamic secureMedia;
  bool saved;
  bool hideScore;
  int totalAwardsReceived;
  String subredditId;
  int score;
  int numComments;
  dynamic modReasonTitle;
  String whitelistStatus;
  List<Null> stewardReports;
  bool spoiler;
  String id;
  double createdUtc;
  dynamic bannedAtUtc;
  dynamic discussionType;
  dynamic edited;
  bool allowLiveComments;
  dynamic authorFlairBackgroundColor;
  dynamic approvedBy;
  PostsFeedDataChildrenDataMediaEmbed mediaEmbed;
  String domain;
  dynamic approvedAtUtc;
  bool noFollow;
  int ups;
  String authorFlairType;
  String permalink;
  List<String> contentCategories;
  int wls;
  dynamic authorFlairCssClass;
  List<Null> modReports;
  int gilded;
  dynamic removalReason;
  bool sendReplies;
  bool archived;
  dynamic authorFlairTextColor;
  bool canModPost;
  bool isSelf;
  String authorFullname;
  dynamic linkFlairCssClass;
  String selftext;
  dynamic selftextHtml;
  List<Null> userReports;
  bool isCrosspostable;
  bool clicked;
  dynamic authorFlairTemplateId;
  String url;
  String parentWhitelistStatus;
  bool stickied;
  bool quarantine;
  dynamic viewCount;
  List<Null> linkFlairRichtext;
  String linkFlairBackgroundColor;
  List<Null> authorFlairRichtext;
  bool over18;
  String subreddit;
  dynamic suggestedSort;
  bool canGild;
  bool isRobotIndexable;
  String postHint;
  bool locked;
  dynamic likes;
  String thumbnail;
  int downs;
  double created;
  String author;
  String linkFlairTextColor;
  PostsFeedDataChildrenDataGildings gildings;
  dynamic reportReasons;
  bool isVideo;
  bool isOriginalContent;
  String subredditNamePrefixed;
  dynamic modReasonBy;
  String name;
  List<Null> awarders;
  bool mediaOnly;
  PostsFeedDataChildrenDataPreview preview;
  dynamic numReports;
  bool pinned;
  bool hidden;
  bool authorPatreonFlair;
  dynamic modNote;
  dynamic media;
  String title;
  dynamic authorFlairText;
  int numCrossposts;
  int thumbnailWidth;
  PostsFeedDataChildrenDataSecureMediaEmbed secureMediaEmbed;
  dynamic linkFlairText;
  String subredditType;
  bool isMeta;
  int subredditSubscribers;
  dynamic distinguished;
  int thumbnailHeight;
  String linkFlairType;
  List<PostsFeedDatachildDataAllAwardings> allAwardings;
  bool visited;
  int pwls;
  dynamic category;
  dynamic bannedBy;
  bool contestMode;
  bool isRedditMediaDomain;
  MediaType postType;

  PostsFeedDataChildrenData({
    this.secureMedia,
    this.saved,
    this.hideScore,
    this.totalAwardsReceived,
    this.subredditId,
    this.score,
    this.numComments,
    this.modReasonTitle,
    this.whitelistStatus,
    this.stewardReports,
    this.spoiler,
    this.id,
    this.createdUtc,
    this.bannedAtUtc,
    this.discussionType,
    this.edited,
    this.allowLiveComments,
    this.authorFlairBackgroundColor,
    this.approvedBy,
    this.mediaEmbed,
    this.domain,
    this.approvedAtUtc,
    this.noFollow,
    this.ups,
    this.authorFlairType,
    this.permalink,
    this.contentCategories,
    this.wls,
    this.authorFlairCssClass,
    this.modReports,
    this.gilded,
    this.removalReason,
    this.sendReplies,
    this.archived,
    this.authorFlairTextColor,
    this.canModPost,
    this.isSelf,
    this.authorFullname,
    this.linkFlairCssClass,
    this.selftext,
    this.selftextHtml,
    this.userReports,
    this.isCrosspostable,
    this.clicked,
    this.authorFlairTemplateId,
    this.url,
    this.parentWhitelistStatus,
    this.stickied,
    this.quarantine,
    this.viewCount,
    this.linkFlairRichtext,
    this.linkFlairBackgroundColor,
    this.authorFlairRichtext,
    this.over18,
    this.subreddit,
    this.suggestedSort,
    this.canGild,
    this.isRobotIndexable,
    this.postHint,
    this.locked,
    this.likes,
    this.thumbnail,
    this.downs,
    this.created,
    this.author,
    this.linkFlairTextColor,
    this.gildings,
    this.reportReasons,
    this.isVideo,
    this.isOriginalContent,
    this.subredditNamePrefixed,
    this.modReasonBy,
    this.name,
    this.awarders,
    this.mediaOnly,
    this.preview,
    this.numReports,
    this.pinned,
    this.hidden,
    this.authorPatreonFlair,
    this.modNote,
    this.media,
    this.title,
    this.authorFlairText,
    this.numCrossposts,
    this.thumbnailWidth,
    this.secureMediaEmbed,
    this.linkFlairText,
    this.subredditType,
    this.isMeta,
    this.subredditSubscribers,
    this.distinguished,
    this.thumbnailHeight,
    this.linkFlairType,
    this.allAwardings,
    this.visited,
    this.pwls,
    this.category,
    this.bannedBy,
    this.contestMode,
    this.isRedditMediaDomain,
    this.postType = MediaType.Url,
  });

  PostsFeedDataChildrenData.fromJson(Map<String, dynamic> json) {
    secureMedia = json['secure_media'];
    saved = json['saved'];
    hideScore = json['hide_score'];
    totalAwardsReceived = json['total_awards_received'];
    subredditId = json['subreddit_id'];
    score = json['score'];
    numComments = json['num_comments'];
    modReasonTitle = json['mod_reason_title'];
    whitelistStatus = json['whitelist_status'];
    if (json['steward_reports'] != null) {
      stewardReports = new List<Null>();
    }
    spoiler = json['spoiler'];
    id = json['id'];
    createdUtc = json['created_utc'];
    bannedAtUtc = json['banned_at_utc'];
    discussionType = json['discussion_type'];
    edited = json['edited'];
    allowLiveComments = json['allow_live_comments'];
    authorFlairBackgroundColor = json['author_flair_background_color'];
    approvedBy = json['approved_by'];
    mediaEmbed = json['media_embed'] != null
        ? new PostsFeedDataChildrenDataMediaEmbed.fromJson(json['media_embed'])
        : null;
    domain = json['domain'];
    approvedAtUtc = json['approved_at_utc'];
    noFollow = json['no_follow'];
    ups = json['ups'];
    authorFlairType = json['author_flair_type'];
    permalink = json['permalink'];
    contentCategories = json['content_categories']?.cast<String>();
    wls = json['wls'];
    authorFlairCssClass = json['author_flair_css_class'];
    if (json['mod_reports'] != null) {
      modReports = new List<Null>();
    }
    gilded = json['gilded'];
    removalReason = json['removal_reason'];
    sendReplies = json['send_replies'];
    archived = json['archived'];
    authorFlairTextColor = json['author_flair_text_color'];
    canModPost = json['can_mod_post'];
    isSelf = json['is_self'];
    authorFullname = json['author_fullname'];
    linkFlairCssClass = json['link_flair_css_class'];
    selftext = json['selftext'];
    selftextHtml = json['selftext_html'];
    if (json['user_reports'] != null) {
      userReports = new List<Null>();
    }
    isCrosspostable = json['is_crosspostable'];
    clicked = json['clicked'];
    authorFlairTemplateId = json['author_flair_template_id'];
    url = json['url'];
    parentWhitelistStatus = json['parent_whitelist_status'];
    stickied = json['stickied'];
    quarantine = json['quarantine'];
    viewCount = json['view_count'];
    if (json['link_flair_richtext'] != null) {
      linkFlairRichtext = new List<Null>();
    }
    linkFlairBackgroundColor = json['link_flair_background_color'];
    if (json['author_flair_richtext'] != null) {
      authorFlairRichtext = new List<Null>();
    }
    over18 = json['over_18'];
    subreddit = json['subreddit'];
    suggestedSort = json['suggested_sort'];
    canGild = json['can_gild'];
    isRobotIndexable = json['is_robot_indexable'];
    postHint = json['post_hint'];
    locked = json['locked'];
    likes = json['likes'];
    thumbnail = json['thumbnail'];
    downs = json['downs'];
    created = json['created'];
    author = json['author'];
    linkFlairTextColor = json['link_flair_text_color'];
    gildings = json['gildings'] != null
        ? new PostsFeedDataChildrenDataGildings.fromJson(json['gildings'])
        : null;
    reportReasons = json['report_reasons'];
    isVideo = json['is_video'];
    isOriginalContent = json['is_original_content'];
    subredditNamePrefixed = json['subreddit_name_prefixed'];
    modReasonBy = json['mod_reason_by'];
    name = json['name'];
    if (json['awarders'] != null) {
      awarders = new List<Null>();
    }
    mediaOnly = json['media_only'];
    preview = json['preview'] != null
        ? new PostsFeedDataChildrenDataPreview.fromJson(json['preview'])
        : null;
    numReports = json['num_reports'];
    pinned = json['pinned'];
    hidden = json['hidden'];
    authorPatreonFlair = json['author_patreon_flair'];
    modNote = json['mod_note'];
    media = json['media'];
    title = json['title'];
    authorFlairText = json['author_flair_text'];
    numCrossposts = json['num_crossposts'];
    thumbnailWidth = json['thumbnail_width'];
    secureMediaEmbed = json['secure_media_embed'] != null
        ? new PostsFeedDataChildrenDataSecureMediaEmbed.fromJson(
            json['secure_media_embed'])
        : null;
    linkFlairText = json['link_flair_text'];
    subredditType = json['subreddit_type'];
    isMeta = json['is_meta'];
    subredditSubscribers = json['subreddit_subscribers'];
    distinguished = json['distinguished'];
    thumbnailHeight = json['thumbnail_height'];
    linkFlairType = json['link_flair_type'];
    if (json['all_awardings'] != null) {
      allAwardings = new List<PostsFeedDatachildDataAllAwardings>();
      (json['all_awardings'] as List).forEach((v) {
        allAwardings.add(new PostsFeedDatachildDataAllAwardings.fromJson(v));
      });
    }
    visited = json['visited'];
    pwls = json['pwls'];
    category = json['category'];
    bannedBy = json['banned_by'];
    contestMode = json['contest_mode'];
    isRedditMediaDomain = json['is_reddit_media_domain'];
    postType = json['postType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['secure_media'] = this.secureMedia;
    data['saved'] = this.saved;
    data['hide_score'] = this.hideScore;
    data['total_awards_received'] = this.totalAwardsReceived;
    data['subreddit_id'] = this.subredditId;
    data['score'] = this.score;
    data['num_comments'] = this.numComments;
    data['mod_reason_title'] = this.modReasonTitle;
    data['whitelist_status'] = this.whitelistStatus;
    if (this.stewardReports != null) {
      data['steward_reports'] = [];
    }
    data['spoiler'] = this.spoiler;
    data['id'] = this.id;
    data['created_utc'] = this.createdUtc;
    data['banned_at_utc'] = this.bannedAtUtc;
    data['discussion_type'] = this.discussionType;
    data['edited'] = this.edited;
    data['allow_live_comments'] = this.allowLiveComments;
    data['author_flair_background_color'] = this.authorFlairBackgroundColor;
    data['approved_by'] = this.approvedBy;
    if (this.mediaEmbed != null) {
      data['media_embed'] = this.mediaEmbed.toJson();
    }
    data['domain'] = this.domain;
    data['approved_at_utc'] = this.approvedAtUtc;
    data['no_follow'] = this.noFollow;
    data['ups'] = this.ups;
    data['author_flair_type'] = this.authorFlairType;
    data['permalink'] = this.permalink;
    data['content_categories'] = this.contentCategories;
    data['wls'] = this.wls;
    data['author_flair_css_class'] = this.authorFlairCssClass;
    if (this.modReports != null) {
      data['mod_reports'] = [];
    }
    data['gilded'] = this.gilded;
    data['removal_reason'] = this.removalReason;
    data['send_replies'] = this.sendReplies;
    data['archived'] = this.archived;
    data['author_flair_text_color'] = this.authorFlairTextColor;
    data['can_mod_post'] = this.canModPost;
    data['is_self'] = this.isSelf;
    data['author_fullname'] = this.authorFullname;
    data['link_flair_css_class'] = this.linkFlairCssClass;
    data['selftext'] = this.selftext;
    data['selftext_html'] = this.selftextHtml;
    if (this.userReports != null) {
      data['user_reports'] = [];
    }
    data['is_crosspostable'] = this.isCrosspostable;
    data['clicked'] = this.clicked;
    data['author_flair_template_id'] = this.authorFlairTemplateId;
    data['url'] = this.url;
    data['parent_whitelist_status'] = this.parentWhitelistStatus;
    data['stickied'] = this.stickied;
    data['quarantine'] = this.quarantine;
    data['view_count'] = this.viewCount;
    if (this.linkFlairRichtext != null) {
      data['link_flair_richtext'] = [];
    }
    data['link_flair_background_color'] = this.linkFlairBackgroundColor;
    if (this.authorFlairRichtext != null) {
      data['author_flair_richtext'] = [];
    }
    data['over_18'] = this.over18;
    data['subreddit'] = this.subreddit;
    data['suggested_sort'] = this.suggestedSort;
    data['can_gild'] = this.canGild;
    data['is_robot_indexable'] = this.isRobotIndexable;
    data['post_hint'] = this.postHint;
    data['locked'] = this.locked;
    data['likes'] = this.likes;
    data['thumbnail'] = this.thumbnail;
    data['downs'] = this.downs;
    data['created'] = this.created;
    data['author'] = this.author;
    data['link_flair_text_color'] = this.linkFlairTextColor;
    if (this.gildings != null) {
      data['gildings'] = this.gildings.toJson();
    }
    data['report_reasons'] = this.reportReasons;
    data['is_video'] = this.isVideo;
    data['is_original_content'] = this.isOriginalContent;
    data['subreddit_name_prefixed'] = this.subredditNamePrefixed;
    data['mod_reason_by'] = this.modReasonBy;
    data['name'] = this.name;
    if (this.awarders != null) {
      data['awarders'] = [];
    }
    data['media_only'] = this.mediaOnly;
    if (this.preview != null) {
      data['preview'] = this.preview.toJson();
    }
    data['num_reports'] = this.numReports;
    data['pinned'] = this.pinned;
    data['hidden'] = this.hidden;
    data['author_patreon_flair'] = this.authorPatreonFlair;
    data['mod_note'] = this.modNote;
    data['media'] = this.media;
    data['title'] = this.title;
    data['author_flair_text'] = this.authorFlairText;
    data['num_crossposts'] = this.numCrossposts;
    data['thumbnail_width'] = this.thumbnailWidth;
    if (this.secureMediaEmbed != null) {
      data['secure_media_embed'] = this.secureMediaEmbed.toJson();
    }
    data['link_flair_text'] = this.linkFlairText;
    data['subreddit_type'] = this.subredditType;
    data['is_meta'] = this.isMeta;
    data['subreddit_subscribers'] = this.subredditSubscribers;
    data['distinguished'] = this.distinguished;
    data['thumbnail_height'] = this.thumbnailHeight;
    data['link_flair_type'] = this.linkFlairType;
    if (this.allAwardings != null) {
      data['all_awardings'] = this.allAwardings.map((v) => v.toJson()).toList();
    }
    data['visited'] = this.visited;
    data['pwls'] = this.pwls;
    data['category'] = this.category;
    data['banned_by'] = this.bannedBy;
    data['contest_mode'] = this.contestMode;
    data['is_reddit_media_domain'] = this.isRedditMediaDomain;
    return data;
  }
}

class PostsFeedDataChildrenDataMediaEmbed {
  PostsFeedDataChildrenDataMediaEmbed();

  PostsFeedDataChildrenDataMediaEmbed.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class PostsFeedDataChildrenDataGildings {
  int gid1;
  int gid2;

  PostsFeedDataChildrenDataGildings({this.gid1, this.gid2});

  PostsFeedDataChildrenDataGildings.fromJson(Map<String, dynamic> json) {
    gid1 = json['gid_1'];
    gid2 = json['gid_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid_1'] = this.gid1;
    data['gid_2'] = this.gid2;
    return data;
  }
}

class PostsFeedDataChildrenDataPreview {
  List<PostsFeedDatachildDataPreviewImages> images;
  bool enabled;

  PostsFeedDataChildrenDataPreview({this.images, this.enabled});

  PostsFeedDataChildrenDataPreview.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = new List<PostsFeedDatachildDataPreviewImages>();
      (json['images'] as List).forEach((v) {
        images.add(new PostsFeedDatachildDataPreviewImages.fromJson(v));
      });
    }
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['enabled'] = this.enabled;
    return data;
  }
}

class PostsFeedDatachildDataPreviewImages {
  List<PostsFeedDatachildDataPreviewImagesResolutions> resolutions;
  PostsFeedDataChildrenDataPreviewImagesSource source;
  PostsFeedDataChildrenDataPreviewImagesVariants variants;
  String id;

  PostsFeedDatachildDataPreviewImages(
      {this.resolutions, this.source, this.variants, this.id});

  PostsFeedDatachildDataPreviewImages.fromJson(Map<String, dynamic> json) {
    if (json['resolutions'] != null) {
      resolutions = new List<PostsFeedDatachildDataPreviewImagesResolutions>();
      (json['resolutions'] as List).forEach((v) {
        resolutions.add(
            new PostsFeedDatachildDataPreviewImagesResolutions.fromJson(v));
      });
    }
    source = json['source'] != null
        ? new PostsFeedDataChildrenDataPreviewImagesSource.fromJson(
            json['source'])
        : null;
    variants = json['variants'] != null
        ? new PostsFeedDataChildrenDataPreviewImagesVariants.fromJson(
            json['variants'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.resolutions != null) {
      data['resolutions'] = this.resolutions.map((v) => v.toJson()).toList();
    }
    if (this.source != null) {
      data['source'] = this.source.toJson();
    }
    if (this.variants != null) {
      data['variants'] = this.variants.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class PostsFeedDatachildDataPreviewImagesResolutions {
  int width;
  String url;
  int height;

  PostsFeedDatachildDataPreviewImagesResolutions(
      {this.width, this.url, this.height});

  PostsFeedDatachildDataPreviewImagesResolutions.fromJson(
      Map<String, dynamic> json) {
    width = json['width'];
    url = json['url'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['url'] = this.url;
    data['height'] = this.height;
    return data;
  }
}

class PostsFeedDataChildrenDataPreviewImagesSource {
  int width;
  String url;
  int height;

  PostsFeedDataChildrenDataPreviewImagesSource(
      {this.width, this.url, this.height});

  PostsFeedDataChildrenDataPreviewImagesSource.fromJson(
      Map<String, dynamic> json) {
    width = json['width'];
    url = json['url'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['url'] = this.url;
    data['height'] = this.height;
    return data;
  }
}

class PostsFeedDataChildrenDataPreviewImagesVariants {
  PostsFeedDataChildrenDataPreviewImagesVariants();

  PostsFeedDataChildrenDataPreviewImagesVariants.fromJson(
      Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class PostsFeedDataChildrenDataSecureMediaEmbed {
  PostsFeedDataChildrenDataSecureMediaEmbed();

  PostsFeedDataChildrenDataSecureMediaEmbed.fromJson(
      Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class PostsFeedDatachildDataAllAwardings {
  dynamic endDate;
  String iconUrl;
  int iconWidth;
  int coinReward;
  int daysOfDripExtension;
  int iconHeight;
  int count;
  String description;
  List<PostsFeedDatachildDataAllAwardingsResizedIcons> resizedIcons;
  int coinPrice;
  int subredditCoinReward;
  String awardType;
  dynamic subredditId;
  bool isEnabled;
  String name;
  String id;
  int daysOfPremium;
  dynamic startDate;

  PostsFeedDatachildDataAllAwardings(
      {this.endDate,
      this.iconUrl,
      this.iconWidth,
      this.coinReward,
      this.daysOfDripExtension,
      this.iconHeight,
      this.count,
      this.description,
      this.resizedIcons,
      this.coinPrice,
      this.subredditCoinReward,
      this.awardType,
      this.subredditId,
      this.isEnabled,
      this.name,
      this.id,
      this.daysOfPremium,
      this.startDate});

  PostsFeedDatachildDataAllAwardings.fromJson(Map<String, dynamic> json) {
    endDate = json['end_date'];
    iconUrl = json['icon_url'];
    iconWidth = json['icon_width'];
    coinReward = json['coin_reward'];
    daysOfDripExtension = json['days_of_drip_extension'];
    iconHeight = json['icon_height'];
    count = json['count'];
    description = json['description'];
    if (json['resized_icons'] != null) {
      resizedIcons = new List<PostsFeedDatachildDataAllAwardingsResizedIcons>();
      (json['resized_icons'] as List).forEach((v) {
        resizedIcons.add(
            new PostsFeedDatachildDataAllAwardingsResizedIcons.fromJson(v));
      });
    }
    coinPrice = json['coin_price'];
    subredditCoinReward = json['subreddit_coin_reward'];
    awardType = json['award_type'];
    subredditId = json['subreddit_id'];
    isEnabled = json['is_enabled'];
    name = json['name'];
    id = json['id'];
    daysOfPremium = json['days_of_premium'];
    startDate = json['start_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['end_date'] = this.endDate;
    data['icon_url'] = this.iconUrl;
    data['icon_width'] = this.iconWidth;
    data['coin_reward'] = this.coinReward;
    data['days_of_drip_extension'] = this.daysOfDripExtension;
    data['icon_height'] = this.iconHeight;
    data['count'] = this.count;
    data['description'] = this.description;
    if (this.resizedIcons != null) {
      data['resized_icons'] = this.resizedIcons.map((v) => v.toJson()).toList();
    }
    data['coin_price'] = this.coinPrice;
    data['subreddit_coin_reward'] = this.subredditCoinReward;
    data['award_type'] = this.awardType;
    data['subreddit_id'] = this.subredditId;
    data['is_enabled'] = this.isEnabled;
    data['name'] = this.name;
    data['id'] = this.id;
    data['days_of_premium'] = this.daysOfPremium;
    data['start_date'] = this.startDate;
    return data;
  }
}

class PostsFeedDatachildDataAllAwardingsResizedIcons {
  int width;
  String url;
  int height;

  PostsFeedDatachildDataAllAwardingsResizedIcons(
      {this.width, this.url, this.height});

  PostsFeedDatachildDataAllAwardingsResizedIcons.fromJson(
      Map<String, dynamic> json) {
    width = json['width'];
    url = json['url'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['url'] = this.url;
    data['height'] = this.height;
    return data;
  }
}
