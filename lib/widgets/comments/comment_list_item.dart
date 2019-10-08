import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/models/comment_chain/comment.dart'
    as CommentPojo;
import 'package:html_unescape/html_unescape.dart';

class CommentItem extends StatefulWidget {
  final CommentPojo.Child _comment;

  CommentItem(this._comment);

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
              width: 16 * widget._comment.data.depth.toDouble(),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    widget._comment.data.author +
                                        " • " +
                                        getTimePosted(
                                          widget._comment.data.createdUtc,
                                        ) +
                                        " • ",
                                    style: Theme.of(context).textTheme.caption,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                    maxLines: 100,
                                  ),
                                ),
                                Text(
                                  widget._comment.data.score.toString() +
                                      " points",
                                  style: Theme.of(context).textTheme.caption,
                                  softWrap: false,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    _unescape
                                        .convert(widget._comment.data.body),
                                    style: Theme.of(context).textTheme.body1,
                                    softWrap: true,
                                    maxLines: 100,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            )
                          ],
                        ),
                      ),
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
}
