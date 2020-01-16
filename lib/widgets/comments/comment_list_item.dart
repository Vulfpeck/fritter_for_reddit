import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_provider_app/helpers/comment_color_annotations/colors.dart';
import 'package:flutter_provider_app/helpers/design_system/color_enums.dart';
import 'package:flutter_provider_app/helpers/design_system/colors.dart';
import 'package:flutter_provider_app/helpers/functions/conversion_functions.dart';
import 'package:flutter_provider_app/models/comment_chain/comment.dart'
    as CommentPojo;
import 'package:flutter_provider_app/pages/subreddit_feed.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';
import 'package:flutter_provider_app/widgets/common/swiper.dart';
import 'package:html_unescape/html_unescape.dart';

import '../../exports.dart';

class CommentItem extends StatefulWidget {
  final CommentPojo.Child _comment;
  final String name;
  final String postId;
  final int commentIndex;

  CommentItem(this._comment, this.name, this.postId, this.commentIndex);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              width: 16.0 * widget._comment.data.depth,
            ),
            Expanded(
              child: AnimatedSize(
                vsync: this,
                child: widget._comment.data.collapseParent == true
                    ? CollapsedCommentParent(
                        comment: widget._comment,
                        postId: widget.postId,
                        commentIndex: widget.commentIndex,
                      )
                    : widget._comment.data.collapse == true
                        ? Container()
                        : widget._comment.kind == CommentPojo.Kind.MORE
                            ? MoreCommentKind(
                                comment: widget._comment,
                                postFullName: widget.name,
                                id: widget.postId,
                              )
                            : Swiper(
                                postId: widget.postId,
                                comment: widget._comment,
                                child: CommentBody(
                                  commentIndex: widget.commentIndex,
                                  comment: widget._comment,
                                  postId: widget.postId,
                                ),
                              ),
                duration: Duration(
                  milliseconds: 250,
                ),
                curve: Curves.linearToEaseOut,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 16.0 * widget._comment.data.depth + 12,
            ),
            widget._comment.data.collapse == false
                ? Expanded(
                    child: Divider(),
                  )
                : Container(),
          ],
        ),
      ],
    );
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
        return Material(
          color: Theme.of(context).cardColor,
          child: Container(
            margin: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: ListTile(
              dense: true,
              onTap: () {
                collapse(commentIndex, context);
              },
              title: Text(
                'Comment Collapsed',
                style: Theme.of(context).textTheme.caption,
              ),
              subtitle: Text(
                model.collapsedChildrenCount[comment.data.id].toString() +
                    " children",
              ),
              trailing: Icon(Icons.expand_more),
            ),
          ),
        );
      },
    );
  }

  void collapse(int commentIndex, BuildContext context) {
    Provider.of<CommentsProvider>(context).collapseUncollapseComment(
      collapse: false,
      postId: postId,
      parentCommentIndex: commentIndex,
    );
  }
}

class CommentBody extends StatefulWidget {
  final CommentPojo.Child comment;
  final String postId;
  final int commentIndex;
  CommentBody(
      {@required this.comment,
      @required this.postId,
      @required this.commentIndex});

  @override
  _CommentBodyState createState() => _CommentBodyState();
}

class _CommentBodyState extends State<CommentBody> {
  final HtmlUnescape _unescape = new HtmlUnescape();
  bool isExpanded = false;
  Brightness _platformBrightness;

  @override
  Widget build(BuildContext context) {
    _platformBrightness = MediaQuery.of(context).platformBrightness;
    return Material(
      color: Theme.of(context).cardColor,
      child: Container(
        padding: EdgeInsets.only(top: 4.0),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: widget.comment.data.depth != 0
                  ? colorsRainbow.elementAt(widget.comment.data.depth % 5)
                  : Colors.transparent,
              width: widget.comment.data.depth != 0 ? 2 : 0,
            ),
          ),
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onLongPress: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          onTap: () {
            setState(() {
              collapse(widget.comment, context);
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              widget.comment.data.stickied
                  ? Container(
                      margin: EdgeInsets.only(
                        left: 8,
                        right: 8.0,
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
                            color: Theme.of(context).textTheme.subtitle.color,
                            size: Theme.of(context).textTheme.subtitle.fontSize,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            "Pinned",
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, top: 4.0, right: 12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      widget.comment.data.isSubmitter
                          ? Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: widget.comment.data.isSubmitter
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
                              text: widget.comment.data.author + " ",
                              style: widget.comment.data.isSubmitter
                                  ? Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                        color: Theme.of(context).accentColor,
                                      )
                                  : Theme.of(context).textTheme.caption,
                            ),
                            widget.comment.data.distinguished
                                        .toString()
                                        .compareTo("moderator") ==
                                    0
                                ? TextSpan(
                                    text: "MOD",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle
                                        .copyWith(
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
                            color: widget.comment.data.likes != null
                                ? widget.comment.data.likes == true
                                    ? getColor(_platformBrightness,
                                        ColorObjects.UpvoteColor)
                                    : getColor(_platformBrightness,
                                        ColorObjects.DownvoteColor)
                                : Theme.of(context).textTheme.subtitle.color,
                            size: 14,
                          ),
                          Text(
                            (widget.comment.data.scoreHidden
                                ? " [?]"
                                : " " +
                                    getRoundedToThousand(
                                        widget.comment.data.score)),
                            style: widget.comment.data.likes != null
                                ? widget.comment.data.likes == true
                                    ? Theme.of(context)
                                        .textTheme
                                        .subtitle
                                        .copyWith(
                                          color: getColor(_platformBrightness,
                                              ColorObjects.UpvoteColor),
                                        )
                                    : Theme.of(context)
                                        .textTheme
                                        .subtitle
                                        .copyWith(
                                          color: getColor(_platformBrightness,
                                              ColorObjects.DownvoteColor),
                                        )
                                : Theme.of(context).textTheme.subtitle,
                            softWrap: true,
                            overflow: TextOverflow.clip,
                            maxLines: 100,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Text(
                          " • " + getTimePosted(widget.comment.data.createdUtc),
                          style: Theme.of(context).textTheme.subtitle,
                          overflow: TextOverflow.fade,
                          maxLines: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                ),
                child: Html(
                  padding: EdgeInsets.all(0),
                  defaultTextStyle: Theme.of(context).textTheme.body1,
                  linkStyle: Theme.of(context).textTheme.body1.copyWith(
                        color: Theme.of(context).accentColor,
                      ),
                  data:
                      """${_unescape.convert(widget.comment.data.bodyHtml)}""",
                  useRichText: true,
                  showImages: false,
                  renderNewlines: false,
                  onLinkTap: (url) {
                    if (url.startsWith("/r/") || url.startsWith("r/")) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) {
                            return SubredditFeedPage(
                                subreddit: url.startsWith("/r/")
                                    ? url.replaceFirst("/r/", "")
                                    : url.replaceFirst("r/", ""));
                          },
                        ),
                      );
                    } else if (url.startsWith("/u/") || url.startsWith("u/")) {
                    } else {
                      print("launching web view");
                      launchURL(context, url);
                    }
                  },
                ),
              ),
              isExpanded
                  ? Container(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_upward,
                            ),
                            onPressed: () {
                              if (Provider.of<UserInformationProvider>(context)
                                  .signedIn) {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                                if (widget.comment.data.likes == true) {
                                  Provider.of<CommentsProvider>(context)
                                      .voteComment(
                                          id: widget.comment.data.id,
                                          dir: 0,
                                          postId: widget.postId);
                                } else {
                                  Provider.of<CommentsProvider>(context)
                                      .voteComment(
                                          id: widget.comment.data.id,
                                          dir: 1,
                                          postId: widget.postId);
                                }
                              } else {
                                buildSnackBar(context);
                              }
                            },
                            color: widget.comment.data.likes == null ||
                                    widget.comment.data.likes == false
                                ? Theme.of(context).accentColor
                                : getColor(_platformBrightness,
                                    ColorObjects.UpvoteColor),
                            splashColor: getColor(
                                _platformBrightness, ColorObjects.UpvoteColor),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_downward),
                            color: widget.comment.data.likes == null ||
                                    widget.comment.data.likes == true
                                ? Theme.of(context).accentColor
                                : getColor(_platformBrightness,
                                    ColorObjects.DownvoteColor),
                            onPressed: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                              if (Provider.of<UserInformationProvider>(context)
                                  .signedIn) {
                                if (widget.comment.data.likes == false) {
                                  Provider.of<CommentsProvider>(context)
                                      .voteComment(
                                          id: widget.comment.data.id,
                                          dir: 0,
                                          postId: widget.postId);
                                } else {
                                  Provider.of<CommentsProvider>(context)
                                      .voteComment(
                                          id: widget.comment.data.id,
                                          dir: -1,
                                          postId: widget.postId);
                                }
                              } else {
                                buildSnackBar(context);
                              }
                            },
                            splashColor: getColor(_platformBrightness,
                                ColorObjects.DownvoteColor),
                          ),
                          IconButton(
                            icon: Icon(Icons.account_circle),
                            onPressed: () {},
                            color: Theme.of(context).accentColor,
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void collapse(CommentPojo.Child comment, BuildContext context) async {
    Provider.of<CommentsProvider>(context).collapseUncollapseComment(
      parentCommentIndex: widget.commentIndex,
      collapse: true,
      postId: widget.postId,
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
                  Provider.of<CommentsProvider>(context).fetchChildren(
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
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'More',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    model.commentsMoreLoadingState == ViewState.Busy &&
                            model.moreParentLoadingId != "" &&
                            model.moreParentLoadingId == comment.data.id
                        ? Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                            ],
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
