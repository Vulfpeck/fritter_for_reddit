import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_provider_app/helpers/misc_helper_methods.dart';
import 'package:flutter_provider_app/models/comment_chain/comment.dart'
    as CommentPojo;
import 'package:flutter_provider_app/pages/subreddit_feed.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';
import 'package:html_unescape/html_unescape.dart';

import '../../exports.dart';

// TODO: implement comment voting
class CommentItem extends StatelessWidget {
  final CommentPojo.Child _comment;
  final String name;
  final String id;

  CommentItem(this._comment, this.name, this.id);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: 16.0 * _comment.data.depth,
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).cardColor,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: _comment.data.depth == 0 ? 0 : 2,
                    ),
                    top: BorderSide(
                      color: _comment.data.depth == 0
                          ? Theme.of(context).dividerColor
                          : Colors.transparent,
                      width: _comment.data.depth == 0 ? 1 : 0,
                    )),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  top: 16.0,
                  bottom: 6.0,
                ),
                child: _comment.kind == CommentPojo.Kind.MORE
                    ? MoreCommentKind(
                        comment: _comment,
                        name: name,
                      )
                    : CommentBody(
                        comment: _comment,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommentBody extends StatelessWidget {
  final HtmlUnescape _unescape = new HtmlUnescape();
  final CommentPojo.Child comment;

  CommentBody({this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            comment.data.isSubmitter
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: comment.data.isSubmitter
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
                comment.data.author +
                    " • " +
                    getTimePosted(
                      comment.data.createdUtc,
                    ) +
                    " • ",
                style: comment.data.isSubmitter
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
              comment.data.score.toString() + " points",
              style: Theme.of(context).textTheme.caption,
              softWrap: false,
              maxLines: 1,
              textAlign: TextAlign.left,
            ),
          ],
        ),
        Html(
          linkStyle: Theme.of(context).textTheme.body1.copyWith(
                color: Theme.of(context).accentColor,
              ),
          defaultTextStyle: Theme.of(context).textTheme.body1,
          padding: EdgeInsets.all(0),
          data: """${_unescape.convert(comment.data.bodyHtml)}""",
          useRichText: true,
          showImages: false,
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
      ],
    );
  }
}

class MoreCommentKind extends StatefulWidget {
  final CommentPojo.Child comment;
  final String name;

  MoreCommentKind({this.comment, this.name});
  @override
  _MoreCommentKindState createState() => _MoreCommentKindState();
}

class _MoreCommentKindState extends State<MoreCommentKind> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, CommentsProvider model, _) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Material(
                child: InkWell(
                  enableFeedback: true,
                  splashColor: Theme.of(context).accentColor,
                  onTap: () {
                    Provider.of<CommentsProvider>(context).fetchChildren(
                      children: widget.comment.data.children,
                      id: widget.name,
                      moreParentId: widget.comment.data.id,
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      model.commentsMoreLoadingState == ViewState.Busy &&
                              model.moreParentLoadingId != "" &&
                              model.moreParentLoadingId ==
                                  widget.comment.data.id
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
                type: MaterialType.card,
              ),
            ),
          ],
        );
      },
    );
  }
}
