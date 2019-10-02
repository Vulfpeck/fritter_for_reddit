import 'package:flutter_provider_app/models/user_profile/default_srs_holdout.dart';
import 'package:flutter_provider_app/models/user_profile/email_verification.dart';
import 'package:flutter_provider_app/models/user_profile/mweb_sharing_web_share_api.dart';
import 'package:flutter_provider_app/models/user_profile/mweb_xpromo_revamp_v2.dart';

class Features {
  final bool chat_subreddit;
  final bool show_amp_link;
  final bool read_from_pref_service;
  final bool chat_rollout;
  final bool chat;
  final bool chat_reddar_reports;
  final Default_srs_holdout default_srs_holdout;
  final bool twitter_embed;
  final bool is_email_permission_required;
  final bool richtext_previews;
  final bool chat_subreddit_notification_ftux;
  final bool mod_awards;
  final Email_verification email_verification;
  final Mweb_xpromo_revamp_v2 mweb_xpromo_revamp_v2;
  final bool webhook_config;
  final bool mweb_xpromo_modal_listing_click_daily_dismissible_ios;
  final bool live_orangereds;
  final bool modlog_copyright_removal;
  final bool dual_write_user_prefs;
  final bool do_not_track;
  final bool chat_user_settings;
  final bool mweb_xpromo_interstitial_comments_ios;
  final bool community_awards;
  final bool premium_subscriptions_table;
  final bool mweb_xpromo_interstitial_comments_android;
  final bool steward_ui;
  final Mweb_sharing_web_share_api mweb_sharing_web_share_api;
  final bool chat_group_rollout;
  final bool custom_feeds;
  final bool spez_modal;
  final bool mweb_xpromo_modal_listing_click_daily_dismissible_android;
  final bool layers_creation;

  Features.fromJsonMap(Map<String, dynamic> map)
      : chat_subreddit = map["chat_subreddit"],
        show_amp_link = map["show_amp_link"],
        read_from_pref_service = map["read_from_pref_service"],
        chat_rollout = map["chat_rollout"],
        chat = map["chat"],
        chat_reddar_reports = map["chat_reddar_reports"],
        default_srs_holdout =
            Default_srs_holdout.fromJsonMap(map["default_srs_holdout"]),
        twitter_embed = map["twitter_embed"],
        is_email_permission_required = map["is_email_permission_required"],
        richtext_previews = map["richtext_previews"],
        chat_subreddit_notification_ftux =
            map["chat_subreddit_notification_ftux"],
        mod_awards = map["mod_awards"],
        email_verification =
            Email_verification.fromJsonMap(map["email_verification"]),
        mweb_xpromo_revamp_v2 =
            Mweb_xpromo_revamp_v2.fromJsonMap(map["mweb_xpromo_revamp_v2"]),
        webhook_config = map["webhook_config"],
        mweb_xpromo_modal_listing_click_daily_dismissible_ios =
            map["mweb_xpromo_modal_listing_click_daily_dismissible_ios"],
        live_orangereds = map["live_orangereds"],
        modlog_copyright_removal = map["modlog_copyright_removal"],
        dual_write_user_prefs = map["dual_write_user_prefs"],
        do_not_track = map["do_not_track"],
        chat_user_settings = map["chat_user_settings"],
        mweb_xpromo_interstitial_comments_ios =
            map["mweb_xpromo_interstitial_comments_ios"],
        community_awards = map["community_awards"],
        premium_subscriptions_table = map["premium_subscriptions_table"],
        mweb_xpromo_interstitial_comments_android =
            map["mweb_xpromo_interstitial_comments_android"],
        steward_ui = map["steward_ui"],
        mweb_sharing_web_share_api = Mweb_sharing_web_share_api.fromJsonMap(
            map["mweb_sharing_web_share_api"]),
        chat_group_rollout = map["chat_group_rollout"],
        custom_feeds = map["custom_feeds"],
        spez_modal = map["spez_modal"],
        mweb_xpromo_modal_listing_click_daily_dismissible_android =
            map["mweb_xpromo_modal_listing_click_daily_dismissible_android"],
        layers_creation = map["layers_creation"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_subreddit'] = chat_subreddit;
    data['show_amp_link'] = show_amp_link;
    data['read_from_pref_service'] = read_from_pref_service;
    data['chat_rollout'] = chat_rollout;
    data['chat'] = chat;
    data['chat_reddar_reports'] = chat_reddar_reports;
    data['default_srs_holdout'] =
        default_srs_holdout == null ? null : default_srs_holdout.toJson();
    data['twitter_embed'] = twitter_embed;
    data['is_email_permission_required'] = is_email_permission_required;
    data['richtext_previews'] = richtext_previews;
    data['chat_subreddit_notification_ftux'] = chat_subreddit_notification_ftux;
    data['mod_awards'] = mod_awards;
    data['email_verification'] =
        email_verification == null ? null : email_verification.toJson();
    data['mweb_xpromo_revamp_v2'] =
        mweb_xpromo_revamp_v2 == null ? null : mweb_xpromo_revamp_v2.toJson();
    data['webhook_config'] = webhook_config;
    data['mweb_xpromo_modal_listing_click_daily_dismissible_ios'] =
        mweb_xpromo_modal_listing_click_daily_dismissible_ios;
    data['live_orangereds'] = live_orangereds;
    data['modlog_copyright_removal'] = modlog_copyright_removal;
    data['dual_write_user_prefs'] = dual_write_user_prefs;
    data['do_not_track'] = do_not_track;
    data['chat_user_settings'] = chat_user_settings;
    data['mweb_xpromo_interstitial_comments_ios'] =
        mweb_xpromo_interstitial_comments_ios;
    data['community_awards'] = community_awards;
    data['premium_subscriptions_table'] = premium_subscriptions_table;
    data['mweb_xpromo_interstitial_comments_android'] =
        mweb_xpromo_interstitial_comments_android;
    data['steward_ui'] = steward_ui;
    data['mweb_sharing_web_share_api'] = mweb_sharing_web_share_api == null
        ? null
        : mweb_sharing_web_share_api.toJson();
    data['chat_group_rollout'] = chat_group_rollout;
    data['custom_feeds'] = custom_feeds;
    data['spez_modal'] = spez_modal;
    data['mweb_xpromo_modal_listing_click_daily_dismissible_android'] =
        mweb_xpromo_modal_listing_click_daily_dismissible_android;
    data['layers_creation'] = layers_creation;
    return data;
  }
}
