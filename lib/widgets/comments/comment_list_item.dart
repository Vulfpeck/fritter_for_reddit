import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fritter_for_reddit/helpers/comment_color_annotations/colors.dart';
import 'package:fritter_for_reddit/helpers/design_system/color_enums.dart';
import 'package:fritter_for_reddit/helpers/design_system/colors.dart';
import 'package:fritter_for_reddit/helpers/functions/conversion_functions.dart';
import 'package:fritter_for_reddit/models/comment_chain/comment.dart'
    as CommentPojo;
import 'package:fritter_for_reddit/pages/subreddit_feed_page.dart';
import 'package:fritter_for_reddit/providers/comments_provider.dart';
import 'package:fritter_for_reddit/widgets/common/swiper.dart';
import 'package:html_unescape/html_unescape.dart';

import '../../exports.dart';

class CommentItem extends StatelessWidget {
  final CommentPojo.Child _comment;
  final String name;
  final String postId;
  final int commentIndex;

  CommentItem(this._comment, this.name, this.postId, this.commentIndex);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      SizedBox(
        width: 16.0 * _comment.data.depth,
      ),
      Expanded(
        child: _comment.data.collapseParent == true
            ? Column(
                children: <Widget>[
                  CollapsedCommentParent(
                    comment: _comment,
                    postId: postId,
                    commentIndex: commentIndex,
                  ),
                  Divider(),
                ],
              )
            : _comment.data.collapse == true
                ? Container()
                : _comment.kind == CommentPojo.Kind.MORE
                    ? Column(
                        children: <Widget>[
                          MoreCommentKind(
                            comment: _comment,
                            postFullName: name,
                            id: postId,
                          ),
                          Divider(),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Swiper(
                            comment: _comment,
                            postId: postId,
                            child: CommentBody(
                              context: context,
                              commentIndex: commentIndex,
                              comment: _comment,
                              postId: postId,
                            ),
                            commentIndex: commentIndex,
                          ),
                          Divider(
                            indent: 16,
                          ),
                        ],
                      ),
      ),
    ]);
  }
}

class CollapsedCommentParent extends StatelessWidget {
  final CommentPojo.Child comment;
  final String postId;
  final int commentIndex;
  CollapsedCommentParent({
    @required this.comment,
    @required this.postId,
    @required this.commentIndex,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, CommentsProvider model, _) {
        return ListTile(
          dense: true,
          onTap: () {
            collapse(commentIndex, context);
          },
          title: Text(
            comment.data.author +
                " [+${model.collapsedChildrenCount[comment.data.id].toString()}]",
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
          trailing: Icon(Icons.expand_more),
        );
      },
    );
  }

  void collapse(int commentIndex, BuildContext context) async {
    Provider.of<CommentsProvider>(context, listen: false)
        .collapseUncollapseComment(
      collapse: false,
      postId: postId,
      parentCommentIndex: commentIndex,
    );
  }
}

class CommentBody extends StatelessWidget {
  final CommentPojo.Child comment;
  final String postId;
  final int commentIndex;
  final BuildContext context;
  static final HtmlUnescape _unescape = new HtmlUnescape();

  String _htmlContent = "";

  CommentBody({
    @required this.comment,
    @required this.postId,
    @required this.commentIndex,
    @required this.context,
  }) {
    _htmlContent = _unescape.convert(comment.data.bodyHtml);
  }

  Brightness _platformBrightness;

  @override
  Widget build(BuildContext context) {
    _platformBrightness = MediaQuery.of(context).platformBrightness;
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12.0, top: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          left: BorderSide(
            color: comment.data.depth != 0
                ? colorsRainbow.elementAt(comment.data.depth % 5)
                : Colors.transparent,
            width: comment.data.depth != 0 ? 2 : 0,
          ),
        ),
      ),
      child: InkWell(
        enableFeedback: true,
        onTap: () {
          collapse(comment, context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            comment.data.stickied
                ? PinnedCommentTag(platformBrightness: _platformBrightness)
                : Container(),
            Flexible(
              child: AuthorTag(
                comment: comment,
                platformBrightness: _platformBrightness,
              ),
            ),
            Html(
              data: _htmlContent,
              onLinkTap: (url, _, __, ___) {
                if (url.startsWith("/r/") || url.startsWith("r/")) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      maintainState: true,
                      fullscreenDialog: false,
                      builder: (BuildContext context) {
                        return SubredditFeedPage(
                          subreddit: url.startsWith("/r/")
                              ? url.replaceFirst("/r/", "")
                              : url.replaceFirst("r/", ""),
                        );
                      },
                    ),
                  );
                } else if (url.startsWith("/u/") || url.startsWith("u/")) {
                } else {
                  launchURL(Theme.of(context).primaryColor, url);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void collapse(CommentPojo.Child comment, BuildContext context) async {
    Provider.of<CommentsProvider>(context, listen: false)
        .collapseUncollapseComment(
      parentCommentIndex: commentIndex,
      collapse: true,
      postId: postId,
    );
  }
}

class AuthorTag extends StatelessWidget {
  const AuthorTag({
    @required this.comment,
    @required Brightness platformBrightness,
  }) : _platformBrightness = platformBrightness;
  final CommentPojo.Child comment;
  final Brightness _platformBrightness;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        comment.data.isSubmitter
            ? Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: comment.data.isSubmitter
                    ? Icon(
                        Icons.person,
                        size: 16,
                        color: Theme.of(context).accentColor,
                      )
                    : Container(),
              )
            : Container(),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: comment.data.author + "  ",
                style: comment.data.isSubmitter
                    ? Theme.of(context).textTheme.caption.copyWith(
                          color: Theme.of(context).accentColor,
                        )
                    : Theme.of(context).textTheme.caption,
              ),
              comment.data.distinguished.toString().compareTo("moderator") == 0
                  ? TextSpan(
                      text: "MOD",
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: Theme.of(context).accentColor,
                            letterSpacing: 1,
                          ),
                    )
                  : TextSpan(),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.arrow_upward,
              color: comment.data.likes != null
                  ? comment.data.likes == true
                      ? getColor(_platformBrightness, ColorObjects.UpvoteColor)
                      : getColor(
                          _platformBrightness, ColorObjects.DownvoteColor)
                  : Theme.of(context).textTheme.subtitle2.color,
              size: 14,
            ),
            Text(
              (comment.data.scoreHidden
                  ? " [?]"
                  : " " + getRoundedToThousand(comment.data.score)),
              style: comment.data.likes != null
                  ? comment.data.likes == true
                      ? Theme.of(context).textTheme.subtitle2.copyWith(
                            color: getColor(
                                _platformBrightness, ColorObjects.UpvoteColor),
                          )
                      : Theme.of(context).textTheme.subtitle2.copyWith(
                            color: getColor(_platformBrightness,
                                ColorObjects.DownvoteColor),
                          )
                  : Theme.of(context).textTheme.subtitle2,
              softWrap: true,
              overflow: TextOverflow.clip,
              maxLines: 100,
            ),
          ],
        ),
        Expanded(
          child: Text(
            " • " + getTimePosted(comment.data.createdUtc),
            style: Theme.of(context).textTheme.subtitle2,
            overflow: TextOverflow.fade,
            maxLines: 100,
          ),
        ),
      ],
    );
  }
}

class PinnedCommentTag extends StatelessWidget {
  const PinnedCommentTag({
    @required Brightness platformBrightness,
  }) : _platformBrightness = platformBrightness;
  final Brightness _platformBrightness;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 4.0,
        top: 4.0,
      ),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: getColor(
          _platformBrightness,
          ColorObjects.TagColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.label_outline,
            color: Theme.of(context).textTheme.subtitle2.color,
            size: Theme.of(context).textTheme.subtitle2.fontSize,
          ),
          SizedBox(
            width: 4.0,
          ),
          Text(
            "Pinned",
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}

class MoreCommentKind extends StatelessWidget {
  final CommentPojo.Child comment;
  final String postFullName;
  final String id;

  MoreCommentKind({this.comment, this.postFullName, this.id});
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, CommentsProvider model, _) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: InkWell(
                enableFeedback: true,
                splashColor: Theme.of(context).accentColor.withOpacity(0.2),
                onTap: () {
                  model.fetchChildren(
                    children: comment.data.children,
                    postId: id,
                    postFullName: postFullName,
                    moreParentId: comment.data.id,
                  );
                },
                child: Row(
                  children: <Widget>[
                    // only change the state of the widget to loading only if
                    // this comment matches the id to the loading comment
                    SizedBox(width: 16.0),
                    Text(
                      'More',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                      height: 32.0,
                    ),
                    model.commentsMoreLoadingState == ViewState.busy &&
                            model.moreParentLoadingId != "" &&
                            model.moreParentLoadingId == comment.data.id
                        ? Container(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
