import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_provider_app/helpers/comment_color_annotations/colors.dart';
import 'package:flutter_provider_app/helpers/functions/relative_dart_conversion.dart';
import 'package:flutter_provider_app/models/comment_chain/comment.dart'
    as CommentPojo;
import 'package:flutter_provider_app/pages/subreddit_feed.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';
import 'package:html_unescape/html_unescape.dart';

import '../../exports.dart';

class CommentItem extends StatefulWidget {
  final CommentPojo.Child _comment;
  final String name;
  final String id;

  CommentItem(this._comment, this.name, this.id);

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
                    ? CollapsedCommentParent(comment: widget._comment)
                    : widget._comment.data.collapse == true
                        ? Container()
                        : widget._comment.kind == CommentPojo.Kind.MORE
                            ? MoreCommentKind(
                                comment: widget._comment,
                                name: widget.name,
                              )
                            : CommentBody(
                                comment: widget._comment,
                              ),
                duration: Duration(
                  milliseconds: 250,
                ),
                curve: Curves.linearToEaseOut,
              ),
            ),
          ],
        ),
        widget._comment.data.collapse == false
            ? Divider(
                height: 16,
              )
            : Container(),
      ],
    );
  }
}

class CollapsedCommentParent extends StatelessWidget {
  final CommentPojo.Child comment;
  CollapsedCommentParent({@required this.comment});
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, CommentsProvider model, _) {
        return Material(
          color: Colors.transparent,
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
                collapse(comment, context);
              },
              title: Text('Comment Collapsed'),
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

  void collapse(CommentPojo.Child comment, BuildContext context) async {
    await Provider.of<CommentsProvider>(context).collapseUncollapseComment(
      comment: comment,
      collapse: false,
    );
  }
}

class CommentBody extends StatefulWidget {
  final CommentPojo.Child comment;

  CommentBody({this.comment});

  @override
  _CommentBodyState createState() => _CommentBodyState();
}

class _CommentBodyState extends State<CommentBody> {
  final HtmlUnescape _unescape = new HtmlUnescape();
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onLongPress: isExpanded
            ? null
            : () {
                collapse(widget.comment, context);
              },
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, top: 4.0, right: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    widget.comment.data.isSubmitter
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: widget.comment.data.isSubmitter
                                ? Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Theme.of(context).accentColor,
                                  )
                                : Container(),
                          )
                        : Container(),
                    Text(
                      widget.comment.data.author + " ",
                      style: widget.comment.data.isSubmitter
                          ? Theme.of(context).textTheme.caption.copyWith(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              )
                          : Theme.of(context).textTheme.body2.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .color
                                    .withOpacity(0.8),
                              ),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      maxLines: 100,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.arrow_upward,
                          color: widget.comment.data.likes != null
                              ? widget.comment.data.likes == true
                                  ? Colors.orange
                                  : Colors.deepPurple
                              : Theme.of(context)
                                  .textTheme
                                  .body2
                                  .color
                                  .withOpacity(0.6),
                          size: 14,
                        ),
                        Text(
                          (widget.comment.data.scoreHidden
                              ? "[?]"
                              : widget.comment.data.score.toString()),
                          style: widget.comment.data.likes != null
                              ? widget.comment.data.likes == true
                                  ? Theme.of(context).textTheme.body2.copyWith(
                                        fontSize: 14,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w400,
                                      )
                                  : Theme.of(context).textTheme.body2.copyWith(
                                        fontSize: 14,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w400,
                                      )
                              : Theme.of(context).textTheme.body2.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .textTheme
                                        .body2
                                        .color
                                        .withOpacity(0.6),
                                  ),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          maxLines: 100,
                        ),
                      ],
                    ),
                    Text(
                      " • " + getTimePosted(widget.comment.data.createdUtc),
                      style: Theme.of(context).textTheme.body2.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                .textTheme
                                .body2
                                .color
                                .withOpacity(0.6),
                          ),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      maxLines: 100,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 0),
              child: Html(
                defaultTextStyle: Theme.of(context).textTheme.body1.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                linkStyle: Theme.of(context).textTheme.body1.copyWith(
                      color: Theme.of(context).accentColor,
                      fontSize: 15,
                    ),
                data: """${_unescape.convert(widget.comment.data.bodyHtml)}""",
                useRichText: true,
                showImages: false,
                renderNewlines: false,
                onLinkTap: (url) {
                  if (url.startsWith("/r/") || url.startsWith("r/")) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
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
                              if (widget.comment.data.likes == true) {
                                Provider.of<CommentsProvider>(context)
                                    .voteComment(
                                        id: widget.comment.data.id, dir: 0);
                              } else {
                                Provider.of<CommentsProvider>(context)
                                    .voteComment(
                                        id: widget.comment.data.id, dir: 1);
                              }
                            } else {
                              buildSnackBar(context);
                            }
                          },
                          color: widget.comment.data.likes == null ||
                                  widget.comment.data.likes == false
                              ? Theme.of(context).accentColor
                              : Colors.orange,
                          splashColor: Colors.orange,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_downward),
                          color: widget.comment.data.likes == null ||
                                  widget.comment.data.likes == true
                              ? Theme.of(context).accentColor
                              : Colors.purple,
                          onPressed: () {
                            if (Provider.of<UserInformationProvider>(context)
                                .signedIn) {
                              if (widget.comment.data.likes == false) {
                                Provider.of<CommentsProvider>(context)
                                    .voteComment(
                                        id: widget.comment.data.id, dir: 0);
                              } else {
                                Provider.of<CommentsProvider>(context)
                                    .voteComment(
                                        id: widget.comment.data.id, dir: -1);
                              }
                            } else {
                              buildSnackBar(context);
                            }
                          },
                          splashColor: Colors.deepPurple,
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
    );
  }

  void collapse(CommentPojo.Child comment, BuildContext context) async {
    await Provider.of<CommentsProvider>(context)
        .collapseUncollapseComment(comment: comment, collapse: true);
  }
}

class MoreCommentKind extends StatelessWidget {
  final CommentPojo.Child comment;
  final String name;

  MoreCommentKind({this.comment, this.name});
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
                    id: name,
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
