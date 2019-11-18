// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Comment> commentFromJson(String str) =>
    List<Comment>.from(json.decode(str).map((x) => Comment.fromMap(x)));

String commentToJson(List<Comment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Comment {
  String kind;
  CommentData data;

  Comment({
    this.kind,
    this.data,
  });

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        kind: json["kind"],
        data: CommentData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "kind": kind,
        "data": data.toMap(),
      };
}

class CommentData {
  String modhash;
  int dist;
  List<Child> children;
  dynamic after;
  dynamic before;

  CommentData({
    this.modhash,
    this.dist,
    this.children,
    this.after,
    this.before,
  });

  factory CommentData.fromMap(Map<String, dynamic> json) => CommentData(
        modhash: json["modhash"],
        dist: json["dist"] == null ? null : json["dist"],
        children:
            List<Child>.from(json["children"].map((x) => Child.fromMap(x))),
        after: json["after"],
        before: json["before"],
      );

  Map<String, dynamic> toMap() => {
        "modhash": modhash,
        "dist": dist == null ? null : dist,
        "children": List<dynamic>.from(children.map((x) => x.toMap())),
        "after": after,
        "before": before,
      };
}

class Child {
  Kind kind;
  ChildData data;

  Child({
    this.kind,
    this.data,
  });

  factory Child.fromMap(Map<String, dynamic> json) => Child(
        kind: kindValues.map[json["kind"]],
        data: ChildData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "kind": kindValues.reverse[kind],
        "data": data.toMap(),
      };
}

class ChildData {
  dynamic approvedAtUtc;
  String subreddit;
  String selftext;
  List<dynamic> userReports;
  bool saved;
  dynamic modReasonTitle;
  int gilded;
  bool clicked;
  String title;
  bool collapse = false;
  bool collapseParent = false;
  List<dynamic> linkFlairRichtext;
  String subredditNamePrefixed;
  bool hidden;
  int pwls;
  dynamic linkFlairCssClass;
  int downs;
  int thumbnailHeight;
  String parentWhitelistStatus;
  bool hideScore;
  String name;
  bool quarantine;
  String linkFlairTextColor;
  dynamic upvoteRatio;
  String authorFlairBackgroundColor;
  String subredditType;
  int ups;
  int totalAwardsReceived;
  dynamic mediaEmbed;
  int thumbnailWidth;
  String authorFlairTemplateId;
  bool isOriginalContent;
  String authorFullname;
  dynamic secureMedia;
  bool isRedditMediaDomain;
  bool isMeta;
  dynamic category;
  Gildings secureMediaEmbed;
  dynamic linkFlairText;
  bool canModPost;
  int numDuplicates;
  dynamic approvedBy;
  String thumbnail;
  dynamic edited;
  String authorFlairCssClass;
  List<dynamic> stewardReports;
  List<dynamic> authorFlairRichtext;
  Gildings gildings;
  String postHint;
  dynamic contentCategories;
  bool isSelf;
  dynamic modNote;
  dynamic created;
  String linkFlairType;
  int wls;
  dynamic bannedBy;
  String authorFlairType;
  String domain;
  bool allowLiveComments;
  dynamic selftextHtml;
  dynamic likes;
  dynamic suggestedSort;
  dynamic bannedAtUtc;
  dynamic viewCount;
  bool archived;
  int score;
  bool noFollow;
  bool isCrosspostable;
  bool pinned;
  bool over18;
  Preview preview;
  List<dynamic> allAwardings;
  List<dynamic> awarders;
  bool mediaOnly;
  bool canGild;
  bool spoiler;
  bool locked;
  String authorFlairText;
  bool visited;
  dynamic numReports;
  dynamic distinguished;
  String subredditId;
  dynamic modReasonBy;
  dynamic removalReason;
  String linkFlairBackgroundColor;
  String id;
  bool isRobotIndexable;
  dynamic reportReasons;
  String author;
  dynamic discussionType;
  int numComments;
  bool sendReplies;
  dynamic media;
  bool contestMode;
  bool authorPatreonFlair;
  String authorFlairTextColor;
  String permalink;
  String whitelistStatus;
  bool stickied;
  String url;
  int subredditSubscribers;
  dynamic createdUtc;
  int numCrossposts;
  List<dynamic> modReports;
  bool isVideo;
  String linkId;
  String replies;
  String parentId;
  String body;
  bool isSubmitter;
  String bodyHtml;
  dynamic collapsedReason;
  bool scoreHidden;
  bool collapsed;
  int controversiality;
  int depth;
  int count;
  List<String> children;

  ChildData({
    this.approvedAtUtc,
    this.subreddit,
    this.selftext,
    this.userReports,
    this.saved,
    this.modReasonTitle,
    this.gilded,
    this.clicked,
    this.title,
    this.linkFlairRichtext,
    this.subredditNamePrefixed,
    this.hidden,
    this.pwls,
    this.linkFlairCssClass,
    this.downs,
    this.thumbnailHeight,
    this.parentWhitelistStatus,
    this.hideScore,
    this.name,
    this.quarantine,
    this.linkFlairTextColor,
    this.upvoteRatio,
    this.authorFlairBackgroundColor,
    this.subredditType,
    this.ups,
    this.totalAwardsReceived,
    this.mediaEmbed,
    this.thumbnailWidth,
    this.authorFlairTemplateId,
    this.isOriginalContent,
    this.authorFullname,
    this.secureMedia,
    this.isRedditMediaDomain,
    this.isMeta,
    this.category,
    this.secureMediaEmbed,
    this.linkFlairText,
    this.canModPost,
    this.numDuplicates,
    this.approvedBy,
    this.thumbnail,
    this.edited,
    this.authorFlairCssClass,
    this.stewardReports,
    this.authorFlairRichtext,
    this.gildings,
    this.postHint,
    this.contentCategories,
    this.isSelf,
    this.modNote,
    this.created,
    this.linkFlairType,
    this.wls,
    this.bannedBy,
    this.authorFlairType,
    this.domain,
    this.allowLiveComments,
    this.selftextHtml,
    this.likes,
    this.suggestedSort,
    this.bannedAtUtc,
    this.viewCount,
    this.archived,
    this.score,
    this.noFollow,
    this.isCrosspostable,
    this.pinned,
    this.over18,
    this.preview,
    this.allAwardings,
    this.awarders,
    this.mediaOnly,
    this.canGild,
    this.spoiler,
    this.locked,
    this.authorFlairText,
    this.visited,
    this.numReports,
    this.distinguished,
    this.subredditId,
    this.modReasonBy,
    this.removalReason,
    this.linkFlairBackgroundColor,
    this.id,
    this.isRobotIndexable,
    this.reportReasons,
    this.author,
    this.discussionType,
    this.numComments,
    this.sendReplies,
    this.media,
    this.contestMode,
    this.authorPatreonFlair,
    this.authorFlairTextColor,
    this.permalink,
    this.whitelistStatus,
    this.stickied,
    this.url,
    this.subredditSubscribers,
    this.createdUtc,
    this.numCrossposts,
    this.modReports,
    this.isVideo,
    this.linkId,
    this.replies,
    this.parentId,
    this.body,
    this.isSubmitter,
    this.bodyHtml,
    this.collapsedReason,
    this.scoreHidden,
    this.collapsed,
    this.controversiality,
    this.depth,
    this.count,
    this.children,
  });

  factory ChildData.fromMap(Map<String, dynamic> json) => ChildData(
        approvedAtUtc: json["approved_at_utc"],
        subreddit: json["subreddit"] == null ? null : json["subreddit"],
        selftext: json["selftext"] == null ? null : json["selftext"],
        userReports: json["user_reports"] == null
            ? null
            : List<dynamic>.from(json["user_reports"].map((x) => x)),
        saved: json["saved"] == null ? null : json["saved"],
        modReasonTitle: json["mod_reason_title"],
        gilded: json["gilded"] == null ? null : json["gilded"],
        clicked: json["clicked"] == null ? null : json["clicked"],
        title: json["title"] == null ? null : json["title"],
        linkFlairRichtext: json["link_flair_richtext"] == null
            ? null
            : List<dynamic>.from(json["link_flair_richtext"].map((x) => x)),
        subredditNamePrefixed: json["subreddit_name_prefixed"] == null
            ? null
            : json["subreddit_name_prefixed"],
        hidden: json["hidden"] == null ? null : json["hidden"],
        pwls: json["pwls"] == null ? null : json["pwls"],
        linkFlairCssClass: json["link_flair_css_class"],
        downs: json["downs"] == null ? null : json["downs"],
        thumbnailHeight:
            json["thumbnail_height"] == null ? null : json["thumbnail_height"],
        parentWhitelistStatus: json["parent_whitelist_status"] == null
            ? null
            : json["parent_whitelist_status"],
        hideScore: json["hide_score"] == null ? null : json["hide_score"],
        name: json["name"],
        quarantine: json["quarantine"] == null ? null : json["quarantine"],
        linkFlairTextColor: json["link_flair_text_color"] == null
            ? null
            : json["link_flair_text_color"],
        upvoteRatio: json["upvote_ratio"] == null ? null : json["upvote_ratio"],
        authorFlairBackgroundColor:
            json["author_flair_background_color"] == null
                ? null
                : json["author_flair_background_color"],
        subredditType:
            json["subreddit_type"] == null ? null : json["subreddit_type"],
        ups: json["ups"] == null ? null : json["ups"],
        totalAwardsReceived: json["total_awards_received"] == null
            ? null
            : json["total_awards_received"],
        mediaEmbed: json["media_embed"] == null
            ? null
            : Gildings.fromMap(json["media_embed"]),
        thumbnailWidth:
            json["thumbnail_width"] == null ? null : json["thumbnail_width"],
        authorFlairTemplateId: json["author_flair_template_id"] == null
            ? null
            : json["author_flair_template_id"],
        isOriginalContent: json["is_original_content"] == null
            ? null
            : json["is_original_content"],
        authorFullname:
            json["author_fullname"] == null ? null : json["author_fullname"],
        secureMedia: json["secure_media"],
        isRedditMediaDomain: json["is_reddit_media_domain"] == null
            ? null
            : json["is_reddit_media_domain"],
        isMeta: json["is_meta"] == null ? null : json["is_meta"],
        category: json["category"],
        secureMediaEmbed: json["secure_media_embed"] == null
            ? null
            : Gildings.fromMap(json["secure_media_embed"]),
        linkFlairText: json["link_flair_text"],
        canModPost: json["can_mod_post"] == null ? null : json["can_mod_post"],
        numDuplicates:
            json["num_duplicates"] == null ? null : json["num_duplicates"],
        approvedBy: json["approved_by"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        edited: json["edited"] == null ? null : json["edited"],
        authorFlairCssClass: json["author_flair_css_class"] == null
            ? null
            : json["author_flair_css_class"],
        stewardReports: json["steward_reports"] == null
            ? null
            : List<dynamic>.from(json["steward_reports"].map((x) => x)),
        authorFlairRichtext: json["author_flair_richtext"] == null
            ? null
            : List<dynamic>.from(json["author_flair_richtext"].map((x) => x)),
        gildings: json["gildings"] == null
            ? null
            : Gildings.fromMap(json["gildings"]),
        postHint: json["post_hint"] == null ? null : json["post_hint"],
        contentCategories: json["content_categories"],
        isSelf: json["is_self"] == null ? null : json["is_self"],
        modNote: json["mod_note"],
        created: json["created"] == null ? null : json["created"],
        linkFlairType:
            json["link_flair_type"] == null ? null : json["link_flair_type"],
        wls: json["wls"] == null ? null : json["wls"],
        bannedBy: json["banned_by"],
        authorFlairType: json["author_flair_type"] == null
            ? null
            : json["author_flair_type"],
        domain: json["domain"] == null ? null : json["domain"],
        allowLiveComments: json["allow_live_comments"] == null
            ? null
            : json["allow_live_comments"],
        selftextHtml: json["selftext_html"],
        likes: json["likes"],
        suggestedSort: json["suggested_sort"],
        bannedAtUtc: json["banned_at_utc"],
        viewCount: json["view_count"],
        archived: json["archived"] == null ? null : json["archived"],
        score: json["score"] == null ? null : json["score"],
        noFollow: json["no_follow"] == null ? null : json["no_follow"],
        isCrosspostable:
            json["is_crosspostable"] == null ? null : json["is_crosspostable"],
        pinned: json["pinned"] == null ? null : json["pinned"],
        over18: json["over_18"] == null ? null : json["over_18"],
        preview:
            json["preview"] == null ? null : Preview.fromMap(json["preview"]),
        allAwardings: json["all_awardings"] == null
            ? null
            : List<dynamic>.from(json["all_awardings"].map((x) => x)),
        awarders: json["awarders"] == null
            ? null
            : List<dynamic>.from(json["awarders"].map((x) => x)),
        mediaOnly: json["media_only"] == null ? null : json["media_only"],
        canGild: json["can_gild"] == null ? null : json["can_gild"],
        spoiler: json["spoiler"] == null ? null : json["spoiler"],
        locked: json["locked"] == null ? null : json["locked"],
        authorFlairText: json["author_flair_text"] == null
            ? null
            : json["author_flair_text"],
        visited: json["visited"] == null ? null : json["visited"],
        numReports: json["num_reports"],
        distinguished: json["distinguished"],
        subredditId: json["subreddit_id"] == null ? null : json["subreddit_id"],
        modReasonBy: json["mod_reason_by"],
        removalReason: json["removal_reason"],
        linkFlairBackgroundColor: json["link_flair_background_color"] == null
            ? null
            : json["link_flair_background_color"],
        id: json["id"],
        isRobotIndexable: json["is_robot_indexable"] == null
            ? null
            : json["is_robot_indexable"],
        reportReasons: json["report_reasons"],
        author: json["author"] == null ? null : json["author"],
        discussionType: json["discussion_type"],
        numComments: json["num_comments"] == null ? null : json["num_comments"],
        sendReplies: json["send_replies"] == null ? null : json["send_replies"],
        media: json["media"],
        contestMode: json["contest_mode"] == null ? null : json["contest_mode"],
        authorPatreonFlair: json["author_patreon_flair"] == null
            ? null
            : json["author_patreon_flair"],
        authorFlairTextColor: json["author_flair_text_color"] == null
            ? null
            : json["author_flair_text_color"],
        permalink: json["permalink"] == null ? null : json["permalink"],
        whitelistStatus:
            json["whitelist_status"] == null ? null : json["whitelist_status"],
        stickied: json["stickied"] == null ? null : json["stickied"],
        url: json["url"] == null ? null : json["url"],
        subredditSubscribers: json["subreddit_subscribers"] == null
            ? null
            : json["subreddit_subscribers"],
        createdUtc: json["created_utc"] == null ? null : json["created_utc"],
        numCrossposts:
            json["num_crossposts"] == null ? null : json["num_crossposts"],
        modReports: json["mod_reports"] == null
            ? null
            : List<dynamic>.from(json["mod_reports"].map((x) => x)),
        isVideo: json["is_video"] == null ? null : json["is_video"],
        linkId: json["link_id"] == null ? null : json["link_id"],
        replies: json["replies"] == null ? null : json["replies"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        body: json["body"] == null ? null : json["body"],
        isSubmitter: json["is_submitter"] == null ? null : json["is_submitter"],
        bodyHtml: json["body_html"] == null ? null : json["body_html"],
        collapsedReason: json["collapsed_reason"],
        scoreHidden: json["score_hidden"] == null ? null : json["score_hidden"],
        collapsed: json["collapsed"] == null ? null : json["collapsed"],
        controversiality:
            json["controversiality"] == null ? null : json["controversiality"],
        depth: json["depth"] == null ? null : json["depth"],
        count: json["count"] == null ? null : json["count"],
        children: json["children"] == null
            ? null
            : List<String>.from(json["children"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "approved_at_utc": approvedAtUtc,
        "subreddit": subreddit == null ? null : subreddit,
        "selftext": selftext == null ? null : selftext,
        "user_reports": userReports == null
            ? null
            : List<dynamic>.from(userReports.map((x) => x)),
        "saved": saved == null ? null : saved,
        "mod_reason_title": modReasonTitle,
        "gilded": gilded == null ? null : gilded,
        "clicked": clicked == null ? null : clicked,
        "title": title == null ? null : title,
        "link_flair_richtext": linkFlairRichtext == null
            ? null
            : List<dynamic>.from(linkFlairRichtext.map((x) => x)),
        "subreddit_name_prefixed":
            subredditNamePrefixed == null ? null : subredditNamePrefixed,
        "hidden": hidden == null ? null : hidden,
        "pwls": pwls == null ? null : pwls,
        "link_flair_css_class": linkFlairCssClass,
        "downs": downs == null ? null : downs,
        "thumbnail_height": thumbnailHeight == null ? null : thumbnailHeight,
        "parent_whitelist_status":
            parentWhitelistStatus == null ? null : parentWhitelistStatus,
        "hide_score": hideScore == null ? null : hideScore,
        "name": name,
        "quarantine": quarantine == null ? null : quarantine,
        "link_flair_text_color":
            linkFlairTextColor == null ? null : linkFlairTextColor,
        "upvote_ratio": upvoteRatio == null ? null : upvoteRatio,
        "author_flair_background_color": authorFlairBackgroundColor == null
            ? null
            : authorFlairBackgroundColor,
        "subreddit_type": subredditType == null ? null : subredditType,
        "ups": ups == null ? null : ups,
        "total_awards_received":
            totalAwardsReceived == null ? null : totalAwardsReceived,
        "media_embed": mediaEmbed == null ? null : mediaEmbed.toMap(),
        "thumbnail_width": thumbnailWidth == null ? null : thumbnailWidth,
        "author_flair_template_id":
            authorFlairTemplateId == null ? null : authorFlairTemplateId,
        "is_original_content":
            isOriginalContent == null ? null : isOriginalContent,
        "author_fullname": authorFullname == null ? null : authorFullname,
        "secure_media": secureMedia,
        "is_reddit_media_domain":
            isRedditMediaDomain == null ? null : isRedditMediaDomain,
        "is_meta": isMeta == null ? null : isMeta,
        "category": category,
        "secure_media_embed":
            secureMediaEmbed == null ? null : secureMediaEmbed.toMap(),
        "link_flair_text": linkFlairText,
        "can_mod_post": canModPost == null ? null : canModPost,
        "num_duplicates": numDuplicates == null ? null : numDuplicates,
        "approved_by": approvedBy,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "edited": edited == null ? null : edited,
        "author_flair_css_class":
            authorFlairCssClass == null ? null : authorFlairCssClass,
        "steward_reports": stewardReports == null
            ? null
            : List<dynamic>.from(stewardReports.map((x) => x)),
        "author_flair_richtext": authorFlairRichtext == null
            ? null
            : List<dynamic>.from(authorFlairRichtext.map((x) => x)),
        "gildings": gildings == null ? null : gildings.toMap(),
        "post_hint": postHint == null ? null : postHint,
        "content_categories": contentCategories,
        "is_self": isSelf == null ? null : isSelf,
        "mod_note": modNote,
        "created": created == null ? null : created,
        "link_flair_type": linkFlairType == null ? null : linkFlairType,
        "wls": wls == null ? null : wls,
        "banned_by": bannedBy,
        "author_flair_type": authorFlairType == null ? null : authorFlairType,
        "domain": domain == null ? null : domain,
        "allow_live_comments":
            allowLiveComments == null ? null : allowLiveComments,
        "selftext_html": selftextHtml,
        "likes": likes,
        "suggested_sort": suggestedSort,
        "banned_at_utc": bannedAtUtc,
        "view_count": viewCount,
        "archived": archived == null ? null : archived,
        "score": score == null ? null : score,
        "no_follow": noFollow == null ? null : noFollow,
        "is_crosspostable": isCrosspostable == null ? null : isCrosspostable,
        "pinned": pinned == null ? null : pinned,
        "over_18": over18 == null ? null : over18,
        "preview": preview == null ? null : preview.toMap(),
        "all_awardings": allAwardings == null
            ? null
            : List<dynamic>.from(allAwardings.map((x) => x)),
        "awarders": awarders == null
            ? null
            : List<dynamic>.from(awarders.map((x) => x)),
        "media_only": mediaOnly == null ? null : mediaOnly,
        "can_gild": canGild == null ? null : canGild,
        "spoiler": spoiler == null ? null : spoiler,
        "locked": locked == null ? null : locked,
        "author_flair_text": authorFlairText == null ? null : authorFlairText,
        "visited": visited == null ? null : visited,
        "num_reports": numReports,
        "distinguished": distinguished,
        "subreddit_id": subredditId == null ? null : subredditId,
        "mod_reason_by": modReasonBy,
        "removal_reason": removalReason,
        "link_flair_background_color":
            linkFlairBackgroundColor == null ? null : linkFlairBackgroundColor,
        "id": id,
        "is_robot_indexable":
            isRobotIndexable == null ? null : isRobotIndexable,
        "report_reasons": reportReasons,
        "author": author == null ? null : author,
        "discussion_type": discussionType,
        "num_comments": numComments == null ? null : numComments,
        "send_replies": sendReplies == null ? null : sendReplies,
        "media": media,
        "contest_mode": contestMode == null ? null : contestMode,
        "author_patreon_flair":
            authorPatreonFlair == null ? null : authorPatreonFlair,
        "author_flair_text_color":
            authorFlairTextColor == null ? null : authorFlairTextColor,
        "permalink": permalink == null ? null : permalink,
        "whitelist_status": whitelistStatus == null ? null : whitelistStatus,
        "stickied": stickied == null ? null : stickied,
        "url": url == null ? null : url,
        "subreddit_subscribers":
            subredditSubscribers == null ? null : subredditSubscribers,
        "created_utc": createdUtc == null ? null : createdUtc,
        "num_crossposts": numCrossposts == null ? null : numCrossposts,
        "mod_reports": modReports == null
            ? null
            : List<dynamic>.from(modReports.map((x) => x)),
        "is_video": isVideo == null ? null : isVideo,
        "link_id": linkId == null ? null : linkId,
        "replies": replies == null ? null : replies,
        "parent_id": parentId == null ? null : parentId,
        "body": body == null ? null : body,
        "is_submitter": isSubmitter == null ? null : isSubmitter,
        "body_html": bodyHtml == null ? null : bodyHtml,
        "collapsed_reason": collapsedReason,
        "score_hidden": scoreHidden == null ? null : scoreHidden,
        "collapsed": collapsed == null ? null : collapsed,
        "controversiality": controversiality == null ? null : controversiality,
        "depth": depth == null ? null : depth,
        "count": count == null ? null : count,
        "children": children == null
            ? null
            : List<dynamic>.from(children.map((x) => x)),
      };
}

class Gildings {
  Gildings();

  factory Gildings.fromMap(Map<String, dynamic> json) => Gildings();

  Map<String, dynamic> toMap() => {};
}

class Preview {
  List<Image> images;
  bool enabled;

  Preview({
    this.images,
    this.enabled,
  });

  factory Preview.fromMap(Map<String, dynamic> json) => Preview(
        images: List<Image>.from(json["images"].map((x) => Image.fromMap(x))),
        enabled: json["enabled"],
      );

  Map<String, dynamic> toMap() => {
        "images": List<dynamic>.from(images.map((x) => x.toMap())),
        "enabled": enabled,
      };
}

class Image {
  Source source;
  List<Source> resolutions;
  Gildings variants;
  String id;

  Image({
    this.source,
    this.resolutions,
    this.variants,
    this.id,
  });

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        source: Source.fromMap(json["source"]),
        resolutions: List<Source>.from(
            json["resolutions"].map((x) => Source.fromMap(x))),
        variants: Gildings.fromMap(json["variants"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "source": source.toMap(),
        "resolutions": List<dynamic>.from(resolutions.map((x) => x.toMap())),
        "variants": variants.toMap(),
        "id": id,
      };
}

class Source {
  String url;
  int width;
  int height;

  Source({
    this.url,
    this.width,
    this.height,
  });

  factory Source.fromMap(Map<String, dynamic> json) => Source(
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
        "width": width,
        "height": height,
      };
}

enum Kind { T3, T1, MORE }

final kindValues =
    EnumValues({"more": Kind.MORE, "t1": Kind.T1, "t3": Kind.T3});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
