class CommentMoreEntity {
  CommentMoreJson json;

  CommentMoreEntity.fromJson(Map<String, dynamic> json) {
//    print(json);
    this.json = json['json'] != null
        ? new CommentMoreJson.fromJson(json['json'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.json != null) {
      data['json'] = this.json.toJson();
    }
    return data;
  }
}

class CommentMoreJson {
  CommentMoreJsonData data;
  List<Null> errors;

  CommentMoreJson.fromJson(Map<String, dynamic> json) {
//    print("data" + json["data"]);
    if (json['data'] != null) {
      data = CommentMoreJsonData.fromJson(json['data']);
    } else {
      print('data is null');
    }
    if (json['errors'] != null) {
      errors = new List<Null>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.errors != null) {
      data['errors'] = [];
    }
    return data;
  }
}

class CommentMoreJsonData {
  List<CommantMoreJsonDataThings> things;

  CommentMoreJsonData({this.things});

  CommentMoreJsonData.fromJson(Map<String, dynamic> json) {
    if (json['things'] != null) {
      things = new List<CommantMoreJsonDataThings>();
      (json['things'] as List).forEach((v) {
        things.add(new CommantMoreJsonDataThings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.things != null) {
      data['things'] = this.things.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommantMoreJsonDataThings {
  CommentMoreJsonDataThingsData data;
  String kind;

  CommantMoreJsonDataThings({this.data, this.kind});

  CommantMoreJsonDataThings.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new CommentMoreJsonDataThingsData.fromJson(json['data'])
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

class CommentMoreJsonDataThingsData {
  String bodyHtml;
  List<Null> authorFlairRichtext;
  bool saved;
  int controversiality;
  String body;
  int totalAwardsReceived;
  String linkId;
  String subredditId;
  String subreddit;
  int score;
  dynamic modReasonTitle;
  bool isSubmitter;
  bool canGild;
  List<Null> stewardReports;
  String id;
  dynamic createdUtc;
  bool locked;
  dynamic likes;
  dynamic bannedAtUtc;
  int downs;
  dynamic edited;
  String author;
  dynamic created;
  dynamic authorFlairBackgroundColor;
  CommentMoreJsonDataThingsDataGildings gildings;
  dynamic reportReasons;
  dynamic approvedBy;
  bool scoreHidden;
  String replies;
  String subredditNamePrefixed;
  dynamic modReasonBy;
  String parentId;
  dynamic approvedAtUtc;
  bool noFollow;
  String name;
  int ups;
  String authorFlairType;
  List<Null> awarders;
  String permalink;
  dynamic authorFlairCssClass;
  dynamic numReports;
  List<Null> modReports;
  int gilded;
  bool authorPatreonFlair;
  dynamic collapsedReason;
  bool collapsed;
  dynamic removalReason;
  dynamic modNote;
  bool sendReplies;
  dynamic authorFlairText;
  bool archived;
  dynamic authorFlairTextColor;
  bool canModPost;
  String authorFullname;
  String subredditType;
  List<Null> userReports;
  dynamic distinguished;
  dynamic authorFlairTemplateId;
  int depth;
  bool stickied;
  List<Null> allAwardings;
  dynamic bannedBy;

  CommentMoreJsonDataThingsData(
      {this.bodyHtml,
      this.authorFlairRichtext,
      this.saved,
      this.controversiality,
      this.body,
      this.totalAwardsReceived,
      this.linkId,
      this.subredditId,
      this.subreddit,
      this.score,
      this.modReasonTitle,
      this.isSubmitter,
      this.canGild,
      this.stewardReports,
      this.id,
      this.createdUtc,
      this.locked,
      this.likes,
      this.bannedAtUtc,
      this.downs,
      this.edited,
      this.author,
      this.created,
      this.authorFlairBackgroundColor,
      this.gildings,
      this.reportReasons,
      this.approvedBy,
      this.scoreHidden,
      this.replies,
      this.subredditNamePrefixed,
      this.modReasonBy,
      this.parentId,
      this.approvedAtUtc,
      this.noFollow,
      this.name,
      this.ups,
      this.authorFlairType,
      this.awarders,
      this.permalink,
      this.authorFlairCssClass,
      this.numReports,
      this.modReports,
      this.gilded,
      this.authorPatreonFlair,
      this.collapsedReason,
      this.collapsed,
      this.removalReason,
      this.modNote,
      this.sendReplies,
      this.authorFlairText,
      this.archived,
      this.authorFlairTextColor,
      this.canModPost,
      this.authorFullname,
      this.subredditType,
      this.userReports,
      this.distinguished,
      this.authorFlairTemplateId,
      this.depth,
      this.stickied,
      this.allAwardings,
      this.bannedBy});

  CommentMoreJsonDataThingsData.fromJson(Map<String, dynamic> json) {
    bodyHtml = json['body_html'];
    if (json['author_flair_richtext'] != null) {
      authorFlairRichtext = new List<Null>();
    }
    saved = json['saved'];
    controversiality = json['controversiality'];
    body = json['body'];
    totalAwardsReceived = json['total_awards_received'];
    linkId = json['link_id'];
    subredditId = json['subreddit_id'];
    subreddit = json['subreddit'];
    score = json['score'];
    modReasonTitle = json['mod_reason_title'];
    isSubmitter = json['is_submitter'];
    canGild = json['can_gild'];
    if (json['steward_reports'] != null) {
      stewardReports = new List<Null>();
    }
    id = json['id'];
    createdUtc = json['created_utc'];
    locked = json['locked'];
    likes = json['likes'];
    bannedAtUtc = json['banned_at_utc'];
    downs = json['downs'];
    edited = json['edited'];
    author = json['author'];
    created = json['created'];
    authorFlairBackgroundColor = json['author_flair_background_color'];
    gildings = json['gildings'] != null
        ? new CommentMoreJsonDataThingsDataGildings.fromJson(json['gildings'])
        : null;
    reportReasons = json['report_reasons'];
    approvedBy = json['approved_by'];
    scoreHidden = json['score_hidden'];
    replies = json['replies'];
    subredditNamePrefixed = json['subreddit_name_prefixed'];
    modReasonBy = json['mod_reason_by'];
    parentId = json['parent_id'];
    approvedAtUtc = json['approved_at_utc'];
    noFollow = json['no_follow'];
    name = json['name'];
    ups = json['ups'];
    authorFlairType = json['author_flair_type'];
    if (json['awarders'] != null) {
      awarders = new List<Null>();
    }
    permalink = json['permalink'];
    authorFlairCssClass = json['author_flair_css_class'];
    numReports = json['num_reports'];
    if (json['mod_reports'] != null) {
      modReports = new List<Null>();
    }
    gilded = json['gilded'];
    authorPatreonFlair = json['author_patreon_flair'];
    collapsedReason = json['collapsed_reason'];
    collapsed = json['collapsed'];
    removalReason = json['removal_reason'];
    modNote = json['mod_note'];
    sendReplies = json['send_replies'];
    authorFlairText = json['author_flair_text'];
    archived = json['archived'];
    authorFlairTextColor = json['author_flair_text_color'];
    canModPost = json['can_mod_post'];
    authorFullname = json['author_fullname'];
    subredditType = json['subreddit_type'];
    if (json['user_reports'] != null) {
      userReports = new List<Null>();
    }
    distinguished = json['distinguished'];
    authorFlairTemplateId = json['author_flair_template_id'];
    depth = json['depth'];
    stickied = json['stickied'];
    if (json['all_awardings'] != null) {
      allAwardings = new List<Null>();
    }
    bannedBy = json['banned_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body_html'] = this.bodyHtml;
    if (this.authorFlairRichtext != null) {
      data['author_flair_richtext'] = [];
    }
    data['saved'] = this.saved;
    data['controversiality'] = this.controversiality;
    data['body'] = this.body;
    data['total_awards_received'] = this.totalAwardsReceived;
    data['link_id'] = this.linkId;
    data['subreddit_id'] = this.subredditId;
    data['subreddit'] = this.subreddit;
    data['score'] = this.score;
    data['mod_reason_title'] = this.modReasonTitle;
    data['is_submitter'] = this.isSubmitter;
    data['can_gild'] = this.canGild;
    if (this.stewardReports != null) {
      data['steward_reports'] = [];
    }
    data['id'] = this.id;
    data['created_utc'] = this.createdUtc;
    data['locked'] = this.locked;
    data['likes'] = this.likes;
    data['banned_at_utc'] = this.bannedAtUtc;
    data['downs'] = this.downs;
    data['edited'] = this.edited;
    data['author'] = this.author;
    data['created'] = this.created;
    data['author_flair_background_color'] = this.authorFlairBackgroundColor;
    if (this.gildings != null) {
      data['gildings'] = this.gildings.toJson();
    }
    data['report_reasons'] = this.reportReasons;
    data['approved_by'] = this.approvedBy;
    data['score_hidden'] = this.scoreHidden;
    data['replies'] = this.replies;
    data['subreddit_name_prefixed'] = this.subredditNamePrefixed;
    data['mod_reason_by'] = this.modReasonBy;
    data['parent_id'] = this.parentId;
    data['approved_at_utc'] = this.approvedAtUtc;
    data['no_follow'] = this.noFollow;
    data['name'] = this.name;
    data['ups'] = this.ups;
    data['author_flair_type'] = this.authorFlairType;
    if (this.awarders != null) {
      data['awarders'] = [];
    }
    data['permalink'] = this.permalink;
    data['author_flair_css_class'] = this.authorFlairCssClass;
    data['num_reports'] = this.numReports;
    if (this.modReports != null) {
      data['mod_reports'] = [];
    }
    data['gilded'] = this.gilded;
    data['author_patreon_flair'] = this.authorPatreonFlair;
    data['collapsed_reason'] = this.collapsedReason;
    data['collapsed'] = this.collapsed;
    data['removal_reason'] = this.removalReason;
    data['mod_note'] = this.modNote;
    data['send_replies'] = this.sendReplies;
    data['author_flair_text'] = this.authorFlairText;
    data['archived'] = this.archived;
    data['author_flair_text_color'] = this.authorFlairTextColor;
    data['can_mod_post'] = this.canModPost;
    data['author_fullname'] = this.authorFullname;
    data['subreddit_type'] = this.subredditType;
    if (this.userReports != null) {
      data['user_reports'] = [];
    }
    data['distinguished'] = this.distinguished;
    data['author_flair_template_id'] = this.authorFlairTemplateId;
    data['depth'] = this.depth;
    data['stickied'] = this.stickied;
    if (this.allAwardings != null) {
      data['all_awardings'] = [];
    }
    data['banned_by'] = this.bannedBy;
    return data;
  }
}

class CommentMoreJsonDataThingsDataGildings {
  CommentMoreJsonDataThingsDataGildings();

  CommentMoreJsonDataThingsDataGildings.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
