class SubredditInformationEntity {
  SubredditInformationData? data;
  String? kind;

  SubredditInformationEntity({this.data, this.kind});

  factory SubredditInformationEntity.fromJson(Map? json) {
    if (json == null) {
      return SubredditInformationEntity();
    }
    final data = json['data'] != null
        ? SubredditInformationData.fromJson(json['data'])
        : null;
    final kind = json['kind'];
    return SubredditInformationEntity(data: data, kind: kind);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['kind'] = this.kind;
    return data;
  }
}

class SubredditInformationData {
  String? userFlairPosition;
  String? publicDescription;
  String? keyColor;
  int? activeUserCount;
  int? accountsActive;
  bool? userIsBanned;
  dynamic submitTextLabel;
  String? userFlairTextColor;
  bool? emojisEnabled;
  bool? userIsMuted;
  bool? disableContributorRequests;
  String? publicDescriptionHtml;
  dynamic isCrosspostableSubreddit;
  bool? userIsSubscriber;
  String? whitelistStatus;
  List<int>? iconSize;
  bool? userFlairEnabledInSr;
  String? id;
  bool? showMedia;
  double? createdUtc;
  int? commentScoreHideMins;
  dynamic isEnrolledInNewModmail;
  List<SubredditInformationDataUserFlairRichtext>? userFlairRichtext;
  dynamic headerTitle;
  bool? restrictCommenting;
  int? subscribers;
  double? created;
  bool? restrictPosting;
  String? communityIcon;
  String? displayName;
  String? primaryColor;
  String? linkFlairPosition;
  bool? linkFlairEnabled;
  bool? userIsContributor;
  bool? canAssignUserFlair;
  String? submitLinkLabel;
  String? bannerImg;
  String? userFlairCssClass;
  String? name;
  bool? allowVideogifs;
  String? userFlairType;
  String? notificationLevel;
  String? descriptionHtml;
  bool? userSrFlairEnabled;
  int? wls;
  dynamic suggestedCommentSort;
  String? submitText;
  bool? userHasFavorited;
  bool? accountsActiveIsFuzzed;
  bool? allowImages;
  bool? publicTraffic;
  String? description;
  String? title;
  String? userFlairText;
  String? bannerBackgroundColor;
  String? userFlairTemplateId;
  String? displayNamePrefixed;
  String? submissionType;
  bool? spoilersEnabled;
  bool? showMediaPreview;
  bool? userSrThemeEnabled;
  bool? freeFormReports;
  String? lang;
  bool? userIsModerator;
  dynamic userFlairBackgroundColor;
  bool? allowDiscovery;
  String? bannerBackgroundImage;
  String? subredditType;
  bool? over18;
  dynamic bannerSize;
  dynamic headerSize;
  bool? collapseDeletedComments;
  String? advertiserCategory;
  bool? hasMenuWidget;
  bool? originalContentTagEnabled;
  bool? allOriginalContent;
  String? url;
  String? mobileBannerImage;
  bool? userCanFlairInSr;
  bool? allowVideos;
  dynamic headerImg;
  String? iconImg;
  String? submitTextHtml;
  bool? wikiEnabled;
  bool? quarantine;
  bool? hideAds;
  dynamic emojisCustomSize;
  bool? canAssignLinkFlair;

  SubredditInformationData(
      {this.userFlairPosition,
      this.publicDescription,
      this.keyColor,
      this.activeUserCount,
      this.accountsActive,
      this.userIsBanned,
      this.submitTextLabel,
      this.userFlairTextColor,
      this.emojisEnabled,
      this.userIsMuted,
      this.disableContributorRequests,
      this.publicDescriptionHtml,
      this.isCrosspostableSubreddit,
      this.userIsSubscriber,
      this.whitelistStatus,
      this.iconSize,
      this.userFlairEnabledInSr,
      this.id,
      this.showMedia,
      this.createdUtc,
      this.commentScoreHideMins,
      this.isEnrolledInNewModmail,
      this.userFlairRichtext,
      this.headerTitle,
      this.restrictCommenting,
      this.subscribers,
      this.created,
      this.restrictPosting,
      this.communityIcon,
      this.displayName,
      this.primaryColor,
      this.linkFlairPosition,
      this.linkFlairEnabled,
      this.userIsContributor,
      this.canAssignUserFlair,
      this.submitLinkLabel,
      this.bannerImg,
      this.userFlairCssClass,
      this.name,
      this.allowVideogifs,
      this.userFlairType,
      this.notificationLevel,
      this.descriptionHtml,
      this.userSrFlairEnabled,
      this.wls,
      this.suggestedCommentSort,
      this.submitText,
      this.userHasFavorited,
      this.accountsActiveIsFuzzed,
      this.allowImages,
      this.publicTraffic,
      this.description,
      this.title,
      this.userFlairText,
      this.bannerBackgroundColor,
      this.userFlairTemplateId,
      this.displayNamePrefixed,
      this.submissionType,
      this.spoilersEnabled,
      this.showMediaPreview,
      this.userSrThemeEnabled,
      this.freeFormReports,
      this.lang,
      this.userIsModerator,
      this.userFlairBackgroundColor,
      this.allowDiscovery,
      this.bannerBackgroundImage,
      this.subredditType,
      this.over18,
      this.bannerSize,
      this.headerSize,
      this.collapseDeletedComments,
      this.advertiserCategory,
      this.hasMenuWidget,
      this.originalContentTagEnabled,
      this.allOriginalContent,
      this.url,
      this.mobileBannerImage,
      this.userCanFlairInSr,
      this.allowVideos,
      this.headerImg,
      this.iconImg,
      this.submitTextHtml,
      this.wikiEnabled,
      this.quarantine,
      this.hideAds,
      this.emojisCustomSize,
      this.canAssignLinkFlair});

  SubredditInformationData.fromJson(Map json) {
    userFlairPosition = json['user_flair_position'];
    publicDescription = json['public_description'];
    keyColor = json['key_color'];
    activeUserCount = json['active_user_count'];
    accountsActive = json['accounts_active'];
    userIsBanned = json['user_is_banned'];
    submitTextLabel = json['submit_text_label'];
    userFlairTextColor = json['user_flair_text_color'];
    emojisEnabled = json['emojis_enabled'];
    userIsMuted = json['user_is_muted'];
    disableContributorRequests = json['disable_contributor_requests'];
    publicDescriptionHtml = json['public_description_html'];
    isCrosspostableSubreddit = json['is_crosspostable_subreddit'];
    userIsSubscriber = json['user_is_subscriber'];
    whitelistStatus = json['whitelist_status'];
    iconSize = json['icon_size']?.cast<int>();
    userFlairEnabledInSr = json['user_flair_enabled_in_sr'];
    id = json['id'];
    showMedia = json['show_media'];
    createdUtc = json['created_utc'];
    commentScoreHideMins = json['comment_score_hide_mins'];
    isEnrolledInNewModmail = json['is_enrolled_in_new_modmail'];
    if (json['user_flair_richtext'] != null) {
      userFlairRichtext = <SubredditInformationDataUserFlairRichtext>[];
      (json['user_flair_richtext'] as List).forEach((v) {
        userFlairRichtext!
            .add(new SubredditInformationDataUserFlairRichtext.fromJson(v));
      });
    }
    headerTitle = json['header_title'];
    restrictCommenting = json['restrict_commenting'];
    subscribers = json['subscribers'];
    created = json['created'];
    restrictPosting = json['restrict_posting'];
    communityIcon = json['community_icon'];
    displayName = json['display_name'];
    primaryColor = json['primary_color'];
    linkFlairPosition = json['link_flair_position'];
    linkFlairEnabled = json['link_flair_enabled'];
    userIsContributor = json['user_is_contributor'];
    canAssignUserFlair = json['can_assign_user_flair'];
    submitLinkLabel = json['submit_link_label'];
    bannerImg = json['banner_img'];
    userFlairCssClass = json['user_flair_css_class'];
    name = json['name'];
    allowVideogifs = json['allow_videogifs'];
    userFlairType = json['user_flair_type'];
    notificationLevel = json['notification_level'];
    descriptionHtml = json['description_html'];
    userSrFlairEnabled = json['user_sr_flair_enabled'];
    wls = json['wls'];
    suggestedCommentSort = json['suggested_comment_sort'];
    submitText = json['submit_text'];
    userHasFavorited = json['user_has_favorited'];
    accountsActiveIsFuzzed = json['accounts_active_is_fuzzed'];
    allowImages = json['allow_images'];
    publicTraffic = json['public_traffic'];
    description = json['description'];
    title = json['title'];
    userFlairText = json['user_flair_text'];
    bannerBackgroundColor = json['banner_background_color'];
    userFlairTemplateId = json['user_flair_template_id'];
    displayNamePrefixed = json['display_name_prefixed'];
    submissionType = json['submission_type'];
    spoilersEnabled = json['spoilers_enabled'];
    showMediaPreview = json['show_media_preview'];
    userSrThemeEnabled = json['user_sr_theme_enabled'];
    freeFormReports = json['free_form_reports'];
    lang = json['lang'];
    userIsModerator = json['user_is_moderator'];
    userFlairBackgroundColor = json['user_flair_background_color'];
    allowDiscovery = json['allow_discovery'];
    bannerBackgroundImage = json['banner_background_image'];
    subredditType = json['subreddit_type'];
    over18 = json['over18'];
    bannerSize = json['banner_size'];
    headerSize = json['header_size'];
    collapseDeletedComments = json['collapse_deleted_comments'];
    advertiserCategory = json['advertiser_category'];
    hasMenuWidget = json['has_menu_widget'];
    originalContentTagEnabled = json['original_content_tag_enabled'];
    allOriginalContent = json['all_original_content'];
    url = json['url'];
    mobileBannerImage = json['mobile_banner_image'];
    userCanFlairInSr = json['user_can_flair_in_sr'];
    allowVideos = json['allow_videos'];
    headerImg = json['header_img'];
    iconImg = json['icon_img'];
    submitTextHtml = json['submit_text_html'];
    wikiEnabled = json['wiki_enabled'];
    quarantine = json['quarantine'];
    hideAds = json['hide_ads'];
    emojisCustomSize = json['emojis_custom_size'];
    canAssignLinkFlair = json['can_assign_link_flair'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_flair_position'] = this.userFlairPosition;
    data['public_description'] = this.publicDescription;
    data['key_color'] = this.keyColor;
    data['active_user_count'] = this.activeUserCount;
    data['accounts_active'] = this.accountsActive;
    data['user_is_banned'] = this.userIsBanned;
    data['submit_text_label'] = this.submitTextLabel;
    data['user_flair_text_color'] = this.userFlairTextColor;
    data['emojis_enabled'] = this.emojisEnabled;
    data['user_is_muted'] = this.userIsMuted;
    data['disable_contributor_requests'] = this.disableContributorRequests;
    data['public_description_html'] = this.publicDescriptionHtml;
    data['is_crosspostable_subreddit'] = this.isCrosspostableSubreddit;
    data['user_is_subscriber'] = this.userIsSubscriber;
    data['whitelist_status'] = this.whitelistStatus;
    data['icon_size'] = this.iconSize;
    data['user_flair_enabled_in_sr'] = this.userFlairEnabledInSr;
    data['id'] = this.id;
    data['show_media'] = this.showMedia;
    data['created_utc'] = this.createdUtc;
    data['comment_score_hide_mins'] = this.commentScoreHideMins;
    data['is_enrolled_in_new_modmail'] = this.isEnrolledInNewModmail;
    if (this.userFlairRichtext != null) {
      data['user_flair_richtext'] =
          this.userFlairRichtext!.map((v) => v.toJson()).toList();
    }
    data['header_title'] = this.headerTitle;
    data['restrict_commenting'] = this.restrictCommenting;
    data['subscribers'] = this.subscribers;
    data['created'] = this.created;
    data['restrict_posting'] = this.restrictPosting;
    data['community_icon'] = this.communityIcon;
    data['display_name'] = this.displayName;
    data['primary_color'] = this.primaryColor;
    data['link_flair_position'] = this.linkFlairPosition;
    data['link_flair_enabled'] = this.linkFlairEnabled;
    data['user_is_contributor'] = this.userIsContributor;
    data['can_assign_user_flair'] = this.canAssignUserFlair;
    data['submit_link_label'] = this.submitLinkLabel;
    data['banner_img'] = this.bannerImg;
    data['user_flair_css_class'] = this.userFlairCssClass;
    data['name'] = this.name;
    data['allow_videogifs'] = this.allowVideogifs;
    data['user_flair_type'] = this.userFlairType;
    data['notification_level'] = this.notificationLevel;
    data['description_html'] = this.descriptionHtml;
    data['user_sr_flair_enabled'] = this.userSrFlairEnabled;
    data['wls'] = this.wls;
    data['suggested_comment_sort'] = this.suggestedCommentSort;
    data['submit_text'] = this.submitText;
    data['user_has_favorited'] = this.userHasFavorited;
    data['accounts_active_is_fuzzed'] = this.accountsActiveIsFuzzed;
    data['allow_images'] = this.allowImages;
    data['public_traffic'] = this.publicTraffic;
    data['description'] = this.description;
    data['title'] = this.title;
    data['user_flair_text'] = this.userFlairText;
    data['banner_background_color'] = this.bannerBackgroundColor;
    data['user_flair_template_id'] = this.userFlairTemplateId;
    data['display_name_prefixed'] = this.displayNamePrefixed;
    data['submission_type'] = this.submissionType;
    data['spoilers_enabled'] = this.spoilersEnabled;
    data['show_media_preview'] = this.showMediaPreview;
    data['user_sr_theme_enabled'] = this.userSrThemeEnabled;
    data['free_form_reports'] = this.freeFormReports;
    data['lang'] = this.lang;
    data['user_is_moderator'] = this.userIsModerator;
    data['user_flair_background_color'] = this.userFlairBackgroundColor;
    data['allow_discovery'] = this.allowDiscovery;
    data['banner_background_image'] = this.bannerBackgroundImage;
    data['subreddit_type'] = this.subredditType;
    data['over18'] = this.over18;
    data['banner_size'] = this.bannerSize;
    data['header_size'] = this.headerSize;
    data['collapse_deleted_comments'] = this.collapseDeletedComments;
    data['advertiser_category'] = this.advertiserCategory;
    data['has_menu_widget'] = this.hasMenuWidget;
    data['original_content_tag_enabled'] = this.originalContentTagEnabled;
    data['all_original_content'] = this.allOriginalContent;
    data['url'] = this.url;
    data['mobile_banner_image'] = this.mobileBannerImage;
    data['user_can_flair_in_sr'] = this.userCanFlairInSr;
    data['allow_videos'] = this.allowVideos;
    data['header_img'] = this.headerImg;
    data['icon_img'] = this.iconImg;
    data['submit_text_html'] = this.submitTextHtml;
    data['wiki_enabled'] = this.wikiEnabled;
    data['quarantine'] = this.quarantine;
    data['hide_ads'] = this.hideAds;
    data['emojis_custom_size'] = this.emojisCustomSize;
    data['can_assign_link_flair'] = this.canAssignLinkFlair;
    return data;
  }
}

class SubredditInformationDataUserFlairRichtext {
  String? t;
  String? e;

  SubredditInformationDataUserFlairRichtext({this.t, this.e});

  SubredditInformationDataUserFlairRichtext.fromJson(Map json) {
    t = json['t'];
    e = json['e'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['t'] = this.t;
    data['e'] = this.e;
    return data;
  }
}
