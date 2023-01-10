class UserInformationEntity {
  bool? hasStripeSubscription;
  bool? canCreateSubreddit;
  bool? over18;
  int? prefClickgadget;
  int? commentKarma;
  UserInformationSubreddit? subreddit;
  UserInformationFeatures? features;
  bool? prefShowTrending;
  String? id;
  bool? hasVisitedNewProfile;
  double? createdUtc;
  int? numFriends;
  int? coins;
  bool? inRedesignBeta;
  bool? hasModMail;
  bool? hideFromRobots;
  bool? hasSubscribedToPremium;
  double? created;
  bool? hasSubscribed;
  bool? hasAndroidSubscription;
  bool? seenPremiumAdblockModal;
  bool? prefShowSnoovatar;
  bool? forcePasswordReset;
  String? name;
  bool? isGold;
  bool? isMod;
  bool? inBeta;
  bool? hasVerifiedEmail;
  String? prefGeopopular;
  bool? isSuspended;
  dynamic newModmailExists;
  bool? isSponsor;
  bool? seenRedesignModal;
  bool? hasExternalAccount;
  dynamic suspensionExpirationUtc;
  bool? hasGoldSubscription;
  bool? seenLayoutSwitch;
  bool? prefNightmode;
  int? linkKarma;
  bool? hasMail;
  String? oauthClientId;
  bool? prefAutoplay;
  int? goldCreddits;
  bool? verified;
  bool? hasPaypalSubscription;
  bool? prefTopKarmaSubreddits;
  bool? prefShowTwitter;
  bool? isEmployee;
  bool? prefVideoAutoplay;
  bool? prefNoProfanity;
  String? iconImg;
  int? inboxCount;
  bool? hasIosSubscription;
  dynamic goldExpiration;
  bool? seenSubredditChatFtux;

  UserInformationEntity(
      {this.hasStripeSubscription,
      this.canCreateSubreddit,
      this.over18,
      this.prefClickgadget,
      this.commentKarma,
      this.subreddit,
      this.features,
      this.prefShowTrending,
      this.id,
      this.hasVisitedNewProfile,
      this.createdUtc,
      this.numFriends,
      this.coins,
      this.inRedesignBeta,
      this.hasModMail,
      this.hideFromRobots,
      this.hasSubscribedToPremium,
      this.created,
      this.hasSubscribed,
      this.hasAndroidSubscription,
      this.seenPremiumAdblockModal,
      this.prefShowSnoovatar,
      this.forcePasswordReset,
      this.name,
      this.isGold,
      this.isMod,
      this.inBeta,
      this.hasVerifiedEmail,
      this.prefGeopopular,
      this.isSuspended,
      this.newModmailExists,
      this.isSponsor,
      this.seenRedesignModal,
      this.hasExternalAccount,
      this.suspensionExpirationUtc,
      this.hasGoldSubscription,
      this.seenLayoutSwitch,
      this.prefNightmode,
      this.linkKarma,
      this.hasMail,
      this.oauthClientId,
      this.prefAutoplay,
      this.goldCreddits,
      this.verified,
      this.hasPaypalSubscription,
      this.prefTopKarmaSubreddits,
      this.prefShowTwitter,
      this.isEmployee,
      this.prefVideoAutoplay,
      this.prefNoProfanity,
      this.iconImg,
      this.inboxCount,
      this.hasIosSubscription,
      this.goldExpiration,
      this.seenSubredditChatFtux});

  UserInformationEntity.fromJson(Map json) {
    hasStripeSubscription = json['has_stripe_subscription'];
    canCreateSubreddit = json['can_create_subreddit'];
    over18 = json['over_18'];
    prefClickgadget = json['pref_clickgadget'];
    commentKarma = json['comment_karma'];
    subreddit = json['subreddit'] != null
        ? new UserInformationSubreddit.fromJson(json['subreddit'])
        : null;
    features = json['features'] != null
        ? new UserInformationFeatures.fromJson(json['features'])
        : null;
    prefShowTrending = json['pref_show_trending'];
    id = json['id'];
    hasVisitedNewProfile = json['has_visited_new_profile'];
    createdUtc = json['created_utc'];
    numFriends = json['num_friends'];
    coins = json['coins'];
    inRedesignBeta = json['in_redesign_beta'];
    hasModMail = json['has_mod_mail'];
    hideFromRobots = json['hide_from_robots'];
    hasSubscribedToPremium = json['has_subscribed_to_premium'];
    created = json['created'];
    hasSubscribed = json['has_subscribed'];
    hasAndroidSubscription = json['has_android_subscription'];
    seenPremiumAdblockModal = json['seen_premium_adblock_modal'];
    prefShowSnoovatar = json['pref_show_snoovatar'];
    forcePasswordReset = json['force_password_reset'];
    name = json['name'];
    isGold = json['is_gold'];
    isMod = json['is_mod'];
    inBeta = json['in_beta'];
    hasVerifiedEmail = json['has_verified_email'];
    prefGeopopular = json['pref_geopopular'];
    isSuspended = json['is_suspended'];
    newModmailExists = json['new_modmail_exists'];
    isSponsor = json['is_sponsor'];
    seenRedesignModal = json['seen_redesign_modal'];
    hasExternalAccount = json['has_external_account'];
    suspensionExpirationUtc = json['suspension_expiration_utc'];
    hasGoldSubscription = json['has_gold_subscription'];
    seenLayoutSwitch = json['seen_layout_switch'];
    prefNightmode = json['pref_nightmode'];
    linkKarma = json['link_karma'];
    hasMail = json['has_mail'];
    oauthClientId = json['oauth_client_id'];
    prefAutoplay = json['pref_autoplay'];
    goldCreddits = json['gold_creddits'];
    verified = json['verified'];
    hasPaypalSubscription = json['has_paypal_subscription'];
    prefTopKarmaSubreddits = json['pref_top_karma_subreddits'];
    prefShowTwitter = json['pref_show_twitter'];
    isEmployee = json['is_employee'];
    prefVideoAutoplay = json['pref_video_autoplay'];
    prefNoProfanity = json['pref_no_profanity'];
    iconImg = json['icon_img'];
    inboxCount = json['inbox_count'];
    hasIosSubscription = json['has_ios_subscription'];
    goldExpiration = json['gold_expiration'];
    seenSubredditChatFtux = json['seen_subreddit_chat_ftux'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['has_stripe_subscription'] = this.hasStripeSubscription;
    data['can_create_subreddit'] = this.canCreateSubreddit;
    data['over_18'] = this.over18;
    data['pref_clickgadget'] = this.prefClickgadget;
    data['comment_karma'] = this.commentKarma;
    if (this.subreddit != null) {
      data['subreddit'] = this.subreddit!.toJson();
    }
    if (this.features != null) {
      data['features'] = this.features!.toJson();
    }
    data['pref_show_trending'] = this.prefShowTrending;
    data['id'] = this.id;
    data['has_visited_new_profile'] = this.hasVisitedNewProfile;
    data['created_utc'] = this.createdUtc;
    data['num_friends'] = this.numFriends;
    data['coins'] = this.coins;
    data['in_redesign_beta'] = this.inRedesignBeta;
    data['has_mod_mail'] = this.hasModMail;
    data['hide_from_robots'] = this.hideFromRobots;
    data['has_subscribed_to_premium'] = this.hasSubscribedToPremium;
    data['created'] = this.created;
    data['has_subscribed'] = this.hasSubscribed;
    data['has_android_subscription'] = this.hasAndroidSubscription;
    data['seen_premium_adblock_modal'] = this.seenPremiumAdblockModal;
    data['pref_show_snoovatar'] = this.prefShowSnoovatar;
    data['force_password_reset'] = this.forcePasswordReset;
    data['name'] = this.name;
    data['is_gold'] = this.isGold;
    data['is_mod'] = this.isMod;
    data['in_beta'] = this.inBeta;
    data['has_verified_email'] = this.hasVerifiedEmail;
    data['pref_geopopular'] = this.prefGeopopular;
    data['is_suspended'] = this.isSuspended;
    data['new_modmail_exists'] = this.newModmailExists;
    data['is_sponsor'] = this.isSponsor;
    data['seen_redesign_modal'] = this.seenRedesignModal;
    data['has_external_account'] = this.hasExternalAccount;
    data['suspension_expiration_utc'] = this.suspensionExpirationUtc;
    data['has_gold_subscription'] = this.hasGoldSubscription;
    data['seen_layout_switch'] = this.seenLayoutSwitch;
    data['pref_nightmode'] = this.prefNightmode;
    data['link_karma'] = this.linkKarma;
    data['has_mail'] = this.hasMail;
    data['oauth_client_id'] = this.oauthClientId;
    data['pref_autoplay'] = this.prefAutoplay;
    data['gold_creddits'] = this.goldCreddits;
    data['verified'] = this.verified;
    data['has_paypal_subscription'] = this.hasPaypalSubscription;
    data['pref_top_karma_subreddits'] = this.prefTopKarmaSubreddits;
    data['pref_show_twitter'] = this.prefShowTwitter;
    data['is_employee'] = this.isEmployee;
    data['pref_video_autoplay'] = this.prefVideoAutoplay;
    data['pref_no_profanity'] = this.prefNoProfanity;
    data['icon_img'] = this.iconImg;
    data['inbox_count'] = this.inboxCount;
    data['has_ios_subscription'] = this.hasIosSubscription;
    data['gold_expiration'] = this.goldExpiration;
    data['seen_subreddit_chat_ftux'] = this.seenSubredditChatFtux;
    return data;
  }
}

class UserInformationSubreddit {
  String? publicDescription;
  String? keyColor;
  bool? over18;
  bool? userIsBanned;
  String? description;
  String? title;
  String? submitTextLabel;
  bool? isDefaultBanner;
  bool? userIsMuted;
  bool? isDefaultIcon;
  bool? disableContributorRequests;
  String? displayNamePrefixed;
  bool? userIsSubscriber;
  List<int>? iconSize;
  bool? freeFormReports;
  bool? showMedia;
  bool? defaultSet;
  bool? userIsModerator;
  dynamic bannerSize;
  String? subredditType;
  bool? restrictCommenting;
  int? coins;
  int? subscribers;
  dynamic headerSize;
  bool? restrictPosting;
  String? communityIcon;
  String? displayName;
  String? primaryColor;
  String? url;
  bool? userIsContributor;
  String? linkFlairPosition;
  bool? linkFlairEnabled;
  String? submitLinkLabel;
  dynamic headerImg;
  String? iconColor;
  String? iconImg;
  String? bannerImg;
  String? name;

  UserInformationSubreddit(
      {this.publicDescription,
      this.keyColor,
      this.over18,
      this.userIsBanned,
      this.description,
      this.title,
      this.submitTextLabel,
      this.isDefaultBanner,
      this.userIsMuted,
      this.isDefaultIcon,
      this.disableContributorRequests,
      this.displayNamePrefixed,
      this.userIsSubscriber,
      this.iconSize,
      this.freeFormReports,
      this.showMedia,
      this.defaultSet,
      this.userIsModerator,
      this.bannerSize,
      this.subredditType,
      this.restrictCommenting,
      this.coins,
      this.subscribers,
      this.headerSize,
      this.restrictPosting,
      this.communityIcon,
      this.displayName,
      this.primaryColor,
      this.url,
      this.userIsContributor,
      this.linkFlairPosition,
      this.linkFlairEnabled,
      this.submitLinkLabel,
      this.headerImg,
      this.iconColor,
      this.iconImg,
      this.bannerImg,
      this.name});

  UserInformationSubreddit.fromJson(Map json) {
    publicDescription = json['public_description'];
    keyColor = json['key_color'];
    over18 = json['over_18'];
    userIsBanned = json['user_is_banned'];
    description = json['description'];
    title = json['title'];
    submitTextLabel = json['submit_text_label'];
    isDefaultBanner = json['is_default_banner'];
    userIsMuted = json['user_is_muted'];
    isDefaultIcon = json['is_default_icon'];
    disableContributorRequests = json['disable_contributor_requests'];
    displayNamePrefixed = json['display_name_prefixed'];
    userIsSubscriber = json['user_is_subscriber'];
    iconSize = json['icon_size']?.cast<int>();
    freeFormReports = json['free_form_reports'];
    showMedia = json['show_media'];
    defaultSet = json['default_set'];
    userIsModerator = json['user_is_moderator'];
    bannerSize = json['banner_size'];
    subredditType = json['subreddit_type'];
    restrictCommenting = json['restrict_commenting'];
    coins = json['coins'];
    subscribers = json['subscribers'];
    headerSize = json['header_size'];
    restrictPosting = json['restrict_posting'];
    communityIcon = json['community_icon'];
    displayName = json['display_name'];
    primaryColor = json['primary_color'];
    url = json['url'];
    userIsContributor = json['user_is_contributor'];
    linkFlairPosition = json['link_flair_position'];
    linkFlairEnabled = json['link_flair_enabled'];
    submitLinkLabel = json['submit_link_label'];
    headerImg = json['header_img'];
    iconColor = json['icon_color'];
    iconImg = json['icon_img'];
    bannerImg = json['banner_img'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['public_description'] = this.publicDescription;
    data['key_color'] = this.keyColor;
    data['over_18'] = this.over18;
    data['user_is_banned'] = this.userIsBanned;
    data['description'] = this.description;
    data['title'] = this.title;
    data['submit_text_label'] = this.submitTextLabel;
    data['is_default_banner'] = this.isDefaultBanner;
    data['user_is_muted'] = this.userIsMuted;
    data['is_default_icon'] = this.isDefaultIcon;
    data['disable_contributor_requests'] = this.disableContributorRequests;
    data['display_name_prefixed'] = this.displayNamePrefixed;
    data['user_is_subscriber'] = this.userIsSubscriber;
    data['icon_size'] = this.iconSize;
    data['free_form_reports'] = this.freeFormReports;
    data['show_media'] = this.showMedia;
    data['default_set'] = this.defaultSet;
    data['user_is_moderator'] = this.userIsModerator;
    data['banner_size'] = this.bannerSize;
    data['subreddit_type'] = this.subredditType;
    data['restrict_commenting'] = this.restrictCommenting;
    data['coins'] = this.coins;
    data['subscribers'] = this.subscribers;
    data['header_size'] = this.headerSize;
    data['restrict_posting'] = this.restrictPosting;
    data['community_icon'] = this.communityIcon;
    data['display_name'] = this.displayName;
    data['primary_color'] = this.primaryColor;
    data['url'] = this.url;
    data['user_is_contributor'] = this.userIsContributor;
    data['link_flair_position'] = this.linkFlairPosition;
    data['link_flair_enabled'] = this.linkFlairEnabled;
    data['submit_link_label'] = this.submitLinkLabel;
    data['header_img'] = this.headerImg;
    data['icon_color'] = this.iconColor;
    data['icon_img'] = this.iconImg;
    data['banner_img'] = this.bannerImg;
    data['name'] = this.name;
    return data;
  }
}

class UserInformationFeatures {
  bool? chatUserSettings;
  bool? modAwards;
  bool? stewardUi;
  bool? chatGroupRollout;
  bool? mwebXpromoInterstitialCommentsAndroid;
  bool? twitterEmbed;
  bool? showAmpLink;
  bool? mwebXpromoInterstitialCommentsIos;
  bool? doNotTrack;
  bool? customFeeds;
  bool? spezModal;
  UserInformationFeaturesMwebXpromoRevampV3? mwebXpromoRevampV3;
  bool? awarderNames;
  bool? chatRollout;
  bool? mwebXpromoModalListingClickDailyDismissibleAndroid;
  UserInformationFeaturesMwebNsfwXpromo? mwebNsfwXpromo;
  UserInformationFeaturesDefaultSrsHoldout? defaultSrsHoldout;
  bool? layersCreation;
  bool? premiumSubscriptionsTable;
  bool? mwebXpromoModalListingClickDailyDismissibleIos;
  bool? dualWriteUserPrefs;
  bool? modlogCopyrightRemoval;
  bool? richtextPreviews;
  bool? chatSubreddit;
  bool? communityAwards;
  bool? isEmailPermissionRequired;
  bool? readFromPrefService;
  bool? chatReddarReports;

  UserInformationFeatures(
      {this.chatUserSettings,
      this.modAwards,
      this.stewardUi,
      this.chatGroupRollout,
      this.mwebXpromoInterstitialCommentsAndroid,
      this.twitterEmbed,
      this.showAmpLink,
      this.mwebXpromoInterstitialCommentsIos,
      this.doNotTrack,
      this.customFeeds,
      this.spezModal,
      this.mwebXpromoRevampV3,
      this.awarderNames,
      this.chatRollout,
      this.mwebXpromoModalListingClickDailyDismissibleAndroid,
      this.mwebNsfwXpromo,
      this.defaultSrsHoldout,
      this.layersCreation,
      this.premiumSubscriptionsTable,
      this.mwebXpromoModalListingClickDailyDismissibleIos,
      this.dualWriteUserPrefs,
      this.modlogCopyrightRemoval,
      this.richtextPreviews,
      this.chatSubreddit,
      this.communityAwards,
      this.isEmailPermissionRequired,
      this.readFromPrefService,
      this.chatReddarReports});

  UserInformationFeatures.fromJson(Map json) {
    chatUserSettings = json['chat_user_settings'];
    modAwards = json['mod_awards'];
    stewardUi = json['steward_ui'];
    chatGroupRollout = json['chat_group_rollout'];
    mwebXpromoInterstitialCommentsAndroid =
        json['mweb_xpromo_interstitial_comments_android'];
    twitterEmbed = json['twitter_embed'];
    showAmpLink = json['show_amp_link'];
    mwebXpromoInterstitialCommentsIos =
        json['mweb_xpromo_interstitial_comments_ios'];
    doNotTrack = json['do_not_track'];
    customFeeds = json['custom_feeds'];
    spezModal = json['spez_modal'];
    mwebXpromoRevampV3 = json['mweb_xpromo_revamp_v3'] != null
        ? new UserInformationFeaturesMwebXpromoRevampV3.fromJson(
            json['mweb_xpromo_revamp_v3'])
        : null;
    awarderNames = json['awarder_names'];
    chatRollout = json['chat_rollout'];
    mwebXpromoModalListingClickDailyDismissibleAndroid =
        json['mweb_xpromo_modal_listing_click_daily_dismissible_android'];
    mwebNsfwXpromo = json['mweb_nsfw_xpromo'] != null
        ? new UserInformationFeaturesMwebNsfwXpromo.fromJson(
            json['mweb_nsfw_xpromo'])
        : null;
    defaultSrsHoldout = json['default_srs_holdout'] != null
        ? new UserInformationFeaturesDefaultSrsHoldout.fromJson(
            json['default_srs_holdout'])
        : null;
    layersCreation = json['layers_creation'];
    premiumSubscriptionsTable = json['premium_subscriptions_table'];
    mwebXpromoModalListingClickDailyDismissibleIos =
        json['mweb_xpromo_modal_listing_click_daily_dismissible_ios'];
    dualWriteUserPrefs = json['dual_write_user_prefs'];
    modlogCopyrightRemoval = json['modlog_copyright_removal'];
    richtextPreviews = json['richtext_previews'];
    chatSubreddit = json['chat_subreddit'];
    communityAwards = json['community_awards'];
    isEmailPermissionRequired = json['is_email_permission_required'];
    readFromPrefService = json['read_from_pref_service'];
    chatReddarReports = json['chat_reddar_reports'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_user_settings'] = this.chatUserSettings;
    data['mod_awards'] = this.modAwards;
    data['steward_ui'] = this.stewardUi;
    data['chat_group_rollout'] = this.chatGroupRollout;
    data['mweb_xpromo_interstitial_comments_android'] =
        this.mwebXpromoInterstitialCommentsAndroid;
    data['twitter_embed'] = this.twitterEmbed;
    data['show_amp_link'] = this.showAmpLink;
    data['mweb_xpromo_interstitial_comments_ios'] =
        this.mwebXpromoInterstitialCommentsIos;
    data['do_not_track'] = this.doNotTrack;
    data['custom_feeds'] = this.customFeeds;
    data['spez_modal'] = this.spezModal;
    if (this.mwebXpromoRevampV3 != null) {
      data['mweb_xpromo_revamp_v3'] = this.mwebXpromoRevampV3!.toJson();
    }
    data['awarder_names'] = this.awarderNames;
    data['chat_rollout'] = this.chatRollout;
    data['mweb_xpromo_modal_listing_click_daily_dismissible_android'] =
        this.mwebXpromoModalListingClickDailyDismissibleAndroid;
    if (this.mwebNsfwXpromo != null) {
      data['mweb_nsfw_xpromo'] = this.mwebNsfwXpromo!.toJson();
    }
    if (this.defaultSrsHoldout != null) {
      data['default_srs_holdout'] = this.defaultSrsHoldout!.toJson();
    }
    data['layers_creation'] = this.layersCreation;
    data['premium_subscriptions_table'] = this.premiumSubscriptionsTable;
    data['mweb_xpromo_modal_listing_click_daily_dismissible_ios'] =
        this.mwebXpromoModalListingClickDailyDismissibleIos;
    data['dual_write_user_prefs'] = this.dualWriteUserPrefs;
    data['modlog_copyright_removal'] = this.modlogCopyrightRemoval;
    data['richtext_previews'] = this.richtextPreviews;
    data['chat_subreddit'] = this.chatSubreddit;
    data['community_awards'] = this.communityAwards;
    data['is_email_permission_required'] = this.isEmailPermissionRequired;
    data['read_from_pref_service'] = this.readFromPrefService;
    data['chat_reddar_reports'] = this.chatReddarReports;
    return data;
  }
}

class UserInformationFeaturesMwebXpromoRevampV3 {
  String? owner;
  int? experimentId;
  String? variant;

  UserInformationFeaturesMwebXpromoRevampV3(
      {this.owner, this.experimentId, this.variant});

  UserInformationFeaturesMwebXpromoRevampV3.fromJson(Map json) {
    owner = json['owner'];
    experimentId = json['experiment_id'];
    variant = json['variant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner'] = this.owner;
    data['experiment_id'] = this.experimentId;
    data['variant'] = this.variant;
    return data;
  }
}

class UserInformationFeaturesMwebNsfwXpromo {
  String? owner;
  int? experimentId;
  String? variant;

  UserInformationFeaturesMwebNsfwXpromo(
      {this.owner, this.experimentId, this.variant});

  UserInformationFeaturesMwebNsfwXpromo.fromJson(Map json) {
    owner = json['owner'];
    experimentId = json['experiment_id'];
    variant = json['variant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner'] = this.owner;
    data['experiment_id'] = this.experimentId;
    data['variant'] = this.variant;
    return data;
  }
}

class UserInformationFeaturesDefaultSrsHoldout {
  String? owner;
  int? experimentId;
  String? variant;

  UserInformationFeaturesDefaultSrsHoldout(
      {this.owner, this.experimentId, this.variant});

  UserInformationFeaturesDefaultSrsHoldout.fromJson(Map json) {
    owner = json['owner'];
    experimentId = json['experiment_id'];
    variant = json['variant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner'] = this.owner;
    data['experiment_id'] = this.experimentId;
    data['variant'] = this.variant;
    return data;
  }
}
