import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_provider_app/models/comment_chain/comment.dart'
    as CommentPojo;
import 'package:flutter_provider_app/pages/subreddit_feed.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';
import 'package:html_unescape/html_unescape.dart';

import '../../exports.dart';

// TODO: implement comment voting
class CommentItem extends StatefulWidget {
  final CommentPojo.Child _comment;
  final String name;
  final String id;

  CommentItem(this._comment, this.name, this.id);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  final HtmlUnescape _unescape = new HtmlUnescape();

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
              child: Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).cardColor,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: widget._comment.data.depth == 0 ? 0 : 2,
                            ),
                            top: BorderSide(
                              color: widget._comment.data.depth == 0
                                  ? Theme.of(context).dividerColor
                                  : Colors.transparent,
                              width: widget._comment.data.depth == 0 ? 1 : 0,
                            )),
                      ),
                      child: widget._comment.kind == CommentPojo.Kind.MORE
                          ? buildMoreKindWidget(context)
                          : buildNormalCommentWidget(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String getTimePosted(double orig) {
    DateTime postDate = DateTime.fromMillisecondsSinceEpoch(
      orig.floor() * 1000,
      isUtc: true,
    );
    Duration difference = DateTime.now().toUtc().difference(postDate);
    if (difference.inDays <= 0) {
      if (difference.inHours <= 0) {
        if (difference.inMinutes <= 0) {
          return "Few Moments Ago";
        } else {
          return difference.inMinutes.toString() +
              (difference.inMinutes == 1 ? " minute" : " minutes") +
              " ago";
        }
      } else {
        return difference.inHours.toString() +
            (difference.inHours == 1 ? " hour" : " hours") +
            " ago";
      }
    } else {
      return difference.inDays.toString() +
          (difference.inDays == 1 ? " day" : " days") +
          " ago";
    }
  }

  String getValidHtml(String bodyHtml) {
    bodyHtml = bodyHtml.replaceFirst('<div class="md">', "");
    return bodyHtml;
  }

  Widget buildMoreKindWidget(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, CommentsProvider model, _) {
        return Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Material(
                  child: InkWell(
                    enableFeedback: true,
                    splashColor: Theme.of(context).accentColor,
                    onTap: () {
                      print(widget._comment.data.children);
                      print(widget.name);
                      Provider.of<CommentsProvider>(context).fetchChildren(
                        children: widget._comment.data.children,
                        id: widget.name,
                        moreParentId: widget._comment.data.id,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            height: 32,
                          ),
                          model.commentsMoreLoadingState == ViewState.Busy &&
                                  model.moreParentLoadingId != "" &&
                                  model.moreParentLoadingId ==
                                      widget._comment.data.id
                              ? Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 24,
                                      height: 24,
                                      padding: EdgeInsets.all(4.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                  ],
                                )
                              : Container(),
                          Text(
                            'More',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  type: MaterialType.card,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildNormalCommentWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          buildAuthorRow(context),
          buildCommentBody(context),
        ],
      ),
    );
  }

  Widget buildAuthorRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        widget._comment.data.isSubmitter
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: widget._comment.data.isSubmitter
                    ? Icon(
                        Icons.person,
                        size: 16,
                        color: Theme.of(context).accentColor,
                      )
                    : Container(),
              )
            : Container(),
        Flexible(
          child: Text(
            widget._comment.data.author +
                " • " +
                getTimePosted(
                  widget._comment.data.createdUtc,
                ) +
                " • ",
            style: widget._comment.data.isSubmitter
                ? Theme.of(context).textTheme.caption.copyWith(
                      color: Theme.of(context).accentColor,
                    )
                : Theme.of(context).textTheme.caption,
            softWrap: false,
            overflow: TextOverflow.fade,
            maxLines: 100,
          ),
        ),
        Text(
          widget._comment.data.score.toString() + " points",
          style: Theme.of(context).textTheme.caption,
          softWrap: false,
          maxLines: 1,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget buildCommentBody(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Html(
            linkStyle: Theme.of(context).textTheme.body1.copyWith(
                  color: Theme.of(context).accentColor,
                ),
            defaultTextStyle: Theme.of(context).textTheme.body1,
            padding: EdgeInsets.all(0),
            data: """${_unescape.convert(widget._comment.data.bodyHtml)}""",
            renderNewlines: true,
            useRichText: true,
            showImages: true,
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
      ],
    );
  }
}
